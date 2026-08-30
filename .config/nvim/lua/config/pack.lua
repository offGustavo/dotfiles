vim.pack.add({
  -- Tokyonight
  { src = "https://github.com/folke/tokyonight.nvim" },
  -- Canola/Oil
  { src = "https://github.com/barrettruth/canola.nvim", version = "canola" },
  -- Snacks
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/tpope/vim-fugitive" },
})

local tokyonight_config = require("extern.themes.tokyonight")
require("tokyonight").setup(tokyonight_config.opts)
tokyonight_config.init()

local snacks_config = require("extern.snacks")
require("snacks").setup(snacks_config.opts)
map(snacks_config.keys)
snacks_config.init()

local canola_config = require("extern.editor.canola")
map(canola_config.keys)
canola_config.init()
