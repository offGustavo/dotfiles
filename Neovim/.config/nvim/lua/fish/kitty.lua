-----------
-- Kitty --
-----------
if os.getenv("KITTY_WINDOW_ID") then
  local uv = vim.loop
  local debounce_timer

  local function get_theme_colors()
    local function get_hl(name, attr)
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
      if not ok or not hl then return nil end
      return hl[attr]
    end

    local function to_hex(color)
      if not color then return nil end
      if type(color) == "string" then
        return color:match("^#%x+$") and color or nil
      elseif type(color) == "number" then
        return string.format("#%06x", color)
      elseif type(color) == "table" and color[1] then
        return string.format("#%02x%02x%02x", color[1], color[2], color[3])
      end
      return nil
    end

    return {
      BG = to_hex(get_hl("Normal", "bg")) or "#1a1b26",
      FG = to_hex(get_hl("Normal", "fg")) or "#c0caf5",
      ACCENT = to_hex(get_hl("CursorLineNr", "fg")) or "#7aa2f7",
    }
  end

  local function apply_kitty_theme()
    local colors = get_theme_colors()
    if not colors then return end

    local socket = os.getenv("KITTY_LISTEN_ON")
    if not socket then return end

    local cmd = {
      "kitty", "@", "--to", socket, "set-colors", "--configured", "-a",
      "background=" .. colors.BG,
      "foreground=" .. colors.FG,
      "selection_background=" .. colors.ACCENT,
      "selection_foreground=" .. colors.BG,
      "cursor=" .. colors.ACCENT,
    }

    vim.fn.jobstart(cmd, { detach = true })
  end

  function UpdateKittyTheme()
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

  local kitty_group = vim.api.nvim_create_augroup("KittyTheme", { clear = true })
  vim.api.nvim_create_autocmd({"OptionSet", "ColorScheme"}, {
    group = kitty_group,
    pattern = {"background", "*"},
    callback = UpdateKittyTheme,
    desc = "Atualiza tema do Kitty quando cores mudam"
  })

  vim.defer_fn(UpdateKittyTheme, 200)

  vim.keymap.set("n", "<leader>oK", UpdateKittyTheme, { desc = "Update Kitty Theme" })
end
