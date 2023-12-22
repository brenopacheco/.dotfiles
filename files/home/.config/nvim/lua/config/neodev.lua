require('neodev').setup({})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsp = require('lspconfig')

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
