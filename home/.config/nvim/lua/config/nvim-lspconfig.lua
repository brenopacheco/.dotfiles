local lsp = require('lspconfig')
local lsputil = require('utils.lsp')

if vim.z.enabled('neodev') then
	require('neodev').setup({ lspconfig = true })
end

vim.lsp.set_log_level(vim.log.levels.INFO) -- DEBUG / INFO

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

local capabilities = lsputil.capabilities

lsp.biome.setup({ capabilities = capabilities })
lsp.bashls.setup({ capabilities = capabilities })
lsp.clangd.setup({
	capabilities = capabilities,
	offset_encoding = 'utf-16',
	cmd = {
		'clangd',
		'--offset-encoding=utf-16',
	},
})
lsp.cssls.setup({ capabilities = capabilities })
lsp.dockerls.setup({ capabilities = capabilities })
lsp.eslint.setup({ capabilities = capabilities })
lsp.gopls.setup({
	capabilities = vim.tbl_extend('force', capabilities, {
		textDocument = {
			completion = {
				completionItem = {
					snippetSupport = true,
				},
			},
		},
	}),
})
lsp.html.setup({ capabilities = capabilities })
lsp.jsonls.setup({
	capabilities = capabilities,
	settings = {
		json = {
			schemas = require('schemastore').json.schemas(),
			validate = { enable = true },
		},
	},
})
lsp.rust_analyzer.setup({ capabilities = capabilities })
lsp.vimls.setup({ capabilities = capabilities })
lsp.yamlls.setup({
	capabilities = capabilities,
	settings = {
		yaml = {
			schemaStore = {
				enable = false,
				url = '',
			},
			schemas = require('schemastore').yaml.schemas(),
		},
	},
})
lsp.zk.setup({ capabilities = capabilities })
lsp.lua_ls.setup({ capabilities = capabilities })
