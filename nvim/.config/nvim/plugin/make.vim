"  File: make.vim
"  Author: Breno Leonhardt Pacheco
"  Email: brenoleonhardt@gmail.com
"  Last Modified: February 22, 2021
"  Description: provides a :Run and :Make functions
"  :Run will try to run an interepreter for the file
"  :Make will look for project's root, set up the appropriate compiler,
"  and launch an FZF menu for selecting the correct target. If the target
"  is has a corresponding :compiler plugin, the FZF sink will set it up
"  and run with makeprg. Otherwise, the command is run in a terminal buffer.

if exists('g:loaded_make_plugin')
    finish
endif
let g:loaded_make_plugin = 1

command! Make :call s:make()
command! -nargs=? Run :call s:run(<q-args>)





















" let s:interpreters = {
"     \ "lua":        "lua",
"     \ "python":     "python",
"     \ "sh":         "sh",
"     \ "javascript": "node",
"     \ "typescript": "ts-node",
"     \}

" fun! s:run(arg)
"     try
"         if &ft == 'vim'
"             source %
"             return
"         endif
"         let interpreter = s:interpreters[&ft]
"         let file = tempname()
"         let cmd = (a:arg ? a:arg : interpreter) . ' ' . expand('%:p') . ' >> ' . file
"         silent call writefile(["[" . expand('%:p') . "] " . cmd , ""], file, "a")
"         let jobid = jobstart(cmd, { 
"             \   'on_stdout':   { j,d,e -> s:run_callback(file) }
"             \ })
"     catch /.*/
"         echomsg v:exception
"     endtry
" endfun

" fun! s:run_callback(file)
"     let olderrorfmt = &efm
"     set efm=%E[%f]%m,%+Cm
"     exec 'cf! '. a:file
"     let &efm = olderrorfmt
"     copen
"     setlocal modifiable
"     exe '%s/|//g'
"     norm gg
"     exec 's/^\(.\{-}\) \(.*\) >\(.*\)/[\2 >\3]'
"     setlocal nomodifiable
"     setlocal bufhidden=hide
"     wincmd p
" endf


" " mvn targets for :make   -> [ 'validate', 'clean', 'compile', 'package', 'test', 'install' ] 
" " c/cpp targets for :make -> systemlist('cat ' . utils#root() . '/Makefile  | egrep "^[a-z]+:" | cut -d: -f1') 
" " npm scripts (terminal)  -> systemlist('npm run-script | sed -n "/^  [a-zA-Z]/p" | tr -d " "')
" " \ "lua":        "export LUA_PATH=\"" . utils#root() . "/?.lua;;\" && lua",
" " \ "sh":         "export PATH=$PATH:./ &&",
"
" make -> !&makeprg 2>&1 | tee l:tmpfile
"         cfile tmpfile
" compiler -> set efm=... for quickfix loading from tmpfile


" filetype   | compiler   | single file makeprg   | project makeprg
" ---------- | ---------- | --------------------- | -----------------
" c/cpp      | gcc        | gcc                   | make
" java       | javac      | javac                 | mvn
" js         | eslint     | eslint                | npm
" ts         | tsc        | tsc                   | npm
" css        | csslint    | csslint               | npm
" lua        | luac       | luac                  | make
" sh         | shellcheck | shellcheck            | shellcheck
" html       | tidy       | tidy                  | tidy

" for single files, the makeprg is always set with the compiler plugin




" set makeprg=npm\ --silent\ run


" make is equivalent to:
" !&makeprg 2>&1 | tee l:tmpfile
" fun! s:make(target)
"     let tmpfile = tempname()
"     exec '!' . &makeprg . ' '. a:target . '2>&1 | tee ' . tmpfile
"     exec 'cfile! ' . tmpfile
"     copen
" endf
