-- Log
--
-- Adds global _G.log function
-- Adds _G.get_log_level() and _G.set_log_level(level)
-- Replaces vim.notify to respect set log level

local count = 0
local log_level = vim.log.levels.INFO

_G.log = vim.schedule_wrap(function(...)
	local args = { ... }
	count = count + 1
	local ts = vim.fn.strftime('%T')
	local texts = {}
	for _, v in ipairs(args) do
		table.insert(texts, vim.inspect(v))
	end
	local text = table.concat(texts, ', ')
	local display = tostring(ts .. ' #' .. count .. ': ' .. text)
	vim.notify(display, vim.log.levels.INFO)
end)

_G.get_log_level = function() return log_level end

---@param level vim.log.levels
_G.set_log_level = function(level)
	if type(level) ~= 'number' or level < 0 or level > 5 then
		error('Invalid log level: ' .. vim.inspect(level))
	end
	log_level = level
	vim.notify('Log level set to ' .. vim.inspect(level), level)
end

---@param msg string
---@param level vim.log.levels
---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, level)
	level = level or vim.log.levels.INFO
	if level < log_level then return end
	local chunks =
		{ { msg, level == vim.log.levels.WARN and 'WarningMsg' or nil } }
	vim.api.nvim_echo(chunks, true, { err = level == vim.log.levels.ERROR })
end
