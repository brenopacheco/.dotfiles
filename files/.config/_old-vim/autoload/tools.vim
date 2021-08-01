" File: tools.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 26, 2021
" Description:

fun! tools#buffer_substitute()
    let word = expand('<cword>')
    if mode() ==? 'v'
        norm! "xy
        let word = @x
    endif
    call feedkeys(':%s/'.word.'/'.word.'/g'. "\<Left>\<Left>")
endf

" not very cool. cannot see all changes
fun! tools#global_substitute()
    let word = expand('<cword>')
    call quickfix#global_grep(word)
    wincmd p
    call feedkeys(':cdo %s/'.word.'/'.word.'/g'. "\<Left>\<Left>")
endf

""
" Run a :global command and open result in separate buffer
" " TODO: not working
fun! tools#global_print()
    silent! bw! __global__
    vsp __global__ | wincmd p
    call feedkeys(":silent g//y a \| call appendbufline(bufnr('__global__'),
        \ '$', @a)\<Home>".repeat("\<Right>", 9))
endf

fun! tools#find_tag()
    call feedkeys(':tag /')
endf

