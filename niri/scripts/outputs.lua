#!/usr/bin/env lua

local function verify_monitor_connect(v)
	local handle = io.popen("niri msg outputs")
	for line in handle:lines() do
		print(line)
		if string.find(line, v) then
			print("found")
			return true
		end
	end
  handle:close()
  return false
end

local monitors = {
	{
		name = "Note",
		port = "eDP-1",
		config = [[
      niri msg output eDP-1 on
      niri msg output eDP-1 position set 1920 0
    ]],
		default = true,
	}, -- Note
	{
		name = "UltraGear",
		port = "HDMI-A-2",
		config = [[
      niri msg output HDMI-A-2 on
      niri msg output HDMI-A-2 position set -- -1920 0
    ]],
		default = true,
	}, -- UltraGear
	{
		name = "TV TCL",
		port = "HDMI-A-2",
		config = [[
      niri msg output HDMI-A-2 on
      niri msg output HDMI-A-2 position set 1920 0
    ]],
		default = verify_monitor_connect(self.name),
	}, -- TV
}

local function is_default(monitor)
	if monitor then
		return "True"
	else
		return "False"
	end
end

for index, monitor in pairs(monitors) do
	print("Name: " .. monitor.name)
	print("Port: " .. monitor.port)
	print("Config: ")
	print(monitor.config)
	print("Default: " .. is_default(monitor.default))

	-- END
	print("--------- // ---------")
end
