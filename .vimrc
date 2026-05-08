let g:mapleader = "\<space>"

" GUI
set guifont=JetBrainsMono\ NFM:h12

" UI
set termguicolors
set nu rnu nowrap

set cmdheight=1
set laststatus=1

set listchars=eol:\ ,space:·
set list

" Code
set foldmethod=indent
set shiftwidth=2 softtabstop=2
set signcolumn=yes foldcolumn=1
set fillchars=foldopen:-,foldclose:+,foldsep:\ ,foldinner:\ 

" Extern
set nobackup

call plug#begin()
  " List your plugins here
  Plug 'vim-fuzzbox/fuzzbox.vim'
  Plug 'https://github.com/tpope/vim-commentary'
  Plug 'https://github.com/tpope/vim-fugitive'
  Plug 'https://github.com/ghifarit53/tokyonight-vim'
call plug#end()

" Theme
color tokyonight

" Keymaps
set keymodel=startsel,stopsel

" Fuzzy
" Buffer
nnoremap <silent> <M-b> :FuzzyBuffers<CR>
nnoremap <silent> <leader>bs :FuzzyInBuffer<CR>

" Files
nnoremap <silent> <M-o> :FuzzyFiles<CR>

" Grep
nnoremap <silent> <M-s> :FuzzyGrep<CR>

" Git
nmap <M-g> <Cmd>Git<Cr>

" Vim
nnoremap <silent> <leader>vh :FuzzyHelp<CR>
nnoremap <silent> <leader>vo :so %<CR>
nnoremap <silent> <leader>vc <Cmd>e $MYVIMRC<CR>

" Clipboard
nmap <C-Insert> :yank +<Cr>
xmap <C-Insert> :yank +<Cr>

nmap <S-Del> :delete +<Cr>
xmap <S-Del> :delete +<Cr>

nmap <S-Insert> :iput +<Cr>
xmap <S-Insert> :iput +<Cr>
imap <S-Insert> :iput +<Cr>
