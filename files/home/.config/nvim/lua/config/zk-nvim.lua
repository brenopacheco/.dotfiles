require('zk').setup({
	picker = 'telescope', -- or "select"
	highlight = {
		additional_vim_regex_highlighting = { 'markdown' },
	},
	lsp = {
		config = {
			cmd = { 'zk', 'lsp' },
			name = 'zk',
			capabilities = require('cmp_nvim_lsp').default_capabilities(),
			on_attach = function(client, bufnr)
				vim.keymap.set(
					'n',
					'<leader>i',
					'<cmd>ZkInsertLink<cr>',
					{ buffer = bufnr }
				)
			end,
		},
		auto_attach = {
			enabled = true,
			filetypes = { 'markdown', 'org', 'norg' },
		},
	},
})
