-- /home/breno/notes/zilnsp0h-fennel.md:25

local bufutils = require('utils.buf')
local fennel = require('fennel').setup()

local mt = getmetatable(fennel) or {}
mt.__call = function(_, ...) return fennel.eval(...) end

_G.fnl = fennel
_G.fennel = fennel

local function open_compile_buffer(selection, lua_code)
	local content = { '// Fennel:', '//' }
	vim
		.iter(selection)
		:each(function(line) table.insert(content, '//    ' .. line) end)
	table.insert(content, '')
	vim.iter(lua_code):each(function(line) table.insert(content, line) end)
	bufutils.throwaway(
		content,
		{ orientation = 'vsplit', filetype = 'lua', bufname = 'fennel-compile' }
	)
end

local function compile(cmd)
	local buffer = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local fnl_code = table.concat(buffer, '\n')
	if cmd.range == 0 then
		local lua_code = assert(fennel.compileString(fnl_code))
		open_compile_buffer(buffer, vim.split(lua_code, '\n'))
		return
	end
	if not bufutils.is_visual() then vim.cmd('normal! gv') end
	local selection = bufutils.get_visual2()
	vim.cmd('normal! "zy')
	local compile_cmd = ',compile ' .. table.concat(selection, '\n')
	local repl = coroutine.create(fennel.repl)
	local msg_nr = 0
	local ast_nr = 0
	local on_out = function(out)
		msg_nr = msg_nr + 1
		local msg = vim
			.iter(out)
			:map(function(line) return vim.split(line, '\n') end)
			:flatten(1)
			:totable()
		if msg_nr == ast_nr then
			vim.schedule(function() open_compile_buffer(selection, msg) end)
		end
	end
	local on_err = function(_, msg)
		vim.notify(msg, vim.log.levels.ERROR)
		coroutine.resume(repl, ',exit')
	end
	coroutine.resume(repl, {
		readChunk = coroutine.yield,
		onValues = on_out,
		onError = on_err,
		env = _G,
	})
	local queue = {}
	local parse = fennel.parser(fnl_code)
	for ok, ast in parse do
		if ok then
			ast_nr = ast_nr + 1
			table.insert(
				queue,
				function() coroutine.resume(repl, fennel.view(ast)) end
			)
		end
	end
	table.insert(queue, function() coroutine.resume(repl, compile_cmd) end)
	ast_nr = ast_nr + 1
	table.insert(queue, function() coroutine.resume(repl, ',exit') end)
	vim.iter(queue):each(function(fn) fn() end)
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
