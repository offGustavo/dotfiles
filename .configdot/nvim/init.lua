vim.g.mapleader = " "
vim.g.maplocalleader = "<M-m>"

vim.autocmd = vim.api.nvim_create_autocmd
vim.doautocmd = vim.api.nvim_exec_autocmds

_G.Fish = {}

vim.keymap.set("n", "<M-o>", ":fin ")
vim.keymap.set("n", "<M-e>", ":Ex<Cr>")
vim.keymap.set("n", "<M-s>", ":grep ")
vim.keymap.set("n", "<M-b>", ":b ")
vim.keymap.set("n", "<M-y>", '"+p')
vim.keymap.set("n", "<M-w>", '"+y')

