local debounce = require('completions.debounce')

---@class CompletionBufferSource : CompletionSource
---@field name 'buffer'
local source = {
	name = 'buffer',
	items = {},
  stale = false
}

---@param ctx CompletionContext
function source:new(ctx)
	local obj = setmetatable({}, { __index = self })
  obj.ctx = ctx
	obj:init()
	return obj
end

function source:init()
	local debounce_time = self.ctx.opts.sources.buffer.debounce_time
	local debounced_update = debounce(debounce_time, function()
		self:update()
	end)
	vim.api.nvim_create_autocmd(
		{ 'TextChanged', 'TextChangedI', 'TextChangedP' },
		{
			-- desc = 'Updates buffer source',
			group = self.ctx.evgroup,
			callback = function(ev)
				if ev.buf == vim.api.nvim_get_current_buf() then
					debounced_update()
				end
			end,
		}
	)
end

function source:update()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local words = {}
	for _, line in ipairs(lines) do
		for match in line:gmatch('%w%w%w+') do
			words[match] = true
		end
	end
	self.items = vim.tbl_keys(words)
  -- pdebug('buffer source updated')
	self.ctx:update()
end

return source
