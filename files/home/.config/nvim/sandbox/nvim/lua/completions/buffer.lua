local debounce = require('completions.debounce')

---@class CompletionBufferSource : CompletionSource
---@field name 'buffer'
local source = {
	name = 'buffer',
	items = {},
	stale = false,
}

---@param ctx CompletionContext
function source:new(ctx)
	local obj = setmetatable({}, { __index = self })
	obj.ctx = ctx
	obj:init()
	return obj
end

function source:should_update(bufnr)
	local mode = vim.api.nvim_get_mode().mode
	local is_current_buffer = vim.api.nvim_get_current_buf() == bufnr
	local is_insert_mode = mode == 'i' or mode == 'ic'
	local is_stale = self.stale
	return is_current_buffer and is_insert_mode and is_stale
end

function source:init()
	local debounce_time = self.ctx.opts.sources.buffer.debounce_time
	local debounced_update = debounce(debounce_time, function()
		self.stale = false
		self:update()
	end)

	vim.api.nvim_create_autocmd('CursorMovedI', {
		desc = 'Updates buffer source',
		group = self.ctx.evgroup,
		callback = function()
			self.stale = true
		end,
	})

	vim.api.nvim_create_autocmd('CursorHoldI', {
		desc = 'Updates buffer source',
		group = self.ctx.evgroup,
		callback = function(ev)
			if self:should_update(ev.buf) then
				debounced_update()
			end
		end,
	})
end

function source:update()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local words = {}
	for _, line in ipairs(lines) do
		for match in line:gmatch('%w%w%w+') do
			if match ~= self.ctx.keyword then
				words[match] = true
			end
		end
	end
	self.items = vim.tbl_map(function(word)
		return { value = word, source = 'buffer' }
	end, vim.tbl_keys(words))
	self.ctx:update({ complete = true })
end

return source
