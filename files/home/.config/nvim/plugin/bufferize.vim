if exists('g:loaded_bufferize_plugin')
    finish
endif
let g:loaded_bufferize_plugin = 1

command! -nargs=* -complete=command Bufferize call s:Bufferize(<f-args>)
function! s:Bufferize(...)
  let cmd = join(a:000, ' ')
  redir => output
    silent exe cmd
  redir END

  new
  setlocal nonumber
  call append(0, split(output, "\n"))
  set nomodified
endfunction
