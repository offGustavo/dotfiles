-----------
-- WezTerm --
-----------
local wezterm = {}

-- Path to your WezTerm theme file
local WEZTERM_THEME_PATH = vim.fn.expand("~/.config/wezterm/theme.lua")

local uv = vim.loop
local debounce_timer
local initialized = false

-- Helper functions from your Kitty script
local function to_hex(color)
  if not color then
    return nil
  end
  if type(color) == "string" then
    return color:match("^#%x+$") and color or nil
  elseif type(color) == "number" then
    return string.format("#%06x", color)
  elseif type(color) == "table" and color[1] then
    return string.format("#%02x%02x%02x", color[1], color[2], color[3])
  end
  return nil
end

local function get_hl(name, attr)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
  if not ok or not hl then
    return nil
  end
  return hl[attr]
end

local function get_terminal_colors()
  local term_colors = {}
  for i = 0, 255 do
    local color = vim.g["terminal_color_" .. i]
    if color then
      term_colors[i] = to_hex(color)
    end
  end
  return term_colors
end

-- Map Neovim highlight groups to WezTerm theme properties
local function get_theme_colors()
  local colors = {}
  local term_colors = get_terminal_colors()

  -- Basic colors
  colors.foreground = to_hex(get_hl("Normal", "fg")) or "#c0caf5"
  colors.background = to_hex(get_hl("Normal", "bg")) or "#1a1b26"

  -- Cursor colors
  colors.cursor_bg = to_hex(get_hl("Cursor", "bg")) or to_hex(get_hl("Cursor", "bg")) or "#7aa2f7"
  colors.cursor_fg = to_hex(get_hl("Cursor", "fg")) or to_hex(get_hl("Normal", "bg")) or "#1a1b26"
  colors.cursor_border = colors.cursor_bg or "#7aa2f7"

  -- Selection colors
  colors.selection_bg = to_hex(get_hl("Visual", "bg")) or to_hex(get_hl("CursorLine", "bg")) or "#283457"
  colors.selection_fg = to_hex(get_hl("Visual", "fg")) or colors.foreground or "#c0caf5"

  -- Split line color
  colors.split = to_hex(get_hl("VertSplit", "fg")) or to_hex(get_hl("WinSeparator", "fg")) or "#292e42"

  -- Scrollbar thumb
  colors.scrollbar_thumb = to_hex(get_hl("Pmenu", "bg")) or "#414868"

  -- Compose cursor
  colors.compose_cursor = to_hex(get_hl("WarningMsg", "fg")) or "#e0af68"

  -- ANSI colors (0-7) - dark colors
  colors.ansi = {
    term_colors[0] or to_hex(get_hl("TerminalColorBlack", "fg")) or "#15161e",
    term_colors[1] or to_hex(get_hl("TerminalColorRed", "fg")) or "#f7768e",
    term_colors[2] or to_hex(get_hl("TerminalColorGreen", "fg")) or "#9ece6a",
    term_colors[3] or to_hex(get_hl("TerminalColorYellow", "fg")) or "#e0af68",
    term_colors[4] or to_hex(get_hl("TerminalColorBlue", "fg")) or "#7aa2f7",
    term_colors[5] or to_hex(get_hl("TerminalColorMagenta", "fg")) or "#bb9af7",
    term_colors[6] or to_hex(get_hl("TerminalColorCyan", "fg")) or "#7dcfff",
    term_colors[7] or to_hex(get_hl("TerminalColorWhite", "fg")) or "#a9b1d6",
  }

  -- Bright colors (8-15)
  colors.brights = {
    term_colors[8] or to_hex(get_hl("TerminalColorBrightBlack", "fg")) or "#414868",
    term_colors[9] or to_hex(get_hl("TerminalColorBrightRed", "fg")) or "#f7768e",
    term_colors[10] or to_hex(get_hl("TerminalColorBrightGreen", "fg")) or "#9ece6a",
    term_colors[11] or to_hex(get_hl("TerminalColorBrightYellow", "fg")) or "#e0af68",
    term_colors[12] or to_hex(get_hl("TerminalColorBrightBlue", "fg")) or "#7aa2f7",
    term_colors[13] or to_hex(get_hl("TerminalColorBrightMagenta", "fg")) or "#bb9af7",
    term_colors[14] or to_hex(get_hl("TerminalColorBrightCyan", "fg")) or "#7dcfff",
    term_colors[15] or to_hex(get_hl("TerminalColorBrightWhite", "fg")) or "#c0caf5",
  }

  -- Tab bar colors
  colors.tab_bar = {
    background = to_hex(get_hl("Normal", "bg")) or "#292e42",

    active_tab = {
      bg_color = to_hex(get_hl("TabLineSel", "bg")) or "#7aa2f7",
      fg_color = to_hex(get_hl("TabLineSel", "fg")) or "#16161e",
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },

    inactive_tab = {
      bg_color = to_hex(get_hl("Normal", "bg")) or "#292e42",
      fg_color = to_hex(get_hl("Normal", "fg")) or "#545c7e",
    },

    inactive_tab_hover = {
      bg_color = to_hex(get_hl("TabLineFill", "bg")) or "#363b54",
      fg_color = to_hex(get_hl("Normal", "fg")) or "#737aa2",
      underline = "Single",
    },

    new_tab = {
      bg_color = to_hex(get_hl("Normal", "bg")) or "#292e42",
      fg_color = to_hex(get_hl("Normal", "fg")) or "#545c7e",
    },

    new_tab_hover = {
      bg_color = to_hex(get_hl("TabLineFill", "bg")) or "#363b54",
      fg_color = to_hex(get_hl("Normal", "fg")) or "#737aa2",
      italic = false,
    },
  }

  -- -- Fixed colors (not from Neovim)
  -- colors.copy_mode_active_highlight_bg = { Color = "#34f1f3" }
  -- colors.copy_mode_active_highlight_fg = { AnsiColor = "#34f1f3" }
  -- colors.copy_mode_inactive_highlight_bg = { Color = "#34f1f3" }
  -- colors.copy_mode_inactive_highlight_fg = { AnsiColor = "#34f1f3" }
  -- colors.quick_select_label_bg = { Color = "#34f1f3" }
  -- colors.quick_select_label_fg = { Color = "#ffffff" }
  -- colors.quick_select_match_bg = { AnsiColor = "#34f1f3" }
  -- colors.quick_select_match_fg = { Color = "#ffffff" }

  -- -- Indexed colors (example)
  -- colors.indexed = { [136] = '#af8700' }

  return colors
end

-- Convert theme table to Lua code string
local function theme_to_string(theme)
  local lines = {}

  local function add_line(str, indent)
    indent = indent or 0
    table.insert(lines, string.rep("  ", indent) .. str)
  end

  local function serialize_value(value, indent)
    indent = indent or 0

    if type(value) == "table" then
      if value.Color then
        return string.format("{ Color = '%s' }", value.Color)
      elseif value.AnsiColor then
        return string.format("{ AnsiColor = '%s' }", value.AnsiColor)
      elseif #value > 0 then -- It's an array
        local items = {}
        for i, item in ipairs(value) do
          table.insert(items, string.format("'%s'", item))
        end
        return string.format("{ %s }", table.concat(items, ", "))
      else -- It's an object
        return serialize_table(value, indent)
      end
    elseif type(value) == "string" then
      if value:match("^#%x+$") then
        return string.format("'%s'", value)
      else
        return string.format("'%s'", value)
      end
    else
      return tostring(value)
    end
  end

  local function serialize_table(t, indent)
    indent = indent or 0
    local result = {}

    add_line("{", indent)

    for key, value in pairs(t) do
      local formatted_key
      if type(key) == "number" then
        formatted_key = string.format("[%s]", key)
      else
        formatted_key = key
      end

      if type(value) == "table" then
        if value.Color or value.AnsiColor then
          add_line(string.format("%s = %s,", formatted_key, serialize_value(value, indent + 1)), indent + 1)
        elseif #value > 0 then -- Array
          add_line(string.format("%s = %s,", formatted_key, serialize_value(value, indent + 1)), indent + 1)
        else -- Object
          add_line(string.format("%s = {", formatted_key), indent + 1)
          for k, v in pairs(value) do
            if type(v) == "table" then
              if v.Color or v.AnsiColor then
                add_line(string.format("%s = %s,", k, serialize_value(v, indent + 2)), indent + 2)
              else
                add_line(string.format("%s = {", k), indent + 2)
                for k2, v2 in pairs(v) do
                  add_line(string.format("%s = %s,", k2, serialize_value(v2, indent + 3)), indent + 3)
                end
                add_line("},", indent + 2)
              end
            else
              add_line(string.format("%s = %s,", k, serialize_value(v, indent + 2)), indent + 2)
            end
          end
          add_line("},", indent + 1)
        end
      else
        add_line(string.format("%s = %s,", formatted_key, serialize_value(value, indent + 1)), indent + 1)
      end
    end

    add_line("}", indent)

    return table.concat(lines, "\n")
  end

  return serialize_table(theme, 0)
end

-- Update WezTerm theme file
local function apply_wezterm_theme()
  local colors = get_theme_colors()
  if not colors or not next(colors) then
    vim.notify("[WezTerm] Failed to get theme colors", vim.log.levels.WARN)
    return
  end

  local theme_str = "return " .. theme_to_string(colors)

  -- Write to file
  local file = io.open(WEZTERM_THEME_PATH, "w")
  if file then
    file:write(theme_str)
    file:close()
    -- vim.notify("[WezTerm] Theme updated successfully!", vim.log.levels.INFO)
  else
    vim.notify("[WezTerm] Error: Could not open file for writing", vim.log.levels.ERROR)
  end
end

function wezterm.UpdateWezTermTheme()
  -- debounce (prevents rapid successive executions)
  if debounce_timer then
    debounce_timer:stop()
    debounce_timer:close()
  end
  debounce_timer = uv.new_timer()
  debounce_timer:start(100, 0, function()
    vim.schedule(apply_wezterm_theme)
  end)
end

-- Create autocommand group to avoid duplications
local wezterm_theme_group = vim.api.nvim_create_augroup("WezTermTheme", { clear = true })

-- Autocommand to detect theme changes
vim.api.nvim_create_autocmd({"ColorScheme"}, {
  group = wezterm_theme_group,
  pattern = "*",
  callback = function(args)
    -- Only execute if we've been initialized (ignore first execution)
    if initialized then
      vim.defer_fn(function()
        wezterm.UpdateWezTermTheme()
      end, 50)
    end
  end,
  desc = "Update WezTerm theme when colors change"
})

vim.api.nvim_create_autocmd('ColorScheme', {
  group = wezterm_theme_group,
  pattern = "background",
  callback = function(args)
    if initialized then
      vim.defer_fn(function()
        wezterm.UpdateWezTermTheme()
      end, 50)
    end
  end,
  desc = "Update WezTerm theme when background changes"
})

-- Also run once when loading Neovim
vim.defer_fn(function()
  wezterm.UpdateWezTermTheme()
  initialized = true -- Mark as initialized after first execution
end, 100)

vim.keymap.set("n", "<leader>otw", wezterm.UpdateWezTermTheme, { desc = "Update WezTerm Theme" })

return wezterm
