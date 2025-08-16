local capabilities = require('utils.lsp').capabilities()

-- TODO:
-- local zk_keywordprg = function(tbl)
-- 	log(tbl)
-- end

-- vim.api.nvim_create_user_command('ZkHelp', zk_keywordprg, { nargs = '+', range = 2 })

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
				-- vim.opt.keywordprg = ':ZkHelp'
			end,
		},
	},
})
