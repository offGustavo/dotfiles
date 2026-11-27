setlocal nornu nonu 
setlocal signcolumn=no
setlocal colorcolumn=50,72
setlocal textwidth=72

nmap <buffer> <C-c><C-c> :x<Cr>
imap <buffer> <C-c><C-c> <C-o>:x<Cr>
nmap <buffer> <C-c><C-k> :q!<Cr>
imap <buffer> <C-c><C-k> <C-o>:q!<Cr>

startinsert
