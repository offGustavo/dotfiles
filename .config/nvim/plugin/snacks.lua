vim.schedule(function()
	vim.pack.add({ "https://github.com/folke/snacks.nvim" })

	local ivy_like_2 = {
		preview = false,
		layout = {
			box = "vertical",
			backdrop = false,
			row = -1,
			width = 0,
			height = 0.4,
			border = "top",
			title = " {title} {live} {flags}",
			title_pos = "left",
			{
				box = "horizontal",
				{ win = "list", border = "none" },
				{ win = "preview", width = 0.6, border = "rounded" },
			},
			{ win = "input", height = 1, border = "none" },
		},
	}

	-- TODO: improve and fix the layouts
	local ivy_like = {
		preview = "main",
		layout = {
			box = "vertical",
			backdrop = false,
			width = 0,
			height = 0.4,
			position = "bottom",
			border = "top",
			title = " {title} {live} {flags}",
			title_pos = "left",
			{ win = "preview", title = "{preview}", width = 0.6, border = "none" },
			{ win = "input", height = 1, border = "none" },
			{
				box = "horizontal",
				{ win = "list", border = "none" },
			},
		},
	}

	local picker_config = {
		sources = {
			grep = { hidden = true, layout = ivy_like },
			git_log = { hidden = true, layout = ivy_like },
			buffers = { hidden = true, layout = ivy_like },
			recent = { hidden = true, layout = ivy_like },
			explorer = {
				-- layout = {
				--   preset = "ivy",
				-- },
				hidden = true,
				follow_file = true,
				auto_close = true,
				actions = {
					explorer_up_and_collapse = function(picker)
						picker:set_cwd(vim.fs.dirname(picker:cwd()))
						picker:find()
						require("snacks.explorer.tree"):close_all(picker:cwd())
					end,
					explorer_focus_or_confirm = function(picker, item, action)
						if item.dir then
							picker:set_cwd(item._path)
							picker:find()
						else
							require("snacks.explorer.actions").actions.confirm(picker, item, action)
						end
					end,
					explorer_collapse_and_close = function(picker)
						require("snacks.explorer.tree"):close_all(picker:cwd())
						picker:norm(function()
							picker:close()
						end)
					end,
				},
				win = {
					list = {
						keys = {
							--    ["h"] = "explorer_up_and_collapse",
							["<BS>"] = "explorer_up_and_collapse",
							["-"] = "explorer_up_and_collapse",
							--   ["l"] = "explorer_focus_or_confirm",
							["<CR>"] = "explorer_focus_or_confirm",
							--  ["q"] = "explorer_collapse_and_close",
						},
					},
				},
			},
			smart = {
				hidden = true,
				layout = ivy_like,
			},
			files = {
				hidden = true,
				layout = ivy_like,
			},
		},
		layout = ivy_like,
	}

	local dashboard_config = {
		enabled = true,
		preset = {
			header = [[
 ███     █████                       ███  ████ 
░███    ░░███                       ░░░  ░░███ 
░███  ███████   ██████  █████ █████ ████  ░███ 
░███ ███░░███  ███░░███░░███ ░░███ ░░███  ░███ 
░███░███ ░███ ░███████  ░███  ░███  ░███  ░███ 
░░░ ░███ ░███ ░███░░░   ░░███ ███   ░███  ░███ 
 ███░░████████░░██████   ░░█████    █████ █████
░░░  ░░░░░░░░  ░░░░░░     ░░░░░    ░░░░░ ░░░░░ ]],
		},
		sections = {
			{ section = "header" },
			-- {
			-- 	-- pane = 2,
			-- 	section = "startup",
			-- 	padding = { 1, 0 },
			-- },
		},
	}

	require("snacks").setup({
		bigfile = { enabled = true },
		dashboard = { enabled = false },
		-- dashboard = dashboard_config,
		gh = {},
		explorer = { enabled = false },
		indent = { enabled = false },
		input = { enabled = false },
		notifier = {
			enabled = false,
			timeout = 3000,
		},
		picker = { enabled = true, layout = "ivy_split" },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = false },
		image = { enabled = true },
		styles = {
			notification = {
				-- wo = { wrap = true } -- Wrap notifications
			},
		},
	})




	-- vim.api.nvim_create_autocmd("User", {
	-- 	pattern = "VeryLazy",
	-- 	callback = function()
	-- 		-- Setup some globals for debugging (lazy-loaded)
	-- 		_G.dd = function(...)
	-- 			Snacks.debug.inspect(...)
	-- 		end
	-- 		_G.bt = function()
	-- 			Snacks.debug.backtrace()
	-- 		end
	--
	-- 		-- Override print to use snacks for `:=` command
	-- 		if vim.fn.has("nvim-0.11") == 1 then
	-- 			vim._print = function(_, ...)
	-- 				dd(...)
	-- 			end
	-- 		else
	-- 			vim.print = _G.dd
	-- 		end


	-- Create some toggle mappings
	Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
	Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
	Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
	Snacks.toggle.diagnostics():map("<leader>ud")
	Snacks.toggle.line_number():map("<leader>ul")
	Snacks.toggle
		.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
		:map("<leader>uc")
	Snacks.toggle.treesitter():map("<leader>uT")
	Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
	Snacks.toggle.inlay_hints():map("<leader>uh")
	Snacks.toggle.indent():map("<leader>ug")
	Snacks.toggle.dim():map("<leader>uD")
	-- Toggle Options
	Snacks.toggle
		.new({
			id = "toggle_sing_and_line_column",
			name = "Relative Line Number and Sign Column",
			get = function()
				return vim.o.relativenumber
			end,
			set = function(state)
				if state then
					vim.o.signcolumn = "no"
					vim.opt.number = false
					vim.opt.relativenumber = false
				end
				vim.o.signcolumn = "yes"
				vim.opt.number = state
				vim.opt.relativenumber = state
			end,
		})
		:map("<leader>u<M-l>")

	Snacks.toggle.option("cursorline", { off = false, on = true }):map("<leader>u<C-l>")
	-- 	end,
	-- })

	-- vim.keymap.set({ "x", "i", "t", "n" }, "<c-/>", function()
	-- 	Snacks.terminal("tmux")
	-- end, { desc = "Open Tmux" })
	-- vim.keymap.set("n", "<leader>gi", function()
	-- 	Snacks.picker.gh_issue()
	-- end, { desc = "GitHub Issues (open)" })
	-- vim.keymap.set("n", "<leader>gI", function()
	-- 	Snacks.picker.gh_issue({ state = "all" })
	-- end, { desc = "GitHub Issues (all)" })
	-- vim.keymap.set("n", "<leader>gp", function()
	-- 	Snacks.picker.gh_pr()
	-- end, { desc = "GitHub Pull Requests (open)" })
	-- vim.keymap.set("n", "<leader>gP", function()
	-- 	Snacks.picker.gh_pr({ state = "all" })
	-- end, { desc = "GitHub Pull Requests (all)" })
	-- -- Top Pickers & Explorer
	-- vim.keymap.set("n", "<leader><space>", function()
	-- 	Snacks.picker.smart()
	-- end, { desc = "Smart Find Files" })
	-- vim.keymap.set("n", "<M-h>", function()
	-- 	Snacks.picker.buffers()
	-- end, { desc = "Buffers" })
	-- vim.keymap.set("n", "<leader>,", function()
	-- 	Snacks.picker.buffers()
	-- end, { desc = "Buffers" })
	-- vim.keymap.set("n", "<leader>/", function()
	-- 	Snacks.picker.grep()
	-- end, { desc = "Grep" })
	-- vim.keymap.set("n", "<leader>:", function()
	-- 	Snacks.picker.command_history()
	-- end, { desc = "Command History" })
	-- vim.keymap.set("n", "<leader>n", function()
	-- 	Snacks.picker.notifications()
	-- end, { desc = "Notification History" })
	-- vim.keymap.set("n", "<leader>e", function()
	-- 	Snacks.explorer()
	-- end, { desc = "File Explorer" })
	-- -- find
	-- vim.keymap.set("n", "<leader>fb", function()
	-- 	Snacks.picker.buffers()
	-- end, { desc = "Buffers" })
	-- vim.keymap.set("n", "<leader>fc", function()
	-- 	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
	-- end, { desc = "Find Config File" })
	-- vim.keymap.set("n", "<M-o>", function()
	-- 	Snacks.picker.files()
	-- end, { desc = "Find Files" })
	-- vim.keymap.set("n", "<leader>ff", function()
	-- 	Snacks.picker.files()
	-- end, { desc = "Find Files" })
	-- vim.keymap.set("n", "<leader>fg", function()
	-- 	Snacks.picker.git_files()
	-- end, { desc = "Find Git Files" })
	-- vim.keymap.set("n", "<leader>fp", function()
	-- 	Snacks.picker.projects()
	-- end, { desc = "Projects" })
	-- vim.keymap.set("n", "<leader>fo", function()
	-- 	Snacks.picker.recent()
	-- end, { desc = "OldFiles" })
	-- vim.keymap.set("n", "<leader>fr", function()
	-- 	Snacks.picker.recent()
	-- end, { desc = "Recent" })
	-- -- git
	-- vim.keymap.set("n", "<leader>gb", function()
	-- 	Snacks.picker.git_branches()
	-- end, { desc = "Git Branches" })
	-- vim.keymap.set("n", "<leader>gl", function()
	-- 	Snacks.picker.git_log()
	-- end, { desc = "Git Log" })
	-- vim.keymap.set("n", "<leader>gL", function()
	-- 	Snacks.picker.git_log_line()
	-- end, { desc = "Git Log Line" })
	-- vim.keymap.set("n", "<leader>gs", function()
	-- 	Snacks.picker.git_status()
	-- end, { desc = "Git Status" })
	-- vim.keymap.set("n", "<leader>gS", function()
	-- 	Snacks.picker.git_stash()
	-- end, { desc = "Git Stash" })
	-- vim.keymap.set("n", "<leader>gd", function()
	-- 	Snacks.picker.git_diff()
	-- end, { desc = "Git Diff (Hunks)" })
	-- vim.keymap.set("n", "<leader>gf", function()
	-- 	Snacks.picker.git_log_file()
	-- end, { desc = "Git Log File" })
	-- -- gh
	-- vim.keymap.set("n", "<leader>gi", function()
	-- 	Snacks.picker.gh_issue()
	-- end, { desc = "GitHub Issues (open)" })
	-- vim.keymap.set("n", "<leader>gI", function()
	-- 	Snacks.picker.gh_issue({ state = "all" })
	-- end, { desc = "GitHub Issues (all)" })
	-- vim.keymap.set("n", "<leader>gp", function()
	-- 	Snacks.picker.gh_pr()
	-- end, { desc = "GitHub Pull Requests (open)" })
	-- vim.keymap.set("n", "<leader>gP", function()
	-- 	Snacks.picker.gh_pr({ state = "all" })
	-- end, { desc = "GitHub Pull Requests (all)" })
	-- -- Grep
	-- vim.keymap.set("n", "<leader>sb", function()
	-- 	Snacks.picker.lines()
	-- end, { desc = "Buffer Lines" })
	-- vim.keymap.set("n", "<leader>sB", function()
	-- 	Snacks.picker.grep_buffers()
	-- end, { desc = "Grep Open Buffers" })
	-- vim.keymap.set("n", "<M-s>", function()
	-- 	Snacks.picker.grep()
	-- end, { desc = "Grep" })
	-- vim.keymap.set("n", "<leader>sg", function()
	-- 	Snacks.picker.grep()
	-- end, { desc = "Grep" })
	-- vim.keymap.set({ "n", "x" }, "<leader>sw", function()
	-- 	Snacks.picker.grep_word()
	-- end, { desc = "Visual selection or word" })
	-- -- search
	-- vim.keymap.set("n", '<leader>s"', function()
	-- 	Snacks.picker.registers()
	-- end, { desc = "Registers" })
	-- vim.keymap.set("n", "<leader>s/", function()
	-- 	Snacks.picker.search_history()
	-- end, { desc = "Search History" })
	-- vim.keymap.set("n", "<leader>sa", function()
	-- 	Snacks.picker.autocmds()
	-- end, { desc = "Autocmds" })
	-- vim.keymap.set("n", "<leader>sb", function()
	-- 	Snacks.picker.lines()
	-- end, { desc = "Buffer Lines" })
	-- vim.keymap.set("n", "<leader>sc", function()
	-- 	Snacks.picker.command_history()
	-- end, { desc = "Command History" })
	-- vim.keymap.set("n", "<leader>sC", function()
	-- 	Snacks.picker.commands()
	-- end, { desc = "Commands" })
	-- vim.keymap.set("n", "<leader>sd", function()
	-- 	Snacks.picker.diagnostics()
	-- end, { desc = "Diagnostics" })
	-- vim.keymap.set("n", "<leader>sD", function()
	-- 	Snacks.picker.diagnostics_buffer()
	-- end, { desc = "Buffer Diagnostics" })
	-- vim.keymap.set("n", "<leader>sh", function()
	-- 	Snacks.picker.help()
	-- end, { desc = "Help Pages" })
	-- vim.keymap.set("n", "<leader>sH", function()
	-- 	Snacks.picker.highlights()
	-- end, { desc = "Highlights" })
	-- vim.keymap.set("n", "<leader>si", function()
	-- 	Snacks.picker.icons()
	-- end, { desc = "Icons" })
	-- vim.keymap.set("n", "<leader>sj", function()
	-- 	Snacks.picker.jumps()
	-- end, { desc = "Jumps" })
	-- vim.keymap.set("n", "<leader>sk", function()
	-- 	Snacks.picker.keymaps()
	-- end, { desc = "Keymaps" })
	-- vim.keymap.set("n", "<leader>sl", function()
	-- 	Snacks.picker.loclist()
	-- end, { desc = "Location List" })
	-- vim.keymap.set("n", "<leader>sm", function()
	-- 	Snacks.picker.marks()
	-- end, { desc = "Marks" })
	-- vim.keymap.set("n", "<leader>sM", function()
	-- 	Snacks.picker.man()
	-- end, { desc = "Man Pages" })
	-- vim.keymap.set("n", "<leader>sp", function()
	-- 	Snacks.picker.lazy()
	-- end, { desc = "Search for Plugin Spec" })
	-- vim.keymap.set("n", "<leader>sq", function()
	-- 	Snacks.picker.qflist()
	-- end, { desc = "Quickfix List" })
	-- vim.keymap.set("n", "<leader>sR", function()
	-- 	Snacks.picker.resume()
	-- end, { desc = "Resume" })
	-- vim.keymap.set("n", "<leader>su", function()
	-- 	Snacks.picker.undo()
	-- end, { desc = "Undo History" })
	-- vim.keymap.set("n", "<leader>uC", function()
	-- 	Snacks.picker.colorschemes()
	-- end, { desc = "Colorschemes" })
	-- -- LSP
	-- vim.keymap.set("n", "<leader>cd", function()
	-- 	Snacks.picker.lsp_definitions()
	-- end, { desc = "Goto Definition" })
	-- vim.keymap.set("n", "<leader>cD", function()
	-- 	Snacks.picker.lsp_declarations()
	-- end, { desc = "Goto Declaration" })
	-- vim.keymap.set("n", "<leader>cr", function()
	-- 	Snacks.picker.lsp_references()
	-- end, { nowait = true, desc = "References" })
	-- vim.keymap.set("n", "<leader>cI", function()
	-- 	Snacks.picker.lsp_implementations()
	-- end, { desc = "Goto Implementation" })
	-- vim.keymap.set("n", "<leader>cy", function()
	-- 	Snacks.picker.lsp_type_definitions()
	-- end, { desc = "Goto T[y]pe Definition" })
	-- vim.keymap.set("n", "<leader>ci", function()
	-- 	Snacks.picker.lsp_incoming_calls()
	-- end, { desc = "C[a]lls Incoming" })
	-- vim.keymap.set("n", "<leader>co", function()
	-- 	Snacks.picker.lsp_outgoing_calls()
	-- end, { desc = "C[a]lls Outgoing" })
	-- vim.keymap.set("n", "<leader>ss", function()
	-- 	Snacks.picker.lsp_symbols()
	-- end, { desc = "LSP Symbols" })
	-- vim.keymap.set("n", "<leader>sS", function()
	-- 	Snacks.picker.lsp_workspace_symbols()
	-- end, { desc = "LSP Workspace Symbols" })

	-- Other
	vim.keymap.set("n", "<leader>uz", function()
		Snacks.zen()
	end, { desc = "Toggle Zen Mode" })
	vim.keymap.set("n", "<leader>uZ", function()
		Snacks.zen.zoom()
	end, { desc = "Toggle Zoom" })
	vim.keymap.set("n", "<leader>.", function()
		Snacks.scratch()
	end, { desc = "Toggle Scratch Buffer" })
	vim.keymap.set("n", "<leader>S", function()
		Snacks.scratch.select()
	end, { desc = "Select Scratch Buffer" })
	vim.keymap.set("n", "<leader>n", function()
		Snacks.notifier.show_history()
	end, { desc = "Notification History" })
	vim.keymap.set("n", "<leader>bd", function()
		Snacks.bufdelete()
	end, { desc = "Delete Buffer" })
	vim.keymap.set("n", "<leader>cR", function()
		Snacks.rename.rename_file()
	end, { desc = "Rename File" })
	vim.keymap.set({ "n", "v" }, "<leader>gB", function()
		Snacks.gitbrowse()
	end, { desc = "Git Browse" })
	-- vim.keymap.set("n",  "<leader>-", function() Snacks.terminal("yazi") end, { desc = "Yazi" })
	vim.keymap.set("n", "<leader>un", function()
		Snacks.notifier.hide()
	end, { desc = "Dismiss All Notifications" })
	vim.keymap.set({ "n", "t" }, "]]", function()
		Snacks.words.jump(vim.v.count1)
	end, { desc = "Next Reference" })
	vim.keymap.set({ "n", "t" }, "[[", function()
		Snacks.words.jump(-vim.v.count1)
	end, { desc = "Prev Reference" })
	vim.keymap.set("n", "<leader>N", function()
		Snacks.win({
			file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
			width = 0.8,
			height = 0.6,
			wo = {
				spell = false,
				wrap = false,
				signcolumn = "yes",
				statuscolumn = " ",
				conceallevel = 3,
			},
		})
	end, {
		desc = "Neovim News",
	})

	vim.keymap.set("n", "<M-S-g>", function()
		Snacks.lazygit()
	end, { desc = "Lazgit" })

end)

