local lsp = require('lspconfig')
local lsputil = require('utils.lsp')

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
-- lsp.marksman.setup({ capabilities = capabilities })
lsp.rust_analyzer.setup({
	cmd = { vim.fn.trim(vim.fn.system('rustup which rust-analyzer')) },
	capabilities = capabilities,
	-- on_attach = function(_, bufnr)
	-- 	vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	-- end,
})
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
