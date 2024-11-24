if exists('b:did_ftplugin')
	finish
endif

setlocal keywordprg=:Man
setlocal scrolloff=0

let b:undo_ftplugin = "setlocal kp< so<"
