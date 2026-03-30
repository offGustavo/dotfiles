-- if true then return {} end

if vim.fn.has('nvim-0.12') == 1 then
	require("vim._core.ui2").enable({
		enable = true, -- Whether to enable or disable the UI.
		msg = { -- Options related to the message module.
			target = "msg",
			timeout = 2000, -- Time a message is visible in the message window.
		},
	})
	return {}
end

--- lazy.nvim
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	lazy = true,
	enabled = true,
	---@type YaziConfig | {}
	opts = {
		cmdline = {
			enabled = true,
			view = "cmdline",
			format = {
				-- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
				-- view: (default is cmdline view)
				-- opts: any options passed to the view
				-- icon_hl_group: optional hl_group for the icon
				-- title: set to anything or empty string to hide
				-- cmdline = { pattern = "^:", icon = "", lang = "vim" },
				cmdline = { pattern = "^:", icon = ":", lang = "vim" },
				-- search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
				-- search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
				search_down = { kind = "search", pattern = "^/", icon = "/", lang = "regex" },
				search_up = { kind = "search", pattern = "^%?", icon = "?", lang = "regex" },
				-- filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
				filter = { pattern = "^:%s*!", icon = "!", lang = "bash" },
				-- lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
				lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = ">", lang = "lua" },
				help = { pattern = "^:%s*he?l?p?%s+", icon = "?" },
				input = { view = "cmdline", icon = "󰥻 " }, -- Used by input()
				-- lua = false, -- to disable a format, set to `false`
			},
		},
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
					},
				},
				view = "mini",
			},
		},
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
		},
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		{ "MunifTanjim/nui.nvim", lazy = true, event = "VeryLazy" },
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		-- "rcarriga/nvim-notify",
	},
}
