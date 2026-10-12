function! s:Tatr(args) abort
  call setqflist([], ' ', {
        \ 'title': 'tatr ' . a:args,
        \ 'lines': systemlist('tatr ' . a:args),
        \ })
  copen
endfunction

command! -nargs=* -complete=file TT call s:Tatr(<q-args>)

"vim.api.nvim_create_user_command("TT", function(o)
"  vim.fn.setqflist({}, " ", { title = "tatr " .. o.args, lines = vim.fn.systemlist("tatr " .. o.args) })
"  vim.cmd.copen()
"end, { nargs = "*" })

