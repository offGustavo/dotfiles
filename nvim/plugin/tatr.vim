function! s:Tatr(args) abort
  call setqflist([], ' ', {
        \ 'title': 'tatr ' . a:args,
        \ 'lines': systemlist('tatr ' . a:args),
        \ })
  copen
endfunction

command! -nargs=* -complete=file Tatr call s:Tatr(<q-args>)

if g:tatr_short_cmd
  command! -nargs=* -complete=file TT call s:Tatr(<q-args>)
endif
