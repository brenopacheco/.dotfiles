-- /home/breno/notes/zilnsp0h-fennel.md:25

local bufutils = require('utils.buf')
local fennel = require('fennel').setup()

local mt = getmetatable(fennel) or {}
mt.__call = function(_, ...) return fennel.eval(...) end

_G.fnl = fennel
_G.fennel = fennel

---@param cmd table
local function compile(cmd)
	if not bufutils.is_visual() then vim.cmd('normal! gv') end
	local lines = bufutils.get_visual2()
	local filename = vim.fn.expand('%:p') .. ':' .. cmd.line1
	local lua_code =
		fennel.compileString(table.concat(lines, '\n'), { filename = filename })
	local content = { '// Fennel:', '//' }
	vim
		.iter(lines)
		:each(function(line) table.insert(content, '//    ' .. line) end)
	table.insert(content, '')
	vim
		.iter(vim.split(lua_code, '\n'))
		:each(function(line) table.insert(content, line) end)
	bufutils.throwaway(
		content,
		{ orientation = 'vsplit', filetype = 'lua', bufname = 'fennel-compile' }
	)
end

---@param cmd table
local function eval(cmd)
	if not bufutils.is_visual() then vim.cmd('normal! gv') end
	local lines = bufutils.get_visual2()
	local filename = vim.fn.expand('%:p') .. ':' .. cmd.line1
	fennel.eval(table.concat(lines, '\n'), { filename = filename })
end

vim.api.nvim_create_user_command('FennelCompile', compile, {
	nargs = 0,
	range = 2,
})

vim.api.nvim_create_user_command('FennelEval', eval, { nargs = 0, range = 2 })
