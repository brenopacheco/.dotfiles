require('neodev').setup({
	library = { plugins = { 'nvim-dap-ui' }, types = true },
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsp = require('lspconfig')

lsp.lua_ls.setup({
	capabilities = capabilities,
	Lua = {
		workspace = {
			library = vim.api.nvim_get_runtime_file('', true),
		},
		runtime = {
			version = 'LuaJIT',
			path = vim.split(package.path, ';'),
		},
		diagnostics = {
			globals = { 'vim' },
			disable = { 'lowercase-global', 'unused-vararg' },
		},
	},
})
