return {
  {
    "folke/tokyonight.nvim",
    opts = {
      dim_inactive = false,
      style = "night",
      transparent = false,
      styles = {
        -- sidebars = "transparent",
        -- floats = "transparent",
        -- functions = { bold = true },
        -- keywords = { bold = true },
      },
      on_colors = function(colors)
        colors.bg_statusline = colors.none -- To check if its working try something like "#ff00ff" instead of colors.none
        -- colors.bg = colors.none
        --   vim.api.nvim_set_hl(0, "BufferlineBackground", { bg = "none" })
        --   vim.api.nvim_set_hl(0, "Tablinefill", { bg = "none" })
        --   vim.api.nvim_set_hl(0, "BufferlineFill", { bg = "none" })
        --   vim.api.nvim_set_hl(0, "BufferLineCloseButtonVisible", { bg = "none" })
        --   vim.api.nvim_set_hl(0, "BufferLineHint", { bg = "none" })
        --   vim.api.nvim_set_hl(0, "BufferLineHintVisible", { bg = "none" })
        --   vim.api.nvim_set_hl(0, "BufferLineBufferVisible", { bg = "none" })
        --   vim.api.nvim_set_hl(0, "BufferLineCloseButton", { bg = "none" })
      end,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
  },
  { "rebelot/kanagawa.nvim", name = "kanagawa" },
  {
    "rose-pine/neovim",
  },
  {
    "shaunsingh/nord.nvim",
  },
}
