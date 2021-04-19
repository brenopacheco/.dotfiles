" File: zeal.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: March 11, 2021
" Description:
"
if exists('g:loaded_zeal_plugin')
    finish
endif
let g:loaded_zeal_plugin = 1

command! -nargs=1 Zeal  call Zeal(<q-args>)

au FileType * set keywordprg=:Zeal

let g:zeal = {
    \    "html": "html,tailwindcss",
    \    "javascript": "javascript,react,node,express",
    \    "typescript": "typescript,react,node,express",
    \}

""
" Opens zeal document
" {keyword} keyword to look for
" [docset] docset to use
fun! Zeal(keyword,...)
    if &ft ==# 'vim'
        silent! exec 'help ' . a:keyword
        return
    endif
    let docset = get(g:zeal, &ft, a:0 > 0 ? a:1 : &ft)
    silent! exec '!zeal "' . docset . ':' . a:keyword . '"'
endf
