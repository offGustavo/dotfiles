local M = {}

local data_dir = vim.fn.stdpath("data") .. "/espeto"
local list = {}          -- { { file = "src/a.lua", row = 1, col = 0 }, ... }
local current_key        -- cwd the list belongs to

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Espeto" })
end

local function storage_path(key)
  return data_dir .. "/" .. key .. ".json"
end

local function save()
  if not current_key then return end
  vim.fn.mkdir(data_dir, "p")
  local f = io.open(storage_path(current_key), "w")
  if f then
    f:write(vim.json.encode(list))
    f:close()
  end
end

-- Reload automatically when the cwd changes (per-project lists)
local function ensure()
  local key = (vim.fn.getcwd():gsub("[^%w]", "_"))
  if key == current_key then return end
  save() -- flush the old project's list first
  current_key, list = key, {}
  local f = io.open(storage_path(key), "r")
  if f then
    local ok, data = pcall(vim.json.decode, f:read("*a"))
    f:close()
    if ok and type(data) == "table" then list = data end
  end
end

local function current_file(buf)
  buf = buf or 0
  if vim.bo[buf].buftype ~= "" then return nil end
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then return nil end
  return vim.fn.fnamemodify(name, ":.")
end

local function index_of(file)
  for i, e in ipairs(list) do
    if e.file == file then return i end
  end
end

-- Public API ---------------------------------------------------------------

function M.add()
  ensure()
  local file = current_file()
  if not file then return notify("No file in this buffer", vim.log.levels.ERROR) end
  if index_of(file) then return notify("Already in list: " .. file) end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  table.insert(list, { file = file, row = row, col = col })
  save()
  notify(string.format("Added %s (%d)", file, #list))
end

function M.remove(index)
  ensure()
  index = index or index_of(current_file())
  if not index or not list[index] then return notify("Nothing to remove", vim.log.levels.WARN) end
  local removed = table.remove(list, index)
  save()
  notify("Removed " .. removed.file)
end

function M.select(index)
  ensure()
  local e = list[index]
  if not e then return notify("No file at " .. index, vim.log.levels.WARN) end
  vim.cmd.edit(vim.fn.fnameescape(e.file))
  pcall(vim.api.nvim_win_set_cursor, 0, { e.row, e.col })
end

local function cycle(step)
  ensure()
  if #list == 0 then return notify("List is empty", vim.log.levels.WARN) end
  local i = index_of(current_file()) or (step > 0 and 0 or #list + 1)
  M.select((i - 1 + step) % #list + 1)
end

function M.next() cycle(1) end
function M.prev() cycle(-1) end

-- Quick menu: edit the list as text (reorder with dd/p, delete with dd) -------

local function read_menu(buf)
  local old = {}
  for _, e in ipairs(list) do old[e.file] = e end
  local new = {}
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    line = vim.trim(line)
    if line ~= "" then
      new[#new + 1] = old[line] or { file = line, row = 1, col = 0 }
    end
  end
  list = new
  save()
end

function M.menu()
  ensure()
  local buf = vim.api.nvim_create_buf(false, true)
  local files = vim.tbl_map(function(e) return e.file end, list)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, files)
  vim.bo[buf].bufhidden = "wipe"

  local width = math.floor(vim.o.columns * 0.6)
  local height = math.max(#files + 1, 8)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Espeto ",
    title_pos = "center",
  })

  local function close()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  end

  -- Sync the list whenever the menu goes away
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    once = true,
    callback = function() read_menu(buf) end,
  })
  -- (BufWipeout runs before the buffer is gone, so get_lines still works)

  local opts = { buffer = buf, nowait = true }
  vim.keymap.set("n", "q", close, opts)
  vim.keymap.set("n", "<Esc>", close, opts)
  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    close()
    M.select(line)
  end, opts)
end

-- Setup ---------------------------------------------------------------------

function M.setup()
  local group = vim.api.nvim_create_augroup("Espeto", { clear = true })

  -- Remember the cursor position of listed files (in memory)
  vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    callback = function(ev)
      ensure()
      local i = index_of(current_file(ev.buf))
      if i then
        list[i].row, list[i].col = unpack(vim.api.nvim_win_get_cursor(0))
      end
    end,
  })

  -- Persist everything on exit
  vim.api.nvim_create_autocmd("VimLeavePre", { group = group, callback = save })
end

return M
