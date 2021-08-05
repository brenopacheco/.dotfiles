" File: how.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 28, 2021
" Description:

fun! how#languages(...)
    return uniq(filter([&ft, 'vim', 'go', 'lua', 'bash', 'html', 'c', 'javascript',
        \ 'typescript'], { _, s -> !match(s, '^' . a:1) }))
endf

fun! how#questions(...) abort range
    return [ ':help', ':info', ':learn' ]
endf

""
" Runs cheat.sh curl. Accepts visual selection
fun! how#cheat() abort
    let text = ''
    let url = 'http://cheat.sh/'
    call system('curl localhost:8002')
    if !v:shell_error
        let url = 'localhost:8002'
    endif
    let language = &ft
    let language = input('>How in /', '', 'customlist,how#languages')
    let question = input('>How'.(len(language) > 0 ? ' in ' . language : '')
        \ . ' do I /', text, 'customlist,how#questions')
    if question == ''
        return
    endif
    norm! \<esc>
    let question = substitute(question, '\s', '+', 'g')
    let query = url . (len(language) > 0 ? language . '/' : '') . question
    let query = tolower(query)
    let curl ='curl ' . query . '?qT 2>/dev/null'
    let result = systemlist(curl)
    echomsg curl
    if v:shell_error
        echomsg 'Curl failed for query: ' . query
        return
    endif
    call s:clear()
    vsp | enew
    set ft=cheatsh
    call append(0, result)
    norm! gg
endf

fun! s:clear()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&ft') ==# 'cheatsh'
                silent exe i . 'close'
            return
        endif
    endfor
endf

augroup cheatsh
    au!
    au FileType cheatsh setlocal
        \ nobuflisted bufhidden=hide buftype=nofile
        \ noswapfile nonu nornu
augroup end

