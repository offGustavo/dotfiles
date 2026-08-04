set guifont=JetBrainsMono\ NFM:h12
set guioptions=!acC

set termguicolors
color catppuccin

set nu rnu nowrap

set cmdheight=1
set laststatus=2

set listchars=eol:\ ,space:·
set list

set foldmethod=indent
set shiftwidth=2 softtabstop=2 expandtab
set signcolumn=yes foldcolumn=2
if has('nvim')
  set statuscolumn=%s%l%C
endif
set fillchars=foldopen:-,foldclose:+,foldsep:\ ,foldinner:\ ,fold:\ 
syntax on

set nobackup

" set complete=o,.,b
set complete=.,b
set completeopt=menuone,noselect,popup
" set autocomplete

"autocmd CmdlineEnter [\/\?] set pumheight=8
"autocmd CmdlineLeave [\/\?] set pumheight&

"autocmd CmdlineChanged [:\/\?] call wildtrigger()

set wildmode=noselect:lastused,full
set wildoptions=pum

set hidden

set keymodel=startsel,stopsel

tmap » <C-\><C-n>
tmap <M-;> <C-\><C-n>
tmap ; <C-\><C-n>

nmap <space>y <Cmd>yank +<Cr>
nmap <space>w <Cmd>delete +<Cr>
nmap <space>p <Cmd>iput +<Cr>

xmap <space>y <Cmd>yank +<Cr>
xmap <space>w <Cmd>delete +<Cr>
xmap <space>p <Cmd>iput +<Cr>

nmap <C-Insert> <Cmd>yank +<Cr>
nmap <S-Del> <Cmd>delete +<Cr>
nmap <S-Insert> <Cmd>iput +<Cr>

xmap <C-Insert> <Cmd>yank +<Cr>
xmap <S-Del> <Cmd>delete +<Cr>
xmap <S-Insert> <Cmd>iput +<Cr>

imap <C-Insert> <Cmd>yank +<Cr>
imap <S-Del> <Cmd>delete +<Cr>
imap <S-Insert> <Cmd>iput +<Cr>

nmap <C-S-a> <Cmd>%y +<Cr>
