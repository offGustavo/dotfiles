local M = config{}

local opts = {
	ui = {
		border = "none",
		height = 1,
		width = 1,
		x = 0.5,
		y = 0.5,
	},
}

---Returns window dimensions based on ui options
---@return WindowDimensions
local function get_window_dimensions()
	local win_height = math.ceil(vim.o.lines * opts.ui.height)
	local win_width = math.ceil(vim.o.columns * opts.ui.width)
	return {
		height = win_height,
		width = win_width,
		row = math.ceil((vim.o.lines - win_height) * opts.ui.y - 1),
		col = math.ceil((vim.o.columns - win_width) * opts.ui.x),
	}
end

---Open a floating window 
M.openFloat = function()
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(
		buf,
		true,
		vim.tbl_extend("error", {
			relative = "editor",
			border = opts.ui.border,
			style = "minimal",
		}, get_window_dimensions())
	)

	vim.api.nvim_set_option_value("winhl", "NormalFloat:Normal", { win = win })
	vim.api.nvim_set_option_value("filetype", "terminal", { buf = buf })

	-- Resize window on VimResized
	local group = vim.api.nvim_create_augroup("forge_terminal", { clear = true })
	vim.api.nvim_create_autocmd("VimResized", {
		group = group,
		buffer = buf,
		callback = function()
			vim.api.nvim_win_set_config(
				win,
				vim.tbl_deep_extend("force", vim.api.nvim_win_get_config(win), get_window_dimensions())
			)
		end,
	})

	-- Apply custom keymaps
	for keybind, command in pairs(opts.keybindings) do
		vim.api.nvim_buf_set_keymap(buf, "t", keybind, command, { silent = true })
	end
end

return M
