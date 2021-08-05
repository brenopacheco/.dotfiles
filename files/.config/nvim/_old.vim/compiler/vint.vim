if exists("current_compiler")
  finish
endif
let current_compiler = "vint"

let s:save_cpo = &cpo
set cpo-=C

setlocal errorformat=%f:%l:%c:\ %m

setlocal makeprg=vint

let &cpo = s:save_cpo
unlet s:save_cpo
