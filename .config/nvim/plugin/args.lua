-- if true then return end
vim.g.forge_arglist = {
  save_local = {
    enable = true,
    file_name = '.args'
  },
  autocmd = true
}

-- Poor man harpoon
vim.keymap.set('n', '<leader>ha', function()
  vim.cmd 'argadd %'
  vim.cmd 'argdedup'
end)
vim.keymap.set('n', '<leader>hd', function()
  vim.cmd 'argd %'
end)

-- assign args to each number
for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, '<CMD>argu ' .. i .. '<CR>', { silent = true, desc = 'Go to arg ' .. i })
  vim.keymap.set('n', '<leader>h' .. i, '<CMD>' .. i - 1 .. 'arga<CR>',
    { silent = true, desc = 'Add current to arg ' .. i })
  vim.keymap.set('n', '<leader>d' .. i, '<CMD>' .. i .. 'argd<CR>', { silent = true, desc = 'Delete arg ' .. i })
end

-- to tmp buffer
local function get_args_file()
  local cfg = vim.g.forge_arglist or {}
  local save_local = (cfg.save_local or {}).enable
  local file_name = (cfg.save_local or {}).file_name or '.args'
  local cwd = vim.fn.getcwd()

  if save_local then
    return cwd .. '/' .. file_name .. '.vim'
  else
    -- Use cwd as a unique key: replace path separators with %
    local cwd_key = cwd:gsub('[/\\]', '%%')
    return vim.fn.stdpath('data') .. '/forge_args/' .. cwd_key .. '.vim'
  end
end

local function load_args()
  local path = get_args_file()
  if vim.fn.filereadable(path) == 1 then
    vim.cmd('source ' .. vim.fn.fnameescape(path))
    -- vim.notify('Loaded args from ' .. path)
  end
end

-- -- Autocmd to load args on startup (only if autocmd = true in config)
-- local cfg = vim.g.forge_arglist or {}
-- if cfg.autocmd then
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('ForgeArglist', { clear = true }),
  callback = function()
    load_args()
  end,
  desc = 'Auto-load forge arglist session',
})
-- end

-- Keymap to manually load args
vim.keymap.set('n', '<leader>hl', load_args, { silent = true, desc = 'Load args session' })
vim.keymap.set('n', '<leader>he', function()
  local list = vim.fn.argv()
  if #list == 0 then
    vim.notify('Argument list is empty', vim.log.levels.WARN)
    return
  end

  local path = get_args_file()

  -- Ensure parent directory exists
  vim.fn.mkdir(vim.fn.fnamemodify(path, ':h'), 'p')

  -- Build lines in mksession style
  local lines = { 'argglobal', '%argdel', '' }
  for _, filename in ipairs(list) do
    table.insert(lines, '$argadd ' .. filename)
  end

  -- Write to file
  vim.fn.writefile(lines, path)

  -- Open the file, reuse window if already visible
  local buf = vim.fn.bufnr(path)
  local win = buf ~= -1 and vim.iter(vim.api.nvim_list_wins()):find(function(w)
    return vim.api.nvim_win_get_buf(w) == buf
  end)

  if not win then
    vim.cmd('botright split ' .. vim.fn.fnameescape(path))
    local height = math.min(#lines + 1, 10)
    vim.api.nvim_win_set_height(0, height)
  else
    vim.api.nvim_set_current_win(win)
    vim.cmd 'edit'
  end

  vim.keymap.set('n', 'q', '<C-w>c', { buffer = true, silent = true })
end, { silent = true, desc = 'Show args in tmp buffer' })
