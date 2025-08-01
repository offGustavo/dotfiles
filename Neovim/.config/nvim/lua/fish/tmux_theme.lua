local M = {}

local function get_theme_colors()
  -- Obtém os highlights do tema atual com fallback seguro
  local function get_hl(name, attr)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
    if not ok or not hl then
      return nil
    end
    return hl[attr]
  end

  -- Função auxiliar para converter cor para hexadecimal
  local function to_hex(color)
    if not color then
      return nil
    end

    -- Se já for string hexadecimal, retorna diretamente
    if type(color) == "string" then
      return color:match("^#%x+$") and color or nil
    end

    -- Se for número, converte para hexadecimal
    if type(color) == "number" then
      return string.format("#%06x", color)
    end

    -- Se for tabela RGB
    if type(color) == "table" and color[1] and color[2] and color[3] then
      return string.format("#%02x%02x%02x", color[1], color[2], color[3])
    end

    return nil
  end

  -- Extrai cores com fallback para valores padrão
  local bg = to_hex(get_hl("NORMAL", "bg")) or "#1a1b26"
  local abg = to_hex(get_hl("lualine_b_normal", "bg")) or "#3b4261"
  local hl = to_hex(get_hl("lualine_a_normal", "bg")) or "#7aa2f7"
  local fg = to_hex(get_hl("NORMAL", "fg")) or "#c0caf5"

  return {
    TMUX_BG = bg,
    TMUX_ABG = abg,
    TMUX_HL = hl,
    TMUX_FG = fg,
  }
end

function M.UpdateTheme()
  local colors = get_theme_colors()

  local lines = {
    string.format('set -g message-style "fg=%s,bg=%s"', colors.TMUX_HL, colors.TMUX_ABG),
    string.format('set -g message-command-style "fg=%s,bg=%s"', colors.TMUX_HL, colors.TMUX_ABG),
    string.format('set -g pane-border-style "fg=%s"', colors.TMUX_ABG),
    string.format('set -g pane-active-border-style "fg=%s"', colors.TMUX_HL),
    "set -g status-position top",
    "set -g status on",
    "set -g status-justify left",
    string.format('set -g status-style "fg=%s,bg=%s"', colors.TMUX_HL, colors.TMUX_BG),
    "set -g status-left-length 100",
    "set -g status-right-length 100",
    "set -g status-left-style NONE",
    "set -g status-right-style NONE",
    string.format(
      'set -g status-left "#[fg=%s,bg=%s,bold] #S #[fg=%s,bg=%s,nobold,nounderscore,noitalics] "',
      colors.TMUX_BG,
      colors.TMUX_HL,
      colors.TMUX_HL,
      colors.TMUX_BG
    ),
    string.format(
      'set -g status-right "#[fg=%s,bg=%s,nobold,nounderscore,noitalics]#[fg=%s,bg=%s,bold]  %%d/%%m/%%y  %%H:%%M #[fg=%s,bg=%s,nobold,nounderscore,noitalics]#[fg=%s,bg=%s] #{?client_prefix, ,󰯉 } #[fg=%s,bg=%s,bold] #h "',
      colors.TMUX_BG,
      colors.TMUX_BG,
      colors.TMUX_FG,
      colors.TMUX_BG,
      colors.TMUX_ABG,
      colors.TMUX_BG,
      colors.TMUX_HL,
      colors.TMUX_ABG,
      colors.TMUX_BG,
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
  else
    vim.notify("Failed to write tmux theme", vim.log.levels.ERROR)
  end

  -- Recarrega o tmux.conf
  os.execute("tmux source-file ~/.config/tmux/config/theme.conf")
end

_G.TmuxTheme = M

return M
