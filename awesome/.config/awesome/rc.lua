-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
--
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/gustavo/.config/awesome/theme/tokyo.lua")

-- This is used later as the default terminal and editor to run.
local terminal = "alacritty"
local editor = os.getenv("EDITOR") or "nvim"
local editor_cmd = terminal .. " -e " .. editor
local editor_gui = "code"
local config_file = "/home/gustavo/.config/awesome/"
local scripts = config_file .. "scripts/"

-- Default super.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local super = "Mod4"
local alt = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.floating,
	-- awful.layout.suit.tile.left,
	--[[
  Tiling Only
  --]]
	-- awful.layout.suit.tile.bottom,
	-- awful.layout.suit.tile.top,
	-- awful.layout.suit.fair,
	-- awful.layout.suit.fair.horizontal,
	-- awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	-- awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier,
	awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_gui .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
	{
		"poweroff",
		function()
			awful.spawn("poweroff")
		end,
	},
	{
		"reboot",
		function()
			awful.spawn("reboot")
		end,
	},
	{
		"suspend",
		function()
			awful.spawn("systemctl suspend")
		end,
	},
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
	mymainmenu = freedesktop.menu.build({
		before = { menu_awesome },
		after = { menu_terminal },
	})
else
	mymainmenu = awful.menu({
		items = {
			menu_awesome,
			{ "Debian", debian.menu.Debian_menu.Debian },
			menu_terminal,
		},
	})
end

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ super }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ super }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
	})

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s })

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			-- mylauncher,
			mytextclock,
			s.mytaglist,
			-- s.mypromptbox,
		},
		s.mytasklist, -- Middle widget
		-- FIX: Adicionar o espaço entre os elementos
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			mykeyboardlayout,
			wibox.widget.systray(),
			s.mylayoutbox,
		},
	})
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
	awful.button({}, 3, function()
		mymainmenu:toggle()
	end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
	awful.key({ super, "Shift" }, "slash", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),

	awful.key({ super }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),

	awful.key({ super }, "h", awful.tag.viewprev, { description = "view previous", group = "tag" }),

	awful.key({ super }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),

	awful.key({ super }, "l", awful.tag.viewnext, { description = "view next", group = "tag" }),

	awful.key({ super }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),

	awful.key({ super }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),

	awful.key({ super, "Shift" }, "w", function()
		mymainmenu:show()
	end, { description = "show main menu", group = "awesome" }),

	awful.key({ super }, "w", function()
		awful.spawn(scripts .. "window.sh")
	end, { description = "rofi windows", group = "launcher" }),

	-- Layout manipulation
	awful.key({ super, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ super, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),

	-- FIX: Não consigo mover a janela para a proxima tela
	-- 	awful.key({ super, "Shift" }, "l", function()
	--     awful.client.move_to_screen("+1")
	--   end, { description = "move to screen", group = "client" }),

	awful.key({ super }, "o", function()
		awful.screen.focus_relative(1)
	end, { description = "cicle focus on the screens", group = "screen" }),

	awful.key({ super, "Shift" }, "h", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),

	awful.key({ super, "Shift" }, "l", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),

	awful.key({ super }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),

	-- Standard program
	awful.key({ super }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),

	awful.key({ super, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),

	awful.key({ super, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

	-- awful.key({ super }, "l", function()
	-- 	awful.tag.incmwfact(0.05)
	-- end, { description = "increase master width factor", group = "layout" }),
	--
	-- awful.key({ super }, "h", function()
	-- 	awful.tag.incmwfact(-0.05)
	-- end, { description = "decrease master width factor", group = "layout" }),
	--
	-- awful.key({ super, "Shift" }, "h", function()
	-- 	awful.tag.incnmaster(1, nil, true)
	-- end, { description = "increase the number of master clients", group = "layout" }),
	--
	-- awful.key({ super, "Shift" }, "l", function()
	-- 	awful.tag.incnmaster(-1, nil, true)
	-- end, { description = "decrease the number of master clients", group = "layout" }),
	--
	-- awful.key({ super, "Control" }, "h", function()
	-- 	awful.tag.incncol(1, nil, true)
	-- end, { description = "increase the number of columns", group = "layout" }),
	--
	-- awful.key({ super, "Control" }, "l", function()
	-- 	awful.tag.incncol(-1, nil, true)
	-- end, { description = "decrease the number of columns", group = "layout" }),

	awful.key({ super }, "y", function()
		awful.layout.inc(1)
	end, { description = "cycle layouts", group = "layout" }),

	awful.key({ super, "Control" }, "m", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),

	-- Prompt
	awful.key({ super }, "r", function()
		awful.screen.focused().mypromptbox:run()
	end, { description = "run prompt", group = "launcher" }),

	awful.key({ super }, "slash", function()
		awful.spawn(scripts .. "runner.sh")
	end, { description = "Rofi launcher", group = "launcher" }),

	-- Menubar
	awful.key({ super }, "p", function()
		menubar.show()
	end, { description = "show the menubar", group = "launcher" }),

	-- scripts
	--
	awful.key({ super }, "b", function()
		awful.spawn(scripts .. "bluetooth.sh")
	end, { description = "Rofi Bluetooth", group = "scripts" }),

	awful.key({ super }, "v", function()
		awful.spawn(scripts .. "sound.sh")
	end, { description = "Rofi Bluetooth", group = "scripts" }),

	awful.key({ super }, "n", function()
		awful.spawn(scripts .. "network.py")
	end, { description = "Rofi Network", group = "scripts" })
)

clientkeys = gears.table.join(
	awful.key({ super }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),

	awful.key({ super }, "q", function(c)
		c:kill()
	end, { description = "close", group = "client" }),
	awful.key({ super }, "g", awful.client.floating.toggle, { description = "toggle floating", group = "client" }),
	awful.key({ super, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),

	awful.key({ super, "Shift" }, "o", function(c)
		c:move_to_screen()
	end, { description = "move to another screen", group = "client" }),

	awful.key({ super }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),

	awful.key({ super }, "comma", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = "minimize", group = "client" }),

	awful.key({ super }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "toggle maximize", group = "client" }),

	awful.key({ super, "Shift" }, "m", function()
		awful.spawn(scripts .. "monitor.sh")
	end, { description = "Rofi Monitors", group = "scripts" }),

	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
	end, { description = "lower volume", group = "system" }),

	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
	end, { description = "increase volume", group = "system" }),

	awful.key({}, "XF86AudioMute", function()
		awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle ")
	end, { description = "toggle mute", group = "system" }),

	--FIX: Control Midia no workin
	awful.key({}, "XF86AudioNext", function()
		awful.spawn("playerctl next")
	end, { description = "media next", group = "system" }),

	awful.key({}, "XF86AudioPrev", function()
		awful.spawn("playerctl previous")
	end, { description = "media previous", group = "system" }),

	awful.key({}, "XF86AudioPlay", function()
		awful.spawn("playerctl play-pause")
	end, { description = "midia play/pause", group = "system" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 10 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ super }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ super, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ super, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ super, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ super }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ super }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
--
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = 2,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },

	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c, { size = 0 })
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)
-- }}}

-- Autostart
awful.spawn.with_shell("xrandr --output HDMI-1-0 --mode 1920x1080 --preferred --left-of eDP-1")
