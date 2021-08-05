if exists("current_compiler")
  finish
endif
let current_compiler = "shellcheck"

let s:save_cpo = &cpo
set cpo-=C

setlocal makeprg=shellcheck\ -f\ gcc\ $*\ %:S

setlocal errorformat=
  \%f:%l:%c:\ %trror:\ %m,
  \%f:%l:%c:\ %tarning:\ %m,
  \%I%f:%l:%c:\ note:\ %m

let &cpo = s:save_cpo
unlet s:save_cpo
