-----------
-- Kitty --
-----------
if os.getenv("KITTY_WINDOW_ID") then
  local uv = vim.loop
  local debounce_timer
  local initialized = false

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

  local function get_theme_colors()
    local colors = {}

    -- Basic colors
    colors.background = to_hex(get_hl("Normal", "bg")) or "#1a1b26"
    colors.foreground = to_hex(get_hl("Normal", "fg")) or "#c0caf5"

    -- Selection colors
    colors.selection_background = to_hex(get_hl("Visual", "bg")) or to_hex(get_hl("CursorLine", "bg")) or "#283457"
    colors.selection_foreground = to_hex(get_hl("Visual", "fg")) or colors.foreground or "#c0caf5"

    -- Cursor colors
    colors.cursor = to_hex(get_hl("Cursor", "bg"))
      or to_hex(get_hl("Cursor", "bg"))
      or to_hex(get_hl("CursorLineNr", "fg"))
      or "#7aa2f7"
    colors.cursor_text_color = to_hex(get_hl("Cursor", "fg")) or "#1a1b26"

    -- URL color (using Underlined group)
    colors.url_color = to_hex(get_hl("Underlined", "fg")) or to_hex(get_hl("Special", "fg")) or "#73daca"

    -- Tab colors
    colors.active_tab_background = to_hex(get_hl("lualine_a_normal", "bg"))
      or to_hex(get_hl("CursorLineNr", "fg"))
      or "#7aa2f7"
    colors.active_tab_foreground = to_hex(get_hl("TabLineSel", "fg")) or colors.background or "#16161e"
    colors.inactive_tab_background = to_hex(get_hl("TabLine", "bg")) or "#292e42"
    colors.inactive_tab_foreground = to_hex(get_hl("TabLine", "fg")) or "#545c7e"

    -- Border colors
    colors.active_border_color = colors.active_tab_background or "#7aa2f7"
    colors.inactive_border_color = colors.inactive_tab_background or "#292e42"

    -- Terminal colors (0-15 for basic, 16-255 for extended)
    local term_colors = get_terminal_colors()

    -- Basic colors (0-7)
    colors.color0 = term_colors[0] or to_hex(get_hl("TerminalColorBlack", "fg")) or "#15161e"
    colors.color1 = term_colors[1] or to_hex(get_hl("TerminalColorRed", "fg")) or "#f7768e"
    colors.color2 = term_colors[2] or to_hex(get_hl("TerminalColorGreen", "fg")) or "#9ece6a"
    colors.color3 = term_colors[3] or to_hex(get_hl("TerminalColorYellow", "fg")) or "#e0af68"
    colors.color4 = term_colors[4] or to_hex(get_hl("TerminalColorBlue", "fg")) or "#7aa2f7"
    colors.color5 = term_colors[5] or to_hex(get_hl("TerminalColorMagenta", "fg")) or "#bb9af7"
    colors.color6 = term_colors[6] or to_hex(get_hl("TerminalColorCyan", "fg")) or "#7dcfff"
    colors.color7 = term_colors[7] or to_hex(get_hl("TerminalColorWhite", "fg")) or "#a9b1d6"

    -- Bright colors (8-15)
    colors.color8 = term_colors[8] or to_hex(get_hl("TerminalColorBrightBlack", "fg")) or "#414868"
    colors.color9 = term_colors[9] or to_hex(get_hl("TerminalColorBrightRed", "fg")) or "#f7768e"
    colors.color10 = term_colors[10] or to_hex(get_hl("TerminalColorBrightGreen", "fg")) or "#9ece6a"
    colors.color11 = term_colors[11] or to_hex(get_hl("TerminalColorBrightYellow", "fg")) or "#e0af68"
    colors.color12 = term_colors[12] or to_hex(get_hl("TerminalColorBrightBlue", "fg")) or "#7aa2f7"
    colors.color13 = term_colors[13] or to_hex(get_hl("TerminalColorBrightMagenta", "fg")) or "#bb9af7"
    colors.color14 = term_colors[14] or to_hex(get_hl("TerminalColorBrightCyan", "fg")) or "#7dcfff"
    colors.color15 = term_colors[15] or to_hex(get_hl("TerminalColorBrightWhite", "fg")) or "#c0caf5"

    -- Extended colors (16-255)
    for i = 16, 255 do
      if term_colors[i] then
        colors["color" .. i] = term_colors[i]
      end
    end

    -- Additional specific colors from the example
    colors.color16 = term_colors[16] or to_hex(get_hl("Number", "fg")) or to_hex(get_hl("Float", "fg")) or "#ff9e64"
    colors.color17 = term_colors[17] or to_hex(get_hl("Error", "fg")) or to_hex(get_hl("ErrorMsg", "fg")) or "#db4b4b"

    return colors
  end

  local function apply_kitty_theme()
    local colors = get_theme_colors()
    if not colors or not next(colors) then
      return
    end

    local socket = os.getenv("KITTY_LISTEN_ON")
    if not socket then
      return
    end

    local cmd = {
      "kitty",
      "@",
      "--to",
      socket,
      "set-colors",
      "--configured",
      "-a",
    }

    -- Add all colors to the command
    for name, value in pairs(colors) do
      if value then
        table.insert(cmd, name .. "=" .. value)
      end
    end

    vim.fn.jobstart(cmd, { detach = true })
  end

  function UpdateKittyTheme()
    -- vim.notify("Kitty Theme Update")
    -- debounce (não roda várias vezes seguidas rápido)
    if debounce_timer then
      debounce_timer:stop()
      debounce_timer:close()
    end
    debounce_timer = uv.new_timer()
    debounce_timer:start(100, 0, function()
      vim.schedule(apply_kitty_theme)
    end)
  end

  -- Cria o autocommand group para evitar duplicações
  local kitty_theme_group = vim.api.nvim_create_augroup("KittyTheme", { clear = true })

  -- Autocommand para detectar mudanças de tema e background
  vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    group = kitty_theme_group,
    pattern = "*",
    callback = function(args)
      -- Só executa se já tivermos sido inicializados (ignora a primeira execução)
      if initialized then
        vim.defer_fn(function()
          UpdateKittyTheme()
        end, 50)
      end
    end,
    desc = "Atualiza tema do Kitty quando cores mudam",
  })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = kitty_theme_group,
    pattern = "background",
    callback = function(args)
      if initialized then
        vim.defer_fn(function()
          UpdateKittyTheme()
        end, 50)
      end
    end,
    desc = "Atualiza tema do Kitty quando background muda",
  })

  -- Também executa uma vez ao carregar o Neovim dentro do kitty
  vim.defer_fn(function()
    UpdateKittyTheme()
    initialized = true -- Marca como inicializado depois da primeira execução
  end, 100)

  vim.keymap.set("n", "<leader>oK", UpdateKittyTheme, { desc = "Update Kitty Theme" })
end
