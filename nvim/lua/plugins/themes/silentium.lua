return {
  "https://github.com/silentium-theme/silentium.nvim",
  enabled = true,
  lazy = false,
  config = function()
    local silentium = require("silentium")
    silentium.setup({
      accent = "#9d7cd8",
      white = "#c0caf5", -- fg
      light_gray = "#9ece6a", -- fg_dark
      gray = "#565f89", -- comment
      ghost = "#3b4261", -- fg_gutter
      dark_gray = "#292e42", -- bg_highlight
      dark = "#1a1b26", -- bg
      diff_add = "#243e4a",
      diff_change = "#1f2231",
      diff_delete = "#4a272f",
      diff_text = "#394b70",
    })

    colorscheme({
      dark = "silentium",
      light = "tokyo-day",
    })
  end,
}
