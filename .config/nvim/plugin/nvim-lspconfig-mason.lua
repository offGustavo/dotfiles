vim.schedule(function()
  vim.cmd.packadd("nvim-lspconfig")
  vim.cmd.packadd("mason.nvim")
  vim.cmd.packadd("mason-lspconfig.nvim")
  require("mason").setup()

  require("mason-lspconfig").setup({
    automatic_enable = true,
  })
end)
