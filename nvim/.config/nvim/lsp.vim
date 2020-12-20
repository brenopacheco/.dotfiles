" Language servers{{{

lua << EOF
    -- override default handlers
    require('lsp-overrides')

    -- require lspconfig for server defaults
    local lspconfig = require'lspconfig'

    -- -- mappings for on_attach and custom handlers
    -- local custom_handlers = require('lsp-handlers')
    -- local custom_attach = function()
    --       vim.api.nvim_buf_set_keymap(0, 'n', '<c-]>', 
    --         '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
    -- end

    -- -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- -- capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- lspconfig.util.default_config = vim.tbl_extend(
    --     "force", lspconfig.util.default_config, { 
    --         -- capabilities = capabilities,
    --         -- init_options = { usePlaceholders = true },
    --         on_attach = custom_attach,
    --         handlers = custom_handlers
    -- })

    -- enable lsp servers
    lspconfig.bashls.setup{}
    lspconfig.ccls.setup{}
    lspconfig.cssls.setup{}
    lspconfig.html.setup{}
    lspconfig.jdtls.setup{}
    lspconfig.jsonls.setup{}
    lspconfig.sumneko_lua.setup{
      on_attach = custom_attach,
      handlers = custom_handlers,
      -- capabilities = {
      --     textDocument = {
      --       completion = {
      --         completionItem = {
      --           snippetSupport = false}}}},
      settings = {
            Lua = {
                -- completion = { 
                --     keywordSnippet = { "Disable"}},
                diagnostics = {
                    globals = {"vim", "love"},
                    disable = {"lowercase-global",
                               "unused-vararg"}}}}}
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
        lua vim.lsp.buf.peek_definition()
        let s:pos = []
      else
        lua vim.lsp.buf.signature_help()
        lua vim.lsp.buf.hover()
        let s:pos = getpos('.')
      endif
  endfunction
  command! PeekDefinition :lua vim.lsp.buf.peek_definition()<CR>
  command! SignatureHelp :lua vim.lsp.buf.signature_help()<CR>
  command! Hover :lua vim.lsp.buf.hover()<CR>

  fun! s:i_signaturehelp()
      lua vim.lsp.buf.signature_help()
      " echo map(getbufinfo(), { _,s -> s.bufnr })
      return ""
  endf

  inoremap <silent> <C-k>     <c-r>=<SID>i_signaturehelp()<CR>
  " idea: from insert mode jump to popup
  " clickin c-k toggles popup in insert mode
  " clicking c-k 3 times closes popup in normal mode


    inoremap <silent><c-o> <c-r>=<SID>close_lsp_floating()<CR>

    fun! s:close_lsp_floating()
       let buffers = map(filter(getbufinfo(), 
           \ { _,s -> has_key(s.variables, 'lsp_floating')
           \ && s.variables.lsp_floating == v:true }),
           \ { _,s -> s.bufnr })
       " echo "buffers: " . string( buffers )
       for buffer in buffers
            call nvim_buf_delete(buffer, { 'force': v:true })
       endfor
       return ""
    endf

  nnoremap <silent> <leader>= gg=G''

  nnoremap <silent> <C-k>     :DisplayInfo<CR>
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
          let sl.='LSP off'
      endif
      return sl
  endfunction

 " }}} 
" diagnostics

hi! LspDiagnosticsUnderlineError guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineWarning guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineInformation guibg=bg gui=NONE guisp=NONE
hi! LspDiagnosticsUnderlineHint guibg=bg gui=NONE guisp=NONE
