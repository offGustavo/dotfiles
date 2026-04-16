-- We set the leader and localleader keys before any mapping
vim.g.mapleader = " "
vim.g.maplocalleader = "<M-m>"

-- Set Global state
_G.Fish = {}

-- Set our temp theme
if vim.o.background == "dark" then
  vim.cmd.colorscheme("tokyo")
else
  vim.cmd.colorscheme("tokyo-day")
end

vim.pack.add({
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
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/brenton-leighton/multiple-cursors.nvim",
    "https://github.com/stevearc/quicker.nvim",
    "https://github.com/folke/snacks.nvim",
    "https://github.com/folke/tokyonight.nvim",
  },
  {
    load = function()
    end
  })
