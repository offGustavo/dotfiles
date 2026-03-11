vim.keymap.set('n', '<leader>lu', function()
  vim.pack.update {}
end)
vim.keymap.set('n', '<leader>lx', function()
  vim.pack.del {}
end)
vim.keymap.set('n', '<leader>le', function()
  vim.cmd("e ~/.local/share/lvim/site/pack/core/opt/")
end)

