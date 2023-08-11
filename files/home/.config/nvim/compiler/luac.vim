if exists('current_compiler')
  finish
endif
let current_compiler = 'luac'

let s:save_cpo = &cpo
set cpo-=C

CompilerSet errorformat=luac:\ %f:%l:\ %m
CompilerSet makeprg=luac\ -p

let &cpo = s:save_cpo
unlet s:save_cpo
