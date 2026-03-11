" Initialize cache
let s:filescache = []

" Color scheme for retrobox
" if has("nvim") 
silent! color shibuya
" else
" color habamax
" endif

set nu rnu
set expandtab
set wildmode=noselect:lastused,full
set wildoptions=pum
set findfunc=Find
syntax on

autocmd CmdlineChanged [:\/\?] call wildtrigger()

func Find(arg, _)
        if empty(s:filescache)
                let s:filescache = globpath('.', '**', 1, 1)
                call filter(s:filescache, '!isdirectory(v:val)')
                call map(s:filescache, "fnamemodify(v:val, ':.')")
        endif
        return a:arg == '' ? s:filescache : matchfuzzy(s:filescache, a:arg)
endfunc

autocmd CmdlineEnter : let s:filescache = []

command! -nargs=+ -complete=customlist,<SID>Grep
                        \ Grep call <SID>VisitFile()

func s:Grep(arglead, cmdline, cursorpos)
        if match(&grepprg, '\$\*') == -1 
                let &grepprg ..= ' $*'
        endif
        let cmd = substitute(&grepprg, '\$\*', shellescape(escape(a:arglead, '\')), '')
        return len(a:arglead) > 1 ? systemlist(cmd) : []
endfunc

let s:selected = 0

func s:VisitFile()
        let qflist = getqflist()
        if empty(qflist) || s:selected >= len(qflist)
                echo "No valid quickfix item selected"
                return
        endif
        let item = qflist[s:selected]
        if bufexists(item.bufnr)
                execute 'buffer' item.bufnr
                call setpos('.', [0, item.lnum, item.col, 0])
                call setbufvar(item.bufnr, '&buflisted', 1)
        else
                echo "Buffer doesn't exist"
        endif
endfunc

nmap <M-u> :b 
nmap <M-o> :find 
nmap <M-i> :Grep 
nmap <M-e> :Ex<Cr> 

nmap <M-w> "+y
nmap <M-w><M-w> "+yy
nmap <M-S-w> "+Y

nmap <M-y> "+p
nmap <M-S-y> "+P
