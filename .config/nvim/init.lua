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

if vim.g.neovide then
  require("config.neovide")
end
-- }}}

-- {{{ Local Plugins
require("offGustavo.espeto.setup")
require("offGustavo.lazygit")
require("offGustavo.TabTerm.setup")
require("offGustavo.todo")
require("offGustavo.yazi")
require("offGustavo.cedit").setup({ key = "<M-x>" })
require("offGustavo.compile-mode")
require("Tatr")
-- }}}

-- {{{ Plugins

vim.pack.add({

  -- General
  "https://github.com/folke/snacks.nvim",
  "https://github.com/nvim-mini/mini.nvim",

  -- File Explorer
  { src = "https://forge.barrettruth.com/barrettruth/canola.nvim", version = "canola" },
  -- "https://github.com/nvim-lua/plenary.nvim",
  -- { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },

  -- Picker
  "https://github.com/ibhagwan/fzf-lua",

  -- Git
  "https://github.com/nvim-lua/plenary.nvim", -- required
  "https://github.com/esmuellert/codediff.nvim", -- optional
  "https://github.com/m00qek/baleia.nvim", -- optional
  "https://github.com/NeogitOrg/neogit",

  -- Quickfix 
  "https://github.com/stevearc/quicker.nvim",

  -- LSP
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/mason-org/mason.nvim",

  -- Treesitter
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/folke/ts-comments.nvim",

  -- Format
  "https://github.com/stevearc/conform.nvim",

  -- Completion
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/folke/lazydev.nvim",
  { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("v1") },

  -- UI
  "https://github.com/folke/which-key.nvim",
  -- "https://github.com/catgoose/nvim-colorizer.lua",
  -- "https://github.com/folke/todo-comments.nvim",

  -- Theme
  "https://github.com/folke/tokyonight.nvim",

  -- Agenda
  "https://github.com/xheisenbugx/org.nvim",
  -- "https://github.com/offGustavo/md-agenda.nvim"

  -- On Demand
  "https://github.com/dstein64/vim-startuptime",
  "https://github.com/nvzone/showkeys",
  -- "https://github.com/nstefan002/screenkey.nvim",
})
-- }, { load = function() end })
--- }}}

-- {{{ Plugins Config

require("extern.canola")
require("extern.fzf-lua")

-- TODO(harpoon): make `espeto` work like harpoon (a persistent list of marked
-- files with quick jump), then drop this plugin.
-- require("extern.harpoon")

-- TODO(format): drop conform and format through Neovim itself.
--   - set `formatprg` per filetype in `ftplugin/<ft>.lua` (e.g. "stylua -",
--     "prettier --stdin-filepath %")
--   - format with `gq`, and map it to a key for the whole buffer
--   - keep conform only for formatters that can't work as a stdin filter
require("extern.conform")
require("extern.quicker")

-- TODO(lsp): remove Mason and the mason-lspconfig plugin.
--   - install language servers with the system package manager
--   - move the server setup into my own config with `vim.lsp.config()` and
--     `vim.lsp.enable()` (needs Neovim 0.11+), one file per server in `lsp/`
--   - keep `lspconfig` only for servers that have no native config
require("extern.mason-lspconfig")

require("extern.snacks")
require("extern.mini")
require("extern.neogit")
require("extern.startuptime")
require("extern.tokyonight")

-- TODO(treesitter): stop depending on the plugin to manage parsers.
--   - install parsers with the system package manager or build them by hand
--   - start highlighting per filetype with `vim.treesitter.start()` in
--     `ftplugin/<ft>.lua`
--   - set `foldexpr` and `indentexpr` in the same ftplugin where supported
require("extern.treesitter")

require("extern.which-key")

-- TODO(todo-comments): make a lua module to replace todo-comments
-- 1. DONE highlighting Comments
-- 2. highlighting colors
-- 3. sign for TODOs
-- require("extern.todo-comments")
-- require("extern.nvim-colorizer")

require("extern.blink")
require("extern.org")

-- }}}
