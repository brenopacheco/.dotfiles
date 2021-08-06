if exists('g:loaded_lf_plugin')
    finish
endif
let g:loaded_lf_plugin = 1

let s:selection_path = ''
let s:last_buffer = 0

command! Lf call <SID>open()

function! s:exit(job_id, code, event)
    if a:code == 0
        let buffer = bufnr()
        " silent exec s:last_buffer . 'b'
        silent exec buffer . 'bw!'
    endif
    try
      if filereadable(s:selection_path)
        for f in readfile(s:selection_path)
          silent exec 'edit ' . f
        endfor
        silent call delete(s:selection_path)
      endif
    endtry
endfunction

function! s:open()
  try
      let s:selection_path = tempname()
      let s:last_buffer = bufnr()
      let currentPath = getcwd()
      let cmd = 'lf -selection-path='. s:selection_path . ' ""'
      enew | call termopen(cmd, { 'on_exit': funcref('s:exit') })
      set ft=lf
      startinsert
  endtry
endfun

