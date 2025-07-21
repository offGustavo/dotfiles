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
    event = "VeryLazy",
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
      { "<leader>op", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },

  {
    "r-pletnev/pdfreader.nvim",
    lazy = false,
    enabled = false,
    dependencies = {
      "folke/snacks.nvim", -- image rendering
      "nvim-telescope/telescope.nvim", -- pickers
    },
    config = function()
      require("pdfreader").setup()
    end,
  },
}
