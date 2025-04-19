return {
  "nvim-java/nvim-java",
  config = function()
    require("java").setup()
    require("lspconfig").jdtls.setup({})
  end,
  keys = {
    { "<leader>cjr", "<Cmd>JavaRunnerRunMain<Cr>", { desc = "Run Main" } },
    { "<leader>cjs", "<Cmd>JavaRunnerStopMain<Cr>", { desc = "Stop Main" } },
  },
}
