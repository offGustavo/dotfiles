local M = {}

-- Simplified Tokyo Night colors
M.colors = {
  -- Base colors (reduced palette)
  bg = '#1a1b26',
  fg = '#c0caf5',

  -- Primary colors only
  blue = '#7aa2f7',
  cyan = '#7dcfff',
  green = '#9ece6a',
  yellow = '#e0af68',
  red = '#f7768e',
  magenta = '#bb9af7',

  -- Utility colors
  gray = '#565f89',
  dark_gray = '#24283b',

  -- UI specific
  cursor = '#c0caf5',
  selection_bg = '#364a82',
}

local p = M.colors
local set = vim.api.nvim_set_hl

M.setup = function()
  -- Clear existing highlights
  vim.cmd('highlight clear')
  if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
  end

  vim.g.colors_name = 'Shibuya-night'
  vim.o.termguicolors = true

  -- Basic UI
  set(0, 'Normal', { fg = p.fg, bg = p.bg })
  set(0, 'NormalFloat', { fg = p.fg, bg = p.dark_gray })
  set(0, 'FloatBorder', { fg = p.gray, bg = p.dark_gray })

  -- Cursor and selection
  set(0, 'Cursor', { fg = p.bg, bg = p.cursor })
  set(0, 'CursorLine', { bg = p.dark_gray })
  set(0, 'CursorLineNr', { fg = p.yellow, bold = true })

  -- Visual mode
  set(0, 'Visual', { bg = p.selection_bg })

  -- Line numbers
  set(0, 'LineNr', { fg = p.gray })
  set(0, 'CursorLineNr', { fg = p.yellow, bold = true })

  -- Status line
  set(0, 'StatusLine', { fg = p.fg, bg = p.dark_gray })
  set(0, 'StatusLineNC', { fg = p.gray, bg = p.dark_gray })

  -- Tab line
  set(0, 'TabLine', { fg = p.gray, bg = p.dark_gray })
  set(0, 'TabLineSel', { fg = p.fg, bg = p.bg })
  set(0, 'TabLineFill', { bg = p.dark_gray })

  -- Search
  set(0, 'Search', { fg = p.bg, bg = p.yellow })
  set(0, 'IncSearch', { fg = p.bg, bg = p.yellow, bold = false })

  -- Messages
  set(0, 'ErrorMsg', { fg = p.red, bold = false })
  set(0, 'WarningMsg', { fg = p.yellow })
  set(0, 'MoreMsg', { fg = p.green })

  -- Completion menu
  set(0, 'Pmenu', { fg = p.fg, bg = p.dark_gray })
  set(0, 'PmenuSel', { fg = p.bg, bg = p.blue })
  set(0, 'PmenuThumb', { fg = p.dark_gray, bg = p.blue })
  set(0, 'PmenuSbar', { fg = p.blue, bg = p.dark_gray })

  -- Fold
  set(0, 'Folded', { fg = p.gray, bg = p.dark_gray, italic = true })

  -- Split
  set(0, 'VertSplit', { fg = p.gray, bg = p.bg })


  -- =====================
  -- SYNTAX HIGHLIGHTING
  -- =====================

  -- Comments
  set(0, 'Comment', { fg = p.gray, italic = true })

  -- Strings and constants (ITALIC)
  set(0, 'String', { fg = p.green, italic = true })
  set(0, 'Character', { fg = p.green, italic = true })
  set(0, 'Constant', { fg = p.red, italic = true })

  -- Numbers and booleans (ITALIC)
  set(0, 'Number', { fg = p.fg, italic = false })
  set(0, 'Boolean', { fg = p.fg, italic = false, bold = false })
  set(0, 'Float', { fg = p.fg, italic = false })

  -- Functions and methods (BOLD)
  vim.api.nvim_set_hl(0, 'Function', { fg = p.magenta })
  vim.api.nvim_set_hl(0, 'Method', { fg = p.magenta })

  -- Variables and identifiers (ITALIC)
  set(0, 'Identifier', { fg = p.fg, italic = true })
  set(0, 'Variable', { fg = p.red, italic = true })


  -- Keywords and control flow
  set(0, 'Keyword', { fg = p.magenta })
  set(0, 'Statement', { fg = p.red })
  set(0, 'Conditional', { fg = p.red })
  set(0, 'Repeat', { fg = p.red })
  set(0, 'Label', { fg = p.red })
  vim.api.nvim_set_hl(0, 'Operator', { fg = p.red })
  set(0, 'Exception', { fg = p.red })

  -- Preprocessor and includes
  set(0, 'PreProc', { fg = p.fg })
  set(0, 'Include', { fg = p.fg })
  set(0, 'Define', { fg = p.fg })
  set(0, 'Macro', { fg = p.fg })

  -- Types
  set(0, 'Type', { fg = p.fg })
  set(0, 'StorageClass', { fg = p.fg })
  set(0, 'Structure', { fg = p.fg })
  set(0, 'Typedef', { fg = p.fg })

  -- Special
  set(0, 'Special', { fg = p.fg })
  set(0, 'SpecialChar', { fg = p.magenta })
  set(0, 'Tag', { fg = p.blue })
  set(0, 'Delimiter', { fg = p.fg })

  -- Special comments and TODOs
  set(0, 'SpecialComment', { fg = p.yellow, bold = true })
  set(0, 'Todo', { fg = p.gray, bg = p.yellow,  bold = true, italic = true })
  set(0, 'Debug', { fg = p.red })

  -- Underlned text
  set(0, 'Underlined', { underline = true })

  -- Errors
  set(0, 'Error', { fg = p.red, bold = true })

  -- Diagnostics (LSP)
  set(0, 'DiagnosticError', { fg = p.red })
  set(0, 'DiagnosticWarn', { fg = p.yellow })
  set(0, 'DiagnosticInfo', { fg = p.blue })
  set(0, 'DiagnosticHint', { fg = p.fg })

  set(0, 'DiagnosticUnderlineError', { undercurl = true, sp = p.red })
  set(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = p.yellow })
  set(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = p.blue })
  set(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = p.gray })

  -- Diff
  set(0, 'DiffAdd', { bg = p.green })
  set(0, 'DiffChange', { bg = p.dark_gray})
  set(0, 'DiffDelete', { bg = p.red })
  set(0, 'DiffText', { bg = p.yellow, fg = p.bg })

  -- Non-text
  set(0, 'NonText', { fg = p.gray })
  set(0, 'Whitespace', { fg = p.gray })

  -- Match pairs
  set(0, 'MatchParen', { fg = p.gray, bg = p.yellow })

  -- Window separator
  set(0, 'WinSeparator', { fg = p.gray })

  -- Re-apply highlights after UI loads
  vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
      -- Re-set specific groups that get overridden
      vim.api.nvim_set_hl(0, 'Function', { fg = p.magenta })
      vim.api.nvim_set_hl(0, 'Method', { fg = p.magenta })
      -- Add any other groups that might be overridden
    end,
  })


-- =====================
-- TREE-SITTER
-- =====================

-- Keywords
set(0, '@keyword', { fg = p.magenta, italic = true })

-- Functions
set(0, '@function', { fg = p.magenta })
set(0, '@function.call', { fg = p.magenta })

-- Methods
set(0, '@method', { fg = p.magenta })
set(0, '@method.call', { fg = p.magenta })

-- Variables
set(0, '@variable', { fg = p.red })
set(0, '@variable.builtin', { fg = p.fg }) -- vim, pairs, ipairs, etc.

-- Namespaces / modules
set(0, '@namespace', { fg = p.fg })

-- Properties / fields
set(0, '@field', { fg = p.fg })
set(0, '@property', { fg = p.fg })

end

M.setup()
