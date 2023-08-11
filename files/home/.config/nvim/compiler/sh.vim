if exists("current_compiler")
  finish
endif
let current_compiler = "sh"

let s:save_cpo = &cpo
set cpo-=C

CompilerSet makeprg=sh
CompilerSet errorformat=%f:\ line\ %l:\ %m,
		       \%-G%.%#

let &cpo = s:save_cpo
unlet s:save_cpo
