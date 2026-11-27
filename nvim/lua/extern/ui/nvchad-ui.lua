return {

  {
    "nvchad/ui",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
      "nvim-lua/plenary.nvim",

      {
        "nvchad/base46",
        lazy = true,
        build = function()
          require("base46").load_all_highlights()
        end,
      },
      -- "nvchad/volt", -- optional, needed for theme switcher
    },
    lazy = false,
    config = function()
      require "nvchad"
    end,
  },
}
