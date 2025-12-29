local set = vim.api.nvim_set_hl

local Shibuya_day = {}

Shibuya_day.colors = {
  -- Core
  fg = "#3760bf",
  fg_dark = "#6172b0",

  -- Soft backgrounds (derived / desaturated)
  bg = "#eef0f7",
  bg_alt = "#e4e7f2",
  bg_float = "#dde1ef",
  bg_highlight = "#d6dbea",
  bg_visual = "#cfd6ea",

  -- UI neutrals
  gray = "#7a83b5",
  gray_dark = "#5c6399",

  -- Accents
  blue = "#2e7de9",
  blue0 = "#7890dd",
		green = "#9ece6a",
		green_bright = "#9fe044",
  yellow = "#8c6c3e",
  yellow_bright = "#a27629",
  red = "#f52a65",
  red_bright = "#ff899d",
  magenta = "#9854f1",
  magenta_bright = "#c7a9ff",
  cyan = "#7dcfff",
  cyan_bright = "#a4daff",

  none = "NONE",
}

function Shibuya_day.setup()
  local p = Shibuya_day.colors

  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "shibuya_day"

  -- =====================
  -- UI
  -- =====================

  set(0, "Normal", { fg = p.fg, bg = p.bg })
  set(0, "NormalFloat", { fg = p.fg, bg = p.bg_float })
  set(0, "FloatBorder", { fg = p.gray, bg = p.bg_float })

  set(0, "CursorLine", { bg = p.bg_highlight })
  set(0, "Visual", { bg = p.bg_visual })

  set(0, "LineNr", { fg = p.gray })
  set(0, "CursorLineNr", { fg = p.blue, bold = true })

  set(0, "StatusLine", { fg = p.fg, bg = p.bg_alt })
  set(0, "StatusLineNC", { fg = p.gray, bg = p.bg_alt })

  set(0, "TabLine", { fg = p.gray, bg = p.bg_alt })
  set(0, "TabLineSel", { fg = p.fg, bg = p.bg })
  set(0, "TabLineFill", { bg = p.bg_alt })

  set(0, "Search", { fg = p.bg, bg = p.yellow })
  set(0, "IncSearch", { fg = p.bg, bg = p.blue })

--=========================
--     SYNTAX (legacy)     
--=========================

  set(0, "Comment", { fg = p.gray, bg = p.bg_alt, italic = true })

  set(0, "String", { fg = p.green, bg = p.bg_alt })
  set(0, "Number", { fg = p.fg })
  set(0, "Boolean", { fg = p.fg, bold = true })

  set(0, "Function", { fg = p.magenta })
  set(0, "Identifier", { fg = p.fg })
  set(0, "Keyword", { fg = p.red })

  set(0, "Type", { fg = p.red })
  set(0, "Operator", { fg = p.fg })

  set(0, "Todo", { fg = p.bg, bg = p.yellow, bold = true })

  -- =====================
  -- TREE-SITTER
  -- =====================

  set(0, "@keyword", { fg = p.red })
  set(0, "@function", { fg = p.magenta })
  set(0, "@function.call", { fg = p.magenta })
  set(0, "@method", { fg = p.magenta })
  set(0, "@method.call", { fg = p.magenta })

  set(0, "@variable", { fg = p.fg, bg = p.bg_float })
  set(0, "@variable.builtin", { fg = p.blue })

  set(0, "@namespace", { fg = p.red, bg = p.bg_float })
  set(0, "@field", { fg = p.gray })
  set(0, "@property", { fg = p.gray })

  -- =====================
  -- DIAGNOSTICS
  -- =====================

  set(0, "DiagnosticError", { fg = p.red })
  set(0, "DiagnosticWarn", { fg = p.yellow })
  set(0, "DiagnosticInfo", { fg = p.blue })
  set(0, "DiagnosticHint", { fg = p.gray })

  set(0, "DiagnosticUnderlineError", { undercurl = true, sp = p.red })
  set(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = p.yellow })
  set(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = p.blue })
end

Shibuya_day.setup()

