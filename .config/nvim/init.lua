-- We set the leader and localleader keys before any mapping
vim.g.mapleader = " "
vim.g.maplocalleader = "<M-m>"

-- Set Global state
_G.Fish = {}

-- Set our custom theme
if vim.o.background == "dark" then
	vim.cmd.colorscheme("tokyo")
else
	vim.cmd.colorscheme("tokyo-day")
end

