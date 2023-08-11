if exists("current_compiler")
	finish
endif
let current_compiler = "rustc"

let s:save_cpo = &cpo
set cpo-=C

CompilerSet makeprg=rustc

CompilerSet errorformat+=
			\%-G,
			\%-Gerror:\ aborting\ %.%#,
			\%-Gerror:\ Could\ not\ compile\ %.%#,
			\%Eerror:\ %m,
			\%Eerror[E%n]:\ %m,
			\%Wwarning:\ %m,
			\%Inote:\ %m,
			\%C\ %#-->\ %f:%l:%c

let &cpo = s:save_cpo
unlet s:save_cpo
