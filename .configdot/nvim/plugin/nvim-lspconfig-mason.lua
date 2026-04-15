vim.schedule(function()
  vim.pack.add({
    "https://github.com/romus204/tree-sitter-manager.nvim",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/neovim/nvim-lspconfig",
  })
  require("mason").setup()
  require("mason-lspconfig").setup({
    automatic_enable = true,
  })
end)
