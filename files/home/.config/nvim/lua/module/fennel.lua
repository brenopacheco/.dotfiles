local fennel = require('fennel')

local root = vim.fn.resolve(vim.fn.stdpath('config')) .. '/'

fennel.path = table.concat({
	root .. 'fnl/?.fnl',
	root .. 'fnl/?/init.fnl',
	root .. 'lua/?.lua',
	root .. 'lua/?/init.lua',
}, ';')

fennel['macro-path'] = table.concat({
	root .. 'fnl/macros.fnl',
	root .. 'fnl/?/macros.fnl',
}, ';')

table.insert(package.loaders, fennel.searcher)
debug.traceback = fennel.traceback

_G.fennel = fennel
