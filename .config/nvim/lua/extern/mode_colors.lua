local M = {}

local hl = function(group)
	return vim.api.nvim_get_hl(0, {
		name = group,
		link = false,
		create = false,
	})
end

-- FIXME: feio
M.hl = hl

-- REF: https://jacobnscott.com/posts/nvim-statusline/
local set_hl_groups = function()
	local base = hl("Normal")

	for group, opts in pairs({
		ModeNormal = { fg = base.bg, bg = hl("Function").fg },
		ModePending = { fg = base.bg, bg = hl("Comment").fg },
		ModeVisual = { fg = base.bg, bg = hl("Statement").fg },
		ModeInsert = { fg = base.bg, bg = hl("String").fg },
		ModeCommand = { fg = base.bg, bg = hl("WarningMsg").fg },
		ModeReplace = { fg = base.bg, bg = hl("ErrorMsg").fg },
		ModeTerminal = { fg = base.bg, bg = hl("String").fg },
		Bold = { fg = base.fg, bg = base.bg, bold = true },
		Dim = { fg = hl("LineNr").fg, bg = base.bg },
	}) do
		group = "StatusLine" .. group
		vim.api.nvim_set_hl(0, group, opts)
		opts.fg, opts.bg = opts.bg, opts.fg
		vim.api.nvim_set_hl(0, group .. "Inverted", opts)
	end

	local diff_add = hl("MiniDiffSignAdd")
	local diff_change = hl("MiniDiffSignChange")
	local diff_delete = hl("MiniDiffSignDelete")

	-- local diff_add = hl("MiniDiffSignAdd")
	-- local diff_change = hl("MiniDiffSignChange")
	-- local diff_delete = hl("MiniDiffSignDelete")

	vim.api.nvim_set_hl(0, "StatuslineDiffAdd", {
		bg = base.bg,
		fg = diff_add.fg,
	})

	vim.api.nvim_set_hl(0, "StatuslineDiffChange", {
		bg = base.bg,
		fg = diff_change.fg,
	})

	vim.api.nvim_set_hl(0, "StatuslineDiffDelete", {
		bg = base.bg,
		fg = diff_delete.fg,
	})
end

-- Compile and apply our custom highlights
set_hl_groups()

-- Re-compile statusline colours when the colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("my_statusline", {}),
	desc = "Re-apply statusline highlights on colorscheme change",
	callback = set_hl_groups,
})

local mode_color = function()
	-- Note: termcodes \19 and \22 are ^S and ^V
	---- stylua: ignore
	local mode_settings = {
		["n"] = { name = "NORMAL", hl = "Normal" },
		["no"] = { name = "OP-PENDING", hl = "Pending" },
		["nov"] = { name = "OP-PENDING", hl = "Pending" },
		["noV"] = { name = "OP-PENDING", hl = "Pending" },
		["no\22"] = { name = "OP-PENDING", hl = "Pending" },
		["niI"] = { name = "NORMAL", hl = "Normal" },
		["niR"] = { name = "NORMAL", hl = "Normal" },
		["niV"] = { name = "NORMAL", hl = "Normal" },
		["nt"] = { name = "NORMAL", hl = "Normal" },
		["ntT"] = { name = "NORMAL", hl = "Normal" },
		["v"] = { name = "VISUAL", hl = "Visual" },
		["vs"] = { name = "VISUAL", hl = "Visual" },
		["V"] = { name = "V-LINE", hl = "Visual" },
		["Vs"] = { name = "V-LINE", hl = "Visual" },
		["\22"] = { name = "V-BLOCK", hl = "Visual" },
		["\22s"] = { name = "V-BLOCK", hl = "Visual" },
		["s"] = { name = "SELECT", hl = "Insert" },
		["S"] = { name = "S-LINE", hl = "Normal" },
		["\19"] = { name = "S-BLOCK", hl = "Normal" },
		["i"] = { name = "INSERT", hl = "Insert" },
		["ic"] = { name = "INSERT", hl = "Insert" },
		["ix"] = { name = "INSERT", hl = "Insert" },
		["R"] = { name = "REPLACE", hl = "Replace" },
		["Rc"] = { name = "REPLACE", hl = "Replace" },
		["Rx"] = { name = "REPLACE", hl = "Replace" },
		["Rv"] = { name = "V-REPLACE", hl = "Replace" },
		["Rvc"] = { name = "V-REPLACE", hl = "Replace" },
		["Rvx"] = { name = "V-REPLACE", hl = "Replace" },
		["c"] = { name = "COMMAND", hl = "Command" },
		["cv"] = { name = "EX", hl = "Command" },
		["ce"] = { name = "EX", hl = "Command" },
		["r"] = { name = "REPLACE", hl = "Normal" },
		["rm"] = { name = "MORE", hl = "Normal" },
		["r?"] = { name = "CONFIRM", hl = "Normal" },
		["!"] = { name = "SHELL", hl = "Normal" },
		["t"] = { name = "TERMINAL", hl = "Command" },
	}
	local mode = mode_settings[vim.fn.mode()] or {}

	return mode.hl
	-- return table.concat({
	-- 	-- "%#StatuslineMode" .. mode.hl .. "Inverted" .. "#",
	-- 	"%#StatuslineMode" .. mode.hl .. "#" .. icon,
	-- 	-- "%#StatuslineMode" .. mode.hl .. "Inverted" .. "#",
	-- })
end

M.render_with_mode_color = function(char)
	return "%#StatuslineMode" .. mode_color() .. "#" .. char
end

M.render_with_mode_color_inverted = function(char)
	return "%#StatuslineMode" .. mode_color() .. "Inverted#" .. char
end

return M
