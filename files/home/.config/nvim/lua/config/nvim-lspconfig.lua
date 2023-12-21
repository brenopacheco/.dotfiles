local lsp = require('lspconfig')

-- vim.api.nvim_del_augroup_by_name('LspAttach')

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

--[[ ansiblels cmake dotls efm elixirls graphql helm_ls jdtls jqls ocamllsp
prismals pylyzer quick_lint_js rust_analyzer serve_d solargraph sqlls svelte
tailwindcss zls --]]

local capabilities = vim.z.enabled('cmp_nvim_lsp')
		and require('cmp_nvim_lsp').default_capabilities()
	or nil

-- This is required because of https://github.com/neovim/neovim/pull/24331

-- lsp.autotools_ls.setup({ capabilities = capabilities })
-- lsp.bashls.setup({ capabilities = capabilities })
-- lsp.clangd.setup({ capabilities = capabilities })
-- lsp.cssls.setup({ capabilities = capabilities })
-- lsp.dockerls.setup({ capabilities = capabilities })
-- lsp.eslint.setup({ capabilities = capabilities
-- on_attach = function() --[[ nmap format to EslintFixAll ]] end
-- })
-- lsp.gopls.setup({ capabilities = capabilities })
-- lsp.html.setup({ capabilities = capabilities })
-- lsp.jsonls.setup({
-- 	settings = {
-- 		json = {
-- 			schemas = require('schemastore').json.schemas(),
-- 			validate = { enable = true },
-- 		},
-- 	},
-- 	capabilities = capabilities,
-- })
lsp.lua_ls.setup({
	capabilities = capabilities,
	-- on_attach = on_attach,
	Lua = {
		workspace = {
			library = {
				[vim.fn.expand('$VIMRUNTIME/lua')] = true,
				[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
			},
		},
		runtime = {
			version = 'LuaJIT',
			path = vim.split(package.path, ';'),
		},
		diagnostics = {
			globals = { 'vim', 'love' },
			disable = { 'lowercase-global', 'unused-vararg' },
		},
	},
})
-- lsp.lua_ls.setup({ capabilities = capabilities, on_attach = on_attach })
-- lsp.marksman.setup({ capabilities = capabilities })
-- lsp.omnisharp.setup({
-- 	cmd = {
-- 		'/bin/omnisharp',
-- 		'--languageserver',
-- 		'--hostPID',
-- 		tostring(vim.fn.getpid()),
-- 	},
-- 	capabilities = capabilities,
-- })
-- lsp.tsserver.setup({ capabilities = capabilities })
-- lsp.vimls.setup({ capabilities = capabilities })
-- lsp.yamlls.setup({
-- 	yaml = {
-- 		schemaStore = { enable = false, url = '' },
-- 		schemas = require('schemastore').yaml.schemas(),
-- 	},
-- 	capabilities = capabilities,
-- })
-- lsp.zk.setup({ capabilities = capabilities })
