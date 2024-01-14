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
			debounce_time = 500,
      min_length = 1
		},
	},
}

---@param opts? CompletionOpts
M.setup = function(opts)
  opts = vim.tbl_deep_extend('force', M.default_opts, opts or {}) ---@cast opts -nil
	ctx = context:new(opts)
  M.configure()
end

M.accept = function()
	ctx:accept()
end

M.enter = function()
	ctx:enter()
end

---@private
M.configure = function()
	vim.o.completeopt = 'menu,menuone,noinsert'
  vim.o.updatetime = 100
	vim.keymap.set(
		'i',
		'<tab>',
		M.accept,
		{ noremap = true, silent = true }
	)
	vim.keymap.set(
		'i',
		'<cr>',
		M.enter,
		{ noremap = true, silent = true }
	)
end

return M
