local fennel = require('fennel')

table.insert(package.loaders, fennel.searcher)
debug.traceback = fennel.traceback

local path = table.concat({
		vim.fn.stdpath('config') .. '/fnl/?.fnl',
		vim.fn.stdpath('config') .. '/fnl/?/init.fnl',
		vim.fn.stdpath('config') .. '/lua/?.lua',
		vim.fn.stdpath('config') .. '/lua/?/init.lua',
	}, ';')

fennel.path = path
fennel["macro-path"] = path
fennel.install({
  -- TODO:
})
