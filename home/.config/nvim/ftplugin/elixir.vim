if exists('b:did_ftplugin')
	finish
endif
let b:did_ftplugin = 1

setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal iskeyword+=!,?
setlocal comments=:#
setlocal commentstring=#\ %s
setlocal suffixesadd=.ex,.exs,.eex,.heex,.leex,.sface,.erl,.xrl,.yrl,.hrl
setlocal formatoptions-=t formatoptions+=croqlj

let b:undo_ftplugin='setl sw< com< cms< sua< fo<'
