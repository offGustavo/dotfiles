-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = " " .. name .. " "
	end
	window:set_right_status(name or "")
end)

config = {
	font_size = 12,

	window_frame = {
		font_size = 12.0,
	},

	tab_bar_at_bottom = false,
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,

	-- Window padding
	window_padding = {
		left = 5,
		right = 5,
		top = 0,
		bottom = 0,
	},

  font = wezterm.font('JetBrainsMonoNL Nerd Font')
}

config.colors = require("theme")
-- config.color_scheme = "tokyonight_day"

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
	{ key = "o", mods = "ALT", action = sessionizer.show(find_sessions) },
	{ key = "u", mods = "ALT", action = sessionizer.show(current_sessions) },

	--LEADER
	{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },
	{ key = "v", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "v", mods = "ALT|SHIFT", action = act.ActivateCopyMode },
	{ key = "/", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },

	-- Move to window
	{ key = "1", mods = "ALT", action = act.ActivateTab(0) },
	{ key = "2", mods = "ALT", action = act.ActivateTab(1) },
	{ key = "3", mods = "ALT", action = act.ActivateTab(2) },
	{ key = "4", mods = "ALT", action = act.ActivateTab(3) },
	{ key = "5", mods = "ALT", action = act.ActivateTab(4) },
	{ key = "6", mods = "ALT", action = act.ActivateTab(5) },
	{ key = "7", mods = "ALT", action = act.ActivateTab(6) },
	{ key = "8", mods = "ALT", action = act.ActivateTab(7) },
	{ key = "9", mods = "ALT", action = act.ActivateTab(8) },
	{ key = "0", mods = "ALT", action = act.ActivateTab(9) },

	-- Manage Tabs
	{ key = "n", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "ALT", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = ".", mods = "ALT", action = act.ActivateTabRelative(1) },
	{ key = ",", mods = "ALT", action = act.ActivateTabRelative(-1) },
	{ key = "<", mods = "ALT|SHIFT", action = act.MoveTabRelative(-1) },
	{ key = ">", mods = "ALT|SHIFT", action = act.MoveTabRelative(1) },

	-- Zoom
	{ key = "z", mods = "ALT", action = act.TogglePaneZoomState },
	-- Manage Windows
	{ key = "s", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- Move
	{ key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	-- Resize
	{ key = "h", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "l", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 1 }) },
	{ key = "k", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "j", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down", 1 }) },
}

-- and finally, return the configuration to wezterm
return config
