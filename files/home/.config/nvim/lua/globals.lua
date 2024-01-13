-- Globals
--
-- Define common lua globals

local count = 0
local messages = {}

---@param level integer
local notifier = function(level)
	---@vararg any
	return function(...)
		local args = { ... }
		count = count + 1
		local ts = vim.fn.strftime('%T')
		local texts = {}
		for _, v in ipairs(args) do
			table.insert(texts, vim.inspect(v))
		end
		local text = table.concat(texts, ', ')
		local trace = debug.traceback()
		local print_trace = level == vim.log.levels.ERROR
		local display = tostring(
			ts
				.. ' #'
				.. count
				.. ': '
				.. text
				.. (print_trace and '\n' .. debug.traceback() or '')
		)
		table.insert(messages, {
			ts = ts,
			text = text,
			level = level,
			trace = trace,
			display = display,
		})
		vim.notify(display, level)
		debug.traceback()
	end
end

_G.ptrace = notifier(vim.log.levels.TRACE)
_G.pdebug = notifier(vim.log.levels.DEBUG)
_G.pinfo = notifier(vim.log.levels.INFO)
_G.pwarn = notifier(vim.log.levels.WARN)
_G.perror = notifier(vim.log.levels.ERROR)

_G.log = notifier(vim.log.levels.INFO)