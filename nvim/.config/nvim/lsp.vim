" Language servers{{{
" enable without git: https://github.com/neovim/nvim-lspconfig/issues/44
" 	tsserver requires typescript, 
" 	jdtls requires jdk-11 
" 	run :LspInstall

lua << EOF
	require'nvim_lsp'.yamlls.setup{}
	require'nvim_lsp'.bashls.setup{}
	require'nvim_lsp'.ccls.setup{}
	require'nvim_lsp'.cssls.setup{}
	require'nvim_lsp'.html.setup{}
	require'nvim_lsp'.jdtls.setup{}
	require'nvim_lsp'.jsonls.setup{}
	require'nvim_lsp'.sumneko_lua.setup{}
	require'nvim_lsp'.tsserver.setup{}
	require'nvim_lsp'.vimls.setup{}
EOF

lua << EOF
	local on_attach = function(client)
		require'diagnostic'.on_attach(client)
		require'lsp-status'.on_attach(client)
	end
EOF

lua <<EOF
	vim.lsp.callbacks['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
	vim.lsp.callbacks['textDocument/references'] = require'lsputil.locations'.references_handler
	vim.lsp.callbacks['textDocument/definition'] = require'lsputil.locations'.definition_handler
	vim.lsp.callbacks['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
	vim.lsp.callbacks['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
	vim.lsp.callbacks['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
	vim.lsp.callbacks['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
	vim.lsp.callbacks['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
EOF


"}}}
" Client settings{{{

	autocmd BufEnter * lua require'diagnostic'.on_attach()
	autocmd BufEnter * set omnifunc=v:lua.vim.lsp.omnifunc

	nmap <C-k> :DisplayInfo<CR>
	command! DisplayInfo :call s:display_info()
	function s:display_info() abort
		lua vim.lsp.buf.hover()
		lua vim.lsp.buf.signature_help()
		lua vim.lsp.util.show_line_diagnostics()
	endfunction

"}}}
" Diagnostics settings{{{

	let g:diagnostic_enable_virtual_text = 1
	let g:diagnostic_virtual_text_prefix = ' '
	let g:diagnostic_trimmed_virtual_text = '100'
	let g:space_before_virtual_text = 5
	let g:diagnostic_show_sign = 1
	let g:diagnostic_sign_priority = 20
	call sign_define("LspDiagnosticsErrorSign"       ,  {"text" : "E" ,  "texthl" : "LspDiagnosticsError"})
	call sign_define("LspDiagnosticsWarningSign"     ,  {"text" : "W" ,  "texthl" : "LspDiagnosticsWarning"})
	call sign_define("LspDiagnosticsInformationSign" ,  {"text" : "I" ,  "texthl" : "LspDiagnosticsInformation"})
	call sign_define("LspDiagnosticsHintSign"        ,  {"text" : "H" ,  "texthl" : "LspDiagnosticsHint"})
	let g:diagnostic_enable_underline = 1
	let g:diagnostic_auto_popup_while_jump = 1
	let g:diagnostic_insert_delay = 1

"}}}

