if exists('b:did_ftplugin')
	finish
endif

setlocal keywordprg=:Man

let b:undo_ftplugin = "setlocal kp<"
