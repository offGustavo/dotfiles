vim.api.nvim_create_user_command("Tatr", function(opts)
  local commands = require("Tatr.commands").commands
  for _, v in pairs(commands) do
    if opts.fargs[1] == v.name then
      v.fun(opts)
      return
    end
  end

  vim.notify(
    [[
  -- Not a Tatr Command.
  Run :Tatr help to see all commands or :h Tatr-commands
  ]],
    vim.log.levels.WARN
  )

  -- Run help
  commands[1].fun()
end, {
  nargs = "*",
  complete = function()
    return require("Tatr.commands").complete()
  end,
})

vim.cmd [[
function! s:Tatr(args) abort
  let l:output = systemlist('tatr ' . a:args)

  if v:shell_error != 0 && empty(l:output)
    echohl ErrorMsg
    echom 'tatr failed with exit code ' . v:shell_error
    echohl None
    return
  endif

  call setqflist([], ' ', {
        \ 'title': 'tatr ' . a:args,
        \ 'lines': l:output,
        \ })
  copen
endfunction

command! -nargs=* -complete=file Ta call s:Tatr(<q-args>)
]]
