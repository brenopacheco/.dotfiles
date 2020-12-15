" Language servers{{{

lua << EOF
    -- require lspconfig for server defaults
    local lspconfig = require'lspconfig'

    -- mappings for on_attach
    local custom_attach = function()
          vim.api.nvim_buf_set_keymap(0, 'n', '<c-]>', 
            '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
    end

    -- enable snippet expansion support for all servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    lspconfig.util.default_config = vim.tbl_extend(
        "force", lspconfig.util.default_config, { 
            capabilities = capabilities,
            init_options = { usePlaceholders = true },
            on_attach = custom_attach
    })

    -- enable lsp servers
    lspconfig.bashls.setup{}
    lspconfig.ccls.setup{}
    lspconfig.cssls.setup{}
    lspconfig.html.setup{}
    lspconfig.jdtls.setup{}
    lspconfig.jsonls.setup{}
    lspconfig.sumneko_lua.setup{}
    lspconfig.tsserver.setup{}
    lspconfig.vimls.setup{}
    lspconfig.yamlls.setup{}
EOF

autocmd BufEnter * set omnifunc=v:lua.vim.lsp.omnifunc

"}}}
" Client mappings {{{

  command! LspStatus :lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>
  command! DisplayInfo :silent call s:display_info()

  let s:pos = []
  function s:display_info() abort
      let new_pos = getpos('.')
      if new_pos == s:pos
        " change line 632 /usr/local/share/nvim/runtime/lua/vim/lsp/util.lua
        " local contents = api.nvim_buf_get_lines(bufnr, range.start.line, 
        " math.max(range["end"].line+1, 10), false)
        lua peek_definition()
        let s:pos = []
      else
        lua vim.lsp.buf.signature_help()
        lua vim.lsp.buf.hover()
        let s:pos = getpos('.')
      endif
  endfunction
  command! PeekDefinition :lua peek_definition()<CR>

  inoremap <buffer><silent> <C-n> <C-n><Cmd>lua vim.lsp.buf.hover()<CR>
  inoremap <buffer><silent> <C-p> <C-p><Cmd>lua vim.lsp.buf.hover()<CR>

  nnoremap <silent> <C-k>     :DisplayInfo<CR>
  nnoremap <silent> <C-h>     :PeekDefinition<CR>
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
