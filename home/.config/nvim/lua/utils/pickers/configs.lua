--- Luafiles picker
--
-- Select a file from ~/.config/nvim

return function()
	local path = vim.fn.expand('~/.config/nvim')
	local cwd_len = string.len(tostring(path)) + 2
	---@type string[]|nil
	local files = vim.fn.systemlist([[ fd -t f . ]] .. path)
	assert(files ~= nil and #files > 0, 'No files found')
	vim.ui.select(files, {
		prompt = 'Lua configurations:',
		format_item = function(item) return string.sub(item, cwd_len) end,
	}, function(choice, _, action)
		if action == 'edit' then
			vim.cmd('edit ' .. choice)
		else
			vim.cmd(action .. ' | edit ' .. choice)
		end
	end)
end
