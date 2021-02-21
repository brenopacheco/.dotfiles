if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

set nobuflisted

"compiler csslint
"setlocal equalprg=
"setlocal foldmethod=
"setlocal foldmarker=
"setlocal foldexpr=
"setlocal formatoptions=
"setlocal textwidth=
"setlocal comments=
"setlocal commentstring=
"setlocal suffixesadd=
"setlocal keywordprg=
"setlocal iskeyword+=

" let b:undo_ftplugin="setl mp< efm< ep< fdm< fmr< fde fo< tw< com< cms< sua< kp< isk<"


" original

let b:undo_ftplugin = "set stl<"
setlocal stl=%t%{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P

function! s:setup_toc() abort
  if get(w:, 'quickfix_title') !~# '\<TOC$' || &syntax != 'qf'
    return
  endif

  let list = getloclist(0)
  if empty(list)
    return
  endif

  let bufnr = list[0].bufnr
  setlocal modifiable
  silent %delete _
  call setline(1, map(list, 'v:val.text'))
  setlocal nomodifiable nomodified
  let &syntax = getbufvar(bufnr, '&syntax')
endfunction

augroup qf_toc
  autocmd!
  autocmd Syntax <buffer> call s:setup_toc()
augroup END
