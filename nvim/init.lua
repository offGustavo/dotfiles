-- vim: foldmethod=marker

-- PERF:
vim.loader.enable()

_G.Fish = {}

-- Custom AuGroup
_G.fish_group = vim.api.nvim_create_augroup("Fish.config", {
  clear = false,
})

-- {{{ Config Files
-- NOTE: this should be load first, this entire config depends on functions provided by this module
require("config.functions")

-- {{{ Set a temp theme here to prevent light/dark flicker and for kitty_scroll_mode
colorscheme({ dark = "tokyo", light = "tokyo-day" })
-- }}}

if os.getenv("SCROLL_MODE") then
  -- require("config.helix").setup()
  source("kitty")
  return
end

require("config.options")
require("config.autocmds")
require("config.commands")
require("config.keymaps")
require("config.emacs")
require("config.lsp")
require("config.multicursor")
require("config.syntax_highlight")

if vim.g.neovide then
  require("config.neovide")
end

-- }}}

-- {{{ Local Plugins
require("offGustavo.espeto.setup")
require("offGustavo.lazygit")
require("offGustavo.TabTerm.setup")
require("offGustavo.todo-comments")
require("offGustavo.yazi")
require("offGustavo.ui.highlight_operation")
-- require("offGustavo.compile-mode")
require("Fish.git_branch").setup()
-- require("Tatr")
-- }}}

-- {{{ Lazy Plugins
require("config.lazy").add({

  -- -- add LazyVim and import its plugins
  -- { "LazyVim/LazyVim", import = "lazyvim.plugins" },

  -- General
  { import = "plugins.general.mini" },
  -- { import = "plugins.general.snacks" },

  -- Theme
  -- { import = "plugins.themes.tokyonight" },
  { import = "plugins.themes.nord" },
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
  -- { import = "plugins.editor.picker.minibuffer" },

  -- Git
  { import = "plugins.editor.fugitive" },
  -- { import = "plugins.editor.neogit" },

  -- Quickfix
  { import = "plugins.editor.quicker" },

  -- LSP
  { import = "plugins.coding.mason-lspconfig" },

  -- Treesitter
  { import = "plugins.coding.treesitter" },

  -- Format
  { import = "plugins.coding.conform" },

  -- Completion
  { import = "plugins.coding.blink" },
  { import = "plugins.coding.lazydev" },

  -- System
  -- { "https://github.com/tpope/vim-eunuch", lazy = true, event = "CmdLineEnter" },
  { import = "plugins.util.kitty-scrollback" },
  -- { import = "plugins.util.compile-mode" },
  { import = "plugins.util.cuik" },

  -- UI
  { import = "plugins.ui.which-key" },
  -- { import = "plugins.ui.menu" },
  -- { import =  "plugins.nvim-colorizer" },
  -- { import = "plugins.ui.baleia" },
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

  {
    dir = "~/Projects/tatr.vim/",
    enabled = not is_windows(),
    lazy = false,
    init = function()
      vim.g.tatr_short_cmd = true
    end,
  },

})
-- }}}

