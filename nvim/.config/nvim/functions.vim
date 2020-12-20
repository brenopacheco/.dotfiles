" ClearCache{{{
command! ClearCache :call s:clear_cache()

fun! s:clear_cache()
    let s:base_dir = expand('~/.cache/nvim/')
    let s:cache_files = [ 'swap', 'backup', 'undo' ]
    for cache_file in s:cache_files
        echo 'rm -f ' . s:base_dir . cache_file . '/*'
        echo system('rm -f ' . s:base_dir . cache_file . '/*')
    endfor
endf
"}}}
" GPG {{{
command! GPGEncrypt silent exec 'g/^gpg:/d' | exec '%!gpg -easq'
command! GPGDecrypt exec '%!gpg -dq' | silent exec 'g/^gpg:/d'
"}}}
" Make {{{


command! Make call s:Make()

let s:build_system = {
    \ "pom.xml":      "mvn",
    \ "package.json": "node",
    \ "Makefile":     "make"
    \}

fun! s:mvn_sources()
    return [ "validate", "clean", "compile", "package", "test", "install" ]
endf

fun! s:node_sources()
    exec 'let b:package_json = ' . join(systemlist('cat ' . s:root() . '/package.json'), '')
    return keys(b:package_json.scripts)
endf

fun! s:make_sources()
    return systemlist('cat ' . s:root() . '/Makefile  | egrep "^[a-z]+:" | cut -d: -f1')
endf

fun! s:sink(target)
    exec 'AsyncRun ' . "cd " . s:root() . "; " . b:build_system . " " . a:target
endf

fun! s:set_system()
    let dir = s:root()
    for key in keys(s:build_system)
        let file = dir . '/' . key
        if filewritable(file)
            let b:build_system = s:build_system[key]
        endif
    endfor
endfun

fun! s:Make()
    let system =  s:set_system()
    if !exists('b:build_system')
        echomsg "Not a project"
        return
    endif
    let sources = function('s:' . b:build_system . '_sources')()
    call fzf#run(fzf#wrap('FZF', {
                \ 'source':sources,
                \ 'sink': function('s:sink')
                \ }))
endf

function s:root() abort
 let l:root = system('git rev-parse --show-toplevel 2>/dev/null')
 let l:root = substitute(l:root, '\n', '', '')
 return len(l:root) == 0 ? '.' : l:root
endfunction
"}}}
" Run {{{

let s:interpreters = {
    \ "lua":        "lua",
    \ "python":     "python",
    \ "sh":         "export PATH=$PATH:./ &&",
    \ "javascript": "node",
    \ "typescript": "ts-node",
    \}

command! Run :call s:run()
fun! s:run()
    try
        if &ft == 'vim'
            source %
            return
        endif
        let interpreter = s:interpreters[&ft]
        exec 'AsyncRun ' . interpreter . ' %'
    catch /.*/
        echomsg "Unknown interpreter"
        echomsg v:exception
    endtry
endfun


" }}}
" Templates {{{

augroup templates
    au!
    au BufEnter * call s:templates()
augroup end

let g:template_dir = expand('~/.config/nvim/templates')
command! Template call s:templates()

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
    silent %s/\${\(.\{-}\)}/\=eval(submatch(1))/
endf


" }}}
