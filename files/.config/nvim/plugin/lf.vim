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
      let width = float2nr(&columns * 0.9)
      let height = float2nr(&lines * 0.9)
      let opts = {
          \ 'relative': "editor",
          \ 'width': float2nr(&columns * 0.9),
          \ 'height' : float2nr(&lines * 0.9),
          \ 'row': float2nr((&lines - height) / 2) - 1 ,
          \ 'col': float2nr((&columns - width)  / 2),
          \ 'border': 'double'
          \ }
      let buf = nvim_create_buf(v:false, v:true)
      let win = nvim_open_win(buf, v:true, opts)
      call setwinvar(win, '&winhl', 'Normal:Pmenu')
      setlocal
            \ buftype=nofile
            \ nobuflisted
            \ bufhidden=hide
            \ nonumber
            \ norelativenumber
            \ signcolumn=no
      let cmd = 'lf -selection-path='. s:selection_path . ' ""'
      call termopen(cmd, { 'on_exit': funcref('s:exit') })
      tunmap <buffer> jk
      tunmap <buffer> kj
      tunmap <buffer> <Esc>
      tunmap <buffer> <C-[>
      redraw!
      " startinsert " TODO: maybe callback?
  endtry
endfun

