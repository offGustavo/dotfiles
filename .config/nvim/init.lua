-- Map Leader and Local Leader
vim.cmd([[
  " <space> as leader
  let g:mapleader = " "
  " <space><space> as local leader
  let g:maplocalleader = "  "
]])

-- Our Global thing
_G.fish = {}

-- Set a temp theme here to prevent light/dark flicker
if vim.o.background == "dark" then
  vim.cmd.colorscheme("tokyo")
else
  vim.cmd.colorscheme("tokyo-day")
end

-- Basic keymaps for Nvim (if lazy fails for some reason)
vim.cmd([[

"set findfunc=Find
"func Find(arg, _)
"  if empty(s:filescache)
"    let s:filescache = globpath('.', '**', 1, 1)
"    call filter(s:filescache, '!isdirectory(v:val)')
"    call map(s:filescache, "fnamemodify(v:val, ':.')")
"  endif
"    return a:arg == '' ? s:filescache : matchfuzzy(s:filescache, a:arg)
"endfunc

"let s:filescache = []
"
"autocmd CmdlineEnter : let s:filescache = []
"
"
"command! -nargs=+ -complete=customlist,<SID>Grep
"  \ Grep call <SID>VisitFile()
"
"func s:Grep(arglead, cmdline, cursorpos)
"if match(&grepprg, '\$\*') == -1 | let &grepprg ..= ' $*' | endif
"  let cmd = substitute(&grepprg, '\$\*', shellescape(escape(a:arglead, '\')), '')
"  return len(a:arglead) > 1 ? systemlist(cmd) : []
"  endfunc
"
"  func s:VisitFile()
"  let item = getqflist(#{lines: [s:selected]}).items[0]
"  let pos  = '[0,\ item.lnum,\ item.col,\ 0]'
"  exe $':b +call\ setpos(".",\ {pos}) {item.bufnr}'
"  call setbufvar(item.bufnr, '&buflisted', 1)
"  endfunc
"
"autocmd CmdlineLeavePre :
"  \ if get(cmdcomplete_info(), 'matches', []) != [] |
"  \   let s:info = cmdcomplete_info() |
"  \   if getcmdline() =~ '^\s*fin\%[d]\s' && s:info.selected == -1 |
"  \     call setcmdline($'find {s:info.matches[0]}') |
"  \   endif |
"  \   if getcmdline() =~ '^\s*Grep\s' |
"  \     let s:selected = s:info.selected != -1
"  \         ? s:info.matches[s:info.selected] : s:info.matches[0] |
"  \     call setcmdline(s:info.cmdline_orig) |
"  \   endif |
"  \ endif

nmap <M-o> :fin<Space>
nmap <M-s> :grep<Space>
nmap <M-b> :b<Space>
nmap <M-e> :Ex<Cr>
]])

-- Disable Custom Nix/Arch FZF.vim
vim.cmd("let g:loaded_fzf = 1")

-- Load Lazy.nvim and external plugins
require("config.lazy")
-- require("config.pack")

-- Intern Plugins
require("intern")

-- Vim options
require("config.options")
require("config.clipboard")
require("config.marks")
require("config.autocmds")
require("config.spell")
require("config.window")

require("config.commands")

-- Keymaps
require("config.keymaps")
require("config.toggle")
require("config.git")

-- Ui
require("config.ui")
--
-- -- LSP
require("config.lsp")
