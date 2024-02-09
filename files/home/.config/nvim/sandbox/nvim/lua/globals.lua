-- Globals
--
-- Define common lua globals

local count = 0

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
