vim.keymap.set("n", "<localleader>x", ":!chmod +x %<Cr>", { silent = true, desc = "Make File Executable", buffer = true})
vim.keymap.set("n", "<localleader>r", "<Cmd>!%<Cr>", { silent = true, desc = "Execute File", buffer = true })
