" File: plugin/markdown.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: May 29, 2021
" Description: Markdown previewer

if exists('g:loaded_markdown_plugin')
    finish
endif
let g:loaded_markdown_plugin = 1

fun! Markdown() abort
    call s:setup()
endf

command! Markdown call Markdown()

let s:server_port = 8999
let s:reload_port = 35729
let s:outdir = '/tmp/marked'
let s:outpath = s:outdir . '/index.html'
let s:logpath = s:outdir . '/log'

fun! s:transpile() abort
    let filepath = expand('%:p')
    call system('marked ' . filepath . ' > ' . s:outpath)
endf

fun! s:shutdown() abort
    call system('lsof -i:' . s:server_port . " -sTCP:LISTEN |awk 'NR > 1 {print $2}' | xargs kill -15")
    call system('lsof -i:' . s:reload_port . " -sTCP:LISTEN |awk 'NR > 1 {print $2}' | xargs kill -15")
    call s:toggle_hook(v:false)
endf

fun! s:startup() abort
    call system('http-server ' . s:outdir . ' -p ' . s:server_port
        \ . ' 2>&1 >> '.s:logpath.' &')
    call system('livereload ' . s:outdir . ' -p ' . s:reload_port
        \ . ' --wait 300 2>&1 >> ' . s:logpath . ' &')
endf

fun! s:setup() abort
    if &ft !=# 'markdown'
        echoerr 'File is not markdown'
        return
    endif
    call system('test -d ' . s:outdir . ' . || mkdir -p ' . s:outdir)
    call system('lsof -i:' . s:server_port)
    if v:shell_error
        call s:startup()
    endif
    call s:toggle_hook(v:true)
    call s:transpile()
    call s:open()
endf

fun! s:open()
    call system('xdg-open http://localhost:' . s:server_port . ' & disown')
endf

fun! s:toggle_hook(status) abort
    if a:status
        augroup MarkdownRefresh
            au!
            au BufWritePost <buffer> call s:transpile()
            au BufDelete,VimLeave <buffer> call s:shutdown()
        augroup end
    else
        augroup MarkdownRefresh
            au!
        augroup end
    endif
endf

