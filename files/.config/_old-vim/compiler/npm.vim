if exists("current_compiler")
  finish
endif
let current_compiler = "npm"

let s:save_cpo = &cpo
set cpo-=C

" supports: 
"   tsc 
"   eslint --format compact
"   csslint --format=compact

setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %trror\ -\ %m,
                       \%f:\ line\ %l\\,\ col\ %c\\,\ %tarning\ -\ %m,
                       \%f%#(%l\\,%c):\ %trror\ TS%n:\ %m,
                       \%-G%.%#


setlocal makeprg=npm\ --silent\ run

let &cpo = s:save_cpo
unlet s:save_cpo


