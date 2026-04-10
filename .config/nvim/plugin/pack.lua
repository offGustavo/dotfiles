vim.keymap.set('n', '<leader>lu', function()
  vim.pack.update()
end)
vim.keymap.set('n', '<leader>lx', function()
  vim.pack.del(vim.pack.get())
end)

vim.keymap.set('n', '<leader>ls', function()
  vim.pack.get()
end)

vim.keymap.set('n', '<leader>le', function()
  vim.cmd("e ~/.local/share/nvim/site/pack/core/opt/")
end)

