local lsputil = require('utils.lsp')

require('neodev').setup({
	-- This makes any root trigger neodev's setup. Otherwise, only neovim files
	-- will trigger it.
	override = function(_, library)
		library.enabled = true
		library.runtime = true
		library.plugins = true
		library.types = true
	end,
	lspconfig = true,
	pathStrict = true,
})

local capabilities = lsputil.capabilities

local lsp = require('lspconfig')

lsp.lua_ls.setup({
	capabilities = capabilities,
  -- https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false,
				library = {
					vim.fn.resolve(vim.fn.stdpath('config') .. '/lua/types'),
				},
			},
			completion = {
				keywordSnippet = 'Disable',
			},
		},
	},
})
