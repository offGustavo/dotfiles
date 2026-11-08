function! kitty#setup() abort
  nmap q <Cmd>qa!<CR>
  xmap q <Cmd>qa!<CR>
  set clipboard=unnamed,unnamedplus
  set readonly
  set laststatus=0
  set nonumber
  set norelativenumber
  set signcolumn=no
  set nocursorline
  set cmdheight=0
  autocmd TextYankPost * silent! lua vim.hl.hl_op({ higroup='Search', timeout=100 })
endfunction

