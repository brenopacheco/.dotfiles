local debounce = require('completions.debounce')

local M = {}

local refresh = debounce(500, function(ctx)
	ctx:refresh_keyword()
	ctx:refresh_matches()
	ctx:complete()
end)

---@param ctx CompletionContext
---@param source CompletionSource
local on_source_changed = function(ctx, source)
	ctx:refresh_source(source)
	refresh(ctx)
end

local on_text_changed_i = function(ctx)
	ctx:complete()
	refresh(ctx)
end

local on_cursor_moved_i = on_text_changed_i

local on_insert_enter = on_text_changed_i

local on_insert_leave = function(ctx)
	ctx:clear()
end

---@param ctx CompletionContext
M.init = function(ctx)
	local group = vim.api.nvim_create_augroup('completions', { clear = true })

	local refresh = debounce(ctx.opts.debounce_time, function()
		ctx:refresh_keyword()
		ctx:refresh_matches()
		ctx:complete()
	end)

	vim.api.nvim_create_autocmd({ 'TextChangedI', 'CursorMovedI' }, {
		nested = true,
		group = group,
		callback = function(ev) end,
	})

	vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		nested = true,
		group = group,
		pattern = '*:i',
		callback = function(ev) end,
	})

	vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
		nested = true,
		group = group,
		callback = function(ev) end,
	})

end

return M
