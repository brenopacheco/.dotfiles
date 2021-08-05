" File: templates.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description: insert a template in empty files according to filetype.
" Templates in s:template_dir must match the filetype glob pattern.
" Allow expanding snippes using ${vim_cmd} syntax inside the template.

" TODO: reformat and add stuff to autoload

if exists('g:loaded_templates_plugin')
    finish
endif
let g:loaded_templates_plugin = 1

command! TemplateThis call s:templates()

command! -nargs=1 -complete=customlist,<SID>list_templates
    \ Template call <SID>templates(<q-args>)

fun! s:list_templates(prefix, ...)
    let templates = systemlist('ls ' . s:template_dir)
    return filter(templates,
        \ { _,s -> match(s, '^'. a:prefix) != -1 && len(s) > 0 })
endf

let s:template_dir = globals#get('templatedir')

fun! s:templates(...)
    if line('$') != 1 || getline(1) != '' | return | endif
    let templates = systemlist('ls ' . s:template_dir)
    let filename = expand('%')
    let template = ''
    if a:0 > 0
        let template = s:template_dir . '/' . a:1
    else
        for t in templates
            if match(filename, glob2regpat(t)) != -1
                let template = s:template_dir . '/' . t
                break
            endif
        endfor
    endif
    if template == '' | return | endif
    call append(0, readfile(template))
    " the next trick will evaluate vim expressions such as ${strftime("%c")}
    silent exec '%s/\${\(.\{-}\)}/\=eval(submatch(1))/e'
endf

fun! s:toggle()
    if execute('au template', 'silent!')
        au! template
    else
        augroup templates
            au!
            au BufRead,BufNewFile * TemplateThis
        augroup end
    endif
endf

call s:toggle()


