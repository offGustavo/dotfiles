vim.g.mapleader = " "
-- FIXME: ????
vim.g.maplocalleader = "<M-m>"

_G.Fish = {}

vim.pack.add({
    "https://github.com/RRethy/base16-nvim",
    "https://github.com/folke/flash.nvim",
    "https://github.com/folke/tokyonight.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/mikavilpas/yazi.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    { src = "https://github.com/Saghen/blink.cmp",     version = vim.version.range("*") },
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/OXY2DEV/markview.nvim",
    "https://github.com/HakonHarnes/img-clip.nvim",
    "https://github.com/zenarvus/md-agenda.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/esmuellert/codediff.nvim",
    "https://github.com/NeogitOrg/neogit",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/brenton-leighton/multiple-cursors.nvim",
    "https://github.com/stevearc/quicker.nvim",
    "https://github.com/folke/snacks.nvim",
    "https://github.com/folke/tokyonight.nvim",
    "https://github.com/chomosuke/term-edit.nvim",
    "https://github.com/offGustavo/nvim-sessionizer",
    "https://github.com/stevearc/oil.nvim",
  },
  {
    load = function()
    end
  })

if vim.o.background == "dark" then
  -- vim.cmd.colorscheme("shibuya")
  vim.cmd.colorscheme("tokyo")
else
  -- vim.cmd('packadd base16-nvim')
  -- vim.cmd.colorscheme("base16-gruvbox-light")
  vim.cmd.colorscheme("tokyo-day")
end
