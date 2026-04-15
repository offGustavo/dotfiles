vim.schedule(function()
	vim.pack.add({
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/esmuellert/codediff.nvim",
		"https://github.com/NeogitOrg/neogit",
	})
	-- vim.keymap.set("n", "<M-S-g>", "<Cmd>Neogit kind=replace<Cr>", { desc = "Neogit" })

  vim.pack.add({ "https://github.com/tpope/vim-fugitive" })
	vim.keymap.set("n", "<M-S-g>", "<Cmd>Git<Cr>", { desc = "Git" })
end)
