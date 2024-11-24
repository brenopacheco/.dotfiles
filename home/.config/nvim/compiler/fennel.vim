if exists("current_compiler")
	finish
endif
let current_compiler = "fennel"

let s:save_cpo = &cpo
set cpo-=C

CompilerSet errorformat=%f:%l:%m
CompilerSet makeprg=fennel\ %

let &cpo = s:save_cpo
unlet s:save_cpo
