local M = {}

M.list = function()
	local buffer_marks = vim
		.iter(vim.fn.getmarklist(vim.fn.bufnr()))
		:map(function(mark)
			mark.file = vim.fn.bufname()
			return mark
		end)
		:totable()

	local global_marks = vim.fn.getmarklist()

	local all_marks = vim.list_extend(buffer_marks, global_marks)

	local marks = vim
		.iter(all_marks)
		:filter(function(item) return item.mark:match("^'[1-9a-z]$") end)
		:totable()

	return marks
end

return M
