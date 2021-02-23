" File: autoload#wrappers.vim
" Author: brenoleonhardt@gmail.com
" Description: wrappers for FZF. call fzf#run([wrapper])
" Last Modified: February 22, 2021

" SNIPPETS ==============================================================={{{
fun! s:source_snippets()
    let l:sources = eval(join(vsnip#source#find(bufnr('%')), '+'))
    return sort(map(l:sources, { _,s -> printf('%-15s%-20s%-30s', 
        \ s.prefix[0],  s.label, s.description)}))
endf

fun! s:sink_snippet(snippet)
    let prefix = matchstr(a:snippet, '^\S\+')
    exec 'norm i' . prefix . "\<plug>(vsnip-expand)"
endf

fun! wrappers#snippets()
    return fzf#wrap({
        \ 'source': s:source_snippets(),
        \ 'sink': function('s:sink_snippet')
        \ })
endf
" }}}
" ARGS ==================================================================={{{
fun! wrappers#args()
    return fzf#wrap({
        \ 'source':argv(),
        \ 'sink':'e'
        \ })
endf
" }}}
" PROJECT ================================================================{{{
fun! wrappers#project()
    return fzf#wrap({
        \ 'source':systemlist('fd "" -H -j2 ' . utils#root()),
        \ 'sink':'e',
        \ 'options': '--prompt "Project > " --preview "bat --color=\"always\" --plain {}"'
        \ })
endf
" }}}
" CLASSES ================================================================{{{
let g:extensions = 'jsx|js|tsx|ts|java|c|cpp|html|css'
fun! wrappers#classe()
    return fzf#wrap({
        \   'source': 'fd "('.g:extensions.')$" -t f ' . utils#root(),
        \   'sink': 'e',
        \   'options': '--prompt "> " --preview "bat --color=\"always\" --plain {}"'
        \})
endf
" }}}
