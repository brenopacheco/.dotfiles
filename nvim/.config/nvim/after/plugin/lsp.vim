" File: after/plugin/lsp.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description:

if exists('g:loaded_lsp_plugin')
    finish
endif
let g:loaded_lsp_plugin = 1

lua require('conf.servers')
lua require('conf.treesitter')
lua require('conf.dap')

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

command! -nargs=1 -complete=customlist,utils#cmd_complete
    \ Lsp call utils#cmd_exec('lsp',<q-args>)

hi! LspDiagnosticsUnderlineError       guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineWarning     guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineInformation guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineHint        guibg=bg gui=NONE guisp=NONE
