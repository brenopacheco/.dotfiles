local api = require("typescript-tools.api")
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('typescript-tools').setup({
	capabilities = capabilities,
	settings = {
		separate_diagnostic_server = true,
		expose_as_code_action = 'all',
		tsserver_plugins = {
			'@styled/typescript-styled-plugin',
		},
		-- code_lens = 'all',
		code_lens = 'off',
		jsx_close_tag = {
			enable = false,
			filetypes = { 'javascriptreact', 'typescriptreact' },
		},
	},
	handlers = {
		['textDocument/publishDiagnostics'] = api.filter_diagnostics(
			-- Ignore 'File is a CommonJS module; it may be converted to an ES module.' diagnostics.
			{ 80001 }
		),
	},
})
