" ============
" Settings
" ============

setl commentstring=;;\ %s
setl foldmethod=indent
setl iskeyword=@,48-57,192-255,$,#

" TODO: Use Compiler Here?
compiler cargo 

" Make kanata check the current file 
setl makeprg=kanata\ --check\ --cfg\ %

"" Match miette location header: ╭─[file:line:col]
"" Capture message on the following line starting with: 1 │ ...
"" Capture trailing `help: ...` line if present
"setl errorformat=
"      \%E\s*╭─[%f:%l:%c]%,
"      \%C\s*%*\\d\ │\ %m,
"      \%C\s*·%.%#,
"      \%C\s*╰────%,
"      \%C\s*help:\ %m,
"      \%-ZFor\ more\ info%.%#,
"      \%-G%.%#

let b:undo_ftplugin = "setlocal foldmethod< commentstring< iskeyword<"
