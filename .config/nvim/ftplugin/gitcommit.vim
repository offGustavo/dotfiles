setlocal nornu nonu 
setlocal signcolumn=no
setlocal colorcolumn=50,72
setlocal textwidth=72

nmap <buffer> <C-c><C-c> :wq<Cr>
imap <buffer> <C-c><C-c> <C-o>:wq<Cr>
nmap <buffer> <C-c><C-k> :qa!<Cr>
imap <buffer> <C-c><C-k> <C-o>:qa!<Cr>
