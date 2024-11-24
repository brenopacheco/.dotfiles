if exists('current_compiler')
  finish
endif
let current_compiler = 'lua'

let s:save_cpo = &cpo
set cpo-=C

CompilerSet errorformat=lua:\ %f:%l:%m
CompilerSet makeprg=lua\ %

let &cpo = s:save_cpo
unlet s:save_cpo
