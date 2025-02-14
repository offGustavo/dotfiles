-------------------------------
--    "Sky" awesome theme    --
--  By Andrei "Garoth" Thorp --
-------------------------------
-- If you want SVGs and extras, get them from garoth.com/awesome/sky-theme

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local themes_path = require("gears.filesystem").get_themes_dir()

local colors = {
	_name = "tokyonight_night",
	_style = "night",
	bg = "#1a1b26",
	bg_dark = "#16161e",
	bg_dark1 = "#0C0E14",
	bg_float = "#16161e",
	bg_highlight = "#292e42",
	bg_popup = "#16161e",
	bg_search = "#3d59a1",
	bg_sidebar = "#16161e",
	bg_statusline = "#16161e",
	bg_visual = "#283457",
	black = "#15161e",
	blue = "#7aa2f7",
	blue0 = "#3d59a1",
	blue1 = "#2ac3de",
	blue2 = "#0db9d7",
	blue5 = "#89ddff",
	blue6 = "#b4f9f8",
	blue7 = "#394b70",
	border = "#15161e",
	border_highlight = "#27a1b9",
	comment = "#565f89",
	cyan = "#7dcfff",
	dark3 = "#545c7e",
	dark5 = "#737aa2",
	diff = {
		add = "#20303b",
		change = "#1f2231",
		delete = "#37222c",
		text = "#394b70",
	},
	error = "#db4b4b",
	fg = "#c0caf5",
	fg_dark = "#a9b1d6",
	fg_float = "#c0caf5",
	fg_gutter = "#3b4261",
	fg_sidebar = "#a9b1d6",
	git = {
		add = "#449dab",
		change = "#6183bb",
		delete = "#914c54",
		ignore = "#545c7e",
	},
	green = "#9ece6a",
	green1 = "#73daca",
	green2 = "#41a6b5",
	hint = "#1abc9c",
	info = "#0db9d7",
	magenta = "#bb9af7",
	magenta2 = "#ff007c",
	none = "NONE",
	orange = "#ff9e64",
	purple = "#9d7cd8",
	rainbow = { "#7aa2f7", "#e0af68", "#9ece6a", "#1abc9c", "#bb9af7", "#9d7cd8", "#ff9e64", "#f7768e" },
	red = "#f7768e",
	red1 = "#db4b4b",
	teal = "#1abc9c",
	terminal = {
		black = "#15161e",
		black_bright = "#414868",
		blue = "#7aa2f7",
		blue_bright = "#8db0ff",
		cyan = "#7dcfff",
		cyan_bright = "#a4daff",
		green = "#9ece6a",
		green_bright = "#9fe044",
		magenta = "#bb9af7",
		magenta_bright = "#c7a9ff",
		red = "#f7768e",
		red_bright = "#ff899d",
		white = "#a9b1d6",
		white_bright = "#c0caf5",
		yellow = "#e0af68",
		yellow_bright = "#faba4a",
	},
	terminal_black = "#414868",
	todo = "#7aa2f7",
	warning = "#e0af68",
	yellow = "#e0af68",
}

-- BASICS
local theme = {}
theme.font = "Jetbrains Mono Nerd Font 10"

theme.bg_focus = colors.blue
theme.bg_normal = colors.bg
theme.bg_urgent = colors.red
theme.bg_minimize = colors.bg
theme.bg_systray = colors.bg

theme.fg_normal = colors.fg
theme.fg_focus = colors.bg
theme.fg_urgent = colors.bg
theme.fg_minimize = colors.fg

theme.useless_gap = dpi(4)
theme.border_width = dpi(1)
theme.border_normal = colors.bg
theme.border_focus = colors.blue
theme.border_marked = colors.red

-- IMAGES
theme.layout_fairh = themes_path .. "sky/layouts/fairh.png"
theme.layout_fairv = themes_path .. "sky/layouts/fairv.png"
theme.layout_floating = themes_path .. "sky/layouts/floating.png"
theme.layout_magnifier = themes_path .. "sky/layouts/magnifier.png"
theme.layout_max = themes_path .. "sky/layouts/max.png"
theme.layout_fullscreen = themes_path .. "sky/layouts/fullscreen.png"
theme.layout_tilebottom = themes_path .. "sky/layouts/tilebottom.png"
theme.layout_tileleft = themes_path .. "sky/layouts/tileleft.png"
theme.layout_tile = themes_path .. "sky/layouts/tile.png"
theme.layout_tiletop = themes_path .. "sky/layouts/tiletop.png"
theme.layout_spiral = themes_path .. "sky/layouts/spiral.png"
theme.layout_dwindle = themes_path .. "sky/layouts/dwindle.png"
theme.layout_cornernw = themes_path .. "sky/layouts/cornernw.png"
theme.layout_cornerne = themes_path .. "sky/layouts/cornerne.png"
theme.layout_cornersw = themes_path .. "sky/layouts/cornersw.png"
theme.layout_cornerse = themes_path .. "sky/layouts/cornerse.png"

theme.awesome_icon = nil

-- from default for now...
theme.menu_submenu_icon = themes_path .. "default/submenu.png"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- MISC
-- theme.wallpaper = themes_path .. "sky/sky-background.png"
theme.wallpaper = "/home/gustavo/Pictures/Wallpapers/archcraft/default.jpg"
theme.taglist_squares = "true"
theme.titlebar_close_button = "true"
theme.menu_height = dpi(15)
theme.menu_width = dpi(200)

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "default/titlebar/maximized_focus_active.png"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
