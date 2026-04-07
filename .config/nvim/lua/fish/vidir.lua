local M = {}

local state = {
  dir = nil,
  original = {},
}

-- Scan directory with type info
local function scandir(path)
  local handle = vim.loop.fs_scandir(path)
  if not handle then return {} end

  local result = {}

  while true do
    local name, t = vim.loop.fs_scandir_next(handle)
    if not name then break end

    if t == "directory" then
      name = name .. "/"
    end

    table.insert(result, name)
  end

  table.sort(result)
  return result
end

-- Utility
local function join_path(a, b)
  return a .. "/" .. b
end

local function strip_slash(name)
  return name:gsub("/$", "")
end

local function is_dir(name)
  return name:sub(-1) == "/"
end

-- Open buffer
function M.open(path)
  path = path or vim.fn.getcwd()

  local entries = scandir(path)

  state.dir = path
  state.original = vim.deepcopy(entries)

  vim.cmd("enew")
  local buf = vim.api.nvim_get_current_buf()

  vim.bo[buf].buftype = "acwrite"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "vidir"

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, entries)

  -- Write handler
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    callback = function()
      M.apply_changes(buf)
    end,
  })

  -- Navigation keymaps
  local opts = { buffer = buf, silent = true }

  vim.keymap.set("n", "<CR>", function()
    M.enter_dir()
  end, opts)

  vim.keymap.set("n", "-", function()
    M.go_up()
  end, opts)

  vim.keymap.set("n", "<BS>", function()
    M.go_up()
  end, opts)
end

-- Apply changes (create, delete, rename)
function M.apply_changes(buf)
  local new = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local old = state.original
  local dir = state.dir

  local old_map = {}
  for _, name in ipairs(old) do
    old_map[name] = true
  end

  local new_map = {}
  for _, name in ipairs(new) do
    new_map[name] = true
  end

  -- Deletes
  for _, name in ipairs(old) do
    if not new_map[name] then
      local path = join_path(dir, strip_slash(name))

      if is_dir(name) then
        vim.loop.fs_rmdir(path)
      else
        os.remove(path)
      end
    end
  end

  -- Creates
  for _, name in ipairs(new) do
    if not old_map[name] then
      local path = join_path(dir, strip_slash(name))

      if is_dir(name) then
        vim.loop.fs_mkdir(path, 493) -- 0755
      else
        local fd = io.open(path, "w")
        if fd then fd:close() end
      end
    end
  end

  -- Renames (position-based)
  for i, old_name in ipairs(old) do
    local new_name = new[i]

    if old_name and new_name and old_name ~= new_name then
      local old_path = join_path(dir, strip_slash(old_name))
      local new_path = join_path(dir, strip_slash(new_name))
      os.rename(old_path, new_path)
    end
  end

  -- Refresh
  state.original = scandir(dir)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, state.original)

  print("Updated")
end

-- Enter directory
function M.enter_dir()
  local line = vim.api.nvim_get_current_line()

  if not is_dir(line) then return end

  local new_dir = join_path(state.dir, strip_slash(line))
  M.open(new_dir)
end

-- Go up
function M.go_up()
  local parent = vim.fn.fnamemodify(state.dir, ":h")
  M.open(parent)
end

return M
