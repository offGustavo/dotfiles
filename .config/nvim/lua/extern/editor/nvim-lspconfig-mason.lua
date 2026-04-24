return {
  "https://github.com/mason-org/mason-lspconfig.nvim",
  event = "VeryLazy",
  opts = {
    automatic_enable = true,
  },
  dependencies = {
    { "https://github.com/mason-org/mason.nvim", opts = {} },
    "https://github.com/neovim/nvim-lspconfig",
  },
}
