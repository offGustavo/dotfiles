-- {{{ Kitty scroll mode
vim.cmd([[
	nmap q <Cmd>qa!<CR>
	xmap q <Cmd>qa!<CR> 
	nnoremap yy "+yy<Cmd>qa!<Cr>
	nnoremap <space>y "+yy<Cmd>qa!<Cr>
	xmap y "+y<Cmd>qa!<Cr>
	xmap <space>y "+y<Cmd>qa!<Cr>
	set laststatus=0 nonu nornu signcolumn=no cursorline cmdheight=0
	$ 
	]])
-- NOTE: Stop config here
-- }}}
