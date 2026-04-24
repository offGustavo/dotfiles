vim.keymap.set("n", "<localleader>s", "<Cmd>source %<Cr>", { silent = true, desc = "Source File", buffer = true })
vim.keymap.set("n", "<localleader>R", ":luafile %<CR>", { desc = "Execute File with Neovim", buffer = true })
vim.keymap.set("n", "<localleader>r", "<Cmd>!%<Cr>", { silent = true, desc = "Execute File External", buffer = true })

-- https://www.youtube.com/watch?v=UE6XQTAxwE0
vim.keymap.set("n", "<localleader>l", ":.lua<Cr>", { silent = true, desc = "Execute Line in Lua", buffer = true })
vim.keymap.set(
  "x",
  "<localleader>l",
  ":'<,'>lua<Cr>",
  { silent = true, desc = "Execute Selection in Lua", buffer = true }
)

vim.lsp.enable 'lua_ls'

vim.schedule(function()
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.wo[0][0].foldmethod = "expr"
vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end)
