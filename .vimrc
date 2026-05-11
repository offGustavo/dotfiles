let g:mapleader = "\<space>"

" GUI
set guifont=JetBrainsMono\ NFM:h12

" UI
set termguicolors
set nu rnu nowrap

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

if has("unix")
  set grepprg=grep\ -rHn
endif

" set complete=o,.,b
set complete=.,b
set completeopt=menuone,noselect,popup
set autocomplete

autocmd CmdlineEnter [\/\?] set pumheight=8
autocmd CmdlineLeave [\/\?] set pumheight&

autocmd CmdlineChanged [:\/\?] call wildtrigger()
set wildmode=noselect:lastused,full
set wildoptions=pum

" Theme
silent! color catppuccin

" Keymaps
set keymodel=startsel,stopsel

" Buffer
nnoremap <M-b> :b<Space>
nnoremap <leader>sb :vimgrep//%<left><left>
nnoremap <silent> <leader>bw :grep '<cword>'<Cr>
nnoremap <silent> <leader>bW :grep '<cWORD>'<Cr>

set findfunc=Find
func Find(arg, _)
  if empty(s:filescache)
    let s:filescache = globpath('.', '**', 1, 1)
    call filter(s:filescache, '!isdirectory(v:val)')
    call map(s:filescache, "fnamemodify(v:val, ':.')")
  endif
  return a:arg == '' ? s:filescache : matchfuzzy(s:filescache, a:arg)
endfunc
let s:filescache = []
autocmd CmdlineEnter : let s:filescache = []

" Files
nnoremap <M-o> :find<Space>

" Grep
command! -nargs=+ -complete=customlist,<SID>Grep
      \ Grep call <SID>VisitFile()

func s:Grep(arglead, cmdline, cursorpos)
  if match(&grepprg, '\$\*') == -1 | let &grepprg ..= ' $*' | endif
  let cmd = substitute(&grepprg, '\$\*', shellescape(escape(a:arglead, '\')), '')
  return len(a:arglead) > 1 ? systemlist(cmd) : []
endfunc

func s:VisitFile()
  let item = getqflist(#{lines: [s:selected]}).items[0]
  let pos  = '[0,\ item.lnum,\ item.col,\ 0]'
  exe $':b +call\ setpos(".",\ {pos}) {item.bufnr}'
  call setbufvar(item.bufnr, '&buflisted', 1)
endfunc

autocmd CmdlineLeavePre :
      \ if get(cmdcomplete_info(), 'matches', []) != [] |
      \   let s:info = cmdcomplete_info() |
      \   if getcmdline() =~ '^\s*fin\%[d]\s' && s:info.selected == -1 |
      \     call setcmdline($'find {s:info.matches[0]}') |
      \   endif |
      \   if getcmdline() =~ '^\s*Grep\s' |
      \     let s:selected = s:info.selected != -1
      \         ? s:info.matches[s:info.selected] : s:info.matches[0] |
      \     call setcmdline(s:info.cmdline_orig) |
      \   endif |
      \ endif

nnoremap <silent> <M-s> :Grep<Space>
nnoremap <silent> <leader>sg :grep<Space>
nnoremap <silent> <leader>sw :grep '<cword>'<Cr>
nnoremap <silent> <leader>sW :grep '<cWORD>'<Cr>

" Git
nmap <M-G> :!git

" Vim
nnoremap <silent> <leader>vh :helpgrep<Space>
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

" pack.vim — minimal native package manager for Vim
" Place this block anywhere in your vimrc.
"
" Usage:
"   call PackDown('https://github.com/tpope/vim-surround')
"   call PackUp()
"   call PackClean()        " removes undeclared plugins
"   call PackClean(1)       " force-removes ALL plugins

" ── config ────────────────────────────────────────────────────────────────────
" let s:pack_dir = expand('~/vimfiles/pack/pack/opt')
let s:pack_dir = expand('~/.vim/pack/pack/opt')
" ── config ────────────────────────────────────────────────────────────────────

" Resolve the right config root for every editor + OS combination:
"
"   Neovim  Unix     stdpath('data')/site          (~/.local/share/nvim/site)
"   Neovim  Windows  stdpath('data')/site          (~\AppData\Local\nvim-data\site)
"   Vim     Unix     ~/.vim
"   Vim     Windows  ~/vimfiles
"
if has('nvim')
  let s:vim_dir = stdpath('data') . '/site'
elseif has('win32') || has('win64')
  let s:vim_dir = expand('~/vimfiles')
else
  let s:vim_dir = expand('~/.vim')
endif

let s:pack_dir = s:vim_dir . '/pack/opt'

" Registry of every plugin declared in this session (populated by PackDown).
let s:declared = []

function! s:EnsureDir(path) abort
  if !isdirectory(a:path)
    call mkdir(a:path, 'p')
  endif
endfunction

" Extract a directory name from a URL.
"   'https://github.com/tpope/vim-surround'  →  'vim-surround'
"   'https://github.com/tpope/vim-surround/' →  'vim-surround'
function! s:DirFromURL(url) abort
  let l:url = substitute(a:url, '\.git$', '', '')
  let l:url = substitute(l:url, '/$', '', '')
  return fnamemodify(l:url, ':t')
endfunction

function! s:Run(cmd) abort
  echo '  » ' . a:cmd
  let l:out = system(a:cmd)
  if v:shell_error
    echoerr 'pack.vim: command failed — ' . a:cmd
    echoerr l:out
    return 0
  endif
  return 1
endfunction

" PackDown({url})
"   Clone {url} into the opt package directory (if not already present),
"   then :packadd it for the current session.
function! PackDown(url) abort
  call s:EnsureDir(s:pack_dir)

  let l:name = s:DirFromURL(a:url)
  let l:dest = s:pack_dir . '/' . l:name

  " Track every declared plugin so PackClean knows what to keep.
  if index(s:declared, l:name) < 0
    call add(s:declared, l:name)
  endif

  if !isdirectory(l:dest)
    echo 'pack.vim: installing ' . l:name . ' …'
    if !s:Run('git clone --depth=1 ' . shellescape(a:url) . ' ' . shellescape(l:dest))
      return
    endif
    echo 'pack.vim: installed ' . l:name
  endif
endfunction

" PackUp()
"   Pull the latest changes for every installed opt plugin.
function! PackUp() abort
  let l:plugins = glob(s:pack_dir . '/*', 0, 1)
  if empty(l:plugins)
    echo 'pack.vim: nothing to update'
    return
  endif

  echo 'pack.vim: updating ' . len(l:plugins) . ' plugin(s) …'
  for l:dir in l:plugins
    if isdirectory(l:dir . '/.git')
      echo 'pack.vim: updating ' . fnamemodify(l:dir, ':t') . ' …'
      call s:Run('git -C ' . shellescape(l:dir) . ' pull --ff-only --rebase=false')
    endif
  endfor
  echo 'pack.vim: done'
endfunction

" PackClean([force])
"   Without arguments — removes plugins not declared via PackDown().
"   With force=1      — removes ALL installed plugins regardless of declarations.
function! PackClean(...) abort
  let l:force = (a:0 > 0 && a:1)
  let l:plugins = glob(s:pack_dir . '/*', 0, 1)

  if empty(l:plugins)
    echo 'pack.vim: nothing to clean'
    return
  endif

  let l:removed = 0
  for l:dir in l:plugins
    let l:name = fnamemodify(l:dir, ':t')
    if l:force || index(s:declared, l:name) < 0
      echo 'pack.vim: removing ' . l:name . ' …'
      if s:Run('rm -rf ' . shellescape(l:dir))
        let l:removed += 1
      endif
    endif
  endfor

  if l:removed == 0
    echo 'pack.vim: nothing to remove'
  else
    echo 'pack.vim: removed ' . l:removed . ' plugin(s)'
  endif
endfunction

call PackDown('https://github.com/tpope/vim-surround')
packadd vim-surround

call PackDown('https://github.com/tpope/vim-commentary')
packadd vim-commentary

call PackDown('https://github.com/tpope/vim-fugitive')
packadd vim-fugitive

if has('nvim')
  call PackDown('https://github.com/ibhagwan/fzf-lua')
  " packadd fzf-lua
  execute 'set runtimepath+=' . s:pack_dir . '/fzf-lua'
  lua require("fzf-lua").setup()
  nmap <M-o> :FzfLua files<Cr>
else
  call PackDown('https://github.com/vim-fuzzbox/fuzzbox.vim')
  packadd fuzzbox.vim
endif

nnoremap <leader>vU :call PackUp()<CR>
nnoremap <leader>vC :call PackClean()<CR>
