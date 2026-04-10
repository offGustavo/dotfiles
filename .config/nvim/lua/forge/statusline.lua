Fish.statusline = {}


local function render_icon_with_mode_color(icon)
	return icon
end

local function fileName()
	-- TODO:
	return "%f %m "
end

-- https://vieitesss.gith
local function gitInfo()
	if vim.b.minigit_summary_string and vim.b.minidiff_summary_string then
		return vim.b.minigit_summary_string .. " " .. vim.b.minidiff_summary_string
	end
	return ""
end

local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "@" .. recording_register .. " "
  end
end


function Fish.buildStatusLine()
	return render_icon_with_mode_color("▊ ")
		.. render_icon_with_mode_color("  ")
		.. fileName()
		.. "%l:%c %L:%p%% "
		.. "%="
    .. show_macro_recording()
		.. gitInfo()
		.. " %r "
		.. "%y "
		.. render_icon_with_mode_color(" ▊")
end

vim.o.statusline = "%!v:lua.Fish.buildStatusLine()"
