if exists("current_compiler")
  finish
endif

let current_compiler = "mvn"

let s:save_cpo = &cpo
set cpo-=C

setlocal errorformat=[%tRROR]\ %f:[%l]\ %m,%-G%.%#

setlocal makeprg=mvn

let &cpo = s:save_cpo
unlet s:save_cpo
