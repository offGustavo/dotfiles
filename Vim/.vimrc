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

" Let's save undo info!
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "", 0700)
endif
set undodir=~/.vim/undo
set undofile
set undolevels=10000
set clipboard+=unnamed,unnamedplus

let mapleader="\ "  

" Netrw Config
let g:netrw_banner = 0

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

" vimrc
nmap <leader>rr :so ~/.vimrc<Cr> nmap
nmap <leader>fc :e ~/.vimrc<Cr>

" Window Control 
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
nmap <leader>w <C-w>

" Grep
nmap <leader>sg :grep -r --exclude-dir=.git --exclude-dir=node_modules  .<Left><Left>

"Buffers 
nmap [b :bp!<Cr>
nmap ]b :bn!<Cr>
nmap <leader>sb :b! 

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
nmap <leader>q :copen<Cr>
nmap <leader>Q :cclose<Cr>

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif 

call plug#begin()
" List your plugins here
Plug 'ghifarit53/tokyonight-vim'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
call plug#end()

" Theme Settings
set termguicolors
set background=dark
let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1
colorscheme tokyonight
" colorscheme retrobox
" syntax off

" FZF Settings
let g:fzf_vim = {} 
let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'query':   ['fg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Comment'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] } 

" let g:fzf_layout = { 'down': '30%' }
" autocmd! FileType fzf
" autocmd  FileType fzf set laststatus=0 noshowmode noruler
"   \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" let g:fzf_layout = { 'down':  '40%'}
" let g:fzf_layout = { 'window': 'enew' }
let g:fzf_vim.buffers_jump = 1
let g:fzf_vim.preview_window = ['right,50%,<50(up,60%)', 'ctrl-o']
" let g:fzf_vim.preview_window = ['up,60%', 'ctrl-o']
" let g:fzf_vim.preview_window = []
" let g:fzf_vim.files_options =   '--style fu ll --no-border'
" let g:fzf_vim.buffers_options = '--style default'
" let g:fzf_vim.rg_options =      '--style default'
" let g:fzf_vim.fi les_options =   ['--style', 'minimal', '--no-border']
" let g:fzf_vim.buffers_options = ['--style', 'minimal', '--no-border']
" let g:fzf_vim.rg_options =      ['--style', 'minimal', '--no-border']
" let g:fzf_vim.colors_options =      ['--style', 'minimal', '--no-preview']
let g:fzf_vim.command_prefix = 'Fzf'

" FZF Keymaps
nmap <silent> <leader><space> :FzfFiles<Cr>
nmap <silent> <leader>sw :FzfRG <C-r><C-w><Cr>
nmap <silent> <leader>/ :FzfRG<Cr>
nmap <silent> <leader>, :FzfBuffers<Cr>
nmap <silent> <leader>uC :FzfColors<Cr>

" Git Keymaps
nmap <silent> <leader>G :Git<Cr>:only<Cr>
nmap <silent> <leader>gg :!lazygit<Cr>
nmap <leader>gp :!git pull<Cr>
nmap <leader>gP :!git push<Cr>
nmap <silent> <leader>gl :Git log<Cr>
