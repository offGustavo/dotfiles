return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function()
      require("mason-nvim-dap").setup()
    end,
  },
  {
    "rareitems/printer.nvim",
    config = function()
      require("printer").setup({
        keymap = "gp", -- Plugin doesn't have any keymaps by default
      })
    end,
  },
}
