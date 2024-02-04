local fennel = require('fennel')

local root = vim.fn.resolve(vim.fn.stdpath('config')) .. '/'

fennel.path = table.concat({
	'./fnl/?.fnl',
	'./fnl/?/init.fnl',
	root .. 'fnl/?.fnl',
	root .. 'fnl/?/init.fnl',
}, ';')

fennel['macro-path'] = table.concat({
	'./fnl/macros.fnl',
	'./fnl/?/macros.fnl',
	root .. 'fnl/macros.fnl',
	root .. 'fnl/?/macros.fnl',
}, ';')

table.insert(package.loaders, fennel.searcher)
debug.traceback = fennel.traceback

_G.fennel = fennel

-- require('fennel-repl').setup()
