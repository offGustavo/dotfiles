local M = {}
local last_cmd = ""

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

--- Append to quickfix list the messages from the running program
---@param lines table
local function append_to_quickfix(lines)
  if #lines > 0 then
    vim.fn.setqflist({}, "a", {
      lines = lines,
    })
  end
end

--- Run user command and set the quickfix list the compilations messages
---@param cmd string
function M.compile(cmd)
  if cmd == nil or cmd == "" then
    cmd = get_user_cmd()
  end

  if cmd == "" or cmd == nil then
    vim.notify("Empty input, provide an command to compile operation canceled", vim.log.levels.WARN)
    return
  end

  vim.fn.setqflist({}, " ", {
    title = cmd,
    lines = {},
  })

  append_to_quickfix({ "Compilation Started", " " })

  vim.cmd.copen()

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      append_to_quickfix(data)
    end,
    on_stderr = function(_, data)
      append_to_quickfix(data)
    end,
    on_exit = function(_, code)
      append_to_quickfix({ "", code == 0 and "Compilation finished" or ("Compilation exited abnormally with code " .. code) })
    end,
  })

  last_cmd = cmd
end

--- Re run the last compilation
function M.recompile()
  M.compile(last_cmd)
end

return M
