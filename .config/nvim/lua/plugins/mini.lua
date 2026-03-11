return {
	"nvim-mini/mini.nvim",
	version = false,
	lazy = true,
	event = "VeryLazy",
	config = function()
		require("mini.git").setup({})
		require("mini.diff").setup({
			-- Options for how hunks are visualized
			view = {
				-- Visualization style. Possible values are 'sign' and 'number'.
				-- Default: 'number' if line numbers are enabled, 'sign' otherwise.
				-- style = vim.go.number and 'number' or 'sign',
				style = "sign",

				-- Signs used for hunks with 'sign' view
				-- signs = { add = '▒', change = '▒', delete = '▒' },
				signs = { add = "+", change = "~", delete = "-" },

				-- Priority of used visualization extmarks
				priority = 1,
			},
		})

		local format_summary = function(data)
			local summary = vim.b[data.buf].minidiff_summary
			local t = {}
			if summary.add > 0 then
				table.insert(t, "+" .. summary.add)
			end
			if summary.change > 0 then
				table.insert(t, "~" .. summary.change)
			end
			if summary.delete > 0 then
				table.insert(t, "-" .. summary.delete)
			end
			vim.b[data.buf].minidiff_summary_string = table.concat(t, " ")
		end
		local au_opts = { pattern = "MiniDiffUpdated", callback = format_summary }
		vim.api.nvim_create_autocmd("User", au_opts)
		require("mini.ai").setup({})
		-- require("mini.sessions").setup({})
		require("mini.surround").setup({
			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				add = "sa", -- Add surrounding in Normal and Visual modes
				delete = "sd", -- Delete surrounding
				find = "sf", -- Find surrounding (to the right)
				find_left = "sF", -- Find surrounding (to the left)
				highlight = "sh", -- Highlight surrounding
				replace = "sr", -- Replace surrounding
				update_n_lines = "sn", -- Update `n_lines`
				suffix_last = "p", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
		})
		require("mini.move").setup({
			mappings = {
				-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
				left = "<M-h>",
				right = "<M-l>",
				down = "<M-j>",
				up = "<M-k>",
			},
			-- Options which control moving behavior
			options = {
				-- Automatically reindent selection during linewise vertical move
				reindent_linewise = true,
			},
		})
		local hipatterns = require("mini.hipatterns")
		hipatterns.setup({
			highlighters = {
				fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
				hack = { pattern = "HACK", group = "MiniHipatternsHack" },
				todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
				note = { pattern = "NOTE", group = "MiniHipatternsNote" },
				perf = { pattern = "PERF", group = "MiniIconsPurple" },
				hex_color = hipatterns.gen_highlighter.hex_color(),
			},
		})

		local miniclue = require("mini.clue")
		miniclue.setup({
			triggers = {
				-- Leader triggers
				{ mode = { "n", "x" }, keys = "<Leader>" },

				-- `[` and `]` keys
				{ mode = "n", keys = "[" },
				{ mode = "n", keys = "]" },

				-- Built-in completion
				{ mode = "i", keys = "<C-x>" },

				-- `g` key
				{ mode = { "n", "x" }, keys = "g" },

				-- Marks
				{ mode = { "n", "x" }, keys = "'" },
				{ mode = { "n", "x" }, keys = "`" },

				-- Registers
				{ mode = { "n", "x" }, keys = '"' },
				{ mode = { "i", "c" }, keys = "<C-r>" },

				-- Window commands
				{ mode = "n", keys = "<C-w>" },

				-- `z` key
				{ mode = { "n", "x" }, keys = "z" },
			},

			clues = {
				-- Enhance this by adding descriptions for <Leader> mapping groups
				miniclue.gen_clues.square_brackets(),
				miniclue.gen_clues.builtin_completion(),
				miniclue.gen_clues.g(),
				miniclue.gen_clues.marks(),
				miniclue.gen_clues.registers(),
				miniclue.gen_clues.windows(),
				miniclue.gen_clues.z(),
			},
		})

    require("mini.pick").setup()
    require("mini.files").setup()
    require("mini.extra").setup()
    -- require("mini.snippets").setup()
    -- require("mini.completion").setup()
    -- require("mini.cmdline").setup()

    vim.keymap.set("n", "<leader>fe", function ()
      require("mini.files").open()
    end)
	end,
}
