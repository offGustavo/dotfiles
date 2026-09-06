local M = {}

local function get_args_file()
  local cwd = vim.fs.normalize(vim.fn.getcwd()) -- normalizes \ to /, expands ~, etc.
  if vim.g.argall.save_local.enable then
    return cwd .. "/" .. vim.g.argall.save_local.file_name .. ".vim"
  end
  local data_dir = vim.fs.normalize(vim.fn.stdpath("data"))
  return data_dir .. "/argall/" .. ".vim"
end

function M.load()
  local path = get_args_file()
  if vim.fn.filereadable(path) == 1 then
    vim.cmd("source " .. vim.fn.fnameescape(path))
  end
end

function M.save()
  local list = vim.fn.argv()
  local path = get_args_file()
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  local lines = { "argglobal", "%argdel", "" }
  for _, filename in ipairs(list) do
    table.insert(lines, "$argadd " .. filename)
  end
  vim.fn.writefile(lines, path)
  return path
end

function M.add(file_name)
  if file_name == nil then
    vim.notify("No file provide")
    return
  end
  vim.cmd("argadd " .. file_name)
  vim.cmd "argdedup"
  M.save()
end

function M.show()
  if #vim.fn.argv() == 0 then
    vim.notify("Argument list is empty", vim.log.levels.WARN)
    return
  end
  local path = M.save()
  local buf = vim.fn.bufnr(path)
  local win = buf ~= -1
    and vim.iter(vim.api.nvim_list_wins()):find(function(w)
      return vim.api.nvim_win_get_buf(w) == buf
    end)
  if not win then
    vim.cmd("botright split " .. vim.fn.fnameescape(path))
    vim.api.nvim_win_set_height(0, math.min(#vim.fn.argv() + 4, 10))
    vim.bo.filetype = "argall"
    vim.keymap.set("n", "q", "<C-w>c", { buffer = true, silent = true })
  else
    vim.api.nvim_set_current_win(win)
    vim.cmd "edit"
  end
end

return M
