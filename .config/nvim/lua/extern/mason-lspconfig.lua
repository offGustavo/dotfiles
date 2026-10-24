later(function()
  require("mason").setup({})
  require("mason-lspconfig").setup({
    automatic_enable = true,
    ensure_installed = { "lua_ls", "rust_analyzer" },
  })
end)
