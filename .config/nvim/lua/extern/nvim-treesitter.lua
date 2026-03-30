if true then return {} end

-- REF: https://www.reddit.com/r/NixOS/comments/1raqini/i_built_a_vs_code_extension_that_brings_syntax/
return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			-- {
			--   "nvim-treesitter/nvim-treesitter-context",
			--   opts = {
			--     max_lines = 4,
			--     multiline_threshold = 2,
			--   },
			-- },
		},
		branch = "main",
		lazy = true,
		event = "VeryLazy",
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			-- ts.install("all", { summary = false }, { max_jobs = 24 }):wait(1000000)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function()
					if pcall(vim.treesitter.start) then
						-- Indent expérimental
						-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						-- Folds
						vim.wo[0][0].foldmethod = "expr"
						vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
					end
				end,
			})
		end,
	},
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-textobjects",
	-- 	branch = "main",
	-- 	lazy = true,
	-- 	event = "VeryLazy",
	-- },
}
