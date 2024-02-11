local fennel = require('fennel')

local root = vim.fn.resolve(vim.fn.stdpath('config')) .. '/'

fennel.path = table.concat({
	'./fnl/?.fnl',
	'./fnl/?/init.fnl',
	root .. 'fnl/?.fnl',
	root .. 'fnl/?/init.fnl',
}, ';')

fennel['macro-path'] = table.concat({
	'./fnl/macros/?.fnl',
	root .. 'fnl/macros/?.fnl',
}, ';')

local options = {
	['useMetadata'] = true,
	['compiler-env'] = _G,
	['compilerEnv'] = _G,
	['env'] = _G,
	['allowedGlobals'] = false,
	['error-pinpoint'] = false,
}

table.insert(package.loaders, fennel.makeSearcher(options))

debug.traceback = fennel.traceback

_G.fennel = fennel

require('fnl.repl').setup()

vim.api.nvim_create_autocmd({ 'SourceCmd' }, {
	pattern = '*.fnl',
	group = vim.api.nvim_create_augroup('', { clear = true }),
	callback = function(ev) fennel.dofile(ev.file, options) end,
})
