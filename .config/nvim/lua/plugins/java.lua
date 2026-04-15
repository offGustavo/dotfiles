return {
  "nvim-java/nvim-java",
  dependencies = {
    -- "williamboman/mason.nvim",
    -- "williamboman/mason-lspconfig.nvim",
    -- "neovim/nvim-lspconfig",
    -- "mfussenegger/nvim-dap",
  },
  config = function()
    require("java").setup({
      jdtls = {
        version = "v1.43.0",
      },
      jdk = {
        -- install jdk using mason.nvim
        auto_install = true,
        version = "21.0.7",
      },
    })
    require("lspconfig").jdtls.setup({})
  end,
  keys = {
    { "<leader>cjr", "<Cmd>JavaRunnerRunMain<Cr>", { desc = "Run Main" } },
    { "<leader>cjs", "<Cmd>JavaRunnerStopMain<Cr>", { desc = "Stop Main" } },
  },
}
