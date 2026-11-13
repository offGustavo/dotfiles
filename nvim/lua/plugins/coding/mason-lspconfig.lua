return {
  "https://github.com/mason-org/mason-lspconfig.nvim",
  lazy = true,
  event = "VeryLazy",
  opts = {
    automatic_enable = true,
    ensure_installed = {
      "lua_ls",
      "rust_analyzer"
    },
  },
  dependencies = {
    "https://github.com/neovim/nvim-lspconfig",
    { "https://github.com/mason-org/mason.nvim", opts = {} },
  },
}
