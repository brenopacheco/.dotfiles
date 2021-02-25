" File: autoload/make.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 23, 2021
" Description:

" key: filetype, value: compiler plugin
let s:compilers = {
    \ 'lua':        { 'linter': 'luac',       'interpreter': 'lua'     },
    \ 'sh':         { 'linter': 'shellcheck', 'interpreter': 'bash'    },
    \ 'python':     { 'linter': 'pylint',     'interpreter': 'python'  },
    \ 'javascript': { 'linter': 'eslint',     'interpreter': 'node'    },
    \ 'typescript': { 'linter': 'eslint',     'interpreter': 'ts-node' },
    \ 'c':          { 'linter': 'gcc',        'interpreter': 'gcc'     },
    \ 'css':        { 'linter': 'csslint',    'interpreter': v:false   },
    \ 'html':       { 'linter': 'tidy',       'interpreter': v:false   },
    \ 'vim':        { 'linter': 'vint',       'interpreter': v:false   }
    \ }

let s:systems = {
    \ 'mvn':   'pom.xml',
    \ 'make':  'Makefile',
    \ 'npm':   'package.json'
    \ }

fun! make#run()
    if &ft ==# 'vim'
        source %
        return
    else
        let interpreter = s:compilers[&ft].interpreter
        if type(interpreter) == 1
            exec 'compiler ' . interpreter
            make %
            call quickfix#pop()
        else
            throw 'Filetype '.&ft.' has no known interpreter.'
        endif
    endif
endf

fun! make#lint()
    let linter = s:compilers[&ft].linter
    if type(linter) == 1
        exec 'compiler ' . linter
        make %
        call quickfix#pop()
    else
        throw 'Filetype '.&ft.' has no known linter.'
    endif
endf

fun! make#make()
    let system = make#get_system()
    call fzf#run(fzf#wrap({
        \ 'source': funcref('make#'.system.'_source')(),
        \ 'sink': funcref('make#'.system.'_sink'),
        \ 'options': '--reverse --prompt "># make "'
        \ }))
endf

fun! make#mvn_sink(target)
    compiler mvn
    exec 'make ' . a:target
    copen
    wincmd p
endf

fun! make#make_sink(target)
    exec 'compiler ' . s:compilers[&ft].interpreter
    let makefile_path = systemlist('fd "^Makefile$" ' . utils#root())[0]
    exec 'cd ' . fnamemodify(makefile_path, ':h') 
    exec 'make ' . a:target
    copen
    wincmd p
endf

fun! make#npm_sink(target)
    let script = matchstr(a:target, '^\S\+')
    if match(a:target, '\(eslint\|tsc\|csslint\)') > -1
        compiler npm
        exec 'make ' . script
    else
        call utils#toggle('term', 'botright 13sp | term', v:true)
        call jobsend(b:terminal_job_id, 'npm run ' . script . "\<CR>")
        function s:callback(...)
            execute('wincmd p')
        endf
        call timer_start(200, funcref('s:callback'), { 'repeat': 1 })
    endif
endf

fun! make#mvn_source()
    return [ 'validate', 'clean', 'compile', 'package', 'test', 'install' ]
endf

fun! make#make_source()
    let file = systemlist('fd "^Makefile$" ' . utils#root())[0]
    return systemlist('egrep "^[a-z]+:" ' . file . ' | cut -d: -f1')
endf

fun! make#npm_source()
    let res = systemlist('npm run-script | sed -n "/^  [a-zA-Z]/,+1p" | tr -d " "')
    return map(range(len(res)/2), { i,_ -> res[2*i] . "\t" . res[2*i+1] })
endf

fun! make#get_system()
    let dir = utils#root()
    for system in keys(s:systems)
        if len(systemlist('fd "^'.s:systems[system].'$" '.dir)) > 0
            echo 'Build system: ' . system
            return system
        endif
    endfor
    throw 'Build system not found.'
endf

""
" Evaluates a visual selection or current line
fun! make#eval()
    " vim -> exec 'getline(".")'
    " js -> call system('| node -i -')
endf
