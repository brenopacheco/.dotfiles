--- Luafiles picker
--
-- Select a file from ~/.config/nvim

return function()
	local cwd_len = string.len(tostring(vim.fn.expand('~/.config/nvim'))) + 2
	---@type string[]|nil
	local files = vim.fn.systemlist([[ fd -t f . ~/.config/nvim ]])
	assert(files ~= nil and #files > 0, 'No files found')
	vim.ui.select(files, {
		prompt = 'Lua configurations:',
		format_item = function(item) return string.sub(item, cwd_len) end,
	}, function(choice, _, action)
		if choice ~= nil then vim.cmd(action .. choice) end
	end)
end
