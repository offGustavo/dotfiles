local M = {}
local fn = vim.fn
local api = vim.api

-- Shared state
M.original_kitty_colors = {}

-- Utility functions
local function get_hl_color(name, attr)
  local ok, hl = pcall(api.nvim_get_hl, 0, { name = name })
  if not ok or not hl then
    return nil
  end
  return hl[attr]
end

local function to_hex(color)
  if not color then
    return nil
  end

  if type(color) == "string" then
    return color:match("^#%x+$") and color or nil
  end

  if type(color) == "number" then
    return string.format("#%06x", color)
  end

  if type(color) == "table" and color[1] and color[2] and color[3] then
    return string.format("#%02x%02x%02x", color[1], color[2], color[3])
  end

  return nil
end

local function is_dark_background()
  local bg_color = to_hex(get_hl_color("Normal", "bg")) or "#000000"
  local r, g, b = bg_color:match("#(%x%x)(%x%x)(%x%x)")
  r, g, b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
  local luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255
  return luminance < 0.5
end

local function get_contrast_cursor_color()
  return is_dark_background() and "#ffffff" or "#000000"
end

-- Kitty functions
local function get_kitty_colors()
  if vim.tbl_isempty(M.original_kitty_colors) then
    fn.jobstart({ "kitty", "@", "get-colors" }, {
      on_stdout = function(_, data, _)
        for _, line in ipairs(data) do
          if line ~= "" then
            local key, value = line:match("^(%S+)%s+(.+)$")
            if key and value then
              M.original_kitty_colors[key] = value
            end
          end
        end
      end,
      on_stderr = function(_, d, _)
        if #d > 1 then
          api.nvim_err_writeln(
            "Chameleon.nvim: Error getting kitty colors. Make sure kitty remote control is turned on."
          )
        end
      end,
    })
  end
end

local function change_kitty_colors(colors, sync)
  local args = {}
  for k, v in pairs(colors) do
    if v then
      table.insert(args, k .. '="' .. v .. '"')
    end
  end
  local command = "kitty @ set-colors " .. table.concat(args, " ")

  if not sync then
    fn.jobstart(command, {
      on_stderr = function(_, d, _)
        if #d > 1 then
          api.nvim_err_writeln(
            "Chameleon.nvim: Error changing kitty colors. Make sure kitty remote control is turned on."
          )
        end
      end,
    })
  else
    fn.system(command)
  end
end

-- Improved Tmux theme functions with better fallbacks
local function get_tmux_theme_colors()
  -- Try to get lualine colors, fallback to other highlight groups
  local abg = to_hex(get_hl_color("lualine_b_normal", "bg")) or to_hex(get_hl_color("StatusLine", "bg")) or "#3b4261"

  local hl = to_hex(get_hl_color("lualine_a_normal", "bg"))
    or to_hex(get_hl_color("Title", "fg"))
    or to_hex(get_hl_color("Function", "fg"))
    or "#7aa2f7"

  return {
    TMUX_BG = to_hex(get_hl_color("Normal", "bg")) or "#1a1b26",
    TMUX_ABG = abg,
    TMUX_HL = hl,
    TMUX_FG = to_hex(get_hl_color("Normal", "fg")) or "#c0caf5",
    TMUX_BORDER = to_hex(get_hl_color("WinSeparator", "fg")) or abg,
    TMUX_ACCENT = to_hex(get_hl_color("Special", "fg")) or hl,
  }
end

local function write_tmux_theme()
  local colors = get_tmux_theme_colors()

  -- More robust tmux theme with fallback colors
  local lines = {
    string.format('set -g message-style "fg=%s,bg=%s"', colors.TMUX_HL, colors.TMUX_ABG),
    string.format('set -g message-command-style "fg=%s,bg=%s"', colors.TMUX_HL, colors.TMUX_ABG),
    string.format('set -g pane-border-style "fg=%s"', colors.TMUX_BORDER),
    string.format('set -g pane-active-border-style "fg=%s"', colors.TMUX_HL),
    "set -g status-position top",
    "set -g status on",
    "set -g status-justify left",
    string.format('set -g status-style "fg=%s,bg=%s"', colors.TMUX_ACCENT, colors.TMUX_BG),
    "set -g status-left-length 100",
    "set -g status-right-length 100",
    "set -g status-left-style NONE",
    "set -g status-right-style NONE",
    string.format(
      'set -g status-left "#[fg=#15161e,bg=%s,bold] #S #[fg=%s,bg=%s,nobold,nounderscore,noitalics] "',
      colors.TMUX_HL,
      colors.TMUX_HL,
      colors.TMUX_BG
    ),
    string.format(
      'set -g status-right "#[fg=%s,bg=%s,nobold,nounderscore,noitalics]#[fg=%s,bg=%s,bold]  %%d/%%m/%%y  %%H:%%M #[fg=%s,bg=%s,nobold,nounderscore,noitalics]#[fg=%s,bg=%s] #{?client_prefix, ,󰯉 } #[fg=#15161e,bg=%s,bold] #h "',
      colors.TMUX_BG,
      colors.TMUX_BG,
      colors.TMUX_FG,
      colors.TMUX_BG,
      colors.TMUX_ABG,
      colors.TMUX_BG,
      colors.TMUX_HL,
      colors.TMUX_ABG,
      colors.TMUX_HL
    ),
    string.format('setw -g window-status-activity-style "underscore,fg=%s,bg=%s"', colors.TMUX_FG, colors.TMUX_BG),
    'setw -g window-status-separator ""',
    string.format('setw -g window-status-style "NONE,fg=%s,bg=%s"', colors.TMUX_FG, colors.TMUX_BG),
    string.format(
      'setw -g window-status-format "#[fg=%s,bg=%s,nobold,nounderscore,noitalics]#[default] #I #W #[fg=%s,bg=%s,nobold,nounderscore,noitalics]"',
      colors.TMUX_BG,
      colors.TMUX_BG,
      colors.TMUX_BG,
      colors.TMUX_BG
    ),
    string.format(
      'setw -g window-status-current-format "#[fg=%s,bg=%s,nobold,nounderscore,noitalics]#[fg=%s,bg=%s,bold] #I #W #[fg=%s,bg=%s,nobold,nounderscore,noitalics]"',
      colors.TMUX_ABG,
      colors.TMUX_BG,
      colors.TMUX_HL,
      colors.TMUX_ABG,
      colors.TMUX_ABG,
      colors.TMUX_BG
    ),
    string.format('set -g popup-border-style "fg=%s"', colors.TMUX_HL),
    string.format('set -g popup-style "bg=%s,fg=default"', colors.TMUX_BG),
  }

  local path = os.getenv("HOME") .. "/.config/tmux/config/theme.conf"
  local file = io.open(path, "w")
  if file then
    for _, line in ipairs(lines) do
      file:write(line .. "\n")
    end
    file:close()
    os.execute("tmux source-file ~/.config/tmux/config/theme.conf")
  else
    vim.notify("Failed to write tmux theme", vim.log.levels.ERROR)
  end
end

-- Combined update function
local function update_all_colors()
  -- Determine cursor colors based on background
  local cursor_fg = get_contrast_cursor_color()
  local cursor_bg = is_dark_background() and "#000000" or "#ffffff"

  -- Update Kitty colors
  local kitty_colors = {
    background = to_hex(get_hl_color("Normal", "bg")),
    foreground = to_hex(get_hl_color("Normal", "fg")),
    cursor = cursor_bg,
    cursor_text_color = cursor_fg,
    selection_background = to_hex(get_hl_color("Visual", "bg")),
    selection_foreground = to_hex(get_hl_color("Visual", "fg")),
    active_tab_background = to_hex(get_hl_color("TabLineSel", "bg")),
    active_tab_foreground = to_hex(get_hl_color("TabLineSel", "fg")),
    inactive_tab_background = to_hex(get_hl_color("TabLine", "bg")),
    inactive_tab_foreground = to_hex(get_hl_color("TabLine", "fg")),
    active_border_color = to_hex(get_hl_color("FloatBorder", "fg")),
    inactive_border_color = to_hex(get_hl_color("WinSeparator", "fg")),
  }

  -- Add basic colors
  local color_mappings = {
    [0] = "LineNr",
    [1] = "Error",
    [2] = "String",
    [3] = "WarningMsg",
    [4] = "Function",
    [5] = "Special",
    [6] = "Type",
    [7] = "Comment",
    [8] = "NonText",
    [9] = "ErrorMsg",
    [10] = "String",
    [11] = "WarningMsg",
    [12] = "Function",
    [13] = "Special",
    [14] = "Type",
    [15] = "Comment",
    [16] = "Todo",
    [17] = "Error",
  }

  for i = 0, 17 do
    kitty_colors["color" .. i] = to_hex(get_hl_color(color_mappings[i], "fg"))
      or to_hex(get_hl_color(color_mappings[i], "bg"))
  end

  change_kitty_colors(kitty_colors)

  -- Update Tmux colors
  write_tmux_theme()
end

-- Setup function
local function setup_autocmds()
  local autocmd = api.nvim_create_autocmd
  local autogroup = api.nvim_create_augroup
  local color_change = autogroup("ColorChange", { clear = true })

  autocmd({ "ColorScheme", "VimResume" }, {
    pattern = "*",
    callback = update_all_colors,
    group = color_change,
  })

  autocmd("User", {
    pattern = "NvChadThemeReload",
    callback = update_all_colors,
    group = color_change,
  })

  autocmd({ "VimLeavePre", "VimSuspend" }, {
    callback = function()
      if not vim.tbl_isempty(M.original_kitty_colors) then
        change_kitty_colors(M.original_kitty_colors, true)
      end
    end,
    group = autogroup("ColorRestore", { clear = true }),
  })
end

M.setup = function()
  get_kitty_colors()
  setup_autocmds()
  -- Initial update with delay to ensure colorscheme is loaded
  vim.defer_fn(function()
    update_all_colors()
  end, 100)
end

return M
