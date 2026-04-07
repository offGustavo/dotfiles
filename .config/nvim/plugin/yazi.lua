-- if true then return end
vim.g.loaded_netrwPlugin = 1

vim.autocmd("UIEnter", {
	callback = function()
		vim.cmd.packadd("plenary.nvim")
		vim.cmd.packadd("yazi.nvim")
		require("yazi").setup({
			-- open_for_directories = true,
		})
	end,
})

-- vim.keymap.set("n", "<M-e>", ":Yazi<CR>", { desc = "Yazi" })
