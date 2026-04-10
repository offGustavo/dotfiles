vim.cmd([[
let g:markdown_syntax_conceal = 0
let g:markdown_recommended_style = 0
let g:markdown_folding = 1
]])

if not Fish.markview_loaded then
	-- print("markview_loaded")
	Fish.markview_loaded = true
	vim.pack.add({ "https://github.com/OXY2DEV/markview.nvim" })
	require("markview").setup({
		preview = {
			modes = { "n", "no", "c" },
			hybrid_modes = { "n", "i" },
			linewise_hybrid_mode = true,
		},
		latex = {
			enable = false,
		},
		-- list_items
		markdown = {
			list_items = {
				enable = true,
				wrap = false,
				indent_size = 2,
				shift_width = 4,
				marker_minus = {
					add_padding = true,
					conceal_on_checkboxes = true,
					text = "-",
					hl = "MarkviewListItemMinus",
				},
				marker_plus = {
					add_padding = true,
					conceal_on_checkboxes = true,
					text = "+",
					hl = "MarkviewListItemPlus",
				},
				marker_star = {
					add_padding = true,
					conceal_on_checkboxes = true,
					text = "*",
					hl = "MarkviewListItemStar",
				},
				marker_dot = {
					add_padding = true,
					conceal_on_checkboxes = true,
				},
				marker_parenthesis = {
					add_padding = true,
					conceal_on_checkboxes = true,
				},
			},
		},
	})
	require("markview.extras.checkboxes").setup()
	require("markview.extras.headings").setup()
	require("markview.extras.editor").setup()
end

if not Fish.imgclip_loaded then
	-- print("imgclip_loaded")
	Fish.imgclip_loaded = true
	vim.pack.add({
		"https://github.com/HakonHarnes/img-clip.nvim",
	})
	require("img-clip").setup({
		-- add options here
		-- or leave it empty to use the default settings
		default = {
			-- file and directory options
			dir_path = "assets", ---@type string | fun(): string
			use_absolute_path = false, ---@type boolean | fun(): boolean
		},
	})
end

vim.keymap.set(
	"n",
	"<localleader>ip",
	"<cmd>PasteImage<cr>",
	{ desc = "Paste image from system clipboard", buffer = 0 }
)
vim.keymap.set("n", "<localleader>ic", ":Editor create<Cr>", { desc = "Create a code block", buffer = 0 })
vim.keymap.set("n", "<localleader>iC", ":Editor edit<Cr>", { desc = "Edit a code block", buffer = 0 })
vim.keymap.set("n", "<localleader>H", ":Headings increase<Cr>", { desc = "Headings increase", buffer = 0 })
vim.keymap.set("n", "<localleader>h", ":Headings decrease<Cr>", { desc = "Headings decrease", buffer = 0 })
vim.keymap.set("n", "<Cr>", ":Checkbox toggle<Cr>", { desc = "Checkbox", buffer = 0 })
vim.keymap.set("n", "<S-Cr>", ":Checkbox interactive<Cr>", { desc = "Checkbox interactive", buffer = 0 })
vim.keymap.set("n", "<localleader>td", "<Cmd>CheckTask<CR>", { silent = true, buffer = 0, desc = "Check Tesk" })
vim.keymap.set("n", "<localleader>tc", "<Cmd>CancelTask<CR>", { silent = true, buffer = 0, desc = "Cancel Tesk" })
vim.keymap.set("n", "<localleader>h", "<Cmd>HabitView<CR>", { silent = true, buffer = 0, desc = "Habits" })
vim.keymap.set("n", "<localleader>d", "<Cmd>AgendaDashboard<CR>", { silent = true, buffer = 0, desc = "Check Tesk" })
vim.keymap.set("n", "<localleader>is", "<Cmd>TaskScheduled<CR>", { silent = true, buffer = 0, desc = "Check Tesk" })
vim.keymap.set("n", "<localleader>id", "<Cmd>TaskDeadline<CR>", { silent = true, buffer = 0, desc = "Check Tesk" })
vim.keymap.set("n", "<localleader>mm", "<Cmd>Markview Toggle<Cr>", { buffer = 0, desc = "Toggle Markview" })
vim.keymap.set("n", "<localleader>mh", "<Cmd>Markview hybridToggle<Cr>", { buffer = 0, desc = "Toggle Hybrid Mode" })
vim.keymap.set("n", "<localleader>ms", "<Cmd>Markview splitToggle<Cr>", { buffer = 0, desc = "Toggle Split View" })

vim.lsp.enable("marksman")
