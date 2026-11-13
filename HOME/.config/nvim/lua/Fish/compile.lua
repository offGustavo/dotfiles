local M = {}
local last_cmd = ""
local BUF_NAME = "[compilation]"

local state = {
  job = nil, ---@type integer|nil
  buf = nil, ---@type integer|nil
  killed = false,
}

---Get user Input
---@return string
local function get_user_cmd()
  return vim.fn.input({
    prompt = "$ ",
    default = last_cmd,
    completion = "shellcmdline",
    scope = "editor",
  })
end

---Get the compilation buffer, creating it if needed
---@return integer
local function get_buf()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    return state.buf
  end

  local buf = vim.api.nvim_create_buf(false, true)
  pcall(vim.api.nvim_buf_set_name, buf, BUF_NAME)

  vim.bo[buf].filetype = "qf"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false

  vim.keymap.set("n", "<C-c>", function()
    M.kill()
  end, { buffer = buf, desc = "Kill running compilation" })

  state.buf = buf
  return buf
end

---Show the buffer in a window (reuses one in the current tab if visible)
---@param buf integer
local function show_buf(buf)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return
    end
  end
  vim.cmd("botright 12split")
  vim.api.nvim_win_set_buf(0, buf)
end

---Append lines to the buffer and follow the output
---@param lines string[]
local function append(lines)
  local buf = state.buf
  if not buf or not vim.api.nvim_buf_is_valid(buf) or #lines == 0 then
    return
  end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
  vim.bo[buf].modifiable = false

  local last = vim.api.nvim_buf_line_count(buf)
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_set_cursor(win, { last, 0 })
  end
end

---Reset buffer content
---@param lines string[]
local function reset(buf, lines)
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
end

---Create an output handler that deals with partial lines across chunks
---@return fun(_, data: string[]), fun()
local function make_handler()
  local pending = ""

  local function on_data(_, data)
    if not data then
      return
    end
    local out = {}
    -- data[1] continues the previous partial line
    pending = pending .. data[1]
    for i = 2, #data do
      table.insert(out, (pending:gsub("\r", "")))
      pending = data[i]
    end
    vim.schedule(function()
      append(out)
    end)
  end

  local function flush()
    local rest = pending:gsub("\r", "")
    pending = ""
    if rest ~= "" then
      vim.schedule(function()
        append({ rest })
      end)
    end
  end

  return on_data, flush
end

--- Kill the running compilation (and its child processes)
function M.kill()
  if not state.job then
    vim.notify("No compilation running", vim.log.levels.INFO)
    return
  end

  state.killed = true

  local ok, pid = pcall(vim.fn.jobpid, state.job)
  if ok and pid then
    -- kill the children first, otherwise they outlive the shell
    vim.fn.system({ "pkill", "-TERM", "-P", tostring(pid) })
  end
  vim.fn.jobstop(state.job)
end

--- Run user command and print the output in the compilation buffer
---@param cmd string|nil
function M.compile(cmd)
  if cmd == nil or cmd == "" then
    cmd = get_user_cmd()
  end

  if cmd == "" or cmd == nil then
    vim.notify("Empty input, provide an command to compile operation canceled", vim.log.levels.WARN)
    return
  end

  -- one compilation at a time
  if state.job then
    M.kill()
  end

  local buf = get_buf()
  reset(buf, { "-*- cmd: " .. cmd .. " -*-", "", "Compilation Started", "" })
  show_buf(buf)

  local on_stdout, flush_stdout = make_handler()
  local on_stderr, flush_stderr = make_handler()

  state.killed = false
  local job
  job = vim.fn.jobstart(cmd, {
    on_stdout = on_stdout,
    on_stderr = on_stderr,
    on_exit = function(_, code)
      -- ignore exits from a job that was replaced by a newer one
      if state.job ~= job then
        return
      end
      flush_stdout()
      flush_stderr()

      local msg
      if state.killed then
        msg = "Compilation killed"
      elseif code == 0 then
        msg = "Compilation finished"
      else
        msg = "Compilation exited abnormally with code " .. code
      end

      state.job = nil
      state.killed = false
      vim.schedule(function()
        append({ "", msg })
      end)
    end,
  })

  if job <= 0 then
    append({ "", "Failed to start command" })
    return
  end

  state.job = job
  last_cmd = cmd
end

--- Re run the last compilation
function M.recompile()
  M.compile(last_cmd)
end

return M
