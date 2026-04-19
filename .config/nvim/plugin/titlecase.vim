" https://github.com/christoomey/vim-titlecase/blob/master/plugin/titlecase.vim

" plugin/titlecase.vim

if exists('g:loaded_titlecase')
  finish
endif
let g:loaded_titlecase = 1

nnoremap <silent> <Plug>Titlecase
      \ <Cmd>set opfunc=titlecase#titlecase<CR>g@
xnoremap <silent> <Plug>Titlecase
      \ <Cmd>call titlecase#titlecase(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
nnoremap <silent> <Plug>TitlecaseLine
      \ <Cmd>set opfunc=titlecase#titlecase<Bar>exe 'normal! ' . v:count1 . 'g@_'<CR>

if !hasmapto('<Plug>Titlecase', 'n') && maparg('gz', 'n') ==# ''
  nmap gz <Plug>Titlecase
endif
if !hasmapto('<Plug>Titlecase', 'x') && maparg('gz', 'x') ==# ''
  xmap gz <Plug>Titlecase
  xmap Z <Plug>Titlecase
endif
if !hasmapto('<Plug>TitlecaseLine', 'n') && maparg('gzz', 'n') ==# ''
  nmap gzz <Plug>TitlecaseLine
endif
