local lsp = require('lspconfig')

vim.lsp.set_log_level(vim.log.levels.ERROR)

for type, icon in pairs({
	Error = '󰅚 ',
	Warning = '󰀪 ',
	Hint = '󰌶 ',
	Information = '󰋽 ',
}) do
	local hl = 'DiagnosticSign' .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = true,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false

lsp.autotools_ls.setup({ capabilities = capabilities })
lsp.bashls.setup({ capabilities = capabilities })
lsp.clangd.setup({ capabilities = capabilities })
lsp.cssls.setup({ capabilities = capabilities })
lsp.dockerls.setup({ capabilities = capabilities })
lsp.eslint.setup({ capabilities = capabilities })
lsp.gopls.setup({ capabilities = capabilities })
lsp.html.setup({ capabilities = capabilities })
lsp.jsonls.setup({
	settings = {
		json = {
			schemas = require('schemastore').json.schemas(),
			validate = { enable = true },
		},
	},
	capabilities = capabilities,
})
lsp.marksman.setup({ capabilities = capabilities })
lsp.omnisharp.setup({
	cmd = {
		'omnisharp',
		'--languageserver',
		'--hostPID',
		tostring(vim.fn.getpid()),
	},
	capabilities = capabilities,
	enable_editorconfig_support = true,
	enable_ms_build_load_projects_on_demand = false,
	enable_roslyn_analyzers = false,
	organize_imports_on_format = false,
	enable_import_completion = false, -- true is too slow
	sdk_include_prereleases = true,
	analyze_open_documents_only = false,
	handlers = {
		['textDocument/definition'] = require('omnisharp_extended').handler,
	},
})
lsp.vimls.setup({ capabilities = capabilities })
lsp.yamlls.setup({
	yaml = {
		schemaStore = { enable = false, url = '' },
		schemas = require('schemastore').yaml.schemas(),
	},
	capabilities = capabilities,
})
lsp.zk.setup({ capabilities = capabilities })
