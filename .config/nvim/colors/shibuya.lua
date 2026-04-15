local Shibuya = {}

-- Dark mode (Shibuya) colors
Shibuya.colors = {
	-- Base colors (reduced palette)
	bg = "#1a1b26",
	bg_alt = "#24283b",
	bg_float = "#24283b",
	bg_highlight = "#292e42",
	bg_visual = "#364a82",

	fg = "#c0caf5",
	fg_dark = "#565f89",

	-- Primary colors only
	blue = "#7aa2f7",
	cyan = "#7dcfff",
	green = "#9ece6a",
	yellow = "#e0af68",
	yellow_bg = "#f5eedb", -- Soft yellow background
	red = "#f7768e",
	magenta = "#bb9af7",

	-- UI specific
	cursor = "#c0caf5",
	selection_bg = "#364a82",
}

-- Light mode (Shibuya Day) colors with background highlights
Shibuya.colors_day = {
	-- Core
	fg = "#3760bf",
	fg_bg = "#c3cfeb",
	fg_dark = "#6172b0",

	-- Soft backgrounds (derived / desaturated)
	bg = "#e1e2e7",
	bg_alt = "#e4e7f2",
	bg_float = "#dde1ef",
	bg_highlight = "#d6dbea",
	bg_visual = "#cfd6ea",

	-- UI neutrals
	gray = "#7a83b5",
	gray_dark = "#5c6399",

	-- Accents
	blue = "#2e7de9",
	blue_bg = "#e1e8fb", -- Soft blue background
	green = "#9ece6a",
	green_bg = "#e8f3df", -- Soft green background
	yellow = "#e0af68",
	yellow_bg = "#f5eedb", -- Soft yellow background
	red = "#f52a65",
	red_bg = "#fbe4e9", -- Soft red background
	magenta = "#9854f1",
	magenta_bg = "#efe5fd", -- Soft magenta background
	cyan = "#7dcfff",
	cyan_bg = "#e6f6ff", -- Soft cyan background
}

-- Helper function to apply colors based on mode
local function apply_highlights(is_day_mode)
	local colors = is_day_mode and Shibuya.colors_day or Shibuya.colors

	-- Clear existing highlights
	vim.cmd("highlight clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end

	vim.o.termguicolors = true

	-- Basic UI
	vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
	vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.fg, bg = colors.bg_float })
	vim.api.nvim_set_hl(0, "FloatBorder", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_float })

	-- Cursor and selection
	vim.api.nvim_set_hl(0, "Cursor", { fg = colors.bg, bg = is_day_mode and colors.blue or colors.cursor })
	vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.bg_highlight })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = is_day_mode and colors.blue or colors.yellow, bold = true })

	-- Visual mode
	vim.api.nvim_set_hl(0, "Visual", { bg = colors.bg_visual })

	-- L
	vim.api.nvim_set_hl(0, "LineNr", { fg = is_day_mode and colors.gray or colors.fg_dark })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = is_day_mode and colors.blue or colors.yellow, bold = true })

	-- Status line
	vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.fg, bg = colors.bg_alt })
	vim.api.nvim_set_hl(0, "StatusLineNC", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_alt })

	-- Tab line
	vim.api.nvim_set_hl(0, "TabLine", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_alt })
	vim.api.nvim_set_hl(0, "TabLineSel", { fg = colors.bg, bg = colors.blue })
	vim.api.nvim_set_hl(0, "TabLineFill", { bg = colors.bg_alt })

	-- Window bar
	vim.api.nvim_set_hl(0, "WinBar", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_alt })
	vim.api.nvim_set_hl(0, "WinBarNC", { fg = colors.bg_alt, bg = colors.bg })

	-- Search
	vim.api.nvim_set_hl(0, "Search", { fg = colors.bg, bg = colors.yellow })
	vim.api.nvim_set_hl(
		0,
		"IncSearch",
		{ fg = colors.bg, bg = is_day_mode and colors.blue or colors.yellow, bold = false }
	)

	-- Messages
	vim.api.nvim_set_hl(0, "ErrorMsg", { fg = colors.red, bold = false })
	vim.api.nvim_set_hl(0, "WarningMsg", { fg = colors.yellow })
	vim.api.nvim_set_hl(0, "MoreMsg", { fg = colors.green })

	-- Completion menu
	vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.fg, bg = colors.bg_float })
	vim.api.nvim_set_hl(0, "PmenuSel", { fg = colors.bg, bg = is_day_mode and colors.blue or colors.blue })
	vim.api.nvim_set_hl(0, "PmenuThumb", { bg = is_day_mode and colors.blue or colors.blue })
	vim.api.nvim_set_hl(0, "PmenuSbar", { bg = colors.bg_float })

	-- Fold
	vim.api.nvim_set_hl(
		0,
		"Folded",
		{ fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_float, italic = true }
	)

	-- Split
	vim.api.nvim_set_hl(0, "VertSplit", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg })

	-- =====================
	-- SYNTAX HIGHLIGHTING
	-- =====================

	-- Comments
	vim.api.nvim_set_hl(0, "Comment", { fg = is_day_mode and colors.gray or colors.fg_dark, italic = true })

	-- Strings and constants
	if is_day_mode then
		vim.api.nvim_set_hl(0, "String", { fg = colors.green, bg = colors.green_bg, italic = true })
		vim.api.nvim_set_hl(0, "Character", { fg = colors.green, bg = colors.green_bg, italic = true })
	else
		vim.api.nvim_set_hl(0, "String", { fg = colors.green, italic = true })
		vim.api.nvim_set_hl(0, "Character", { fg = colors.green, italic = true })
	end
	vim.api.nvim_set_hl(0, "Constant", { fg = colors.fg, italic = true })

	-- Numbers and booleans
	vim.api.nvim_set_hl(0, "Number", { fg = colors.fg, italic = false })
	vim.api.nvim_set_hl(0, "Boolean", { fg = colors.fg, italic = false, bold = false })
	vim.api.nvim_set_hl(0, "Float", { fg = colors.fg, italic = false })

	-- Functions and methods
	if is_day_mode then
		vim.api.nvim_set_hl(0, "Function", { fg = colors.magenta, bg = colors.magenta_bg })
		vim.api.nvim_set_hl(0, "Method", { fg = colors.magenta, bg = colors.magenta_bg })
	else
		vim.api.nvim_set_hl(0, "Function", { fg = colors.magenta })
		vim.api.nvim_set_hl(0, "Method", { fg = colors.magenta })
	end

	-- Variables and identifiers
	vim.api.nvim_set_hl(0, "Identifier", { fg = colors.fg, italic = true })
	vim.api.nvim_set_hl(0, "Variable", { fg = colors.fg, italic = true })

	-- Keywords and control flow
	if is_day_mode then
	else
		vim.api.nvim_set_hl(0, "Keyword", { fg = colors.magenta, italic = true })
	end
	vim.api.nvim_set_hl(0, "Statement", { fg = colors.fg })
	vim.api.nvim_set_hl(0, "Conditional", { fg = colors.fg })
	vim.api.nvim_set_hl(0, "Repeat", { fg = colors.fg })
	vim.api.nvim_set_hl(0, "Label", { fg = colors.fg })

	if is_day_mode then
		vim.api.nvim_set_hl(0, "Operator", { fg = colors.fg, bg = colors.bg })
	else
		vim.api.nvim_set_hl(0, "Operator", { fg = colors.red })
	end

	vim.api.nvim_set_hl(0, "Exception", { fg = colors.yellow })

	-- Preprocessor and includes
	vim.api.nvim_set_hl(0, "PreProc", { fg = colors.fg })
	vim.api.nvim_set_hl(0, "Include", { fg = colors.fg })
	vim.api.nvim_set_hl(0, "Define", { fg = colors.fg })
	vim.api.nvim_set_hl(0, "Macro", { fg = colors.fg })

	-- Types
	if is_day_mode then
		vim.api.nvim_set_hl(0, "Type", { fg = colors.red, bg = colors.red_bg })
		vim.api.nvim_set_hl(0, "StorageClass", { fg = colors.red, bg = colors.red_bg })
	else
		vim.api.nvim_set_hl(0, "Type", { fg = colors.fg })
		vim.api.nvim_set_hl(0, "StorageClass", { fg = colors.fg })
	end
	vim.api.nvim_set_hl(0, "Structure", { fg = colors.fg })
	vim.api.nvim_set_hl(0, "Typedef", { fg = colors.fg })

	-- Special
	vim.api.nvim_set_hl(0, "Special", { fg = colors.red, bg = colors.green_bg })
	vim.api.nvim_set_hl(0, "SpecialChar", { fg = colors.magenta })
	vim.api.nvim_set_hl(0, "Tag", { fg = colors.blue })
	vim.api.nvim_set_hl(0, "Delimiter", { fg = colors.fg })

	-- -- Special comments and TODOs
	-- vim.api.nvim_set_hl(0, "SpecialComment", { fg = colors.yellow, bg = colors.yellow_bg, bold = false })
	-- if is_day_mode then
	-- 	vim.api.nvim_set_hl(0, "Todo", { fg = colors.yellow, bg = colors.yellow_bg, bold = false })
	-- else
	-- 	vim.api.nvim_set_hl(0, "Todo", { fg = colors.fg_dark, bg = colors.yellow, bold = false, italic = true })
	-- end
	-- vim.api.nvim_set_hl(0, "Debug", { fg = colors.red })

	-- Underlined text
	vim.api.nvim_set_hl(0, "Underlined", { underline = true })

	-- Errors
	vim.api.nvim_set_hl(0, "Error", { fg = colors.red, bold = false })

	-- Diagnostics (LSP)
	vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.red })
	vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = colors.yellow })
	vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = colors.blue })
	vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = colors.fg })

	vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = colors.red })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = colors.yellow })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = colors.blue })
	vim.api.nvim_set_hl(
		0,
		"DiagnosticUnderlineHint",
		{ undercurl = true, sp = is_day_mode and colors.gray or colors.fg_dark }
	)

	-- Diff
	vim.api.nvim_set_hl(0, "DiffAdd", { fg = colors.green, bg = colors.bg })
	vim.api.nvim_set_hl(0, "DiffChange", { fg = colors.yellow, bg = colors.bg })
	vim.api.nvim_set_hl(0, "DiffDelete", { fg = colors.red, bg = colors.bg })
	vim.api.nvim_set_hl(0, "DiffText", { bg = colors.fg, fg = colors.bg })

	-- Non-text
	vim.api.nvim_set_hl(0, "NonText", { fg = is_day_mode and colors.gray or colors.fg_dark })
	vim.api.nvim_set_hl(0, "Whitespace", { fg = is_day_mode and colors.gray or colors.fg_dark })

	-- Match pairs
	vim.api.nvim_set_hl(0, "MatchParen", { fg = colors.yellow, bg = colors.yellow_bg })

	-- Window separator
	vim.api.nvim_set_hl(0, "WinSeparator", { fg = is_day_mode and colors.gray or colors.fg_dark })
	vim.api.nvim_set_hl(0, "Title", { fg = is_day_mode and colors.gray or colors.fg_dark })

	-- =====================
	-- TREE-SITTER
	-- =====================

	-- Keywords
	if is_day_mode then
		vim.api.nvim_set_hl(0, "@keyword", { fg = colors.red, bg = colors.red_bg, italic = true })
	else
		vim.api.nvim_set_hl(0, "@keyword", { fg = colors.magenta, italic = true })
	end

	-- Functions
	if is_day_mode then
		vim.api.nvim_set_hl(0, "@function", { fg = colors.magenta, bg = colors.magenta_bg })
		vim.api.nvim_set_hl(0, "@function.call", { fg = colors.magenta, bg = colors.magenta_bg })
	else
		vim.api.nvim_set_hl(0, "@function", { fg = colors.magenta })
		vim.api.nvim_set_hl(0, "@function.call", { fg = colors.magenta })
	end

	-- Methods
	if is_day_mode then
		vim.api.nvim_set_hl(0, "@method", { fg = colors.magenta, bg = colors.magenta_bg })
		vim.api.nvim_set_hl(0, "@method.call", { fg = colors.magenta, bg = colors.magenta_bg })
	else
		vim.api.nvim_set_hl(0, "@method", { fg = colors.magenta })
		vim.api.nvim_set_hl(0, "@method.call", { fg = colors.magenta })
	end

	-- Variables
	vim.api.nvim_set_hl(0, "@variable", { fg = colors.fg })
	if is_day_mode then
		vim.api.nvim_set_hl(0, "@variable.builtin", { fg = colors.blue, bg = colors.blue_bg })
	else
		vim.api.nvim_set_hl(0, "@variable.builtin", { fg = colors.red })
	end

	-- Namespaces / modules
	if is_day_mode then
		vim.api.nvim_set_hl(0, "@namespace", { fg = colors.red, bg = colors.red_bg })
	else
		vim.api.nvim_set_hl(0, "@namespace", { fg = colors.magenta })
	end

	-- Properties / fields
	vim.api.nvim_set_hl(0, "@field", { fg = colors.fg })
	vim.api.nvim_set_hl(0, "@property", { fg = colors.fg })
end

Shibuya.setup = function(opts)
	opts = opts or {}
	local is_day_mode = opts.mode == "day"

	-- Update vim.o.background to match the mode
	vim.o.background = is_day_mode and "light" or "dark"

	vim.g.colors_name = is_day_mode and "shibuya_day" or "shibuya"
	apply_highlights(is_day_mode)

	-- Re-apply highlights after UI loads
	vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
		once = true,
		callback = function()
			apply_highlights(is_day_mode)
		end,
	})
end

-- Helper function to toggle between modes
Shibuya.toggle_mode = function()
	local new_mode = (vim.o.background == "light") and "night" or "day"
	Shibuya.setup({ mode = new_mode })
	print("Switched to " .. new_mode .. " mode")
end

-- Initialize the theme (default to dark mode)
Shibuya.setup({ mode = "night" })

vim.keymap.set("n", "<localleader>b", function()
	Shibuya.toggle_mode()
end, { desc = "Toggle color theme" })
