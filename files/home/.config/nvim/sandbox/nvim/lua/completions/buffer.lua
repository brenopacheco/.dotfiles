---@class CompletionBufferSource : CompletionSource
---@field name 'buffer'
---@field private timer uv_timer_t
---@field private stale boolean
local Source = {}

---@param ctx CompletionContext
function Source:new(ctx)
	local obj = setmetatable({}, { __index = self })
	obj.ctx = ctx
	obj.name = 'buffer'
	obj.items = {}
	obj.stale = false
	obj.timer = vim.loop.new_timer()
	obj:setup_autocmds()
	return obj
end

---@private
function Source:invalidate()
	self.stale = true
end

---@private
function Source:should_update(bufnr)
	return self.stale
		and vim.api.nvim_get_current_buf() == bufnr
		and vim.api.nvim_get_mode().mode:match('i')
end

---@private
function Source:update()
	if self.timer:is_active() then
		self.timer:stop()
	end
	self.timer:start(
		self.ctx.opts.sources.buffer.debounce_time,
		0,
		vim.schedule_wrap(function()
			pdebug('updating buffer source')
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
		end)
	)
end

---@private
function Source:setup_autocmds()
	vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
		desc = 'Updates buffer source',
		group = self.ctx.evgroup,
		callback = function()
			-- pdebug('buffer source invalidated')
			self:invalidate()
		end,
	})
	vim.api.nvim_create_autocmd('CursorHoldI', {
		desc = 'Try updating buffer source',
		group = self.ctx.evgroup,
		callback = function(ev)
			if self:should_update(ev.buf) then
				pdebug('triggering buffer source update')
				self:update()
			end
		end,
	})
end

return Source
