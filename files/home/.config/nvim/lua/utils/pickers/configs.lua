--- Luafiles picker
--
-- Select a file from ~/.config/nvim

return function()
	local cwd_len = string.len(tostring(vim.fn.expand('~/.config/nvim'))) + 2

	vim.ui.select(vim.fn.systemlist([[ fd -t f . ~/.config/nvim ]]), {
		prompt = 'Lua configurations:',
		format_item = function(item)
			return string.sub(item, cwd_len)
		end,
	}, function(choice)
		if choice ~= nil then
			vim.cmd('e ' .. choice)
		end
	end)
end
