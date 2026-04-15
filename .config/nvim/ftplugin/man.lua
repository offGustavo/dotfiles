vim.wo.number = false
vim.wo.relativenumber = false
vim.wo.signcolumn = "yes"
vim.keymap.set("n", "q", function()
    vim.cmd("quit")
end, { buffer = true, silent = true })
