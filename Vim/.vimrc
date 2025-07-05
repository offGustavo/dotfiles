"My Simple config

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
set path=**
set wildoptions=pum
set showcmd
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

" Set cursor to line in insert mode
let &t_SI = "\e[5 q"
" Set cursor to block in normal mode
let &t_EI = "\e[2 q"

" "STATUSLINE
" set laststatus=2
" set noshowmode
" "STATUSLINE MODE
" let g:currentmode={
"             \ 'n' : 'NORMAL ',
"             \ 'v' : 'VISUAL ',
"             \ 'V' : 'V-LINE ',
"             \ '\' : 'V-BLOCK' ,
"             \ 'i' : 'INSERT ',
"             \ 'R' : 'REPLACE ',
"             \ 'Rv' : 'V-REPLACE ',
"             \ 'c' : 'COMMAND ',
"             \}
" set statusline=
" set statusline+=%#Icon#
" set statusline+=\ %#NormalC#%{(mode()=='n')?'\ NORMAL\ ':''}
" set statusline+=%#InsertC#%{(mode()=='i')?'\ INSERT\ ':''}
" set statusline+=%#VisualC#%{(mode()=='v')?'\ VISUAL\ ':''}
" set statusline+=%#Filename#
" set statusline+=\ %f
" set statusline+=%#ReadOnly#
" set statusline+=\ %r
" set statusline+=%m
" set statusline+=%=
" set statusline+=%#Fileformat#
"  set statusline+=\ %y
" set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
" set statusline+=\ [%{&fileformat}\]
" set statusline+=%#Position#
" set statusline+=\ (%l/%L)
" set statusline+=\ [vim]\  

" Netrw Config
let g:netrw_banner = 0
let g:netrw_liststyle = 0

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
nmap <leader>rr :so ~/.vimrc<Cr>
nmap <leader>fc :e ~/.vimrc<Cr>

" " Clean Search Highligth
" nmap <Esc> :noh<Cr>

" Window Control 
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
nmap <leader>w <C-w>

" Grep
nmap <leader>sg :grep -r --exclude-dir=.git --exclude-dir=node_modules  .<Left><Left>
nmap <leader>sG :grep

"Buffers 
nmap [b :bp!<Cr>
nmap ]b :bn!<Cr>
nmap <leader>sb :ls<Cr> :b! 

" Vim File Explorer
nmap <leader><Cr> :Ex<Cr>

" Command Line in Vi-Mode
" nmap <leader>; :<C-f>

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
vmap j gj
vmap k gk
nmap k gk

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
imap <M-char-102> <C-Right>
" M-b
execute "set <M-char-98>=\eb"
imap <M-char-98> <C-Left>
" M-d
execute "set <M-char-100>=\ed"
imap <M-char-100> <C-o>dw
" M-< → Vai para o início do arquivo
execute "set <M-char-60>=\e<"
imap <M-char-60> <C-o>gg
" M-> → Vai para o final do arquivo
execute "set <M-char-62>=\e>"
imap <M-char-62> <C-o>G
" M-} → Pular para a próxima chave }
execute "set <M-char-125>=\e}"
imap <M-char-125> <C-o>}
" M-{ → Pular para a chave anterior {
execute "set <M-char-123>=\e{"
imap <M-char-123> <C-o>{

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


" Vim Terminal
nmap <leader>tn :ter<Cr><C-w>j:w<Cr><C-w>c
tmap <Esc><Esc> <C-\><C-n>
tmap <C-h> <C-w>h
tmap <C-j> <C-w>j
tmap <C-k> <C-w>k
tmap <C-l> <C-w>l

" Quick Fix
nmap ]q :cnext<Cr>
nmap ]Q :clast<Cr>
nmap [q :cprev<Cr>
nmap [Q :cfirst<Cr>
nmap <leader>q :copen<Cr>
nmap <leader>Q :cclose<Cr>
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction
nnoremap <silent> <leader>xq :call ToggleQuickFix()<cr>

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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'Donaldttt/fuzzyy'"
call plug#end()

function! Search() abort
	let l:tempname = tempname()
	" fzf | awk '{ print $1":1:0" }' > file
   execute 'silent !fzf --style full --no-border --margin 5 --preview "if [ -d {} ]; then tree {}; else cat {}; fi" --multi ' . '| awk ''{ print $1":1:0" }'' > ' . fnameescape(l:tempname)
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
nnoremap <leader>ff :SearchFiles<cr>

" FZF config
" " Initialize configuration dictionary
" let g:fzf_vim = {} 
" " Set to jump to buffer
" let g:fzf_vim.buffers_jump = 1
" " Set to open in new window
" let g:fzf_layout = { 'window': 'enew' }
" " Change Style for buffers picker
" let g:fzf_vim.buffers_options = ['--style', 'minimal', '--border-label', ' Open Buffers ']

" Fzf Find Word
nmap <leader>sw :RG <C-r><C-w><Cr>
" Fzf Grep 
nmap <leader>/ :RG<Cr>
" Ffz Find Files
nmap <leader><space> :Files<Cr>
" Fzf Buffers
nmap <leader>, :Buffers<Cr>
" Fzf Colors
nmap <leader>uC :FuzzyColors<Cr>

" Git 
nmap <leader>G :Git<Cr>

" Theme Settings
set termguicolors
set background=dark
" Set Tokyo
let g:tokyonight_style = 'night' " available: night, storm
" Enable Italic
let g:tokyonight_enable_italic = 1
" Set colorscheme
colorscheme tokyonight
" colorscheme retrobox

" Turn Off Syntax
" syntax off

" FZF config
let g:fzf_vim = {} 

let g:fzf_vim.buffers_jump = 1
" let g:fzf_vim.preview_window = ['right,50%', 'ctrl-o']
" let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_vim.buffers_options = ['--style', 'default']
" let g:fzf_vim.files_options =   ['--style', 'default']
" let g:fzf_vim.rg_options =      ['--style', 'default']
" let g:fzf_vim.colors_options =      ['--no-preview']

let g:fzf_vim.command_prefix = 'Fzf'

" Fzf Find Word
nmap <leader>sw :FzfRG <C-r><C-w><Cr>
" Fzf Grep 
nmap <leader>/ :FzfRG<Cr>
" Ffz Find Files
nmap <leader><space> :FzfFiles<Cr>
" Fzf Buffers
nmap <leader>, :FzfBuffers<Cr>

" Git 
nmap <leader>G :Git<Cr>
