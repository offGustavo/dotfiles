local old = vim.o.statusline
Fish.statusline = {}
local function fileName()
	-- TODO:
	return "%f %m "
end


local function gitInfo()
  if vim.b.minigit_summary_string and vim.b.minidiff_summary_string then
    return vim.b.minigit_summary_string
      .. " "
      .. vim.b.minidiff_summary_string
  end
  return ""
end

function Fish.buildStatusLine()
	return "▊   "
		.. fileName()
		.. "[%l/%L] "
		.. "%c %p%% "
		.. "%="
    .. gitInfo()
		.. " %r "
		.. "%y "
		.. " ▊"
end

vim.o.statusline = "%!v:lua.Fish.buildStatusLine()"
