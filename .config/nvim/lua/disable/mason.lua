if true then return {} end
-------------
--- Mason ---
-------------
vim.keymap.set("n", "<leader>lm", ":Mason<Cr>", { desc = "Mason", silent = true })

return {
	"mason-org/mason-lspconfig.nvim",
	lazy = true,
	event = "VeryLazy",
	opts = {
		automatic_enable = true,
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {}, lazy = true, event = "VeryLazy" },
		-- "neovim/nvim-lspconfig", 
  },
}
