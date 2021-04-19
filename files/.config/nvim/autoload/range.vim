" File: range.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 27, 2021
" Description: auxiliary functions for running a function given a range.
" Any range is valid (v, ^V, V).
" Example usage:
" command! -range Echo call range#run({ text -> execute('echomsg ' . text) })

command! -nargs=0 -range Echo echomsg range#run({ text -> text })

""
" Run a function using the text from the last visual selection.
" Returns whatever callback function returns
" [required] callback: funcref
fun! range#run(callback) range
    let selection = range#text()
    return a:callback(selection)
endf

""
" Returns the text from the last visual selection.
fun! range#text()
    let range = { 'bufnr': bufnr() }
    let [_, range.line_start, range.col_start, _] = getpos("'<")
    let [_, range.line_end,   range.col_end,   _] = getpos("'>")
    if mode() !=# 'n'
        let mode = mode()
    else
        let mode  = visualmode()
    endif
    if mode ==# 'v'
        return s:charwise_visual(range)
    elseif mode ==# 'V'
        return s:linewise_visual(range)
    elseif mode ==# "\<C-v>"
        return s:blockwise_visual(range)
    endif
    throw 'Invalid mode.'
endf

fun! s:blockwise_visual(range)
    let lines = getbufline(a:range.bufnr, a:range.line_start, a:range.line_end)
    return join(map(lines,
        \ { _,s -> s[a:range.col_start-1:a:range.col_end-1] }), "\n")
endf

fun! s:charwise_visual(range)
    let lines = getbufline(a:range.bufnr, a:range.line_start, a:range.line_end)
    let text  = join(lines, "\n")
    let delta = len(lines[-1]) - a:range.col_end + 1
    return text[a:range.col_start-1:-delta]
endf

fun! s:linewise_visual(range)
    return join(getbufline(a:range.bufnr,
        \ a:range.line_start, a:range.line_end), "\n")
endf

