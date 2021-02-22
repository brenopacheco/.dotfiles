" command! ClearCache 
" command! GPGEncrypt 
" command! GPGDecrypt 

nnoremap <leader>i call fzf#run(wrapper#snippets())
command! Args      call fzf#run(wrappers#args())
command! PFiles    call fzf#run(wrappers#project())

" Make {{{

" mvn targets for :make   -> [ 'validate', 'clean', 'compile', 'package', 'test', 'install' ] 
" c/cpp targets for :make -> systemlist('cat ' . utils#root() . '/Makefile  | egrep "^[a-z]+:" | cut -d: -f1') 
" npm scripts (terminal)  -> systemlist('npm run-script | sed -n "/^  [a-zA-Z]/p" | tr -d " "')

" }}}
" Run {{{

" Run the current file through an interpreter
" Results are shown in qf
command! -nargs=? Run :call s:run(<q-args>)

    " \ "lua":        "export LUA_PATH=\"" . utils#root() . "/?.lua;;\" && lua",
    " \ "sh":         "export PATH=$PATH:./ &&",
let s:interpreters = {
    \ "lua":        "lua",
    \ "python":     "python",
    \ "sh":         "sh",
    \ "javascript": "node",
    \ "typescript": "ts-node",
    \}

fun! s:run(arg)
    try
        if &ft == 'vim'
            source %
            return
        endif
        let interpreter = s:interpreters[&ft]
        let file = tempname()
        let cmd = (a:arg ? a:arg : interpreter) . ' ' . expand('%:p') . ' >> ' . file
        silent call writefile(["[" . expand('%:p') . "] " . cmd , ""], file, "a")
        let jobid = jobstart(cmd, { 
            \   'on_stdout':   { j,d,e -> s:run_callback(file) }
            \ })
    catch /.*/
        echomsg v:exception
    endtry
endfun

fun! s:run_callback(file)
    let olderrorfmt = &efm
    set efm=%E[%f]%m,%+Cm
    exec 'cf! '. a:file
    let &efm = olderrorfmt
    copen
    setlocal modifiable
    exe '%s/|//g'
    norm gg
    exec 's/^\(.\{-}\) \(.*\) >\(.*\)/[\2 >\3]'
    setlocal nomodifiable
    setlocal bufhidden=hide
    wincmd p
endf


" }}}
