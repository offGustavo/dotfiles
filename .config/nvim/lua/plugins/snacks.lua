if true then return {} end

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

local devil_header = [[
 ███     █████                       ███  ████ 
░███    ░░███                       ░░░  ░░███ 
░███  ███████   ██████  █████ █████ ████  ░███ 
░███ ███░░███  ███░░███░░███ ░░███ ░░███  ░███ 
░███░███ ░███ ░███████  ░███  ░███  ░███  ░███ 
░░░ ░███ ░███ ░███░░░   ░░███ ███   ░███  ░███ 
 ███░░████████░░██████   ░░█████    █████ █████
░░░  ░░░░░░░░  ░░░░░░     ░░░░░    ░░░░░ ░░░░░ ]]

local dashboard_config = {
	enabled = true,
	preset = {
		-- pick = function(cmd, opts)
		--   return LazyVim.pick(cmd, opts)()
		-- end,
		header = devil_header,
    -- stylua: ignore
    ---@type snacks.dashboard.Item[]
    keys = {
      -- { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      -- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      -- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      -- { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      -- { icon = " ", key = "z", desc = "Change Directory", action = ":lua Snacks.dashboard.pick('zoxide')" },
      -- { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
      -- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      -- { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
      -- { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
      -- { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
	},
	sections = {
		{ section = "header" },
		-- {
		--   -- pane = 2,
		--   section = "terminal",
		--   cmd = "pokeget --hide-name gengar",
		--   -- cmd = "pokeget --hide-name bulbasaur",
		--   -- cmd = "colorscript -e square",
		--   -- cmd = "colorscript -e pacman",
		--   -- cmd = "chafa ~/Pictures/Wallpapers/my/gengara.jpg --format symbols --symbols vhalf --size 60x11 --stretch",
		--   -- cmd = "fzf",
		--   height = 20,
		--   padding = { 0, 0 },
		--   -- indent = 10,
		-- },
		{
			-- pane = 2,
			section = "startup",
			padding = { 1, 0 },
		},
		-- {
		--   pane = 2,
		--   icon = " ",
		--   desc = "Browse Repo",
		--   padding = 1,
		--   key = "b",
		--   action = function()
		--     Snacks.gitbrowse()
		--   end,
		-- },
		-- { section = "keys", gap = 1, padding = 1 },
		-- { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
		-- { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
		-- {
		--   pane = 2,
		--   icon = " ",
		--   title = "Git Status",
		--   section = "terminal",
		--   enabled = function()
		--     return Snacks.git.get_root() ~= nil
		--   end,
		--   cmd = "git status --short --branch --renames",
		--   height = 5,
		--   padding = 1,
		--   ttl = 5 * 60,
		--   indent = 3,
		-- },
	},
}

local init_config = function()
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			-- Setup some globals for debugging (lazy-loaded)
			_G.dd = function(...)
				Snacks.debug.inspect(...)
			end
			_G.bt = function()
				Snacks.debug.backtrace()
			end

			-- Override print to use snacks for `:=` command
			if vim.fn.has("nvim-0.11") == 1 then
				vim._print = function(_, ...)
					dd(...)
				end
			else
				vim.print = _G.dd
			end

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
			Snacks.toggle
				.option("background", { off = "light", on = "dark", name = "Dark Background" })
				:map("<leader>ub")
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
        :map("<leader>on")

      Snacks.toggle.option("cursorline", { off = false, on = true }):map("<leader>ol")

		end,
	})
end

local snacks_keys = {
	{
		"<leader>gi",
		function()
			Snacks.picker.gh_issue()
		end,
		desc = "GitHub Issues (open)",
	},
	{
		"<leader>gI",
		function()
			Snacks.picker.gh_issue({ state = "all" })
		end,
		desc = "GitHub Issues (all)",
	},
	{
		"<leader>gp",
		function()
			Snacks.picker.gh_pr()
		end,
		desc = "GitHub Pull Requests (open)",
	},
	{
		"<leader>gP",
		function()
			Snacks.picker.gh_pr({ state = "all" })
		end,
		desc = "GitHub Pull Requests (all)",
	},
	-- Top Pickers & Explorer
	{
		"<leader><space>",
		function()
			Snacks.picker.smart()
		end,
		desc = "Smart Find Files",
	},
	{
		"<leader>,",
		function()
			Snacks.picker.buffers()
		end,
		desc = "Buffers",
	},
	{
		"<leader>/",
		function()
			Snacks.picker.grep()
		end,
		desc = "Grep",
	},
	{
		"<leader>:",
		function()
			Snacks.picker.command_history()
		end,
		desc = "Command History",
	},
	{
		"<leader>n",
		function()
			Snacks.picker.notifications()
		end,
		desc = "Notification History",
	},
	{
		"<leader>e",
		function()
			Snacks.explorer()
		end,
		desc = "File Explorer",
	},
	-- find
	{
		"<leader>fb",
		function()
			Snacks.picker.buffers()
		end,
		desc = "Buffers",
	},
	{
		"<leader>fc",
		function()
			Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
		end,
		desc = "Find Config File",
	},
	{
		"<leader>ff",
		function()
			Snacks.picker.files()
		end,
		desc = "Find Files",
	},
	{
		"<leader>fg",
		function()
			Snacks.picker.git_files()
		end,
		desc = "Find Git Files",
	},
	{
		"<leader>fp",
		function()
			Snacks.picker.projects()
		end,
		desc = "Projects",
	},
	{
		"<leader>fr",
		function()
			Snacks.picker.recent()
		end,
		desc = "Recent",
	},
	-- git
	{
		"<leader>gb",
		function()
			Snacks.picker.git_branches()
		end,
		desc = "Git Branches",
	},
	{
		"<leader>gl",
		function()
			Snacks.picker.git_log()
		end,
		desc = "Git Log",
	},
	{
		"<leader>gL",
		function()
			Snacks.picker.git_log_line()
		end,
		desc = "Git Log Line",
	},
	{
		"<leader>gs",
		function()
			Snacks.picker.git_status()
		end,
		desc = "Git Status",
	},
	{
		"<leader>gS",
		function()
			Snacks.picker.git_stash()
		end,
		desc = "Git Stash",
	},
	{
		"<leader>gd",
		function()
			Snacks.picker.git_diff()
		end,
		desc = "Git Diff (Hunks)",
	},
	{
		"<leader>gf",
		function()
			Snacks.picker.git_log_file()
		end,
		desc = "Git Log File",
	},
	-- gh
	{
		"<leader>gi",
		function()
			Snacks.picker.gh_issue()
		end,
		desc = "GitHub Issues (open)",
	},
	{
		"<leader>gI",
		function()
			Snacks.picker.gh_issue({ state = "all" })
		end,
		desc = "GitHub Issues (all)",
	},
	{
		"<leader>gp",
		function()
			Snacks.picker.gh_pr()
		end,
		desc = "GitHub Pull Requests (open)",
	},
	{
		"<leader>gP",
		function()
			Snacks.picker.gh_pr({ state = "all" })
		end,
		desc = "GitHub Pull Requests (all)",
	},
	-- Grep
	{
		"<leader>sb",
		function()
			Snacks.picker.lines()
		end,
		desc = "Buffer Lines",
	},
	{
		"<leader>sB",
		function()
			Snacks.picker.grep_buffers()
		end,
		desc = "Grep Open Buffers",
	},
	{
		"<leader>sg",
		function()
			Snacks.picker.grep()
		end,
		desc = "Grep",
	},
	{
		"<leader>sw",
		function()
			Snacks.picker.grep_word()
		end,
		desc = "Visual selection or word",
		mode = { "n", "x" },
	},
	-- search
	{
		'<leader>s"',
		function()
			Snacks.picker.registers()
		end,
		desc = "Registers",
	},
	{
		"<leader>s/",
		function()
			Snacks.picker.search_history()
		end,
		desc = "Search History",
	},
	{
		"<leader>sa",
		function()
			Snacks.picker.autocmds()
		end,
		desc = "Autocmds",
	},
	{
		"<leader>sb",
		function()
			Snacks.picker.lines()
		end,
		desc = "Buffer Lines",
	},
	{
		"<leader>sc",
		function()
			Snacks.picker.command_history()
		end,
		desc = "Command History",
	},
	{
		"<leader>sC",
		function()
			Snacks.picker.commands()
		end,
		desc = "Commands",
	},
	{
		"<leader>sd",
		function()
			Snacks.picker.diagnostics()
		end,
		desc = "Diagnostics",
	},
	{
		"<leader>sD",
		function()
			Snacks.picker.diagnostics_buffer()
		end,
		desc = "Buffer Diagnostics",
	},
	{
		"<leader>sh",
		function()
			Snacks.picker.help()
		end,
		desc = "Help Pages",
	},
	{
		"<leader>sH",
		function()
			Snacks.picker.highlights()
		end,
		desc = "Highlights",
	},
	{
		"<leader>si",
		function()
			Snacks.picker.icons()
		end,
		desc = "Icons",
	},
	{
		"<leader>sj",
		function()
			Snacks.picker.jumps()
		end,
		desc = "Jumps",
	},
	{
		"<leader>sk",
		function()
			Snacks.picker.keymaps()
		end,
		desc = "Keymaps",
	},
	{
		"<leader>sl",
		function()
			Snacks.picker.loclist()
		end,
		desc = "Location List",
	},
	{
		"<leader>sm",
		function()
			Snacks.picker.marks()
		end,
		desc = "Marks",
	},
	{
		"<leader>sM",
		function()
			Snacks.picker.man()
		end,
		desc = "Man Pages",
	},
	{
		"<leader>sp",
		function()
			Snacks.picker.lazy()
		end,
		desc = "Search for Plugin Spec",
	},
	{
		"<leader>sq",
		function()
			Snacks.picker.qflist()
		end,
		desc = "Quickfix List",
	},
	{
		"<leader>sR",
		function()
			Snacks.picker.resume()
		end,
		desc = "Resume",
	},
	{
		"<leader>su",
		function()
			Snacks.picker.undo()
		end,
		desc = "Undo History",
	},
	{
		"<leader>uC",
		function()
			Snacks.picker.colorschemes()
		end,
		desc = "Colorschemes",
	},
	-- LSP
	{
		"<leader>cd",
		function()
			Snacks.picker.lsp_definitions()
		end,
		desc = "Goto Definition",
	},
	{
		"<leader>cD",
		function()
			Snacks.picker.lsp_declarations()
		end,
		desc = "Goto Declaration",
	},
	{
		"<leader>cr",
		function()
			Snacks.picker.lsp_references()
		end,
		nowait = true,
		desc = "References",
	},
	{
		"<leader>cI",
		function()
			Snacks.picker.lsp_implementations()
		end,
		desc = "Goto Implementation",
	},
	{
		"<leader>cy",
		function()
			Snacks.picker.lsp_type_definitions()
		end,
		desc = "Goto T[y]pe Definition",
	},
	{
		"<leader>cai",
		function()
			Snacks.picker.lsp_incoming_calls()
		end,
		desc = "C[a]lls Incoming",
	},
	{
		"<leader>cao",
		function()
			Snacks.picker.lsp_outgoing_calls()
		end,
		desc = "C[a]lls Outgoing",
	},
	{
		"<leader>ss",
		function()
			Snacks.picker.lsp_symbols()
		end,
		desc = "LSP Symbols",
	},
	{
		"<leader>sS",
		function()
			Snacks.picker.lsp_workspace_symbols()
		end,
		desc = "LSP Workspace Symbols",
	},
	-- Other
	{
		"<leader>z",
		function()
			Snacks.zen()
		end,
		desc = "Toggle Zen Mode",
	},
	{
		"<leader>Z",
		function()
			Snacks.zen.zoom()
		end,
		desc = "Toggle Zoom",
	},
	{
		"<leader>.",
		function()
			Snacks.scratch()
		end,
		desc = "Toggle Scratch Buffer",
	},
	{
		"<leader>S",
		function()
			Snacks.scratch.select()
		end,
		desc = "Select Scratch Buffer",
	},
	{
		"<leader>n",
		function()
			Snacks.notifier.show_history()
		end,
		desc = "Notification History",
	},
	{
		"<leader>bd",
		function()
			Snacks.bufdelete()
		end,
		desc = "Delete Buffer",
	},
	{
		"<leader>cR",
		function()
			Snacks.rename.rename_file()
		end,
		desc = "Rename File",
	},
	{
		"<leader>gB",
		function()
			Snacks.gitbrowse()
		end,
		desc = "Git Browse",
		mode = { "n", "v" },
	},
	{
		"<leader>-",
		function()
			Snacks.terminal("yazi")
		end,
		desc = "Lazygit",
	},
	{
		"<leader>lg",
		function()
			Snacks.lazygit()
		end,
		desc = "Lazygit",
	},
	{
		"<leader>gg",
		function()
			Snacks.lazygit()
		end,
		desc = "Lazygit",
	},
	{
		"<leader>un",
		function()
			Snacks.notifier.hide()
		end,
		desc = "Dismiss All Notifications",
	},
	{
		"<c-/>",
		function()
			Snacks.terminal()
		end,
		desc = "Toggle Terminal",
	},
	{
		"<c-_>",
		function()
			Snacks.terminal()
		end,
		desc = "which_key_ignore",
	},
	{
		"]]",
		function()
			Snacks.words.jump(vim.v.count1)
		end,
		desc = "Next Reference",
		mode = { "n", "t" },
	},
	{
		"[[",
		function()
			Snacks.words.jump(-vim.v.count1)
		end,
		desc = "Prev Reference",
		mode = { "n", "t" },
	},
	{
		"<leader>N",
		desc = "Neovim News",
		function()
			Snacks.win({
				file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
				width = 0.6,
				height = 0.6,
				wo = {
					spell = false,
					wrap = false,
					signcolumn = "yes",
					statuscolumn = " ",
					conceallevel = 3,
				},
			})
		end,
	},
}

return {
	"folke/snacks.nvim",
	-- priority = 1000,
	-- lazy = false,
	lazy = true,
	event = "VeryLazy",
	enabled = true,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
    dashboard = { enabled = false } ,
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
		words = { enabled = true },
		image = { enabled = true },
		styles = {
			notification = {
				-- wo = { wrap = true } -- Wrap notifications
			},
		},
	},
	keys = snacks_keys,
	-- keys = { {
	-- 	"<M-g>",
	-- 	function()
	-- 		Snacks.lazygit()
	-- 	end,
	-- } },
	init = init_config,
}
