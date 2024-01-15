local context = require('completions.context')

local M = {}

---@type CompletionContext
local ctx = nil

---@type CompletionOpts
M.default_opts = {
	max_items = 5,
	debounce_time = 100,
	sources = {
		buffer = {
			debounce_time = 1000,
			min_length = 1,
			all_buffers = false, -- TODO: implement
		},
		snippet = {
			min_length = 1,
		},
	},
}

---@param opts? CompletionOpts
M.setup = function(opts)
	opts = vim.tbl_deep_extend('force', M.default_opts, opts or {}) ---@cast opts -nil
	ctx = context:new(opts)
	vim.o.completeopt = 'menu,menuone,noinsert'
	vim.o.updatetime = 100
	vim.keymap.set('i', '<cr>', '<c-e><cr>', {})
	vim.keymap.set('i', '<tab>', function()
		ctx:accept('<tab>')
	end)
	vim.keymap.set('n', '<s-tab>', M.inspect, {})
end

M.toggle = function()
	assert(ctx, 'completions not setup')
	ctx:toggle()
end

M.inspect = function()
  pdebug(ctx)
end

return M
