" My Simple config

" Options 
set nu
set rnu
set cursorline 
set nowrap
set ignorecase
set smartcase
set tabstop=2
set shiftwidth=2
set expandtab
set wildoptions=pum
set showcmd
set showcmdloc=statusline
set nocompatible
set noswapfile
set incsearch
set foldmethod=indent
set splitkeep=cursor
set path+=**
set wildignore+=*/node_modules/*,_site,*/__pycache__/,*/venv/*,*/target/*,*/.vim$,\~$,*/.log,*/.aux,*/.cls,*/.aux,*/.bbl,*/.blg,*/.fls,*/.fdb*/,*/.toc,*/.out,*/.glo,*/.log,*/.ist,*/.fdb_latexmk,*/.git
" set clipboard=unnamed,unnamedplus
set wlsteal

" Let's save undo info!
if has('nvim')
    " Neovim: use stdpath('state')/undo
    let s:undodir = stdpath('state') . '/undo'
else
    " Vim: use ~/.vim/undo
    let s:undodir = $HOME . '/.local/state/vim/undo'
endif

" Create undo directory if it doesn't exist
if !isdirectory(s:undodir)
    call mkdir(s:undodir, "p", 0700)
endif

" Set undodir with double slashes for Neovim (to enable multiple files)
if has('nvim')
    execute 'set undodir=' . fnameescape(s:undodir) . '//'
else
    execute 'set undodir=' . fnameescape(s:undodir)
endif

set undofile
set undolevels=10000

let mapleader="\ "  

" Netrw Config
let g:netrw_banner = 0

nmap <C-s> :w<Cr>
imap <C-s> <C-o>:w<Cr>

" Better Marks
nmap <leader>1 `1
nmap <leader>2 `2
nmap <leader>3 `3
nmap <leader>4 `4
nmap <leader>5 `5
nmap <leader>6 `6
nmap <leader>7 `7
nmap <leader>8 `8
nmap <leader>9 `9
nmap <leader>0 `0

" Close
nmap <leader>qq :q<Cr>
nmap <leader>qQ :qa!<Cr>
" Vimr
nmap <leader>qr :so $MYVIMRC<Cr>
nmap <leader>fc :e $MYVIMRC<Cr>

" Window Control 
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
nmap <leader>w <C-w>

" Find
nmap <leader>ff :find 

" Grep
nmap <leader>sg :grep -r --exclude-dir=.git --exclude-dir=node_modules  .<Left><Left>

"Buffers 
nmap [b :bp!<Cr>
nmap ]b :bn!<Cr>
nmap <leader>sb :b! 
nmap <leader>bd :bd!<Cr>

" Vim File Explorer
nmap <leader><Cr> :Ex<Cr>

" Text Managment
vmap <S-k> :m '<-2<CR>gv=gv
vmap <S-j> :m '>+1<CR>gv=gv

" Word Substitution
nmap <leader>s/ :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
nmap <leader>s. :s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Text Movement 
nmap <C-d> <C-d>zz
nmap <C-u> <C-u>zz
nmap j gj
nmap k gk
vmap j gj
vmap k gk

" Search Movement
nmap n nzz 
nmap N Nzz 

" Insert Mode - Emacs Readline
imap <C-a> <Home>
imap <C-f> <Right>
imap <C-p> <Up>
imap <C-n> <Down>
imap <C-b> <Left>
imap <C-e> <End>
imap <C-d> <Del>
" M-f
execute "set <M-char-102>=\ef"
imap <M-char-102> <C-o>w
" M-b
execute "set <M-char-98>=\eb"
imap <M-char-98> <C-o>b
" M-d
execute "set <M-char-100>=\ed"
imap <M-char-100> <C-o>dw
imap <C-/> <C-o>u
imap <C-x><C-s> <C-o>:w<Cr>

" Command Mode Emacs Readline
cnoremap <C-h> <BS>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Delete>
cnoremap <C-o> <C-f>

" Quick Fix
nmap ]q :cnext<Cr>
nmap ]Q :clast<Cr>
nmap [q :cprev<Cr>
nmap [Q :cfirst<Cr>
nmap <leader>qo :copen<Cr>
nmap <leader>qc :cclose<Cr>

" Term Mode
tmap » <C-\><C-n>

" Install vim-plug if not found
" let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.config/vim/after'
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" List your plugins here
Plug 'ghifarit53/tokyonight-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
call plug#end()

" Theme Settings
set termguicolors
set background=dark
let g:tokyonight_style = 'night' 
let g:tokyonight_enable_italic = 1
colorscheme tokyonight

" FZF Keymaps
nmap <silent> ï :FzfFiles<Cr>
nmap <silent> ó :FzfRG<Cr>

" Git Keymaps
nmap <silent> ç :Git<Cr>:only<Cr>

" Ex
nmap å :Ex<CR>
