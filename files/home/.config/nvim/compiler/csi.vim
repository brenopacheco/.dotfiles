if exists('current_compiler')
  finish
endif
let current_compiler = 'csi'

let s:save_cpo = &cpo
set cpo-=C

CompilerSet makeprg=chicken-csi\ -s\ %
CompilerSet errorformat=%f:%l:%m

let &cpo = s:save_cpo
unlet s:save_cpo


