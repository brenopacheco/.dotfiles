---@param path string
---@return string, number : trimmed path, length of trimmed path
local function trim_path(path, max_len)
	local match
	local tpath = tostring(path)
	while true do
		if string.len(tpath) <= max_len or string.find(tpath, '^/?[^/]+$') then
			break
		end
		tpath, match = string.gsub(tpath, '^/[^/]+', '')
		if match == 0 then break end
	end
	if string.len(path) > string.len(tpath) then
		return '…' .. tpath, string.len(tpath) + 1
	end
	return tpath, string.len(tpath)
end

local M = function()
	local cur_win = vim.api.nvim_get_current_win()
	local orig_buf = vim.api.nvim_get_current_buf()

	local bufs = vim
		.iter(vim.api.nvim_list_bufs())
		:filter(
			---@diagnostic disable-next-line: return-type-mismatch
			function(buf) return vim.fn.buflisted(buf) ~= 0 end
		)
		:totable()

	local max_len =
		tonumber(string.format('%.0f', 0.7 * vim.api.nvim_win_get_width(cur_win)))

	-- BUG: this does not work when writing text into prompt. need a hook?
	vim.ui.select(bufs, {
		prompt = 'Quickbuf',
		on_next = function(selection)
			-- workaround
			vim.cmd(
				'keepjumps lua vim.api.nvim_win_set_buf('
					.. cur_win
					.. ','
					.. selection.value
					.. ')'
			)
		end,
		format_item = function(item)
			local bufname = vim.api.nvim_buf_get_name(item)
			local trimmed = trim_path(bufname, max_len)
			return string.format('%-4s %s', '[' .. tostring(item) .. ']', trimmed)
		end,
	}, function(choice) vim.print('choice: ' .. choice) end)
end

M()

return M
