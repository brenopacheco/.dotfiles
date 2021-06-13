" File: range.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 27, 2021
" Description: auxiliary functions for running a function given a range.
" Any range is valid (v, ^V, V).

""
" Get the start and end position of a visual selection.
" If not in visual mode, returns the last visual selection
fun! range#get() range
    " if mode() !=? 'v' && mode() !=# "\<C-v>"
    "     throw 'Not in visual mode'
    " endif
    if mode() ==? 'v' || mode() ==# "\<C-v>"
        exe "normal! \<ESC>"
    endif
    let start = getpos("'<")
    let end   = getpos("'>")
    if end[1] < start[1]
        let tmp = end
        let end = start
        let start = end
    endif
    let pos = 
        \ {
        \   'start': {
        \     'lnum': start[1],
        \     'col':  start[2]
        \   },
        \   'end': {
        \      'lnum': end[1],
        \      'col':  end[2]
        \   },
        \   'bufnr': bufnr()
        \ }
    normal! gv
    return pos
endf

""
" Run a function using the text from the last visual selection.
" Returns whatever callback function returns
" Example: 
"   > xnoremap v <cmd>call range#run({text -> execute('!'.text', "")})<CR>
"   > xnoremap v <cmd>echo range#run({text -> toupper(text)})<CR>
" [required] callback: funcref
fun! range#run(callback) range
    let selection = range#text()
    return a:callback(selection)
endf

""
" Returns the text from the last visual selection.
" Example:
"   > xnoremap v <cmd>echo range#text()<CR>
fun! range#text() range
    let b:range = range#get()
    let text = ''
    if mode() ==# 'v'
        let text = s:charwise_visual(b:range)
    elseif mode() ==# 'V'
        let text = s:linewise_visual(b:range)
    elseif mode() ==# "\<C-v>"
        let text = s:blockwise_visual(b:range)
    endif
    return text
endf

fun! s:blockwise_visual(range)
    let lines = getbufline(a:range.bufnr, a:range.start.lnum, a:range.end.lnum)
    return join(map(lines,
        \ { _,s -> s[a:range.start.col-1:a:range.end.col-1] }), "\n")
endf

fun! s:charwise_visual(range)
    let lines = getbufline(a:range.bufnr, a:range.start.lnum, a:range.end.lnum)
    let text  = join(lines, "\n")
    let delta = len(lines[-1]) - a:range.end.col + 1
    return text[a:range.start.col-1:-delta]
endf

fun! s:linewise_visual(range)
    return join(getbufline(a:range.bufnr,
        \ a:range.start.lnum, a:range.end.lnum), "\n")
endf
