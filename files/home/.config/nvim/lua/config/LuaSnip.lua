local ls = require('luasnip')

ls.setup({
	history = true,
	delete_check_events = 'TextChanged',
})

require('luasnip.loaders.from_snipmate').lazy_load({
	paths = { vim.fn.stdpath('config') .. '/snippets' },
})

vim.keymap.set({ 'x' }, 's', ls.select_keys, { noremap = false })
