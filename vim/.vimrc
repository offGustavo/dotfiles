"My Simple config 

" Options 
set nu
set rnu
set cursorline 
set nowrap
set ignorecase
set smartcase
set clipboard+=unnamedplus
set tabstop=2
set shiftwidth=2
set expandtab
" set path=**
" set wildoptions=pum

" Netrw Config
let g:netrw_banner = 0

let g:netrw_liststyle = 0

" Clean Search Highligth
nmap <Esc><Esc> :noh<Cr>
" Window Control 
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
nmap <space>w <C-w>

" Buffers 
nmap [b :bp<Cr>
nmap ]b :bn<Cr>
" nmap <space>, :ls<Cr> :b! 

" Vim File Explorer
nmap <space><Cr> :Ex<Cr>

" Find Files
" nmap <space>ff :find 

" Command Line in Vi-Mode
" nmap <space>; :<C-f>

" Text Managment
vmap <S-k> :m '<-2<CR>gv=gv
vmap <S-j> :m '>+1<CR>gv=gv

" Text Movement 
nmap <C-d> <C-d>zz
nmap <C-u> <C-u>zz
nmap <C-f> <C-f>zz
nmap <C-b> <C-b>zz
nmap j gj
vmap j gj
vmap k gk
nmap k gk
nmap <pagedown> <pagedown>zz
nmap <pageup> <pageup>zz

" Search Movement
nmap n nzz 
nmap N Nzz 

" Insert Mode
imap <C-a> <Home>
imap <C-f> <Right>
imap <C-p> <Up>
imap <C-n> <Down>
imap <C-b> <Left>
imap <C-e> <End>
imap <C-d> <Del>
" M-f
execute "set <M-char-102>=\ef"
imap <M-char-102> <C-Right>
" M-b
execute "set <M-char-98>=\eb"
imap <M-char-98> <C-Left>
" M-d
execute "set <M-char-100>=\ed"
imap <M-char-100> <C-o>dw

" Vim Terminal
nmap <space>tt :ter<Cr>
tmap <Esc><Esc> <C-\><C-n>
tmap <C-h> <C-w>h
tmap <C-j> <C-w>j
tmap <C-k> <C-w>k
tmap <C-l> <C-w>l

" Quick Fix
nmap ]q :cnext<Cr>
nmap [q :cprev<Cr>

call plug#begin()

" List your plugins here
Plug 'ghifarit53/tokyonight-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

function! Search() abort
	let l:tempname = tempname()
	" fzf | awk '{ print $1":1:0" }' > file
   execute 'silent !fzf --margin 5 --preview "if [ -d {} ]; then tree {}; else cat {}; fi" --multi ' . '| awk ''{ print $1":1:0" }'' > ' . fnameescape(l:tempname)
   
   " execute 'silent !fzf --multi ' . '| awk ''{ print $1":1:0" }'' > ' . fnameescape(l:tempname)
	try
		execute 'cfile ' . l:tempname
		redraw!
	finally
		call delete(l:tempname)
	endtry
endfunction

" :SearchFiles
command! SearchFiles call Search()

nnoremap <space>ff :SearchFiles<cr>

" FZF config

" let g:fzf_vim.buffers_jump = 1

" Initialize configuration dictionary
" let g:fzf_vim = {} 

" let g:fzf_layout = { 'window': 'enew' }

" let g:fzf_vim.buffers_options = ['--style', 'minimal', '--border-label', ' Open Buffers ']

" Fzf Grep 
nmap <space>/ :RG<Cr>
" Ffz Find Files
nmap <space><space> :Files<Cr>
" Fzf Buffers
nmap <space>, :Buffers<Cr>
 
" let g:fzf_vim.buffers_jump = 1

" let g:fzf_layout = { 'window': 'enew' }

" Theme Settings
set termguicolors

" let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1

colorscheme tokyonight

" Turn Off Syntax
" syntax off
