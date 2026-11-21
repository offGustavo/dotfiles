" autoload/cuik.vim
"
" Implementation for cuik. Configuration lives in g:cuik, whose defaults are
" defined in plugin/cuik.vim. Supports both Vim (job_start) and Neovim
" (jobstart).

if exists('g:autoloaded_cuik')
  finish
endif
let g:autoloaded_cuik = 1

let s:save_cpo = &cpo
set cpo&vim

let s:is_nvim = has('nvim')

" last_cmd: last command that was run
" running:  1 while a job is active
" job:      Neovim job id, or Vim job object
" seq:      incremented per run, identifies the "current" job in callbacks
let s:state = {'last_cmd': '', 'running': 0, 'job': v:null, 'seq': 0}

" ---------------------------------------------------------------------------
" Default config. User values win; only missing keys are filled in.
" ---------------------------------------------------------------------------
if type(get(g:, 'cuik', 0)) != v:t_dict
  let g:cuik = {}
endif

call extend(g:cuik, {
      \ 'default_cmd': '',
      \ 'run_async': v:true,
      \ 'open_qf': v:true,
      \ 'auto_scroll': v:true,
      \ 'prompt': '$ ',
      \ 'short_cuik_cmds': v:false,
      \ }, 'keep')


" ---------------------------------------------------------------------------
" Helpers
" ---------------------------------------------------------------------------

function! s:warn(msg) abort
  echohl WarningMsg | echom 'cuik: ' . a:msg | echohl None
endfunction

function! s:error(msg) abort
  echohl ErrorMsg | echom 'cuik: ' . a:msg | echohl None
endfunction

" Ask the user for a command.
function! s:get_user_cmd() abort
  let l:default = s:state.last_cmd !=# '' ? s:state.last_cmd : g:cuik.default_cmd
  " 'shellcmdline' completion is not available in every Vim version
  let l:completion = s:is_nvim ? 'shellcmdline' : 'shellcmd'
  return input(g:cuik.prompt, l:default, l:completion)
endfunction

" Append lines to a specific quickfix list (by id).
function! s:append(qf_id, lines) abort
  if empty(a:lines)
    return
  endif

  call setqflist([], 'a', {'id': a:qf_id, 'lines': a:lines})

  if g:cuik.auto_scroll
    let l:winid = getqflist({'id': a:qf_id, 'winid': 0}).winid
    if l:winid != 0 && l:winid != win_getid()
      call win_execute(l:winid, 'keepjumps normal! G')
    endif
  endif
endfunction

" Called once when the job is completely done (all output delivered).
function! s:finish(seq, Emit, code) abort
  if s:state.seq == a:seq
    let s:state.running = 0
    let s:state.job = v:null
  endif
  call a:Emit([
        \ '',
        \ a:code == 0 ? 'Compilation finished'
        \             : 'Compilation exited abnormally with code ' . a:code,
        \ ])
endfunction

" ---------------------------------------------------------------------------
" Neovim backend
" ---------------------------------------------------------------------------

" jobstart hands us chunks where the first item continues the previous
" chunk's last (partial) line, so buffer it until a newline arrives.
function! s:new_collector(Emit) abort
  let l:c = {'partial': '', 'emit': a:Emit}

  function! l:c.handle(data) abort dict
    if empty(a:data)
      return
    endif
    let l:data = copy(a:data)
    let l:data[0] = self.partial . l:data[0]
    " last item is an unfinished line (or '' at EOF)
    let self.partial = remove(l:data, -1)
    let l:lines = map(l:data, {_, v -> substitute(v, '\r$', '', '')})
    call call(self.emit, [l:lines])
  endfunction

  function! l:c.flush() abort dict
    if self.partial !=# ''
      call call(self.emit, [[substitute(self.partial, '\r$', '', '')]])
      let self.partial = ''
    endif
  endfunction

  return l:c
endfunction

function! s:nvim_exit(out, err, Done, code) abort
  call a:out.flush()
  call a:err.flush()
  call a:Done(a:code)
endfunction

" Returns the job id, or v:null on failure.
function! s:start_nvim(cmd, Emit, Done) abort
  let l:out = s:new_collector(a:Emit)
  let l:err = s:new_collector(a:Emit)
  let l:Done = a:Done

  let l:id = jobstart(a:cmd, {
        \ 'on_stdout': {j, d, e -> l:out.handle(d)},
        \ 'on_stderr': {j, d, e -> l:err.handle(d)},
        \ 'on_exit': {j, code, e -> s:nvim_exit(l:out, l:err, l:Done, code)},
        \ })

  return l:id > 0 ? l:id : v:null
endfunction

" ---------------------------------------------------------------------------
" Vim backend
" ---------------------------------------------------------------------------

" In Vim, exit_cb can fire before all output has been read, so the job is only
" considered done once both the process exited and the channel closed.
function! s:vim_event(st, which, code) abort
  let a:st[a:which] = 1
  if a:which ==# 'exited'
    let a:st.code = a:code
  endif
  if a:st.exited && a:st.closed
    call a:st.done(a:st.code)
  endif
endfunction

" Returns the job object, or v:null on failure.
function! s:start_vim(cmd, Emit, Done) abort
  let l:st = {'exited': 0, 'closed': 0, 'code': 0, 'done': a:Done}
  let l:Emit = a:Emit

  try
    let l:job = job_start([&shell, &shellcmdflag, a:cmd], {
          \ 'in_io': 'null',
          \ 'out_io': 'pipe',
          \ 'err_io': 'out',
          \ 'out_mode': 'nl',
          \ 'noblock': 1,
          \ 'out_cb': {ch, msg -> l:Emit([substitute(msg, '\r$', '', '')])},
          \ 'close_cb': {ch -> s:vim_event(l:st, 'closed', 0)},
          \ 'exit_cb': {j, status -> s:vim_event(l:st, 'exited', status)},
          \ })
  catch
    return v:null
  endtry

  return job_status(l:job) ==# 'fail' ? v:null : l:job
endfunction

" ---------------------------------------------------------------------------
" Public API
" ---------------------------------------------------------------------------

" Last command that was run.
function! cuik#last_cmd() abort
  return s:state.last_cmd
endfunction

" Stop the running command, if any.
function! cuik#kill() abort
  if !s:state.running || s:state.job is v:null
    return
  endif
  if s:is_nvim
    call jobstop(s:state.job)
  else
    call job_stop(s:state.job)
  endif
endfunction

" Block until the run identified by seq is finished (Ctrl-C stops the job).
function! s:wait(seq) abort
  try
    if s:is_nvim && s:state.job isnot v:null
      call jobwait([s:state.job], -1)
    endif
    while s:state.running && s:state.seq == a:seq
      sleep 10m
    endwhile
  catch /^Vim:Interrupt$/
    call cuik#kill()
  endtry
endfunction

" cuik#compile([cmd [, opts]])
"   cmd:  command to run; prompts when omitted/empty
"   opts: {'async': v:true|v:false} overrides g:cuik.run_async for this call
function! cuik#compile(...) abort
  let l:cmd = a:0 >= 1 ? a:1 : ''
  let l:opts = a:0 >= 2 ? a:2 : {}

  if l:cmd ==# ''
    let l:cmd = s:get_user_cmd()
  endif

  if l:cmd ==# ''
    call s:warn('empty command, operation canceled')
    return
  endif

  let l:async = get(l:opts, 'async', g:cuik.run_async)

  " Only one job at a time: replace the previous one.
  if s:state.running
    echom 'cuik: stopping previous command'
    call cuik#kill()
  endif

  call setqflist([], ' ', {'title': l:cmd, 'lines': ['Compilation started', '']})
  let l:qf_id = getqflist({'id': 0}).id

  if g:cuik.open_qf
    copen
    wincmd p " keep focus where the user was
  endif

  let s:state.seq += 1
  let l:seq = s:state.seq

  let l:Emit = {lines -> s:append(l:qf_id, lines)}
  let l:Done = {code -> s:finish(l:seq, l:Emit, code)}

  let l:job = s:is_nvim
        \ ? s:start_nvim(l:cmd, l:Emit, l:Done)
        \ : s:start_vim(l:cmd, l:Emit, l:Done)

  if l:job is v:null
    call l:Emit(['Failed to start command: ' . l:cmd])
    call s:error('failed to start `' . l:cmd . '`')
    return
  endif

  let s:state.job = l:job
  let s:state.running = 1
  let s:state.last_cmd = l:cmd

  if !l:async
    " Blocks the editor until the job ends; output callbacks still run
    " while waiting, so the quickfix list is filled as usual.
    call s:wait(l:seq)
  endif
endfunction

" Run a command without blocking the editor.
function! cuik#compile_async(...) abort
  call cuik#compile(a:0 ? a:1 : '', {'async': v:true})
endfunction

" Run a command and block until it finishes.
function! cuik#compile_sync(...) abort
  call cuik#compile(a:0 ? a:1 : '', {'async': v:false})
endfunction

" Re-run the last command.
function! cuik#recompile() abort
  if s:state.last_cmd ==# ''
    call s:warn('no previous command to re-run')
    return
  endif
  call cuik#compile(s:state.last_cmd)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
