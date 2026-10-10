return {
  "https://github.com/silentium-theme/silentium.nvim",
  enabled = false,
  config = function()
local silentium = require("silentium")
    silentium.setup({
      accent = silentium.accents.yellow,
      white = "#c0caf5", -- fg
      light_gray = "#a9b1d6", -- fg_dark
      gray = "#565f89", -- comment
      ghost = "#3b4261", -- fg_gutter
      dark_gray = "#292e42", -- bg_highlight
      dark = "#1a1b26", -- bg
      diff_add = "#20303b",
      diff_change = "#1f2231",
      diff_delete = "#37222c",
      diff_text = "#394b70",
    })
  end,
}
