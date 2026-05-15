-- Set a temp theme here to prevent light/dark flicker
if vim.o.background == "dark" then
  vim.cmd.colorscheme("tokyo")
else
  vim.cmd.colorscheme("tokyo-day")
end

-- Kitty scroll mode
if os.getenv("SCROLL_MODE") then
  vim.cmd([[
    nmap q <Cmd>qa!<CR>
    xmap q <Cmd>qa!<CR> 
    nnoremap yy "+yy<Cmd>qa!<Cr>
    xmap y "+y<Cmd>qa!<Cr>
    set laststatus=0 nonu nornu signcolumn=no cursorline cmdheight=0
    $ 
  ]])
  -- NOTE: Stop vimrc here
  return
end

-- Map Leader and Local Leader
vim.cmd([[
  " <space> as leader
  let g:mapleader = " "
  " <space><space> as local leader
  let g:maplocalleader = "  "
]])

-- Our Global thing
_G.Fish = {}

-- basic keymaps for nvim (if lazy fails for some reason)
vim.cmd([[
  nmap <m-o> :fin<space>
  nmap <m-s> :grep<space>
  nmap <m-b> :b<space>
  nmap <m-e> :ex<cr>
  nmap <leader>vc :e $myvimrc<cr>
]])

-- disable custom nix/arch fzf.vim
vim.cmd("let g:loaded_fzf = 1")

-- load lazy.nvim and external plugins
require("config.lazy")
-- require("config.pack")

-- intern plugins
require("intern")

-- vim options
require("config.options")
require("config.autocmds")
require("config.commands")
require("config.keymaps")
require("config.lsp")
