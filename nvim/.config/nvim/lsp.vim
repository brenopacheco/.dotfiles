" Language servers{{{

silent! lua << EOF
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

"}}}
" Client settings{{{

	autocmd BufEnter * set omnifunc=v:lua.vim.lsp.omnifunc

    command! LspStatus      :lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>
	nmap <C-k> :DisplayInfo<CR>
	command! DisplayInfo :silent call s:display_info()
	function s:display_info() abort
		lua vim.lsp.buf.hover()
		lua vim.lsp.buf.signature_help()
		lua vim.lsp.util.show_line_diagnostics()
	endfunction

"}}}
