local M = {}

-- Dark mode (Shibuya) colors
M.colors = {
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
M.colors_day = {
  -- Core
  fg = "#3760bf",
  fg_bg = "#c3cfeb",
  fg_dark = "#6172b0",

  -- Soft backgrounds (derived / desaturated)
  bg = "#eef0f7",
  -- bg = "none",
  -- bg = "#ffffff",
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
  blue0 = "#7890dd",
  green = "#9ece6a",
  green_bg = "#e8f3df", -- Soft green background
  green_bright = "#9fe044",
  yellow = "#e0af68",
  yellow_bg = "#f5eedb", -- Soft yellow background
  yellow_bright = "#a27629",
  red = "#f52a65",
  red_bg = "#fbe4e9", -- Soft red background
  red_bright = "#ff899d",
  magenta = "#9854f1",
  magenta_bg = "#efe5fd", -- Soft magenta background
  magenta_bright = "#c7a9ff",
  cyan = "#7dcfff",
  cyan_bg = "#e6f6ff", -- Soft cyan background
  cyan_bright = "#a4daff",

  none = "\bNONE",
}

local p = M.colors
local p_day = M.colors_day
local set = vim.api.nvim_set_hl

-- Helper function to apply colors based on mode
local function apply_highlights(is_day_mode)
  local colors = is_day_mode and p_day or p

  -- Clear existing highlights
  if vim.fn.exists("syntax_on") then
    vim.cmd("highlight clear")
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true

  -- Basic UI
  set(0, "Normal", { fg = colors.fg, bg = colors.bg })
  set(0, "NormalFloat", { fg = colors.fg, bg = colors.bg_float })
  set(0, "FloatBorder", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_float })

  -- Cursor and selection
  set(0, "Cursor", { fg = colors.bg, bg = is_day_mode and colors.blue or colors.cursor })
  set(0, "CursorLine", { bg = colors.bg_highlight })
  set(0, "CursorLineNr", { fg = is_day_mode and colors.blue or colors.yellow, bold = true })

  -- Visual mode
  set(0, "Visual", { bg = colors.bg_visual })

  -- Line numbers
  set(0, "LineNr", { fg = is_day_mode and colors.gray or colors.fg_dark })
  set(0, "CursorLineNr", { fg = is_day_mode and colors.blue or colors.yellow, bold = true })

  -- Status line
  set(0, "StatusLine", { fg = colors.fg, bg = colors.bg_alt })
  set(0, "StatusLineNC", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_alt })

  -- Tab line
  set(0, "TabLine", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_alt })
  set(0, "TabLineSel", { fg = colors.fg, bg = colors.bg })
  set(0, "TabLineFill", { bg = colors.bg_alt })

  set(0, "WinBar", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_alt })
  set(0, "WinBarNC", { fg = colors.bg_alt, bg = colors.bg })

  -- Search
  set(0, "Search", { fg = colors.bg, bg = is_day_mode and colors.yellow or colors.yellow })
  set(0, "IncSearch", { fg = colors.bg, bg = is_day_mode and colors.blue or colors.yellow, bold = false })

  -- Messages
  set(0, "ErrorMsg", { fg = colors.red, bold = false })
  set(0, "WarningMsg", { fg = colors.yellow })
  set(0, "MoreMsg", { fg = colors.green })

  -- Completion menu
  set(0, "Pmenu", { fg = colors.fg, bg = colors.bg_float })
  set(0, "PmenuSel", { fg = colors.bg, bg = is_day_mode and colors.blue or colors.blue })
  set(0, "PmenuThumb", { fg = colors.bg_float, bg = is_day_mode and colors.blue or colors.blue })
  set(0, "PmenuSbar", { fg = is_day_mode and colors.blue or colors.blue, bg = colors.bg_float })

  -- Fold
  set(0, "Folded", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg_float, italic = true })

  -- Split
  set(0, "VertSplit", { fg = is_day_mode and colors.gray or colors.fg_dark, bg = colors.bg })

  -- =====================
  -- SYNTAX HIGHLIGHTING
  -- =====================

  -- Comments
  set(0, "Comment", { fg = is_day_mode and colors.gray or colors.fg_dark, italic = true })

  -- Strings and constants
  if is_day_mode then
    set(0, "String", { fg = colors.green, bg = colors.green_bg, italic = true })
    set(0, "Character", { fg = colors.green, bg = colors.green_bg, italic = true })
  else
    set(0, "String", { fg = colors.green, italic = true })
    set(0, "Character", { fg = colors.green, italic = true })
  end
  set(0, "Constant", { fg = colors.fg, italic = true })

  -- Numbers and booleans
  set(0, "Number", { fg = colors.fg, italic = false })
  set(0, "Boolean", { fg = colors.fg, italic = false, bold = false })
  set(0, "Float", { fg = colors.fg, italic = false })

  -- Functions and methods
  if is_day_mode then
    set(0, "Function", { fg = colors.magenta, bg = colors.magenta_bg })
    set(0, "Method", { fg = colors.magenta, bg = colors.magenta_bg })
  else
    set(0, "Function", { fg = colors.magenta })
    set(0, "Method", { fg = colors.magenta })
  end

  -- Variables and identifiers
  set(0, "Identifier", { fg = colors.fg, italic = true })
  set(0, "Variable", { fg = colors.fg, italic = true })

  -- Keywords and control flow
  if is_day_mode then
    set(0, "Keyword", { fg = colors.red, bg = colors.red_bg, italic = true })
  else
    set(0, "Keyword", { fg = colors.magenta, italic = true })
  end
  set(0, "Statement", { fg = colors.fg })
  set(0, "Conditional", { fg = colors.fg })
  set(0, "Repeat", { fg = colors.fg })
  set(0, "Label", { fg = colors.fg })

  if is_day_mode then
    set(0, "Operator", { fg = colors.fg, bg = colors.bg })
  else
    set(0, "Operator", { fg = colors.red })
  end

  set(0, "Exception", { fg = colors.yellow })

  -- Preprocessor and includes
  set(0, "PreProc", { fg = colors.fg })
  set(0, "Include", { fg = colors.fg })
  set(0, "Define", { fg = colors.fg })
  set(0, "Macro", { fg = colors.fg })

  -- Types
  if is_day_mode then
    set(0, "Type", { fg = colors.red, bg = colors.red_bg })
    set(0, "StorageClass", { fg = colors.red, bg = colors.red_bg })
  else
    set(0, "Type", { fg = colors.fg })
    set(0, "StorageClass", { fg = colors.fg })
  end
  set(0, "Structure", { fg = colors.fg })
  set(0, "Typedef", { fg = colors.fg })

  -- Special
  set(0, "Special", { fg = colors.fg })
  set(0, "SpecialChar", { fg = colors.red, bg = colors.green_bg })
  set(0, "Tag", { fg = colors.blue })
  set(0, "Delimiter", { fg = colors.fg })

  -- Special comments and TODOs
  set(0, "SpecialComment", { fg = colors.yellow, bold = false })
  if is_day_mode then
    set(0, "Todo", { fg = colors.bg, bg = colors.yellow, bold = true, italic = true })
  else
    set(0, "Todo", { fg = colors.fg_dark, bg = colors.yellow, bold = false, italic = true })
  end
  set(0, "Debug", { fg = colors.red })

  -- Underlined text
  set(0, "Underlined", { underline = true })

  -- Errors
  set(0, "Error", { fg = colors.red, bold = false })

  -- Diagnostics (LSP)
  set(0, "DiagnosticError", { fg = colors.red })
  set(0, "DiagnosticWarn", { fg = colors.yellow })
  set(0, "DiagnosticInfo", { fg = colors.blue })
  set(0, "DiagnosticHint", { fg = colors.fg })

  set(0, "DiagnosticUnderlineError", { undercurl = true, sp = colors.red })
  set(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = colors.yellow })
  set(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = colors.blue })
  set(0, "DiagnosticUnderlineHint", { undercurl = true, sp = is_day_mode and colors.gray or colors.fg_dark })

  -- Diff
  set(0, "DiffAdd", { fg = colors.green, bg = colors.bg })
  set(0, "DiffChange", { fg = colors.yellow, bg = colors.bg })
  set(0, "DiffDelete", { fg = colors.red, bg = colors.bg })
  set(0, "DiffText", { bg = colors.fg, fg = colors.bg })

  -- Non-text
  set(0, "NonText", { fg = is_day_mode and colors.gray or colors.fg_dark })
  set(0, "Whitespace", { fg = is_day_mode and colors.gray or colors.fg_dark })

  -- Match pairs
  set(0, "MatchParen", { fg = colors.yellow, bg = colors.yellow_bg })

  -- Window separator
  set(0, "WinSeparator", { fg = is_day_mode and colors.gray or colors.fg_dark })
  set(0, "Title", { fg = is_day_mode and colors.gray or colors.fg_dark })

  -- =====================
  -- TREE-SITTER
  -- =====================

  -- Keywords
  if is_day_mode then
    set(0, "@keyword", { fg = colors.red, bg = colors.red_bg, italic = true })
  else
    set(0, "@keyword", { fg = colors.magenta, italic = true })
  end

  -- Functions
  if is_day_mode then
    set(0, "@function", { fg = colors.magenta, bg = colors.magenta_bg })
    set(0, "@function.call", { fg = colors.magenta, bg = colors.magenta_bg })
  else
    set(0, "@function", { fg = colors.magenta })
    set(0, "@function.call", { fg = colors.magenta })
  end

  -- Methods
  if is_day_mode then
    set(0, "@method", { fg = colors.magenta, bg = colors.magenta_bg })
    set(0, "@method.call", { fg = colors.magenta, bg = colors.magenta_bg })
  else
    set(0, "@method", { fg = colors.magenta })
    set(0, "@method.call", { fg = colors.magenta })
  end

  -- Variables
  set(0, "@variable", { fg = colors.fg })
  if is_day_mode then
    set(0, "@variable.builtin", { fg = colors.blue, bg = colors.blue_bg })
  else
    set(0, "@variable.builtin", { fg = colors.red })
  end

  -- Namespaces / modules
  if is_day_mode then
    set(0, "@namespace", { fg = colors.red, bg = colors.red_bg })
  else
    set(0, "@namespace", { fg = colors.magenta })
  end

  -- Properties / fields
  set(0, "@field", { fg = colors.fg })
  set(0, "@property", { fg = colors.fg })
end

M.setup = function(opts)
  opts = opts or {}
  local is_day_mode = opts.mode == "day"

  vim.g.colors_name = "shibuya"
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
M.toggle_mode = function()
  local current_mode = vim.g.colors_name == "shibuya_day" and "day" or "shibuya"
  local new_mode = current_mode == "day" and "night" or "day"

  M.setup({ mode = new_mode })
  print("Switched to " .. new_mode .. " mode")
end

-- Set default to dark mode
M.setup({ mode = "night" })

return M
