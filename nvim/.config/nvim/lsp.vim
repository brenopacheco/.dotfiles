" Language servers{{{

lua << EOF
    -- override default handlers
    require('lsp-overrides')
    require('lsp-utils')
    local lspconfig = require'lspconfig'
    local util      = require('lspconfig/util')

    local servers = { "bashls", "ccls", "cssls", "html", "jdtls", "jsonls",
                      "sumneko_lua", "tsserver", "vimls", "yamlls" }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = false

    for _, server in pairs(servers) do
        lspconfig[server].setup{
            root_dir = util.root_pattern(".git", vim.fn.getcwd()),
            capabilities = capabilities,
        }
    end

    lspconfig.sumneko_lua.setup{
      capabilities = capabilities,
      root_dir = util.root_pattern(".git", vim.fn.getcwd()),
      settings = {
            Lua = {
                completion = { 
                    keywordSnippet = { "Disable"}},
                diagnostics = {
                    globals = {"vim", "love"},
                    disable = {"lowercase-global",
                               "unused-vararg"}}}}}

    local capabilities2 = vim.lsp.protocol.make_client_capabilities()
    capabilities2.textDocument.completion.completionItem.snippetSupport = true
    lspconfig.jdtls.setup{
        capabilities = capabilities2
    }

EOF

autocmd BufEnter * set omnifunc=v:lua.vim.lsp.omnifunc

"}}}
" Client mappings {{{

    " TODO: format should see if lsp provides a formatter

    command! LspPeekDefinition   lua vim.lsp.buf.peek_definition()
    command! LspSignatureHelp    lua vim.lsp.buf.signature_help()
    command! LspHover            lua vim.lsp.buf.hover()
    command! LspDefinition       lua vim.lsp.buf.definition()
    command! LspDeclaration      lua vim.lsp.buf.declaration()
    command! LspReferences       lua vim.lsp.buf.references()
    command! LspImplementation   lua vim.lsp.buf.implementation()
    command! LspTypeDefinition   lua vim.lsp.buf.type_definition()
    command! LspDocumentSymbol   lua vim.lsp.buf.document_symbol()
    command! LspWorkspaceSymbol  lua vim.lsp.buf.workspace_symbol()
    command! LspDiagnosticNext   lua vim.lsp.diagnostic.goto_next { wrap = true }
    command! LspDiagnosticPrev   lua vim.lsp.diagnostic.goto_prev { wrap = true }
    command! LspDiagnostics      lua vim.lsp.diagnostic.set_loclist()
    command! LspAction           lua vim.lsp.buf.code_action()
    command! LspRename           lua vim.lsp.buf.rename()

    command! LspStatus           Bufferize lua print(vim.inspect(vim.lsp.buf_get_clients()))
    command! LspDisplayInfo      call s:display_info()
    command! LspFormat           call s:format()
    command! LspClosePopup       call s:close_lsp_floating()

    nnoremap <c-]> :silent exec <SID>lsp_on() ? 
        \ 'lua vim.lsp.buf.definition()' : 
        \ ('tag /' . expand('<cword>'))<CR>

    nnoremap <silent> gd        <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <silent> gr        <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> gi        <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <silent> gy        <cmd>lua vim.lsp.buf.type_definition()<CR>
    nnoremap <silent> go        <cmd>lua vim.lsp.buf.document_symbol()<CR>
    nnoremap <silent> gs        <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
    nnoremap <silent> ]e        <cmd>lua vim.lsp.diagnostic.goto_next { wrap = true }<CR>
    nnoremap <silent> [e        <cmd>lua vim.lsp.diagnostic.goto_prev { wrap = true }<CR>
    nnoremap <silent> <leader>d <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
    xnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
    nnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
    nnoremap <silent> <leader>r <cmd>lua vim.lsp.buf.rename()<CR>
    xnoremap <silent> <leader>r <cmd>lua vim.lsp.buf.rename()<CR>

    nnoremap <silent> <leader>= <cmd>LspFormat<CR>
    nnoremap <silent> <C-k>     <cmd>LspHover<CR>
    nnoremap <silent> <C-p>     <cmd>LspPeekDefinition<CR>
    nnoremap <silent> <C-j>     <cmd>LspClosePopup<CR>
    inoremap <silent> <C-k>     <cmd>LspSignatureHelp<CR>
    inoremap <silent> <c-j>     <cmd>LspClosePopup<CR>

    fun! s:format()
        try
            if !s:lsp_on()
                throw "Lsp off"
            endif
            lua vim.lsp.buf.formatting_sync()
            echo "Formatting using LSP formatter"
        catch /.*/
            norm gg=G''
            echo "Formatting using formatprg"
        endtry
    endf

    fun! s:close_lsp_floating()
        let buffers = 
            \  map(
            \      filter(
            \          getbufinfo(), 
            \          { _,s -> has_key(s.variables, 'lsp_floating')
            \                   && s.variables.lsp_floating == v:true }),
            \      { _,s -> s.bufnr })
        for buffer in buffers
            call nvim_buf_delete(buffer, { 'force': v:true })
        endfor
    endf

    function! LspStatus() abort
        let sl = ''
        if s:lsp_on()
            let sl.='E[' . luaeval("vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), [[Error]])") . '] '
            let sl.='W[' . luaeval("vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), [[Warning]])") . '] '
        else
            let sl.='LSP off'
        endif
        return sl
    endfunction

    function! s:lsp_on() abort
        return luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    endf

 " }}} 
" Highlights{{{

    hi! LspDiagnosticsUnderlineError guibg=bg gui=NONE guisp=NONE
    hi! LspDiagnosticsUnderlineWarning guibg=bg gui=NONE guisp=NONE
    hi! LspDiagnosticsUnderlineInformation guibg=bg gui=NONE guisp=NONE
    hi! LspDiagnosticsUnderlineHint guibg=bg gui=NONE guisp=NONE

"}}}
