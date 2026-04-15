--- REFs
--- [How to change color schemes across neovim, tmux, and other tools/TUIs? : r/neovim](https://www.reddit.com/r/neovim/comments/18jxa8d/how_to_change_color_schemes_across_neovim_tmux/)
--- [cultab/themr: A program to set a global theme by replacing strings in config files](https://github.com/cultab/themr?tab=BSD-2-Clause-1-ov-file)
--- [How to change color schemes across neovim, tmux, and other tools/TUIs? : r/neovim](https://www.reddit.com/r/neovim/comments/18jxa8d/how_to_change_color_schemes_across_neovim_tmux/)
--- [shaun-mathew/Chameleon.nvim: A plugin to sync Kitty's background colour with your Neovim colorscheme](https://github.com/shaun-mathew/Chameleon.nvim)

-----------
-- Tmux ---
-----------
if os.getenv("TMUX") then

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

function UpdateTheme()
    -- vim.notify("Update Tmux Theme")
  local colors = get_theme_colors()

  local lines = {
    string.format('set -g message-style "fg=%s,bg=%s"', colors.TMUX_HL, colors.TMUX_ABG),
    string.format('set -g message-command-style "fg=%s,bg=%s"', colors.TMUX_HL, colors.TMUX_ABG),
    string.format('set -g pane-border-style "fg=%s"', colors.TMUX_ABG),
    string.format('set -g pane-active-border-style "fg=%s"', colors.TMUX_HL),
    "set -g status-position top",
    "set -g status on",
    "set -g status-justify absolute-centre",
    string.format('set -g status-style "fg=%s,bg=%s"', colors.TMUX_HL, colors.TMUX_BG),
    "set -g status-left-length 100",
    "set -g status-right-length 100",
    "set -g status-left-style NONE",
    "set -g status-right-style NONE",
    string.format(
      'set -g status-left "#[fg=%s,bg=%s,bold] #{?client_prefix, ,󰯉 }#[fg=%s,bg=%s,nobold,nounderscore,noitalics] "',
      colors.TMUX_BG,
      colors.TMUX_HL,
      colors.TMUX_HL,
      colors.TMUX_BG
    ),
    string.format(
      'set -g status-right "#[fg=%s,bg=%s,nobold,nounderscore,noitalics]#[fg=%s,bg=%s,bold]  #[fg=%s,bg=%s,bold] #S #[fg=%s,bg=%s] ▊"',
      colors.TMUX_BG,
      colors.TMUX_BG,
      colors.TMUX_FG,
      colors.TMUX_BG,
      colors.TMUX_BG,
      colors.TMUX_HL,
      colors.TMUX_HL,
      colors.TMUX_BG,
      colors.TMUX_ABG,
      colors.TMUX_HL
    ),
    string.format('setw -g window-status-activity-style "underscore,fg=%s,bg=%s"', colors.TMUX_FG, colors.TMUX_BG),
    'setw -g window-status-separator ""',
    string.format('setw -g window-status-style "NONE,fg=%s,bg=%s"', colors.TMUX_FG, colors.TMUX_BG),
    string.format(
      'setw -g window-status-format "#[fg=%s,bg=%s,nobold,nounderscore,noitalics]#[default] #I #W "',
      colors.TMUX_BG,
      colors.TMUX_BG,
      colors.TMUX_BG,
      colors.TMUX_BG
    ),
    string.format(
      'setw -g window-status-current-format "#[fg=%s,bg=%s,nobold,nounderscore,noitalics]#[fg=%s,bg=%s,bold] #I #W "',
      colors.TMUX_HL,
      colors.TMUX_BG,
      colors.TMUX_BG,
      colors.TMUX_HL,
      colors.TMUX_BG,
      colors.TMUX_BG
    ),
    string.format('set -g popup-border-style "fg=%s"', colors.TMUX_HL),
    string.format('set -g popup-style "bg=%s,fg=default"', colors.TMUX_BG),
  }

local tmux_theme_path = "/tmp/tmux/theme.conf"

-- garante que o diretório existe
vim.fn.mkdir(vim.fn.fnamemodify(tmux_theme_path, ":h"), "p")

-- abre/cria o arquivo
local file = io.open(tmux_theme_path, "w")

if file then
  for _, line in ipairs(lines) do
    file:write(line .. "\n")
  end
  file:close()
else
  vim.notify("Failed to write tmux theme", vim.log.levels.ERROR)
end

  -- Recarrega o tmux.conf
  os.execute("tmux source-file " .. tmux_theme_path)
end

  -- Cria o autocommand group para evitar duplicações
  local tmux_theme_group = vim.api.nvim_create_augroup("TmuxTheme", { clear = true })

  -- Autocommand para detectar mudanças de tema e background
  vim.api.nvim_create_autocmd({"ColorScheme"}, {
    group = tmux_theme_group,
    pattern = {"background", "*"},
    callback = function(args)
      -- Pequeno delay para garantir que as cores já foram carregadas
      vim.defer_fn(function()
        UpdateTheme()
      end, 50)
    end,
    desc = "Atualiza tema do Tmux quando cores mudam"
  })

  -- Também executa uma vez ao carregar o Neovim dentro do tmux
  vim.defer_fn(function()
    UpdateTheme()
  end, 100)

  -- vim.keymap.set("n", "<leader>oT", function() UpdateTheme() end, { desc = "Update Tmux Theme" })

  -- vim.keymap.set(
  --   "n",
  --   "<leader>gg",
  --   ":! ~/scripts/tmux-open.sh lazygit<Cr>",
  --   { silent = true, desc = "Open Lazygit in Tmux" }
  -- )

end
