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
  nmap <M-o> :fin 
  nmap <M-e> :Ex<Cr>
  nmap <M-s> :grep 
  nmap <M-b> :b 
]])

-- Disable Custom Nix/Arch FZF.vim
vim.cmd("let g:loaded_fzf = 1")

-- Load Lazy.nvim and external plugins
require("config.lazy")

-- Load my custom plugins
require("config.forge")
