" File: templates.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description: insert a template in empty files according to filetype.
" Templates in g:template_dir must match the filetype glob pattern.
" Allow expanding snippes using ${vim_cmd} syntax inside the template.

if exists('g:loaded_templates_plugin')
    finish
endif
let g:loaded_templates_plugin = 1

let g:template_dir = expand('~/.config/nvim/templates')

fun! s:templates()
    if line('$') != 1 || getline(1) != '' | return | endif
    let templates = systemlist('ls ' . g:template_dir)
    let filename = expand('%')
    let template = ''
    for t in templates
        if match(filename, glob2regpat(t)) != -1
            let template = g:template_dir . '/' . t
            break
        endif
    endfor
    if template == '' | return | endif
    call append(0, readfile(template))
    " the next trick will evaluate vim expressions such as ${strftime("%c")}
    silent exec '%s/\${\(.\{-}\)}/\=eval(submatch(1))/e'
endf

command! Template call s:templates()

augroup templates
    au!
    au BufRead,BufNewFile * call s:templates()
augroup end
