later(function()

  -- LSP plugins
  vim.cmd [[
  packadd nvim-lspconfig
  packadd mason.nvim
  packadd mason-lspconfig.nvim
  ]]

  require("mason").setup({})
  require("mason-lspconfig").setup({
    automatic_enable = true,
  })

end)
