return {
	-- "https://github.com/offGustavo/nvim-sessionizer",
	dir = "~/Projects/nvim-sessionizer/",
	dev = true,
	keys = {
		{
			"ZO",
			function()
				require("nvim-sessionizer").sessionizer()
			end,
			desc = "Create a new session",
		},
		{
			"ZC",
			function()
				require("nvim-sessionizer").new_session()
			end,
			desc = "Create a new session in current dir",
		},
		{
			"ZA",
			function()
				local count = vim.v.count
				if count > 0 then
					require("nvim-sessionizer").attach_session(count)
				end
				require("nvim-sessionizer").attach_session()
			end,
			desc = "Attach to a session with vim.ui.select",
		},
		{
			"ZN",
			function()
				require("nvim-sessionizer").attach_session("+1")
			end,
			desc = "Go to next session",
		},
		{
			"ZP",
			function()
				require("nvim-sessionizer").attach_session("-1")
			end,
			desc = "Go to previous session",
		},
		{
			"ZX",
			function()
				require("nvim-sessionizer").remove_session()
			end,
			desc = "Remove Session",
		},
		{
			"ZS",
			function()
				require("nvim-sessionizer").manage_sessions()
			end,
			desc = "Manage sessions",
		},
		{ "ZD", ":detach<CR>", desc = "Detach current session" },
	},
	init = function()
		vim.g.sessionizer = {
			-- Disable Zoxide integration.
			-- Set to true if prefer not to use it.
			-- If Zoxide isn't installed, this setting has no effect.
			-- A list of directories where Sessionizer will search for projects.
			-- Each entry should be an absolute path or use ~ for the home directory.
			-- Example:
			--   { "~/Projects", "~/Work" }
			search_dirs = { "~/Projects" },

			-- Maximum depth to search for projects.
			-- Example: max_depth = 3 means scan up to 3 subdirectory levels.
			max_depth = 1,

			-- UI configuration
			ui = {
				keymap = {
					quit = "q", -- Key to quit the session window
					attach = "<CR>", -- Key to attach to a session
					delete = "<S-d>", -- Key to delete a session
					move_up = "<C-k>", -- Move session up
					move_down = "<C-j>", -- Move session down
				},
				win = {
					width = 0.6, -- Window width ratio (0-1)
					height = 0.4, -- Window height ratio (0-1)
					winbar = {
						hl_left = "Title", -- Highlight for left section text
						hl_right = "Comment", -- Highlight for right section text
						hl_separator = "Comment", -- Highlight for separators
						sep_left = "/", -- Separator between left items
						sep_mid = "%=", -- Separator for center alignment
						sep_right = "│", -- Separator for right items
						format = function(config) -- Function to format winbar items
							return {
								left = {
									" " .. config.ui.keymap.quit .. " close",
									config.ui.keymap.delete .. " delete session",
								},
								right = {
									config.ui.keymap.attach .. " attach session",
									config.ui.keymap.move_up .. "/" .. config.ui.keymap.move_down .. " move session",
								},
							}
						end,
					},
				},
				current = {
					mark = ">", -- Marker for the current session
					hl = "MatchParen", -- Highlight group for the marker
				},
			},
		}
	end,
}
