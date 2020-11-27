
nnoremap ]e <cmd>vim.lsp.diagnostic.get_next()<CR>
nnoremap [e <cmd>vim.lsp.diagnostic.get_prev()<CR>

nnoremap <silent> <leader>a viW<cmd>lua vim.lsp.buf.code_action()<CR><ESC>
xnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>= <cmd>lua vim.lsp.buf.formatting()<CR>
xnoremap <silent> <leader>= <cmd>lua vim.lsp.buf.range_formatting()<CR>
xnoremap <silent> <leader>r <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>r <cmd>lua vim.lsp.buf.rename()<CR>

nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gy <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> go <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gs <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
