" File: autoload#wrappers.vim
" Author: brenoleonhardt@gmail.com
" Description: wrappers for FZF. call fzf#run([wrapper])
" Last Modified: February 22, 2021
" Adding sink disables the g:fzf_action
" To override it, do it in the wrapper

" HELPERS ===================================================================
fun! s:override(actions)
    let old_actions = deepcopy(g:fzf_action)
    let g:fzf_action = a:actions
    call timer_start(1000, { _ -> old_actions })
endf

fun! s:options(preview, relative)
    let opt = ''
    if a:preview
        let opt .= '--prompt "> " --preview "bat --color=\"always\" --plain {}"'
    endif
    if a:relative
        let opt .= ' --with-nth='.(len(split(utils#git_root(), '/'))+1).'..'.' -d "/"'
    endif
    return opt
endf

" SNIPPETS ==============================================================={{{
fun! s:source_snippets()
    let l:sources = eval(join(vsnip#source#find(bufnr('%')), '+'))
    return uniq(sort(map(l:sources, { _,s -> printf('%-15s%-20s%-30s',
        \ s.prefix[0],  s.label, s.description)})))
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
        \ 'options': s:options(v:true, v:false)
        \ })
endf
" }}}
" PROJECT ================================================================{{{
fun! wrappers#files(pat, dir)
    return fzf#wrap({
        \ 'source': utils#files(a:pat, a:dir),
        \ 'options': s:options(v:true, v:true)
        \ })
endf
" }}}
" SOURCES ================================================================{{{
fun! wrappers#sources()
    return fzf#wrap({
        \   'source': utils#files(globals#get('extensions')),
        \   'options': s:options(v:true, v:true)
        \})
endf
" }}}
