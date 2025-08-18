vim.pack.add { "https://github.com/williamboman/mason.nvim" }
require("mason").setup()

vim.pack.add { "https://github.com/neovim/nvim-lspconfig" }

vim.pack.add { "https://github.com/mason-org/mason-lspconfig.nvim", }
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "rust_analyzer", "marksman" },
})
