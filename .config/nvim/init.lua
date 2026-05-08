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

-- Basic keymaps for Nvim (if lazy fails for some reason)
vim.cmd([[
  nmap <M-o> :fin<Space>
  nmap <M-s> :grep<Space>
  nmap <M-b> :b<Space>
  nmap <M-e> :Ex<Cr>
]])

-- Disable Custom Nix/Arch FZF.vim
vim.cmd("let g:loaded_fzf = 1")

-- Load Lazy.nvim and external plugins
require("config.lazy")
-- require("config.pack")

require("config.forge")

require("config.options")

require("config.clipboard")
require("config.marks")
require("config.autocmds")
require("config.spell")
require("config.window")

require("config.keymaps")
require("config.toggle")
require("config.emacs")

require("config.statuscolumn")
require("config.statusline")
require("config.tabline")

require("config.lsp")
