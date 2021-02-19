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




set makeprg=npm\ --silent\ run


" make is equivalent to:
" !&makeprg 2>&1 | tee l:tmpfile
fun! s:make(target)
    let tmpfile = tempname()
    exec '!' . &makeprg . ' '. a:target . '2>&1 | tee ' . tmpfile
    exec 'cfile! ' . tmpfile
    copen
endf
