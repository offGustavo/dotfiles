vim.keymap.set("n", "<localleader>s", "<Cmd>source %<Cr>", { silent = true, desc = "Source File", buffer = true})

vim.keymap.set("n", "<localleader>R", ":luafile %<CR>", { desc = "Execute File with Neovim", buffer = true })
vim.keymap.set("n", "<localleader>r", "<Cmd>!%<Cr>", { silent = true, desc = "Execute File External", buffer = true })

-- https://www.youtube.com/watch?v=UE6XQTAxwE0
vim.keymap.set("n", "<localleader>l", ":.lua<Cr>", { silent = true, desc = "Execute Line in Lua", buffer = true })
vim.keymap.set("x", "<localleader>l", ":'<,'>lua<Cr>", { silent = true, desc = "Execute Selection in Lua", buffer = true })
