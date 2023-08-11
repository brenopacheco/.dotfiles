if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal equalprg=
setlocal formatoptions=croqlj
setlocal textwidth=80
setlocal comments=s1:/*,mb:*,ex:*/
setlocal commentstring=/*%s*/
setlocal suffixesadd=.css,.sass,.less

let b:undo_ftplugin='setl ep< fo< tw< com< cms< sua<'
