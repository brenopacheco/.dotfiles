if exists('b:did_ftplugin')
	finish
endif

setlocal cms=#%s

let b:undo_ftplugin = "setlocal cms<"
