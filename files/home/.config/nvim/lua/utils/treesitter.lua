local M = {}

--- Get capture groups at cursor position.
--- Works in insert and normal mode.
---
---@return string[] : capture group names
M.get_captures = function()
	---@type string
	local mode = vim.fn.mode()
	assert(mode == 'i' or mode == 'n', 'invalid mode')
	local pos = vim.api.nvim_win_get_cursor(0)
	local row = pos[1] - 1
	local col = pos[2] - (mode == 'i' and 1 or 0)
	local buf = vim.api.nvim_get_current_buf()
	local data = vim.inspect_pos(buf, row, col, {
		syntax = false,
		treesitter = true,
		extmarks = false,
		semantic_tokens = false,
	}).treesitter
	return vim.tbl_map(function(group)
		return group.capture
	end, data)
end

--- Checks if cursor is in a comment.
---
---@return boolean : true if cursor is in a comment
M.is_comment = function()
	local captures = M.get_captures()
	for _, capture in ipairs(captures) do
		local str = string.lower(capture)
		local match = string.match(str, 'comment')
		if match then
			return true
		end
	end
	return false
end

return M
