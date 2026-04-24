-- forge-arglist.lua
local M = {}

local config = {
  save_local = {
    enable = true,
    file_name = '.args'
  },
  autocmd = true
}

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})
  if config.autocmd then
    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('ForgeArglist', { clear = true }),
      callback = function()
        vim.schedule(function()
          M.load()
        end)
      end,
      desc = 'Auto-load forge arglist session',
    })
  end
end

local function get_args_file()
  local save_local = config.save_local.enable
  local file_name = config.save_local.file_name or '.args'
  local cwd = vim.fn.getcwd()

  if save_local then
    return cwd .. '/' .. file_name .. '.vim'
  else
    local cwd_key = cwd:gsub('[/\\]', '%%')
    return vim.fn.stdpath('data') .. '/forge_args/' .. cwd_key .. '.vim'
  end
end

function M.load()
  local path = get_args_file()
  if vim.fn.filereadable(path) == 1 then
    vim.cmd('source ' .. vim.fn.fnameescape(path))
  end
end

function M.save_and_show()
  local list = vim.fn.argv()
  if #list == 0 then
    vim.notify('Argument list is empty', vim.log.levels.WARN)
    return
  end

  local path = get_args_file()
  vim.fn.mkdir(vim.fn.fnamemodify(path, ':h'), 'p')

  local lines = { 'argglobal', '%argdel', '' }
  for _, filename in ipairs(list) do
    table.insert(lines, '$argadd ' .. filename)
  end

  vim.fn.writefile(lines, path)

  local buf = vim.fn.bufnr(path)
  local win = buf ~= -1 and vim.iter(vim.api.nvim_list_wins()):find(function(w)
    return vim.api.nvim_win_get_buf(w) == buf
  end)

  if not win then
    vim.cmd('botright split ' .. vim.fn.fnameescape(path))
    local height = math.min(#lines + 1, 10)
    vim.api.nvim_win_set_height(0, height)
    vim.keymap.set('n', 'q', '<C-w>c', { buffer = true, silent = true })
  else
    vim.api.nvim_set_current_win(win)
    vim.cmd 'edit'
  end
end

return M
