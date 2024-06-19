local bufutil = require('utils.buf')
local configs = require('lspconfig.configs')
local lsp = require('lspconfig')
local lsputil = require('utils.lsp')
local util = require('lspconfig.util')

-- vim.lsp.set_log_level(vim.log.levels.DEBUG)
vim.lsp.set_log_level(vim.log.levels.INFO)

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

lsp.autotools_ls.setup({ capabilities = capabilities })
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
lsp.eslint.setup({
	capabilities = capabilities,
	on_attach = function(_, bufnr)
		vim.keymap.set(
			{ 'n', 'x' },
			'<leader>=',
			'<cmd>EslintFixAll<cr>',
			{ buffer = bufnr }
		)
	end,
})
lsp.elixirls.setup({
	capabilities = capabilities,
	cmd = { '/usr/bin/elixir-ls' },
})
if vim.z.enabled('fennel') then
	lsp.fennel_ls.setup({
		root_dir = function() return vim.fn.resolve(vim.fn.stdpath('config')) end,
		capabilities = capabilities,
		settings = {
			['fennel-ls'] = {
				['fennel-path'] = fennel['path'],
				['macro-path'] = fennel['macro-path'],
				['macro-file'] = fennel['macro-path'],
				['extra-globals'] = table.concat(vim.tbl_keys(_G), ' '),
			},
		},
	})
end
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
		'dotnet',
		'/usr/lib/omnisharp/OmniSharp.dll',
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
	on_attach = function(client, bufnr)
		vim.keymap.set({ 'n', 'x' }, '<leader>=', vim.lsp.buf.format, {})
	end,
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

lsp.metals.setup({
	capabilities = capabilities,
	root_dir = lsp.util.root_pattern(
		'build.sbt',
		'build.sc',
		'build.gradle',
		'pom.xml',
		'.git'
	),
})

lsp.svelte.setup({
	capabilities = capabilities,
})

lsp.helm_ls.setup({
	capabilities = capabilities,
})

-- lsp.biome.setup({
-- 	capabilities = capabilities,
-- 	on_attach = function(_, bufnr)
-- 		vim.keymap.set({ 'n', 'x' }, '<leader>=', function()
-- 			if vim.fn.mode() == 'n' then
-- 				vim.cmd([[Neoformat biome]])
-- 			else
-- 				bufutil.set_visual(bufutil.get_visual())
-- 				vim.cmd([['<,'>Neoformat biome]])
-- 			end
-- 		end, { buffer = bufnr })
-- 	end,
-- })
