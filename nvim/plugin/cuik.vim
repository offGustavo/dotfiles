" plugin/cuik.vim
"
" Run a shell command and stream its output into the quickfix list.
" Works on Vim 8.1.1418+ and Neovim 0.5+.
"
" Configure (before this file is sourced) with:
"   let g:cuik = {'run_async': v:true}
" or from Lua:
"   vim.g.cuik = { run_async = true }

if exists('g:loaded_cuik')
  finish
endif

if has('nvim') ? !has('nvim-0.5') : !has('patch-8.1.1418')
  echohl WarningMsg
  echom 'cuik: requires Vim 8.1.1418+ or Neovim 0.5+'
  echohl None
  finish
endif

let g:loaded_cuik = 1

let s:save_cpo = &cpo
set cpo&vim

" ---------------------------------------------------------------------------
" Default config. User values win; only missing keys are filled in.
" ---------------------------------------------------------------------------
if type(get(g:, 'cuik', 0)) != v:t_dict
  let g:cuik = {}
endif

call extend(g:cuik, {
      \ 'default_cmd': '',
      \ 'run_async': v:false,
      \ 'open_qf': v:true,
      \ 'auto_scroll': v:true,
      \ 'prompt': '$ ',
      \ 'short_cmds': v:false,
      \ 'really_short_cmds': v:false,
      \ }, 'keep')

" ---------------------------------------------------------------------------
" Commands
" ---------------------------------------------------------------------------
command! -nargs=* -complete=shellcmd CuikCompile      call cuik#compile(<q-args>)
command! -nargs=* -complete=shellcmd CuikCompileAsync call cuik#compile_async(<q-args>)
command! -nargs=* -complete=shellcmd CuikCompileSync  call cuik#compile_sync(<q-args>)
command! CuikRecompile call cuik#recompile()
command! CuikKill      call cuik#kill()

if g:cuik.short_cmds
  command! -nargs=* -complete=shellcmd CCompile      call cuik#compile(<q-args>)
  command! -nargs=* -complete=shellcmd CAsync call cuik#compile_async(<q-args>)
  command! -nargs=* -complete=shellcmd CSync  call cuik#compile_sync(<q-args>)
  command! CRecompile call cuik#recompile()
  command! CKill      call cuik#kill()
endif

if g:cuik.really_short_cmds
  command! -nargs=* -complete=shellcmd CC      call cuik#compile(<q-args>)
  command! -nargs=* -complete=shellcmd CA      call cuik#compile_async(<q-args>)
  command! -nargs=* -complete=shellcmd CS      call cuik#compile_sync(<q-args>)
  command! CR  call cuik#recompile()
  command! CK  call cuik#kill()
endif

let &cpo = s:save_cpo
unlet s:save_cpo
