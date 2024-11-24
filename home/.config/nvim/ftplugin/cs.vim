if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler gcc
setlocal equalprg=
setlocal shiftwidth=2
setlocal tabstop=2
setlocal noexpandtab
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal formatoptions=croqlj
setlocal textwidth=80
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
setlocal commentstring=//%s
setlocal suffixesadd+=~,.o,.h,.obj,.cpp
setlocal keywordprg=:Man
let b:man_default_sects = '3,2'

let b:undo_ftplugin='setl mp< efm< ep< sw< ts< fdm< fde< fo< tw< com< cms< sua< kp< ff<'

if strlen(matchstr(expand('%:p'), '/fc/backend/')) > 0
	" overides editorconfig settings because FC has it wrong.
	" the correct config for .cs is - end_of_line = lf
	let b:editorconfig = v:false
	setlocal fileformat=unix
	setlocal encoding=utf-8
	setlocal fileencoding=utf-8
	setlocal bomb
	let b:undo_ftplugin=b:undo_ftplugin . ' ff< fenc< enc< bomb<'
end

