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
  require("config.kitty_scroll_mode")
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
  { import = "plugins.fugitive-neogit" },

  -- Quickfix
  { import = "plugins.quicker" },

  -- LSP
  -- TODO(lsp): remove Mason and the mason-lspconfig plugin.
  --   - install language servers with the system package manager
  --   - move the server setup into my own config with `vim.lsp.config()` and
  --     `vim.lsp.enable()` (needs Neovim 0.11+), one file per server in `lsp/`
  --   - keep `lspconfig` only for servers that have no native config
  { import = "plugins.mason-lspconfig" },

  -- Treesitter
  { import = "plugins.treesitter" },

  -- Format
  -- TODO(format): drop conform and format through Neovim itself.
  --   - set `formatprg` per filetype in `ftplugin/<ft>.lua` (e.g. "stylua -",
  --     "prettier --stdin-filepath %")
  --   - format with `gq`, and map it to a key for the whole buffer
  --   - keep conform only for formatters that can't work as a stdin filter
  { import = "plugins.conform" },

  -- Completion
  { import = "plugins.blink" },

  -- System
  -- "https://github.com/tpope/vim-eunuch",

  --   -- UI
  { import = "plugins.which-key" },

  -- TODO(todo-comments): make a lua module to replace todo-comments
  -- 1. DONE highlighting Comments
  -- 2. DONE highlighting colors
  -- 3. DONE sign for TODOs
  -- { import =  "plugins.todo-comments" },
  -- { import =  "plugins.nvim-colorizer" },
  -- "https://github.com/catgoose/nvim-colorizer.lua",
  -- "https://github.com/folke/todo-comments.nvim",

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
