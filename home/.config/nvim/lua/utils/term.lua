local M = {}

local count = 0

local function find_term_window()
	local wins = vim.api.nvim_tabpage_list_wins(0)
	for _, win_id in ipairs(wins) do
		local bufnr = vim.api.nvim_win_get_buf(win_id)
		local cmd = vim.fn.getbufvar(bufnr, 'term')
		if cmd ~= '' then return win_id end
	end
	return nil
end

local function find_term_buffer()
	local buffers = vim.api.nvim_list_bufs()
	for _, buffer in ipairs(buffers) do
		if vim.fn.getbufvar(buffer, 'term') ~= '' then return buffer end
	end
	return nil
end

M.new_term = function()
	vim.cmd('silent! bo te!')
	vim.api.nvim_buf_set_var(vim.fn.bufnr(), 'term', count)
	count = count + 1
end

M.toggle = function()
	local win_id = find_term_window()
	if win_id ~= nil then
		vim.api.nvim_win_close(win_id, true)
		return
	end

	local buffer = find_term_buffer()
	if buffer ~= nil then
		vim.cmd('silent! bo split | b ' .. tostring(buffer))
		return
	end

	M.new_term()
end

return M
