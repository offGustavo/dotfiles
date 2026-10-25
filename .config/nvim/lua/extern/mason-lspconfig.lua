later(function()
  packadd({ "nvim-lspconfig", "mason.nvim", "mason-lspconfig.nvim" })
  require("mason").setup({})
  require("mason-lspconfig").setup({
    automatic_enable = true,
    ensure_installed = { "lua_ls", "rust_analyzer" },
  })
end)
