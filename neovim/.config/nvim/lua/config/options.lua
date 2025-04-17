-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.snacks_animate = false

-- vim.opt.scrolloff = 28
vim.opt.scrolloff = 0

vim.o.wrap = false

vim.o.list = false

vim.opt.spelllang = { "pt_br", "en_us", "es" }

----------------------
-- NEOVIDE          --
----------------------

if vim.g.neovide then
  vim.g.neovide_padding_top = 8
  vim.g.neovide_padding_bottom = 8
  vim.g.neovide_padding_right = 8
  vim.g.neovide_padding_left = 8
end
