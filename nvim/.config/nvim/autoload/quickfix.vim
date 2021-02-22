" File: autoload#quickfix.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description: 
"
fun! quickfix#global_search()
    
endf

fun! quickfix#global_star()
    
endf


fun! quickfix#buffer_search()
    
endf

fun! quickfix#buffer_star()
    
endf

fun! quickfix#next()
    
endf

fun! quickfix#prev()
    
endf

fun! quickfix#filter(pat)
    let all = getqflist()
    for d in all
      if bufname(d['bufnr']) !~ a:pat && d['text'] !~ a:pat
          call remove(all, index(all,d))
      endif
    endfor
    call setqflist(all)
endf

