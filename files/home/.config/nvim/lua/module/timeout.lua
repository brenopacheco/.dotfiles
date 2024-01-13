--- Timeout
--
-- Overrides timeout and timeoutlen for insert mode

local group = vim.api.nvim_create_augroup('winresize', { clear = true })

local old_timeout = vim.opt.timeout
local old_timeoutlen = vim.opt.timeoutlen

vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
	nested = true,
	desc = 'Sets insert mode timeout',
	group = group,
	callback = vim.schedule_wrap(function()
		old_timeout = vim.opt.timeout:get()
		old_timeoutlen = vim.opt.timeoutlen:get()
		vim.opt.timeout = true
		vim.opt.timeoutlen = 300
	end),
})

vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
	nested = true,
	desc = 'Sets insert mode timeout',
	group = group,
	callback = vim.schedule_wrap(function()
		vim.opt.timeout = old_timeout
		vim.opt.timeoutlen = old_timeoutlen
	end),
})
