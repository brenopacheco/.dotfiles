if exists("current_compiler")
  finish
endif
let current_compiler = "yaml"

let s:save_cpo = &cpo
set cpo-=C

setlocal errorformat=%E%f:%l:%c:\ [error]\ %m,%W%f:%l:%c:\ [warning]\ %m

setlocal makeprg=yamllint\ -f\ parsable

let &cpo = s:save_cpo
unlet s:save_cpo
