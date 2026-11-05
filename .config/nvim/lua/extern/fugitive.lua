vim.cmd[[
packadd vim-fugitive 

let g:fugitive_legacy_commands = v:false

nmap <M-G> :Git<Cr>
nmap <leader>gl :Git log<Cr>
]]


