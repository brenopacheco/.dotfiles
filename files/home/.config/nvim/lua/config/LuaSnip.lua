require('luasnip').setup({
	history = true,
	delete_check_events = 'TextChanged',
})

require('luasnip.loaders.from_snipmate').lazy_load({
	paths = { vim.fn.stdpath('config') .. '/snippets' },
})
