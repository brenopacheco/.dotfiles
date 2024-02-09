local plugin_dir = vim.fn.simplify(vim.fn.stdpath('config') .. '/../../')
log(plugin_dir)
vim.opt.runtimepath = {
	vim.fn.stdpath('config'),
	vim.fn.stdpath('config') .. '/after',
	vim.env.VIMRUNTIME,
	'/usr/lib/nvim',
}
vim.opt.packpath = { plugin_dir }
vim.cmd('packadd LuaSnip')

require('luasnip').setup({
	history = true,
	delete_check_events = 'TextChanged',
})

require('luasnip.loaders.from_snipmate').lazy_load({
	paths = { plugin_dir .. '/snippets' },
})
