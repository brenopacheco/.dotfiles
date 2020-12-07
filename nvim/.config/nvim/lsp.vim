" Language servers{{{

lua << EOF
    require'lspconfig'.yamlls.setup{}
    require'lspconfig'.bashls.setup{}
    --require'lspconfig'.ccls.setup{}
    require'lspconfig'.clangd.setup{}
    require'lspconfig'.cssls.setup{}
    require'lspconfig'.html.setup{}
    -- require'lspconfig'.jdtls.setup{}
    require'lspconfig'.jsonls.setup{}
    -- require'lspconfig'.sumneko_lua.setup{}
    require'lspconfig'.tsserver.setup{}
    require'lspconfig'.vimls.setup{}
EOF

autocmd BufEnter * set omnifunc=v:lua.vim.lsp.omnifunc

"}}}
" Client mappings {{{

  command! LspStatus :lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>
  command! DisplayInfo :silent call s:display_info()
  function s:display_info() abort
      lua vim.lsp.buf.hover()
      lua vim.lsp.buf.signature_help()
      lua vim.lsp.diagnostic.show_line_diagnostics()
  endfunction

  nnoremap <silent> <C-k>     :DisplayInfo<CR>
  " nnoremap <silent> <c-]>     <cmd>lua    vim.lsp.buf.definition()<CR>
  nnoremap <silent> gd        <cmd>lua    vim.lsp.buf.declaration()<CR>
  nnoremap <silent> gr        <cmd>lua    vim.lsp.buf.references()<CR>
  nnoremap <silent> gi        <cmd>lua    vim.lsp.buf.implementation()<CR>
  nnoremap <silent> gy        <cmd>lua    vim.lsp.buf.type_definition()<CR>
  nnoremap <silent> go        <cmd>lua    vim.lsp.buf.document_symbol()<CR>
  nnoremap <silent> gs        <cmd>lua    vim.lsp.buf.workspace_symbol()<CR>
  nnoremap <silent> ]e        <cmd>lua    vim.lsp.diagnostic.goto_next { wrap = false }<CR>
  nnoremap <silent> [e        <cmd>lua    vim.lsp.diagnostic.goto_prev { wrap = false }<CR>
  nnoremap <silent> <leader>d <cmd>lua    vim.lsp.diagnostic.set_loclist()<CR>
  xnoremap <silent> <leader>a <cmd>lua    vim.lsp.buf.code_action()<CR>
  nnoremap <silent> <leader>a <cmd>lua    vim.lsp.buf.code_action()<CR>
  nnoremap <silent> <leader>= <cmd>lua    vim.lsp.buf.formatting()<CR>
  xnoremap <silent> <leader>= <cmd>lua    vim.lsp.buf.range_formatting()<CR>
  nnoremap <silent> <leader>r <cmd>lua    vim.lsp.buf.rename()<CR>
  xnoremap <silent> <leader>r <cmd>lua    vim.lsp.buf.rename()<CR>

"}}}
" Status line {{{

function! LspStatus() abort
    let sl = ''
    if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
        let sl.='E[' . luaeval("vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), [[Error]])") . '] '
        let sl.='W[' . luaeval("vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), [[Warning]])") . '] '
    else
        let sl.='off'
    endif
    return sl
endfunction

call sign_define("LspDiagnosticsErrorSign"       ,  {"text" : "E" ,  "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign"     ,  {"text" : "W" ,  "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign" ,  {"text" : "I" ,  "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign"        ,  {"text" : "H" ,  "texthl" : "LspDiagnosticsHint"})

" }}} 
