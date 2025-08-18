vim.pack.add {
  "https://github.com/folke/tokyonight.nvim"
}

require('tokyonight').setup {
  on_colors = function(colors)
    colors.bg_statusline = colors.none -- To check if its working try something like "#ff00ff" instead of colors.none
    colors.bg_statusline = colors.none
  end,
}

vim.cmd.colorscheme 'tokyonight-night'
