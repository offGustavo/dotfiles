local M = {}

local function find_in_dir(path)
  local path = path or ""
  local fnames = vim.fn.systemlist("fd --hidden -t f --color=never 'Task'" .. path)
  return fnames
end

function M.ls(path)
  local path = path or vim.fn.expand("%:h", false, false)
  return find_in_dir(path)
end

vim.print(find_in_dir())

return M
