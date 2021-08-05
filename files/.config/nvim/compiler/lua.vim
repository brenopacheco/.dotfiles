if exists('current_compiler')
  finish
endif
let current_compiler = 'lua'

let s:save_cpo = &cpo
set cpo-=C

setlocal efm=lua:\ %f:%l:%m

setlocal makeprg=lua\ %

let &cpo = s:save_cpo
unlet s:save_cpo
