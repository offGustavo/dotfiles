silent color catppuccin
set termguicolors nu rnu nowrap
set guifont=JetBrainsMono\ NFM:h12
if !has('nvim')
  set guioptions=!acC
endif
set laststatus=2 keymodel=startsel,stopsel
set shiftwidth=2 softtabstop=2 expandtab
set signcolumn=yes foldcolumn=2
if has('nvim')
  set statuscolumn=%s%l%C\ 
endif
set fillchars=foldopen:-,foldclose:+,foldsep:\ ,foldinner:\ ,fold:\ 
syntax on
set nobackup noswapfile
set hidden belloff=all
set wildmode=noselect:lastused,full wildoptions=pum
set complete=.,b completeopt=noinsert,menuone,popup autocomplete
autocmd CmdlineChanged [:] call wildtrigger()
nmap - :Ex<Cr>
nmap <space>y "+y
nmap <space>d "+d
nmap <space>p "+p
xmap <space>y "+y
xmap <space>d "+d
xmap <space>p "+p
