fun! vjs#ipc#SendMessage(message)
  if exists('g:vjs_test_env')
    let response = system(s:GetServerExecPath().' refactoring --single-run', a:message)
    call vjs#extract#RefactoringResponseHandler(0, response)
  else
    let channel = s:JobGetChannel(s:refactoring_server_job)
    call s:ChSend(channel, a:message . nr2char(10))
  endif
endf

fun! vjs#ipc#StartJsRefactoringServer()
  if !exists('g:vjs_test_env') && !exists('s:refactoring_server_job')
    let s:refactoring_server_job = s:JobStart(s:GetServerExecPath().' refactoring', {'err_cb': function('s:ErrorCb'), 'out_cb': function('vjs#extract#RefactoringResponseHandler')})
  endif
endf

fun! vjs#ipc#StartJsTagsServer()
  if !exists('g:vjs_test_env') && !exists('s:tags_server_job') && g:vjs_tags_enabled == 1
    let tags_job_cmd = s:GetServerExecPath().' tags'
    if g:vjs_tags_regenerate_at_start == 0
      let tags_job_cmd = tags_job_cmd.' --update'
    endif
    for path in g:vjs_tags_ignore
      let tags_job_cmd = tags_job_cmd.' --ignore '.path
    endfor

    " without `out_cb` must be present
    let s:tags_server_job = s:JobStart(tags_job_cmd, {'cwd': getcwd(), 'err_cb': 's:ErrorCb', 'out_cb': 's:ErrorCb', 'pty': 1})
  end
endf

fun! s:ChSend(channel, msg)
  if has('nvim')
    return chansend(a:channel.id, a:msg)
  else
    return ch_sendraw(a:channel, a:msg)
  endif
endf

fun! s:JobGetChannel(channel)
  if has('nvim')
    return nvim_get_chan_info(a:channel)
  else
    return job_getchannel(a:channel)
  endif
endf

fun! s:ErrorCb(channel, message, ...)
  echom 'Vjs language server error: '.string(a:message)
endf

fun! s:JobStart(cmd, options)
  if has('nvim')
    let options = a:options
    let options.on_stdout = options.out_cb
    let options.on_stderr = options.err_cb
    " let options.stdout_buffered = v:true
    " let options.stderr_buffered = v:true
    return jobstart(a:cmd, options)
  else
    return job_start(a:cmd, a:options)
  endif
endf

let s:s_path = resolve(expand('<sfile>:p:h:h'). '/..')

fun s:GetServerExecPath()
  let platform = substitute(system('uname'), '\n', '', '')

  if exists('g:vjs_test_env')
    return s:s_path .'/js_language_server.js'
  endif

  let server_bin = ''
  if platform == 'Darwin'
    let server_bin = s:s_path.'/dist/js_language_server'
  else
    let server_bin = 'node '.s:s_path.'/dist/js_language_server.js'
  endif

  return server_bin
endf