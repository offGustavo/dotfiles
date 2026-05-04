-- -- Declare a global function to retrieve the current directory
-- function _G.get_oil_winbar()
--   local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
--   local dir = require("oil").get_current_dir(bufnr)
--   if dir then
--     return vim.fn.fnamemodify(dir, ":~")
--   else
--     -- If there is no current directory (e.g. over ssh), just show the buffer name
--     return vim.api.nvim_buf_get_name(0)
--   end
-- end

return {
	"https://github.com/barrettruth/canola.nvim",
	branch = "canola",
  priority = 1000,
  lazy = false,
	event = "UiEnter",
	keys = {
		{ "<M-e>", "<Cmd>Canola<Cr>", desc = "Oil" },
		{ "<leader><M-e>", "<Cmd>e.<Cr>", desc = "Open cwd" },
		{ "<leader>fd", ":Canola", desc = "Oil Explore" },
	},
	init = function()
		vim.g.canola = {
			columns = {
				"icon",
				"permissions",
				"size",
				"mtime",
			},
			cursor = true,
			watch = false,
			border = "rounded",

			hidden = { enabled = true, patterns = { "^%." }, always = {} },

			sort = "default",
			highlights = { filename = {}, columns = true },

			confirm = false,
			save = "prompt",
			delete = { wipe = false, recursive = true },
			create = { file_mode = 420, dir_mode = 493 },
			extglob = false,

			keymaps = {
				["g?"] = { callback = "actions.show_help", mode = "n" },
				["<CR>"] = "actions.select",
				["<C-s>"] = { callback = "actions.select", opts = { vertical = true } },
				["<C-h>"] = { callback = "actions.select", opts = { horizontal = true } },
				["<C-t>"] = { callback = "actions.select", opts = { tab = true } },
				["<C-p>"] = "actions.preview",
				["<C-c>"] = { callback = "actions.close", mode = "n" },
				["<C-l>"] = "actions.refresh",
				["-"] = { callback = "actions.parent", mode = "n" },
				["_"] = { callback = "actions.open_cwd", mode = "n" },
				["`"] = { callback = "actions.cd", mode = "n" },
				["g~"] = { callback = "actions.cd", opts = { scope = "tab" }, mode = "n" },
				["gs"] = { callback = "actions.change_sort", mode = "n" },
				["gx"] = "actions.open_external",
				["g."] = { callback = "actions.toggle_hidden", mode = "n" },
				["q"] = { callback = "actions.close", mode = "n" },
			},

			lsp = { enabled = true, timeout_ms = 1000, autosave = false },

			float = {
				default = false,
				title = true,
				padding = 2,
				max_width = 0,
				max_height = 0,
				border = nil,
				preview_split = "auto",
				win = { winblend = 0 },
			},

			preview = {
				follow = true,
				live = false,
				max_file_size_mb = 10,
				win = {},
			},

			confirmation = {
				max_width = 0.9,
				min_width = { 40, 0.4 },
				width = nil,
				max_height = 0.9,
				min_height = { 5, 0.1 },
				height = nil,
				border = nil,
				win = { winblend = 0 },
			},

			progress = {
				max_width = 0.9,
				min_width = { 40, 0.4 },
				width = nil,
				max_height = { 10, 0.9 },
				min_height = { 5, 0.1 },
				height = nil,
				border = nil,
				minimized_border = "none",
				win = { winblend = 0 },
			},

			buf = { buflisted = true, bufhidden = "hide" },
			win = {
				wrap = false,
				signcolumn = "no",
				cursorcolumn = false,
				foldcolumn = "0",
				spell = false,
				list = false,
				conceallevel = 3,
				concealcursor = "nvic",
			},
		}
	end,
}
