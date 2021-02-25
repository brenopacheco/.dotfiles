" File: after/plugin/lsp.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description: 

if exists('g:loaded_lsp_plugin')
    finish
endif
let g:loaded_lsp_plugin = 1

lua require('servers')
lua require('treesitter')

command! -nargs=1 -complete=customlist,lsp#cmd_complete 
    \ Lsp call lsp#cmd_exec(<q-args>)

hi! LspDiagnosticsUnderlineError       guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineWarning     guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineInformation guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineHint        guibg=bg gui=NONE guisp=NONE
