if exists("current_compiler")
  finish
endif
let current_compiler = "eslint"

let s:save_cpo = &cpo
set cpo-=C

CompilerSet errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %trror\ -\ %m,
                             \%f:\ line\ %l\\,\ col\ %c\\,\ %tarning\ -\ %m,
                             \%-G%.%#

CompilerSet makeprg=eslint\ -f\ compact\ --fix

let &cpo = s:save_cpo
unlet s:save_cpo
