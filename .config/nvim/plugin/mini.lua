vim.schedule(function()
	vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

	require("mini.icons").setup({})
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
			{ mode = { "n", "x" }, keys = "<localleader>" },
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

			{ mode = "n", keys = "<Leader>a", desc = "+Agenda" },
			{ mode = "n", keys = "<Leader>b", desc = "+Buffer" },
			{ mode = "n", keys = "<Leader>s", desc = "+Search" },
			{ mode = "n", keys = "<Leader>f", desc = "+Find" },
			{ mode = "n", keys = "<Leader>g", desc = "+Git" },
			{ mode = "n", keys = "<Leader>gc", desc = "+Commit" },
			{ mode = "n", keys = "<Leader>c", desc = "+Code" },
			{ mode = "n", keys = "<Leader>u", desc = "+Ui" },
			-- TODO: improve this
			{ mode = "n", keys = "<Leader>o", desc = "+Other" },
			{ mode = "n", keys = "<Leader>t", desc = "+Terminal" },
			{ mode = "n", keys = "<Leader>r", desc = "+Replace" },
			{ mode = "n", keys = "<Leader>h", desc = "+Harpoon" },
			{ mode = "n", keys = "<Leader><Tab>", desc = "+Tabs" },
			{ mode = "n", keys = "<Leader>l", desc = "+Location List" },
			{ mode = "n", keys = "<Leader>q", desc = "+Quickfix/Quit" },
		},
	})

	local ui_select_orig = vim.ui.select
	require("mini.pick").setup()
	vim.ui.select = ui_select_orig
	require("mini.extra").setup()

	require("mini.snippets").setup()
	require("mini.completion").setup()
	require("mini.cmdline").setup()

	-- require("mini.files").setup()
	-- vim.keymap.set("n", "<leader>fe", function ()
	--   require("mini.files").open()
	-- end)

	require("mini.align").setup({
		-- Module mappings. Use `''` (empty string) to disable one.
		mappings = {
			start = "sl",
			start_with_preview = "sL",
		},

		-- -- Modifiers changing alignment steps and/or options
		-- modifiers = {
		--   -- Main option modifiers
		--   ['s'] = --<function: enter split pattern>,
		--   ['j'] = --<function: choose justify side>,
		--   ['m'] = --<function: enter merge delimiter>,
		--
		--   -- Modifiers adding pre-steps
		--   ['f'] = --<function: filter parts by entering Lua expression>,
		--   ['i'] = --<function: ignore some split matches>,
		--   ['p'] = --<function: pair parts>,
		--   ['t'] = --<function: trim parts>,
		--
		--   -- Delete some last pre-step
		--   ['<BS>'] = --<function: delete some last pre-step>,
		--
		--   -- Special configurations for common splits
		--   ['='] = --<function: enhanced setup for '='>,
		--   [','] = --<function: enhanced setup for ','>,
		--   ['|'] = --<function: enhanced setup for '|'>,
		--   [' '] = --<function: enhanced setup for ' '>,
		-- },

		-- -- Default options controlling alignment process
		-- options = {
		--   split_pattern = '',
		--   justify_side = 'left',
		--   merge_delimiter = '',
		-- },

		-- -- Default steps performing alignment (if `nil`, default is used)
		-- steps = {
		--   pre_split   = {},
		--   split       = nil,
		--   pre_justify = {},
		--   justify     = nil,
		--   pre_merge   = {},
		--   merge       = nil,
		-- },

		-- Whether to disable showing non-error feedback
		-- This also affects (purely informational) helper messages shown after
		-- idle time if user input is required.
		silent = false,
	})
end)
