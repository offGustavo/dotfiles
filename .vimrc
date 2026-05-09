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
set shiftwidth=2 softtabstop=2 expandtab
set signcolumn=yes foldcolumn=1
if has('nvim')
  set statuscolumn=%s%l%C 
endif
set fillchars=foldopen:-,foldclose:+,foldsep:\ ,foldinner:\ 
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
