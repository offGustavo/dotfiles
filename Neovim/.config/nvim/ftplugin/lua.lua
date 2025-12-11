vim.keymap.set("n", "<localleader>r", ":luafile %<CR>", { buffer = true })

vim.keymap.set("n", "<localleader>s", "<Cmd>source %<Cr>", { silent = true, desc = "Source File" })

-- https://www.youtube.com/watch?v=UE6XQTAxwE0
vim.keymap.set("n", "<localleader>l", ":.lua<Cr>", { silent = true, desc = "Execute Line in Lua" })
vim.keymap.set("x", "<localleader>l", ":'<,'>lua<Cr>", { silent = true, desc = "Execute Selection in Lua" })
