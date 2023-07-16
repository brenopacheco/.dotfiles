local utils = require("utils")

require("typescript-tools").setup({
	on_attach = utils.lsp_attach,
	settings = {
		tsserver_plugins = {
			"@styled/typescript-styled-plugin",
		},
	},
	on_init = function(client, _)
		if client.server_capabilities then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.semanticTokensProvider = false
		end
	end,
})
