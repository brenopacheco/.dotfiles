local utils = require("utils")

require("zk").setup({
	picker = "telescope", -- or "select"
	highlight = {
		additional_vim_regex_highlighting = { "markdown" },
	},
	lsp = {
		config = {
			cmd = { "zk", "lsp" },
			name = "zk",
			on_attach = utils.lsp_attach,
		},
		auto_attach = {
			enabled = true,
			filetypes = { "markdown", "org", "norg" },
		},
	},
})
