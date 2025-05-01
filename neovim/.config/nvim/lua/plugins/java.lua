return {
  {
    "nvim-java/nvim-java",
    config = function()
      require("java").setup()
      require("lspconfig").jdtls.setup({})
    end,
    keys = {
      { "<leader>cjr", "<Cmd>JavaRunnerRunMain<Cr>", { desc = "Run Main" } },
      { "<leader>cjs", "<Cmd>JavaRunnerStopMain<Cr>", { desc = "Stop Main" } },
    },
  },
  -- {
  --   "JavaHello/spring-boot.nvim",
  --   ft = "java",
  --   dependencies = {
  --     "mfussenegger/nvim-jdtls", -- or nvim-java, nvim-lspconfig
  --     "ibhagwan/fzf-lua", -- optional
  --   },
  --   config = function()
  --     require("spring_boot").setup({})
  --   end,
  -- },
}
