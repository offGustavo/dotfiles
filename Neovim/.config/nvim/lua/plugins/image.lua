return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      image = {
        -- your image configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    -- event = "VeryLazy",
    lazy = true,
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
      default = {
        -- file and directory options
        dir_path = "assets", ---@type string | fun(): string
        use_absolute_path = false, ---@type boolean | fun(): boolean
      },
    },
    keys = {
      -- suggested keymap
      { "<leader>ii", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
}
