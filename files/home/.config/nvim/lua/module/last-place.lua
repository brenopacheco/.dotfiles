--- Last-place
--
-- Remember the last cursor position when a file is opened and positions
-- the cursor when the file is next opened.

local group = vim.api.nvim_create_augroup('last_place', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
	group = group,
	pattern = { '*' },
	desc = 'Remember last cursor place',
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})
