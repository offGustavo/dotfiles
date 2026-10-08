map {
  { "n", "<localleader>s", "<Cmd>source %<Cr>", silent = true, desc = "Source File", buffer = true },
  { "n", "<localleader>R", ":luafile %<CR>", desc = "Execute File with Neovim", buffer = true },
  { "n", "<localleader>r", "<Cmd>!%<Cr>", silent = true, desc = "Execute File External", buffer = true },
  -- vim.keymap.set("n", "<localleader>im", "I-- {{{<Esc>o}}}<Esc>O<Esc>S", { silent = true, desc = "Execute File External", buffer = true })
  -- https://www.youtube.com/watch?v=UE6XQTAxwE0
  { "n", "<localleader>l", ":.lua<Cr>", silent = true, desc = "Execute Line in Lua", buffer = true },
  { "x", "<localleader>l", ":'<,'>lua<Cr>", silent = true, desc = "Execute Selection in Lua", buffer = true },
}

vim.lsp.enable("lua_ls")

set_local {
  formatprg = "stylua",
  foldmethod = "expr",
  foldexpr = "v:lua.vim.treesitter.foldexpr()",
  indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()",
}

