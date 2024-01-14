local debounce = require('completions.debounce')

local M = {}

---@param ctx CompletionContext
M.init = function(ctx)
	local group = vim.api.nvim_create_augroup('completions', { clear = true })

	local update = function()
		ctx:update()
	end

 --  --- this also handles insert mode enter
	-- vim.api.nvim_create_autocmd({ 'TextChangedI' }, {
	-- 	desc = 'Refresh on text change and cursor move',
	-- 	group = group,
	-- 	callback = function()
 --      pdebug('TextChangedI')
	-- 	  -- update()
	-- 	end,
	-- })

	-- vim.api.nvim_create_autocmd({  'TextChangedP' }, {
	-- 	desc = 'Refresh on text change and cursor move',
	-- 	group = group,
	-- 	callback = function()
 --      pdebug('TextChangedP')
	-- 	  -- update()
	-- 	end,
	-- })

	vim.api.nvim_create_autocmd({ 'CursorMovedI' }, {
		desc = 'Refresh on text change and cursor move',
		group = group,
		callback = function()
      pdebug('CursorMovedI')
		  -- update()
		end,
	})

	return group
end

return M
