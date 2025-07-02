local capabilities = require('utils.lsp').capabilities

require('zk').setup({
	picker = 'telescope', -- or "select"
	highlight = {
		additional_vim_regex_highlighting = { 'markdown' },
	},
	lsp = {
		config = {
			capabilities = capabilities,
			on_attach = function(_, bufnr)
				vim.keymap.set(
					'n',
					'<leader>i',
					'<cmd>ZkInsertLink<cr>',
					{ buffer = bufnr }
				)
			end,
		},
	},
})
