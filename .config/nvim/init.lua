-- Download plugins without adding they
vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/folke/flash.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/brenton-leighton/multiple-cursors.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/esmuellert/codediff.nvim",
	"https://github.com/NeogitOrg/neogit",
	-- "https://github.com/mikavilpas/yazi.nvim",
	"https://github.com/HakonHarnes/img-clip.nvim",
	"https://github.com/zenarvus/md-agenda.nvim",
	{
		src = "https://github.com/Saghen/blink.cmp",
		version = vim.version.range("*"),
	},
	"https://github.com/rafamadriz/friendly-snippets",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
	"https://github.com/romus204/tree-sitter-manager.nvim",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/neovim/nvim-lspconfig",
}, {
	load = function() end,
})

vim.g.mapleader = " "
vim.g.maplocalleader = "<M-m>"

vim.autocmd = vim.api.nvim_create_autocmd
vim.doautocmd = vim.api.nvim_exec_autocmds
