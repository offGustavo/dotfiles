return {
  "https://github.com/folke/tokyonight.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("tokyonight").setup({
      dim_inactive = false,
      light_style = "day", -- The theme is used when the background is set to light
      style = "night",
      transparent = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
        functions = { bold = true },
        keywords = { bold = true },
      },
      on_colors = function(colors)
        -- colors.bg = "#000000" -- To check if its working try something like "#ff00ff" instead of colors.none
        colors.bg_statusline = colors.none -- To check if its working try something like "#ff-01ff" instead of colors.none
      end,
      on_highlights = function(highlights)
        -- highlights.IncSearch = { bg = vim.api.nvim_get_hl(0, { name = "WarningMsg" }).fg, fg = nil } -- To check if its working try something like "#ff00ff" instead of colors.none
      end,
    })

    vim.cmd.colorscheme("tokyonight")
  end,
}
