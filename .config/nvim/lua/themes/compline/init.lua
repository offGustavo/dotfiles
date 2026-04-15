local M = {}

M.palette = {
  bg = '#1a1d21',
  fg = '#e0dcd4',
  cursor = '#DBCDB3',
  cursor_text_color = 'background',
  selection_foreground = '#e0dcd4',
  selection_background = '#3d424a',

  color0 = '#1a1d21',
  color8 = '#515761',

  color1 = '#CDACAC',
  color9 = '#c8beb8',

  color2 = '#b8c4b8',
  color10 = '#b4beb4',

  color3 = '#DBCDB3',
  color11 = '#ccc4b0',

  color4 = '#b4bcc4',
  color12 = '#b4bcc4',

  color5 = '#c0b8bc',
  color13 = '#c4beb8',

  color6 = '#b0bcc8',
  color14 = '#b0c0b8',

  color7 = '#c0bdb8',
  color15 = '#e0dcd4',
}

function M.setup()
  vim.cmd("colorscheme zen")
  local p = M.palette
  local set = vim.api.nvim_set_hl

  -- Basic UI
  set(0, 'Normal', { fg = p.fg, bg = p.bg })
  set(0, 'NormalNC', { fg = p.fg, bg = p.bg })
  set(0, 'CursorLine', { bg = p.color0 })
  set(0, 'LineNr', { fg = p.color8 })
  set(0, 'Visual', { fg = p.selection_foreground })
  set(0, 'Visual', { bg = p.selection_background })
  set(0, 'CursorLineNr', { fg = p.color3, bold = false })

  -- Syntax
  set(0, 'Comment', { fg = p.color8, italic = true })
  set(0, 'String', { fg = p.color2 })
  set(0, 'Function', { fg = p.color4 })
  set(0, 'Identifier', { fg = p.color1 })
  set(0, 'Keyword', { fg = p.color1 })

  -- Diagnostics
  set(0, 'DiagnosticError', { fg = p.color1 })
  set(0, 'DiagnosticWarn', { fg = p.color3 })
  set(0, 'DiagnosticInfo', { fg = p.color2 })
  set(0, 'DiagnosticHint', { fg = p.color8 })
end

return M



-- local M = {}
--
-- -- Color palette
-- M.colors = {
--   -- Base colors
--   bg = '#1a1d21',
--   fg = '#e0dcd4',
--   cursor = '#DBCDB3',
--   cursor_text_color = '#1a1d21',
--   selection_fg = '#e0dcd4',
--   selection_bg = '#3d424a',
--
--   -- ANSI colors (0-15)
--   color0 = '#1a1d21',
--   color1 = '#CDACAC',
--   color2 = '#b8c4b8',
--   color3 = '#DBCDB3',
--   color4 = '#b4bcc4',
--   color5 = '#c0b8bc',
--   color6 = '#b0bcc8',
--   color7 = '#c0bdb8',
--   color8 = '#515761',
--   color9 = '#c8beb8',
--   color10 = '#b4beb4',
--   color11 = '#ccc4b0',
--   color12 = '#b4bcc4',
--   color13 = '#c4beb8',
--   color14 = '#b0c0b8',
--   color15 = '#e0dcd4',
--
--   -- Semantic names for better readability
--   red = '#CDACAC',
--   green = '#b8c4b8',
--   yellow = '#DBCDB3',
--   blue = '#b4bcc4',
--   magenta = '#c0b8bc',
--   cyan = '#b0bcc8',
--   white = '#c0bdb8',
--   gray = '#515761',
--   bright_red = '#c8beb8',
--   bright_green = '#b4beb4',
--   bright_yellow = '#ccc4b0',
--   bright_blue = '#b4bcc4',
--   bright_magenta = '#c4beb8',
--   bright_cyan = '#b0c0b8',
--   bright_white = '#e0dcd4',
-- }
--
-- local p = M.colors
-- local set = vim.api.nvim_set_hl
--
-- M.setup = function()
--   -- Clear existing highlights to prevent conflicts
--   vim.cmd('highlight clear')
--   if vim.fn.exists('syntax_on') then
--     vim.cmd('syntax reset')
--   end
--
--   vim.g.colors_name = 'custom_theme'
--   vim.o.termguicolors = true
--
--   -- Basic UI
--   set(0, 'Normal', { fg = p.fg, bg = p.bg })
--   set(0, 'NormalNC', { fg = p.fg, bg = p.bg })
--   set(0, 'NormalFloat', { fg = p.fg, bg = p.color0 })
--   set(0, 'FloatBorder', { fg = p.color8, bg = p.color0 })
--
--   -- Cursor and selection
--   set(0, 'Cursor', { fg = p.cursor_text_color, bg = p.cursor })
--   set(0, 'CursorLine', { bg = '#25292e' }) -- Slightly lighter than bg
--   set(0, 'CursorLineNr', { fg = p.yellow, bold = true })
--   set(0, 'CursorColumn', { bg = '#25292e' })
--
--   -- Visual mode
--   set(0, 'Visual', { fg = p.selection_fg, bg = p.selection_bg })
--   set(0, 'VisualNOS', { fg = p.selection_fg, bg = p.selection_bg, underline = true })
--
--   -- Line numbers
--   set(0, 'LineNr', { fg = p.gray })
--   set(0, 'LineNrAbove', { fg = p.gray })
--   set(0, 'LineNrBelow', { fg = p.gray })
--
--   -- Status line
--   set(0, 'StatusLine', { fg = p.fg, bg = p.color0 })
--   set(0, 'StatusLineNC', { fg = p.gray, bg = p.color0 })
--   set(0, 'StatusLineTerm', { fg = p.fg, bg = p.color0 })
--   set(0, 'StatusLineTermNC', { fg = p.gray, bg = p.color0 })
--
--   -- Tab line
--   set(0, 'TabLine', { fg = p.gray, bg = p.color0 })
--   set(0, 'TabLineSel', { fg = p.fg, bg = p.selection_bg })
--   set(0, 'TabLineFill', { bg = p.color0 })
--
--   -- Search
--   set(0, 'Search', { fg = p.bg, bg = p.yellow })
--   set(0, 'IncSearch', { fg = p.bg, bg = p.bright_yellow })
--   set(0, 'CurSearch', { fg = p.bg, bg = p.bright_yellow })
--
--   -- Messages and prompts
--   set(0, 'ErrorMsg', { fg = p.red, bold = true })
--   set(0, 'WarningMsg', { fg = p.yellow, bold = true })
--   set(0, 'MoreMsg', { fg = p.green, bold = true })
--   set(0, 'ModeMsg', { fg = p.blue })
--   set(0, 'Question', { fg = p.cyan })
--
--   -- Pmenu (completion menu)
--   set(0, 'Pmenu', { fg = p.fg, bg = p.color0 })
--   set(0, 'PmenuSel', { fg = p.bg, bg = p.blue })
--   set(0, 'PmenuSbar', { bg = p.color8 })
--   set(0, 'PmenuThumb', { bg = p.gray })
--
--   -- Fold
--   set(0, 'Folded', { fg = p.gray, bg = '#25292e', italic = true })
--   set(0, 'FoldColumn', { fg = p.gray, bg = p.bg })
--
--   -- Sign column
--   set(0, 'SignColumn', { fg = p.gray, bg = p.bg })
--
--   -- Color column
--   set(0, 'ColorColumn', { bg = '#25292e' })
--
--   -- VertSplit
--   set(0, 'VertSplit', { fg = p.color8, bg = p.bg })
--
--   -- Syntax highlighting
--   set(0, 'Comment', { fg = p.gray, italic = true })
--   set(0, 'String', { fg = p.green })
--   set(0, 'Character', { fg = p.bright_green })
--   set(0, 'Number', { fg = p.cyan })
--   set(0, 'Boolean', { fg = p.cyan })
--   set(0, 'Float', { fg = p.cyan })
--   set(0, 'Function', { fg = p.blue })
--   set(0, 'Identifier', { fg = p.magenta })
--   set(0, 'Keyword', { fg = p.red })
--   set(0, 'Statement', { fg = p.red })
--   set(0, 'Conditional', { fg = p.red })
--   set(0, 'Repeat', { fg = p.red })
--   set(0, 'Label', { fg = p.blue })
--   set(0, 'Operator', { fg = p.fg })
--   set(0, 'Exception', { fg = p.red })
--   set(0, 'PreProc', { fg = p.yellow })
--   set(0, 'Include', { fg = p.red })
--   set(0, 'Define', { fg = p.red })
--   set(0, 'Macro', { fg = p.yellow })
--   set(0, 'PreCondit', { fg = p.yellow })
--   set(0, 'Type', { fg = p.yellow })
--   set(0, 'StorageClass', { fg = p.yellow })
--   set(0, 'Structure', { fg = p.yellow })
--   set(0, 'Typedef', { fg = p.yellow })
--   set(0, 'Special', { fg = p.cyan })
--   set(0, 'SpecialChar', { fg = p.cyan })
--   set(0, 'Tag', { fg = p.blue })
--   set(0, 'Delimiter', { fg = p.fg })
--   set(0, 'SpecialComment', { fg = p.gray, bold = true })
--   set(0, 'Debug', { fg = p.red })
--   set(0, 'Underlined', { underline = true })
--   set(0, 'Ignore', { fg = p.gray })
--   set(0, 'Error', { fg = p.red, bold = true })
--   set(0, 'Todo', { fg = p.yellow, bold = true, italic = true })
--
--   -- Diagnostics (LSP)
--   set(0, 'DiagnosticError', { fg = p.red })
--   set(0, 'DiagnosticWarn', { fg = p.yellow })
--   set(0, 'DiagnosticInfo', { fg = p.blue })
--   set(0, 'DiagnosticHint', { fg = p.gray })
--   set(0, 'DiagnosticUnderlineError', { undercurl = true, sp = p.red })
--   set(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = p.yellow })
--   set(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = p.blue })
--   set(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = p.gray })
--
--   -- Diff
--   set(0, 'DiffAdd', { fg = p.green, bg = '#1e2a1e' })
--   set(0, 'DiffChange', { fg = p.yellow, bg = '#2a2a1e' })
--   set(0, 'DiffDelete', { fg = p.red, bg = '#2a1e1e' })
--   set(0, 'DiffText', { fg = p.bg, bg = p.yellow })
--
--   -- Spell
--   set(0, 'SpellBad', { undercurl = true, sp = p.red })
--   set(0, 'SpellCap', { undercurl = true, sp = p.yellow })
--   set(0, 'SpellRare', { undercurl = true, sp = p.cyan })
--   set(0, 'SpellLocal', { undercurl = true, sp = p.blue })
--
--   -- Non-text
--   set(0, 'NonText', { fg = p.color8 })
--   set(0, 'Whitespace', { fg = p.color8 })
--   set(0, 'EndOfBuffer', { fg = p.color0 })
--
--   -- Match pairs
--   set(0, 'MatchParen', { fg = p.yellow, bold = true, underline = true })
--
--   -- Conceal
--   set(0, 'Conceal', { fg = p.gray, bg = p.bg })
--
--   -- Special windows
--   set(0, 'WinSeparator', { fg = p.color8 })
--   set(0, 'WildMenu', { fg = p.bg, bg = p.blue })
-- end
--
-- M.setup()
--
