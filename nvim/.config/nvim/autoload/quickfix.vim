" File: autoload#quickfix.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description: 


" nnoremap <expr><leader>s ':%s/'.expand('<cword>').'/'.expand('<cword>').'/g<left><left>'
" xnoremap <leader>s "zy:%s/<c-r>z/<c-r>z/g<left><left>

" SEARCH ====================================================================

fun! quickfix#global_grep()
    call feedkeys(":grep! '' " . utils#root() . 
        \ '| copen | wincmd p' ."\<Home>".repeat("\<Right>", 7))
endf

""
" performs grep on all project files using word under cursor.
" may be called in visual mode. if in visual mode, map as <expr> 
fun! quickfix#global_star()
    if mode() ==# 'v'
        return "\"zy:grep! '\<C-r>z' " . utils#root() . 
            \ " \| copen \| wincmd p\<CR>"
    else
        let cmd = "grep! '".expand('<cword>')."' " . utils#root()
        echo cmd | exec cmd
        silent copen | wincmd p
    endif
endf

""
" performs vimgrep on the file. if file has no name, give 
" it an unique name
fun! quickfix#buffer_grep()
    call feedkeys(':vimgrep//j % | copen | wincmd p'.repeat("\<left>", 23))
endf

""
" performs vimgrep on the file using word under cursor.
" may be called in visual mode. if in visual mode, map as <expr> 
fun! quickfix#buffer_star() abort
    if mode() ==# 'v'
        return "\"zy:vimgrep/\<C-r>z/j % \| copen \| wincmd p\<CR>"
    else
        let cmd = 'vimgrep/'.expand('<cword>').'/j %'
        echo cmd | exec cmd
        silent copen | wincmd p
    endif
endf

""
" Filter quickdix list given a pattern
fun! quickfix#filter(pat)
    let all = getqflist()
    for d in all
      if bufname(d['bufnr']) !~ a:pat && d['text'] !~ a:pat
          call remove(all, index(all,d))
      endif
    endfor
    call setqflist(all)
endf

" NAVIGATE ==================================================================

fun! quickfix#next()
    try
        cnext
    catch 'E553: No more items'
        cfirst
    catch 'E42: No Errors'
        echomsg 'Quickfix is empty.'
    endtry
endf

fun! quickfix#prev()
    try
        cprev
    catch 'E553: No more items'
        clast
    catch 'E42: No Errors'
        echomsg 'Quickfix is empty.'
    endtry
endf

fun! quickfix#cnewer()
    silent! cnewer<CR>
endf

fun! quickfix#colder()
    silent! colder<CR>
endf

" DOODLES ===================================================================


" TODO: see later
" fun! quickfix#buffer_search()
"     let pat = input('vimgrep % /')
"     if expand('%') == ''
"         let bufnr = bufnr()
"         let tmpfile = fnamemodify(tempname(), ':h:t')
"         exec 'e ' . tmpfile
"         call appendbufline(bufnr(), 0, getbufline(bufnr, 1, '$'))
"         exec bufnr . 'bw!'
"     endif
"     try
"         echo 'vimgrep/' . pat . '/j %'
"         silent exec 'vimgrep/' . pat . '/j %'
"         copen 
"         wincmd p
"     catch /^E480.*/
"         echomsg v:errmsg
"     endtry

" endf

""
" " pops qf open if there is any entry
" fun! quickfix#pop(...)
"    if getqflist({'size': v:true}).size > 0
"        copen
"        wincmd p
"    else 
"        echo 'qf empty'
"    endif
" endf

