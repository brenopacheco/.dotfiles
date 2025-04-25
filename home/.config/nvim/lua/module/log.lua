-- Log
--
-- Adds global _G.log function
-- Adds Log <lua expr> command

-- TODO: new module "timestamp"
-- local start_time = vim.loop.hrtime()
-- log('Time: ' .. (vim.loop.hrtime() - start_time) / 1e6 .. ' ms') -- Convert to ms


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

local function logcmd(tbl)
	local s = 'return _G.log(' .. table.concat(tbl.fargs, '\n') .. ')'
	assert(loadstring(s))()
end

vim.api.nvim_create_user_command('Log', logcmd, { nargs = '*' })
