-- vim: foldmethod=marker

-- PERF:
vim.loader.enable()

_G.Fish = {}

-- Custom AuGroup
_G.fish_group = vim.api.nvim_create_augroup("Fish.config", {
  clear = false,
})

-- {{{ Set a temp theme here to prevent light/dark flicker and for kitty_scroll_mode
if vim.o.background == "dark" then
  vim.cmd.colorscheme("tokyo")
else
  vim.cmd.colorscheme("tokyo-day")
end
-- }}}

-- {{{ Config Files
if os.getenv("SCROLL_MODE") then
  vim.cmd.call("kitty#setup()")
  return
end

require("config.functions")
require("config.options")
require("config.autocmds")
require("config.commands")
require("config.keymaps")
require("config.lsp")
require("config.multicursor")
require("config.syntax_highlight")

if vim.g.neovide then
  require("config.neovide")
end
-- }}}

-- {{{ Lazy Plugins
require("config.lazy").add({
  -- General
  { import = "plugins.mini" },
  { import = "plugins.snacks" },

  -- Theme
  { import = "plugins.tokyonight" },

  -- File Explorer
  { import = "plugins.canola" },

  -- Picker
  -- { import = "plugins.fzf-lua" },

  -- Git
  { import = "plugins.fugitive" },
  -- { import = "plugins.neogit" },

  -- Quickfix
  { import = "plugins.quicker" },

  -- LSP
  { import = "plugins.mason-lspconfig" },

  -- Treesitter
  { import = "plugins.treesitter" },

  -- Format
  { import = "plugins.conform" },

  -- Completion
  { import = "plugins.blink" },

  -- System
  -- { "https://github.com/tpope/vim-eunuch", lazy = true, event = "CmdLineEnter" },

  -- UI
  { import = "plugins.which-key" },
  -- { import =  "plugins.todo-comments" },
  -- { import =  "plugins.nvim-colorizer" },

  -- Agenda
  { import = "plugins.org" },

  -- On Demand
  -- { "https://github.com/nstefan002/screenkey.nvim" },
})
-- }}}

-- {{{ Local Plugins
require("offGustavo.espeto.setup")
require("offGustavo.lazygit")
require("offGustavo.TabTerm.setup")
require("offGustavo.todo")
require("offGustavo.yazi")
require("offGustavo.cedit").setup({ key = "<M-x>" })
require("offGustavo.compile-mode")
-- require("Tatr")
-- }}}
