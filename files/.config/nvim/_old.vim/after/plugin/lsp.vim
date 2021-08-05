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
" lua require('conf.dap')

augroup lsp
    au!
    autocmd BufEnter * set omnifunc=v:lua.vim.lsp.omnifunc
    " au FileType LspSagaCodeActionTitle call s:saga_maps()
augroup end

" fun! s:saga_maps()
"     nnoremap <buffer> <C-[> <cmd>lua require('lspsaga.codeaction').quit_action_window()<CR>
"     nnoremap <buffer> jk    <cmd>lua require('lspsaga.codeaction').quit_action_window()<CR>
"     nnoremap <buffer> kj    <cmd>lua require('lspsaga.codeaction').quit_action_window()<CR>
"     nnoremap <buffer> <TAB> <CR>
"     nnoremap <buffer> <C-n> j
"     nnoremap <buffer> <C-p> k
" endf

" augroup treesitter
"     set foldmethod=expr
"     set foldexpr=nvim_treesitter#foldexpr()
" augroup end



command! -nargs=1 -complete=customlist,utils#cmd_complete
    \ Lsp call utils#cmd_exec('lsp',<q-args>)

hi! LspDiagnosticsUnderlineError       guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineWarning     guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineInformation guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineHint        guibg=bg gui=NONE guisp=NONE
