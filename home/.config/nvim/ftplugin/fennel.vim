if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

compiler fennel
setlocal equalprg=
setlocal shiftwidth=2
setlocal tabstop=2
setlocal foldexpr=expr
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal expandtab
setlocal formatoptions=croqlj
setlocal textwidth=78
setlocal comments=:;;,:;
setlocal commentstring=;%s
setlocal suffixesadd=.fnl
setlocal keywordprg=:help
setlocal lisp

let b:undo_ftplugin='setl mp< efm< ep< sw< ts< fdm< fde< et< fo< tw< com< cms< sua< kp< lisp<'
