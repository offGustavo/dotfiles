return {

  {
    "folke/tokyonight.nvim",
    opts = {
      dim_inactive = false,
      style = "night",
      transparent = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
        -- functions = { bold = true },
        -- keywords = { bold = true },
      },
      on_colors = function(colors)
        colors.bg_statusline = colors.none -- To check if its working try something like "#ff00ff" instead of colors.none
      end,
    },
  },

  -- { "catppuccin/nvim", name = "catppuccin", lazy = true },

  -- { "rebelot/kanagawa.nvim", name = "kanagawa", lazy = true },

  -- { "rose-pine/neovim", lazy = true },

  -- { "shaunsingh/nord.nvim", lazy = true },

  { "ellisonleao/gruvbox.nvim", lazy = true },

  -- { "SomeCoder99/darkslate.nvim", lazy = true },

  -- { "Mofiqul/adwaita.nvim", lazy = false, priority = 1000 },
}
