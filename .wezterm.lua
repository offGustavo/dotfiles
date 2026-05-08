local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- config.default_prog = { 'pwsh.exe' }

-- Function to check if the current pane is running Vim/Neovim
local function is_vim(pane)
  -- Get the name of the foreground process (e.g., 'nvim', 'vim')
  local proc_name = pane:get_foreground_process_name()
  if proc_name then
    return proc_name:find("n?vim$") ~= nil
  end
  return false
end

-- Event listener that decides what to do when Ctrl+Insert is pressed
wezterm.on("send-ctrl-insert", function(window, pane)
  if is_vim(pane) then
    -- If Vim is active, send the raw key combination to it
    window:perform_action(act.SendKey({ key = "Insert", mods = "CTRL" }), pane)
  else
    -- If Vim is not active, perform the native WezTerm action (e.g., copy)
    -- Replace 'Copy' with the action you want for non-Vim contexts
    window:perform_action(act.Copy, pane)
    -- Alternative: If you just want to let the terminal handle it, use:
    -- window:perform_action(act.SendKey({ key = "Insert", mods = "CTRL" }), pane)
  end
end)

-- Event listener that decides what to do when Ctrl+Insert is pressed
wezterm.on("send-shift-insert", function(window, pane)
  if is_vim(pane) then
    -- If Vim is active, send the raw key combination to it
    window:perform_action(act.SendKey({ key = "Insert", mods = "SHIFT" }), pane)
  else
    -- If Vim is not active, perform the native WezTerm action (e.g., copy)
    -- Replace 'Copy' with the action you want for non-Vim contexts
    window:perform_action(act.Insert, pane)
    -- Alternative: If you just want to let the terminal handle it, use:
    -- window:perform_action(act.SendKey({ key = "Insert", mods = "Shift" }), pane)
  end
end)

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
  local name = window:active_key_table()
  if name == "copy_mode" then
    name = "  "
  end
  if window:leader_is_active() then
    name = "  "
  end
  window:set_right_status(name or "󰯉  ")
end)

config = {
  font_size = 12,

  window_frame = {
    font_size = 12.0,
  },

  tab_bar_at_bottom = true,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = true,

  -- Window padding
  window_padding = {
    left = 5,
    right = 5,
    top = 0,
    bottom = 0,
  },

  font = wezterm.font("JetBrainsMonoNL Nerd Font"),
  enable_wayland = true,

--  colors = require("theme")

-- color_scheme = "tokyonight_day"
-- color_scheme = 'catppuccin-mocha'
color_scheme = 'tokyonight'

}


local sessionizer = wezterm.plugin.require("https://github.com/mikkasendke/sessionizer.wezterm")

local find_sessions = {
  wezterm.plugin.require("https://github.com/mikkasendke/sessionizer-zoxide.git").Zoxide({}),
}

local current_sessions = {
  sessionizer.DefaultWorkspace({}),
  sessionizer.AllActiveWorkspaces({}),
}

config.leader = { key = "p", mods = "ALT" }

config.keys = {

  -- Bind Ctrl+Insert to our custom event
  {
    key = "Insert",
    mods = "CTRL",
    action = act.EmitEvent("send-ctrl-insert"),
  },
  {
    key = "Insert",
    mods = "SHIFT",
    action = act.EmitEvent("send-shift-insert"),
  },
  { key = "o", mods = "ALT", action = sessionizer.show(find_sessions) },
  {
    key = "o",
    mods = "LEADER|ALT",
    action = wezterm.action.SendKey { key = 'o', mods = 'ALT' },
  },
  { key = "u", mods = "ALT", action = sessionizer.show(current_sessions) },
  {
    key = "u",
    mods = "LEADER|ALT",
    action = wezterm.action.SendKey { key = 'u', mods = 'ALT' },
  },

  --LEADER
  { key = "r", mods = "LEADER",    action = act.ReloadConfiguration },
  { key = "v", mods = "LEADER",    action = act.ActivateCopyMode },
  { key = ":", mods = "ALT", action = act.ActivateCopyMode },
  { key = "/", mods = "LEADER",    action = act.Search("CurrentSelectionOrEmptyString") },

  -- Move to window
  { key = "1", mods = "ALT",       action = act.ActivateTab(0) },
  { key = "2", mods = "ALT",       action = act.ActivateTab(1) },
  { key = "3", mods = "ALT",       action = act.ActivateTab(2) },
  { key = "4", mods = "ALT",       action = act.ActivateTab(3) },
  { key = "5", mods = "ALT",       action = act.ActivateTab(4) },
  { key = "6", mods = "ALT",       action = act.ActivateTab(5) },
  { key = "7", mods = "ALT",       action = act.ActivateTab(6) },
  { key = "8", mods = "ALT",       action = act.ActivateTab(7) },
  { key = "9", mods = "ALT",       action = act.ActivateTab(8) },
  { key = "0", mods = "ALT",       action = act.ActivateTab(9) },
  -- Move to window
  { key = "1", mods = "LEADER",    action = act.ActivateTab(0) },
  { key = "2", mods = "LEADER",    action = act.ActivateTab(1) },
  { key = "3", mods = "LEADER",    action = act.ActivateTab(2) },
  { key = "4", mods = "LEADER",    action = act.ActivateTab(3) },
  { key = "5", mods = "LEADER",    action = act.ActivateTab(4) },
  { key = "6", mods = "LEADER",    action = act.ActivateTab(5) },
  { key = "7", mods = "LEADER",    action = act.ActivateTab(6) },
  { key = "8", mods = "LEADER",    action = act.ActivateTab(7) },
  { key = "9", mods = "LEADER",    action = act.ActivateTab(8) },
  { key = "0", mods = "LEADER",    action = act.ActivateTab(9) },

  -- Manage Tabs
  { key = "n", mods = "ALT",       action = act.SpawnTab("CurrentPaneDomain") },
  { key = "x", mods = "ALT",       action = act.CloseCurrentPane({ confirm = false }) },
  { key = ".", mods = "ALT",       action = act.ActivateTabRelative(1) },
  { key = ",", mods = "ALT",       action = act.ActivateTabRelative(-1) },
  { key = "<", mods = "ALT|SHIFT", action = act.MoveTabRelative(-1) },
  { key = ">", mods = "ALT|SHIFT", action = act.MoveTabRelative(1) },

  -- Zoom
  { key = "z", mods = "ALT",       action = act.TogglePaneZoomState },
  -- Manage Windows
  { key = "s", mods = "ALT",       action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  {
    key = "s",
    mods = "LEADER|ALT",
    action = wezterm.action.SendKey { key = 's', mods = 'ALT' },
  },
  { key = "v", mods = "ALT",          action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  {
    key = "v",
    mods = "LEADER|ALT",
    action = wezterm.action.SendKey { key = 'v', mods = 'ALT' },
  },
  -- Move
  { key = "h", mods = "ALT",          action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "ALT",          action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "ALT",          action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "ALT",          action = act.ActivatePaneDirection("Down") },
  { key = "h", mods = "LEADER",       action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER",       action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "LEADER",       action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "LEADER",       action = act.ActivatePaneDirection("Down") },
  -- Resize
  { key = "h", mods = "ALT|SHIFT",    action = act.AdjustPaneSize({ "Left", 1 }) },
  { key = "l", mods = "ALT|SHIFT",    action = act.AdjustPaneSize({ "Right", 1 }) },
  { key = "k", mods = "ALT|SHIFT",    action = act.AdjustPaneSize({ "Up", 1 }) },
  { key = "j", mods = "ALT|SHIFT",    action = act.AdjustPaneSize({ "Down", 1 }) },
  { key = "h", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 1 }) },
  { key = "l", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 1 }) },
  { key = "k", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 1 }) },
  { key = "j", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 1 }) },
  {
    key = 'z',
    mods = 'ALT',
    action = wezterm.action.SendKey { key = 'z', mods = 'ALT' },
  },
}

-- and finally, return the configuration to wezterm
return config
