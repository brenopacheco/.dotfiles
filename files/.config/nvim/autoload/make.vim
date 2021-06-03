" File: autoload/make.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 23, 2021
" Description: exposes file/project-wide make functions

let s:compilers = {
    \ 'lua':        { 'linter': 'luac',       'interpreter': 'lua'     },
    \ 'sh':         { 'linter': 'shellcheck', 'interpreter': 'sh'      },
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

fun! make#eval_line()
    call s:eval(getline('.'))
endf

fun! make#eval_range()
    call range#run(funcref('s:eval'))
endf

fun! make#eval_buffer()
    call s:repl_close()
    call s:eval(join(getline(1,'$'),"\n"))
endf

fun! make#lint()
    try
        let linter = s:compilers[&ft].linter
        exec 'compiler ' . linter
        make %
        call quickfix#pop()
    catch /'^E716: Key not present in Dictionary'/
        echoerr 'Filetype '.&ft.' has no known linter.'
    catch
        echoerr v:exception
    endtry
endf

fun! make#build() abort
    let system = make#get_system()
    call fzf#run(fzf#wrap({
        \ 'source': funcref('make#'.system.'_source')(),
        \ 'sink': funcref('make#'.system.'_sink'),
        \ 'options': '--reverse --prompt "># make "'
        \ }))
endf

" MAKE SINKS ================================================================
fun! make#mvn_sink(target)
    compiler mvn
    exec 'make ' . a:target
    copen
    wincmd p
endf

fun! make#make_sink(target)
    compiler gcc
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
        call term#open()
        call jobsend(b:terminal_job_id, 'npm run ' . script . "\<CR>")
        fun! s:callback(...)
            execute('wincmd p')
        endf
        call timer_start(200, funcref('s:callback'), { 'repeat': 1 })
    endif
endf

" MAKE SOURCES ==============================================================
fun! make#mvn_source()
    return [ 'validate', 'clean', 'compile', 'package', 'test', 'install' ]
endf

fun! make#make_source()
    let file = systemlist('fd "^Makefile$" ' . utils#root())[0]
    return systemlist('egrep "^[a-z]+:" ' . file . ' | cut -d: -f1')
endf

fun! make#npm_source()
    let res = systemlist("npm run-script | sed -n '/^available/,$p'")
    return map(range(len(res)/2), { i,_ -> res[2*i+1][2:-1] . "\t" . res[2*i+2] })
endf

fun! make#get_system()
    let dir = utils#root()
    if !utils#is_git()
        throw 'Not a git repository'
    endif
    for system in keys(s:systems)
        if len(systemlist('fd "^'.s:systems[system].'$" '.dir)) > 0
            echomsg 'Build system: ' . system
            return system
        endif
    endfor
    throw 'Build system not found.'
endf

" ALT =======================================================================

fun! make#serve()
    let dir = fnamemodify(utils#files('index.html')[0], ':h')
    call term#open()
    call jobsend(b:terminal_job_id, 'livereload '  . dir . ' -d -e html,css,js &' . "\<CR>")
    call jobsend(b:terminal_job_id, 'http-server ' . dir . ' -p 8080' . "\<CR>")
    function! s:callback(...)
        execute('wincmd p')
        silent !xdg-open http://localhost:8080 & disown
    endf
    call timer_start(500, funcref('s:callback'), { 'repeat': 1 })
endf

" EVAL FUNCTIONS ============================================================
fun! s:eval(what) abort
    if &ft ==# 'vim' || &ft ==# ''
        let cmd = ':' . substitute(a:what, '^\s\+', '', '')
        echomsg cmd
        exec cmd
        return
    endif
    let content = split(a:what, "\n")
    let id = s:repl()
    call chansend(id, "\<C-l>")
    for line in content
        call chansend(id, line . "\<CR>")
    endfor
    call chansend(id, "\<CR>")
endf

fun! s:repl() abort
    let interpreter = s:compilers[&ft].interpreter
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&ft') ==# 'repl'
            if getbufvar(bnum, 'interpreter') != interpreter
                exec i 'close!'
                break
            endif
            return getbufvar(bnum, 'terminal_job_id')
        endif
    endfor
    " vsp | enew
    call term#open(interpreter)
    set ft=repl
    let id = b:terminal_job_id
    let b:interpreter = interpreter
    wincmd p
    return id
endf

fun! s:repl_close()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&ft') ==# 'repl'
            exec i 'close!'
            return
        endif
    endfor
endf
