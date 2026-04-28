-- Map Leader and Local Leader
vim.cmd([[
  " <space> as leader
	let g:mapleader = " "
  " <space><space> as local leader
	let g:maplocalleader = "  "
]])

-- Our Global thing
_G.Fish = {}

-- Set a temp theme here to prevent light/dark flicker
if vim.o.background == "dark" then
	vim.cmd.colorscheme("tokyo")
else
	vim.cmd.colorscheme("tokyo-day")
end

require("config.lazy")
require("forge.forge")
