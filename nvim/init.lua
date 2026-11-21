-- vim: foldmethod=marker

-- {{{ Global Things
-- PERF:
vim.loader.enable()

-- vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"

_G.Fish = {}

-- Custom AuGroup
_G.fish_group = vim.api.nvim_create_augroup("Fish.config", {
  clear = false,
})
-- }}}

-- {{{ Config Files
-- WARN: this should be load first, this entire config depends on functions provided by this module
require("config.functions")

-- NOTE: Set a temp theme here to prevent light/dark flicker and for kitty_scroll_mode
-- colorscheme({ dark = "tokyo", light = "tokyo-day" })

if os.getenv("SCROLL_MODE") then
  -- require("config.helix").setup()
  source("kitty")
  return
end

require("config.options")
require("config.syntax_highlight")
require("config.ui2")
require("config.autocmds")
require("config.commands")
require("config.keymaps")
require("config.emacs")
require("config.lsp")
require("config.multicursor")

if vim.g.neovide then
  require("config.neovide")
end

-- }}}

-- {{{ Local Plugins
require("offGustavo.espeto.setup")
require("offGustavo.lazygit")
require("offGustavo.TabTerm.setup")
require("offGustavo.todo-comments")
require("offGustavo.ui.highlight_operation")
-- require("offGustavo.compile-mode")
require("Fish.git_branch").setup()
-- require("Tatr")
-- }}}

-- {{{ Lazy Plugins
require("config.lazy").add({

  -- -- add LazyVim and import its plugins
  -- { "LazyVim/LazyVim", import = "lazyvim.plugins" },

  -- -- NvChad
  -- {
  --   "NvChad/NvChad",
  --   lazy = false,
  --   branch = "v2.5",
  --   import = "nvchad.plugins",
  -- },

  -- {
  --   "AstroNvim/AstroNvim",
  --   version = "^6", -- Remove version tracking to elect for nightly AstroNvim
  --   import = "astronvim.plugins",
  --   opts = { -- AstroNvim options must be set here with the `import` key
  --     mapleader = " ", -- This ensures the leader key must be configured before Lazy is set up
  --     maplocalleader = "\\", -- This ensures the localleader key must be configured before Lazy is set up
  --     icons_enabled = true, -- Set to false to disable icons (if no Nerd Font is available)
  --     pin_plugins = nil, -- Default will pin plugins when tracking `version` of AstroNvim, set to true/false to override
  --     update_notifications = true, -- Enable/disable notification about running `:Lazy update` twice to update pinned plugins
  --   },
  -- },
  -- { import = "astronvim.community" },

  -- General
  { import = "plugins.general.mini" },
  { import = "plugins.general.snacks.init" },

  -- Theme
  { import = "plugins.themes.tokyonight" },
  -- { import = "plugins.themes.nord" },
  -- { import = "plugins.themes.base16" },
  -- { import = "plugins.themes.silentium" },

  -- File Explorer
  -- { import = "plugins.editor.explorer.canola" },
  -- { import = "plugins.editor.explorer.oil" },
  -- { import = "plugins.editor.explorer.yazi" },
  -- { import = "plugins.editor.explorer.vim-dirvish" },
  { import = "plugins.editor.explorer.dired" },

  -- Picker
  { import = "plugins.editor.picker.fzf-lua" },
  -- { import = "plugins.editor.picker.telescope" },
  -- { import = "plugins.general.snacks.picker" },
  -- { import = "plugins.editor.picker.minibuffer" },

  -- Git
  { import = "plugins.editor.fugitive" },
  -- { import = "plugins.editor.neogit" },

  -- Quickfix
  { import = "plugins.editor.quicker" },

  -- LSP
  -- { import = "plugins.coding.nvim-lspconfig" },
  -- { import = "plugins.coding.mason" },
  -- { import = "plugins.coding.mason-lspconfig" },

  -- Treesitter
  { import = "plugins.coding.nvim-treesitter" },
  { import = "plugins.coding.nvim-treesitter-textobjects" },

  -- Format
  { import = "plugins.coding.conform" },

  -- Completion
  { import = "plugins.coding.blink" },
  -- { import = "plugins.coding.lazydev" },

  -- System
  -- { "https://github.com/tpope/vim-eunuch", lazy = true, event = "CmdLineEnter" },
  -- { import = "plugins.util.kitty-scrollback" },
  -- { import = "plugins.util.compile-mode" },
  { import = "plugins.util.cuik" },
  { import = "plugins.util.tatr" },


  -- UI
  -- { import = "plugins.ui.which-key" },
  -- { import = "plugins.ui.menu" },
  -- { import =  "plugins.ui.nvim-colorizer" },
  -- { import =  "plugins.ui.todo-comments" },
  -- { import = "plugins.ui.baleia" },
  -- { import = "plugins.ui.nvchad-ui" },
  -- { import = "plugins.ui.noice" },
  -- { import = "plugins.ui.lualine" },
  -- { import = "plugins.ui.tabby" },
  -- { "https://github.com/nstefan002/screenkey.nvim" },

  -- Agenda
  { import = "plugins.util.org-nvim" },
  -- { import = "plugins.util.orgmode" },

  -- Markdown
  -- { import = "plugins.ui.markview" },
  -- { import = "plugins.util.md-agenda" },

  -- Typing
  -- { import = "plugins.util.typr" },

  -- Sessions
  -- { import = "plugins.util.nvim-sessionizer" },
})

-- -- NvChad: load theme
-- dofile(vim.g.base46_cache .. "defaults")
-- dofile(vim.g.base46_cache .. "statusline")

-- require "nvchad.options"
-- require "nvchad.mappings"
-- require "nvchad.autocmds"

-- }}}
