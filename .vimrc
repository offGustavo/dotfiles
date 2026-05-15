let g:mapleader = "\<space>"

" GUI
set guifont=JetBrainsMono\ NFM:h12

" UI
set termguicolors
set nu rnu nowrap

set clipboard=unnamedplus

set cmdheight=1
set laststatus=2

set listchars=eol:\ ,space:·
set list

" Code
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
set autocomplete

autocmd CmdlineEnter [\/\?] set pumheight=8
autocmd CmdlineLeave [\/\?] set pumheight&

autocmd CmdlineChanged [:\/\?] call wildtrigger()
set wildmode=noselect:lastused,full
set wildoptions=pum

set hidden

" Keymaps
set keymodel=startsel,stopsel

" Term
tmap » <C-\><C-n>
tmap <M-;> <C-\><C-n>
tmap ; <C-\><C-n>


" Vim
nnoremap <silent> <leader>vo :so %<CR>
nnoremap <silent> <leader>vc <Cmd>e $MYVIMRC<CR>

" Clipboard
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

let data_dir = has('nvim') ? stdpath('data') . '/site' : has('win32') || has('win64') ? '~/vimfiles' : '~/.vim' 
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
 Plug 'https://github.com/ghifarit53/tokyonight-vim'
 Plug 'https://github.com/tpope/vim-surround'
 Plug 'https://github.com/tpope/vim-fugitive'
 Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
 Plug 'junegunn/fzf.vim'
call plug#end()

silent! color tokyonight

" Initialize configuration dictionary
let g:fzf_vim = {}

nmap <M-o> :Files<Cr>
nmap <M-s> :RG<Cr>
nmap <M-b> :Buffers<Cr>

nmap o :Files<Cr>
nmap s :RG<Cr>
nmap b :Buffers<Cr>

nmap ï :Files<Cr>
nmap ó :RG<Cr>
nmap â :Buffers<Cr>
