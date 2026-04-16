set nu rnu
set shiftwidth=2
set signcolumn=yes
set foldmethod=indent

set termguicolors
syntax on
color catppuccin

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

nmap <M-o> :find 
nmap <M-e> :Ex<Cr> 
nmap <M-h> :b 
nmap <M-s> :grep  
