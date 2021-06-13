" File: autoload#quickfix.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description:

" SEARCH ====================================================================

fun! quickfix#global_grep(...)
    if a:0 > 0
        let pat = a:1
        exec "silent grep! '".pat."' " . utils#git_root() | copen | wincmd p
    else
        call feedkeys(":silent grep! '' " . utils#git_root() .
            \ '| copen | wincmd p' ."\<Home>".repeat("\<Right>", 14))
    endif
endf

fun! quickfix#global_grep2(...)
    let pattern = ''
    if a:0 > 0
        let pattern = a:1
    else
        let pattern = input('>Grep /')
    endif
    " let pattern = substitute(pattern, '\(#\|\.\)', '\\\1', 'g')
    let pattern = substitute(pattern, '\(#\)', '\\\1', 'g')
    " ask for where
    let where = input(">Grep '".pattern."' in <complete>/",'', 'customlist,quickfix#_where')
    let buffer = bufnr()
    if where ==# 'buffer'
        call feedkeys(':vimgrep /'.pattern.'/j %'."\<CR>")
    elseif where ==# 'git'
        call feedkeys(":grep! '" . pattern . "' " . utils#git_root() . "\<CR>")
    elseif where ==# 'project'
        call feedkeys(":grep! '" . pattern . "' " . utils#npm_root())
    elseif where ==# 'buflist'
        call feedkeys(':cexpr [] | bufdo vimgrepadd /'.pattern.'/j % | '.buffer.'b'."\<CR>")
    elseif where ==# 'arglist'
        call feedkeys(':vimgrep /'.pattern.'/j ## | '.buffer.'b'."\<CR>")
    endif
    copen | wincmd p
endf

fun! quickfix#_where(...)
    return filter(['git', 'project', 'buffer', 'buflist', 'arglist'], 
        \ { _, s -> !match(s, '^' . a:1) })
endf

fun! quickfix#global_star2()
    let word = expand('<cword>')
    if mode() ==? 'v'
        norm! "xy
        let word = @x
    endif
    call quickfix#global_grep2(word)
endf


" performs grep on all project files using word under cursor.
" may be called in visual mode. if in visual mode, map as xnoremap <cmd>
fun! quickfix#global_star()
    let word = expand('<cword>')
    if mode() ==? 'v'
        norm! "xy
        let word = @x
    endif
    let pattern = substitute(word, '\(#\|\.\)', '\\\1', 'g')
    let cmd = "silent grep! '".pattern."' " . utils#git_root()
    echomsg cmd
    exec cmd
    silent copen | wincmd p
endf

""
" performs vimgrep on the file. if file has no name, give
" it an unique name
fun! quickfix#buffer_grep()
    call feedkeys(':vimgrep//j % | copen | wincmd p'.repeat("\<left>", 23))
endf

""
" performs vimgrep on the file using word under cursor.
" may be called in visual mode. if in visual mode, map as xnoremap <cmd>
fun! quickfix#buffer_star() abort
    let word = expand('<cword>')
    if mode() ==# 'v'
        norm! "xy
        let word = @x
    endif
    let cmd = 'silent vimgrep/'.word.'/j %'
    echo cmd | exec cmd
    silent copen | wincmd p
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
    silent! cnewer
endf

fun! quickfix#colder()
    silent! colder
endf

" UTILS ===================================================================

" pops qf open if there is any entry
fun! quickfix#pop()
    if getqflist({'size': v:true}).size > 0
        copen
        wincmd p
    endif
endf

" toggle quickfix
fun! quickfix#toggle()
    call utils#toggle('qf', 'copen | wincmd p')
endf

""
" source all source files into qf
fun! quickfix#source()
    let files = utils#files(globals#get('extensions'), utils#git_root())
    call setqflist(map(copy(files), '{ "filename": v:val }'))
    silent copen | silent wincmd p
endf
