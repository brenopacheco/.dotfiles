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

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false


local lsp = require('lspconfig')

lsp.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			workspace = {
				library = {
					vim.fn.resolve(vim.fn.stdpath('config') .. '/lua/types'),
				},
			},
      completion = {
        keywordSnippet = "Disable"
      }
		},
	},
})
