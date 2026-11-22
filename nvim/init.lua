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
set {
  termguicolors = false,
}

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
require("intern.cuik")
require("intern.tatr")
require("intern.dired")
require("intern.espeto")
require("intern.lazygit")
require("intern.TabTerm")

-- TODO: Change The config files to Fish.
require("offGustavo.todo-comments")
require("offGustavo.ui.highlight_operation")
require("Fish.git_branch").setup()
-- require("offGustavo.compile-mode")
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
        { import = "extern.general.mini" },
        { import = "extern.general.snacks.init" },

        -- Theme
        -- { import = "extern.themes.tokyonight" },
        -- { import = "extern.themes.nord" },
        { import = "extern.themes.base16" },
        -- { import = "extern.themes.silentium" },

        -- File Explorer
        -- { import = "extern.editor.explorer.canola" },
        -- { import = "extern.editor.explorer.oil" },
        -- { import = "extern.editor.explorer.yazi" },
        -- { import = "extern.editor.explorer.vim-dirvish" },
        -- { import = "extern.editor.explorer.dired" },

        -- Picker
        { import = "extern.editor.picker.fzf-lua" },
        -- { import = "extern.editor.picker.fzf-vim" },
        -- { import = "extern.editor.picker.telescope" },
        -- { import = "extern.general.snacks.picker" },
        -- { import = "extern.editor.picker.minibuffer" },

        -- Git
        { import = "extern.editor.fugitive" },
        -- { import = "extern.editor.neogit" },

        -- Quickfix
        { import = "extern.editor.quicker" },

        -- LSP
        -- { import = "extern.coding.nvim-lspconfig" },
        -- { import = "extern.coding.mason" },
        -- { import = "extern.coding.mason-lspconfig" },

        -- Treesitter
        { import = "extern.coding.nvim-treesitter" },
        { import = "extern.coding.nvim-treesitter-textobjects" },

        -- Format
        { import = "extern.coding.conform" },

        -- Completion
        { import = "extern.coding.blink" },
        -- { import = "extern.coding.lazydev" },

        -- System
        -- { "https://github.com/tpope/vim-eunuch", lazy = true, event = "CmdLineEnter" },
        -- { import = "extern.util.kitty-scrollback" },
        -- { import = "extern.util.compile-mode" },
        -- { import = "extern.util.cuik" },
        -- { import = "extern.util.tatr" },

        -- UI
        -- { import = "extern.ui.which-key" },
        -- { import = "extern.ui.menu" },
        -- { import =  "extern.ui.nvim-colorizer" },
        -- { import =  "extern.ui.todo-comments" },
        -- { import = "extern.ui.baleia" },
        -- { import = "extern.ui.nvchad-ui" },
        -- { import = "extern.ui.noice" },
        -- { import = "extern.ui.lualine" },
        -- { import = "extern.ui.tabby" },
        -- { "https://github.com/nstefan002/screenkey.nvim" },

        -- Agenda
        -- { import = "extern.util.org-nvim" },
        -- { import = "extern.util.orgmode" },

        -- Markdown
        -- { import = "extern.ui.markview" },
        -- { import = "extern.util.md-agenda" },

        -- Typing
        -- { import = "extern.util.typr" },

        -- Sessions
        -- { import = "extern.util.nvim-sessionizer" },
      })

      -- -- NvChad: load theme
      -- dofile(vim.g.base46_cache .. "defaults")
      -- dofile(vim.g.base46_cache .. "statusline")

      -- require "nvchad.options"
      -- require "nvchad.mappings"
      -- require "nvchad.autocmds"

      -- }}}
