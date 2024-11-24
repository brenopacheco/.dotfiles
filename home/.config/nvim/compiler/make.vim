if exists('current_compiler')
  finish
endif
let current_compiler = 'make'

let s:save_cpo = &cpo
set cpo-=C

CompilerSet errorformat&
CompilerSet makeprg=make

let &cpo = s:save_cpo
unlet s:save_cpo
