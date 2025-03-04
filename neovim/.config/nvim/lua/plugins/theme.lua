return {
  {
    "folke/tokyonight.nvim",
    opts = {
      dim_inactive = true,
      style = "night",
      transparent = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
        -- keywords = { bold = true },
        -- functions = { bold = true },
      },
      on_colors = function(colors)
        colors.bg_statusline = colors.none -- To check if its working try something like "#ff00ff" instead of colors.none
        -- colors.bg = colors.none
        -- vim.api.nvim_set_hl(0, "BufferlineBackground", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "Tablinefill", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "BufferlineFill", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "BufferLineCloseButtonVisible", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "BufferLineHint", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "BufferLineHintVisible", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "BufferLineBufferVisible", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "BufferLineCloseButton", { bg = "none" })
      end,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false, -- disables setting the background color.
      show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
      term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = true, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      no_underline = false, -- Force no underline
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "intalic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
      },
      color_overrides = {},
      custom_highlights = {},
      default_integrations = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
      },
    },
    priority = 1000,
  },

  { "rebelot/kanagawa.nvim", name = "kanagawa" },

  {
    "rose-pine/neovim",
  },
  {
    "shaunsingh/nord.nvim",
  },
}
