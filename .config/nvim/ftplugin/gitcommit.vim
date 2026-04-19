setlocal nornu nonu 
setlocal signcolumn=no
setlocal colorcolumn=50,72
setlocal textwidth=72

nmap <C-c><C-c> :wq<Cr>
imap <C-c><C-c> <C-o>:wq<Cr>
nmap <C-c><C-k> :qa!<Cr>
imap <C-c><C-k> <C-o>:qa!<Cr>
