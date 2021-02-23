"  File: plugin/lsp.vim
"  Author: Breno Leonhardt Pacheco
"  Email: brenoleonhardt@gmail.com
"  Last Modified: February 22, 2021
"  Description: 

if exists('g:loaded_lsp_plugin')
    finish
endif
let g:loaded_lsp_plugin = 1


augroup Lsp
    au VimEnter * nested lua require('servers')
    au VimEnter * nested lua require('treesitter')
    autocmd BufEnter * set omnifunc=v:lua.vim.lsp.omnifunc
augroup END

command! -nargs=1 -complete=customlist,lsp#cmd_complete 
    \ Lsp call lsp#cmd_exec(<q-args>)

hi! LspDiagnosticsUnderlineError       guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineWarning     guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineInformation guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineHint        guibg=bg gui=NONE guisp=NONE

nnoremap <silent> <C-]>    <cmd>call lsp#goto_definition()<CR>
nnoremap <silent> gd       <cmd>call lsp#goto_declaration()<CR>
nnoremap <silent> gr       <cmd>call lsp#goto_references()<CR>
nnoremap <silent> gi       <cmd>call lsp#goto_implementation()<CR>
nnoremap <silent> gy       <cmd>call lsp#goto_type_definition()<CR>
nnoremap <silent> go       <cmd>call lsp#goto_document_symbol()<CR>
nnoremap <silent> gs       <cmd>call lsp#goto_workspace_symbol()<CR>
nnoremap <silent><leader>= <cmd>call lsp#format()<CR>
nnoremap <silent><leader>e <cmd>call lsp#toggle_diagnostics()<CR>
nnoremap <silent>[e        <cmd>call lsp#goto_prev_diagnostic()<CR>
nnoremap <silent>]e        <cmd>call lsp#goto_next_diagnostic()<CR>
nnoremap <silent><leader>a <cmd>call lsp#code_action()<CR>
nnoremap <silent><leader>r <cmd>call lsp#rename()<CR>
nnoremap <silent><c-h>     <cmd>call lsp#show_signature_help()<CR>
nnoremap <silent><c-k>     <cmd>call lsp#show_hover()<CR>
nnoremap <silent><c-p>     <cmd>call lsp#show_preview()<CR>
nnoremap <silent><c-d>     <cmd>call lsp#show_line_diagnostic()<CR>
nnoremap <silent><C-n>     <cmd>call lsp#scrolldown_hover()<CR>
nnoremap <silent><C-p>     <cmd>call lsp#scrollup_hover()<CR>

nnoremap <leader>pl        <cmd>call lsp#servers()<CR>
