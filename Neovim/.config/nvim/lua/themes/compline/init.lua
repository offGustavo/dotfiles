local M = {}

M.palettes = {
  light = {
    bg = '#f0efeb',
    bg_alt = '#e0dcd4',

    base0 = '#f5f4f2',
    base1 = '#efeeed',
    base2 = '#e5e3e0',
    base3 = '#d8d6d3',
    base4 = '#b8b5b0',
    base5 = '#9a9791',
    base6 = '#7d7a75',
    base7 = '#5f5c58',
    base8 = '#2d2a27',

    fg = '#1a1d21',
    fg_alt = '#4A4D51',

    red = '#8B6666',
    orange = '#7A6D5A',
    green = '#5A6B5A',
    yellow = '#8B7E52',
    blue = '#5A6B7A',
    cyan = '#64757d',
    teal = '#4D6B6B',
    dark_cyan = '#546470',

    -- Additional colors from second theme for consistency
    cursor = '#2d2a27',
    cursor_text_color = '#f0efeb',
    selection_foreground = '#2d2a27',
    selection_background = '#b8b5b0',
  },

  dark = {
    background = '#1a1d21',
    foreground = '#e0dcd4',
    cursor = '#DBCDB3',
    cursor_text_color = '#1a1d21',
    selection_foreground = '#e0dcd4',
    selection_background = '#3d424a',

    -- Map the color0-15 system to our naming convention
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

    -- Map to consistent naming for API
    bg = '#1a1d21',
    bg_alt = '#2d2a27',
    fg = '#e0dcd4',
    fg_alt = '#b0bcc8',
    red = '#CDACAC',
    green = '#b8c4b8',
    yellow = '#DBCDB3',
    blue = '#b4bcc4',
    cyan = '#b0bcc8',
  }
}

-- Default to dark mode
M.current_mode = 'dark'

function M.set_mode(mode)
  if M.palettes[mode] then
    M.current_mode = mode
    M.setup()
  else
    print('Invalid mode. Use "light" or "dark".')
  end
end

function M.setup()
  local p = M.palettes[M.current_mode]
  local set = vim.api.nvim_set_hl

  if M.current_mode == 'light' then
    -- Light mode UI
    set(0, 'Normal', { fg = p.fg, bg = p.bg_alt })
    set(0, 'CursorLine', { bg = p.base2 })
    set(0, 'LineNr', { fg = p.base7 })
    set(0, 'CursorLineNr', { fg = p.base8, bold = true })
    set(0, 'Visual', { bg = p.base7, fg = p.bg })
    set(0, 'Cursor', { fg = p.cursor_text_color, bg = p.cursor })

    -- Light mode Syntax
    set(0, 'Comment', { fg = p.base7, italic = true })
    set(0, 'String', { fg = p.fg })
    set(0, 'Function', { fg = p.fg })
    set(0, 'Identifier', { fg = p.blue })
    set(0, 'Keyword', { fg = p.blue, bold = true })
    set(0, 'Operator', { fg = p.green, bold = true })
    set(0, 'Type', { fg = p.blue, bold = true })

    -- Light mode Diagnostics
    set(0, 'DiagnosticError', { fg = p.red })
    set(0, 'DiagnosticWarn', { fg = p.yellow })
    set(0, 'DiagnosticInfo', { fg = p.green })
    set(0, 'DiagnosticHint', { fg = p.base7 })

  else
    -- Dark mode UI
    set(0, 'Normal', { fg = p.fg, bg = p.bg })
    set(0, 'CursorLine', { bg = p.color0 })
    set(0, 'LineNr', { fg = p.color8 })
    set(0, 'Visual', { 
      fg = p.selection_foreground, 
      bg = p.selection_background 
    })
    set(0, 'CursorLineNr', { fg = p.color3, bold = true })
    set(0, 'Cursor', { fg = p.cursor_text_color, bg = p.cursor })

    -- Dark mode Syntax
    set(0, 'Comment', { fg = p.color8, italic = true })
    set(0, 'String', { fg = p.color2 })
    set(0, 'Function', { fg = p.color4 })
    set(0, 'Identifier', { fg = p.color1 })
    set(0, 'Keyword', { fg = p.color1 })
    set(0, 'Operator', { fg = p.color2 })
    set(0, 'Type', { fg = p.color4, bold = true })

    -- Dark mode Diagnostics
    set(0, 'DiagnosticError', { fg = p.color1 })
    set(0, 'DiagnosticWarn', { fg = p.color3 })
    set(0, 'DiagnosticInfo', { fg = p.color2 })
    set(0, 'DiagnosticHint', { fg = p.color8 })
  end

  -- Common settings for both modes
  set(0, 'MatchParen', { bold = true, underline = true })
  set(0, 'Search', { reverse = true })
  set(0, 'IncSearch', { reverse = true, bold = true })
end

-- Helper function to toggle between modes
function M.toggle_mode()
  if M.current_mode == 'light' then
    M.set_mode('dark')
  else
    M.set_mode('light')
  end
end

-- Auto-detect based on background setting
function M.auto_detect()
  local bg = vim.o.background
  if bg == 'light' then
    M.set_mode('light')
  else
    M.set_mode('dark')
  end
end

return M
