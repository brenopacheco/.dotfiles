fun! narrow#narrow_region(bufnr) range abort
    let start = a:firstline > a:lastline ? a:lastline : a:firstline
    let end = a:firstline > a:lastline ? a:firstline : a:lastline
    let b:narrowed = v:true
    let b:narrow = { 
        \   "pretext": getbufline(a:bufnr, 0, start -  1), 
        \   "range": { 
        \     "start": start,
        \     "end": end
        \   },
        \   "aftertext": getbufline(a:bufnr, end + 1, line('$')), 
        \ }
    exec 'augroup Narrow_' . a:bufnr . ' | au! | '
        \ . 'au BufWritePre <buffer='.a:bufnr.'> call narrow#widen('.a:bufnr.')'
        \ . ' | augroup END'
    call deletebufline(a:bufnr, end+1, line('$'))
    call deletebufline(a:bufnr, 1, start-1)
    " TODO: remove last two undos?
    echomsg 'Narroed ' . bufname(a:bufnr)
endf

fun! narrow#widen(bufnr) abort
    if (!b:narrowed)
        echoerr "Buffer is not narrowed."
    endif
    call append(0, b:narrow.pretext)
    call append(line('$'), b:narrow.aftertext)
    let b:narrowed = v:null
    let b:narrow = v:null
    exec 'aug! Narrow_' . a:bufnr
    echomsg 'Widened ' . bufname(a:bufnr)
endf
