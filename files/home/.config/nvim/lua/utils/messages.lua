---TODO: add alternative to have multiple message buffers

---@class Messages
---@field messages string[]
---@field bufname string
---@field bufnr number
---@field group number
local M = {
	messages = {},
	bufname = 'messages:///',
	bufnr = -1,
	group = -1,
}

function M:setup()
	assert(self, 'Messages:setup() must be called on an instance')
	pcall(vim.api.nvim_buf_delete, self.bufnr, { force = true })
	pcall(vim.api.nvim_buf_delete, vim.fn.bufnr(self.bufname), { force = true })
	self.bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(self.bufnr, self.bufname)
	self.group = vim.api.nvim_create_augroup('messages', { clear = true })
	vim.api.nvim_create_autocmd({ 'BufWipeout' }, {
		desc = 'Restore message buffer',
		group = self.group,
		pattern = { tostring(self.bufnr) },
		callback = vim.schedule_wrap(self.setup),
	})
end

---@param message any
function M:echo(message)
	assert(self, 'Messages:echo() must be called on an instance')
	if type(message) == 'table' then message = vim.inspect(message) end
	table.insert(self.messages, message)
	--- update if window is open
	local winid = vim.fn.bufwinid(self.bufnr)
	if winid == -1 then return end
	vim.fn.appendbufline(self.bufnr, 0, message)
	if vim.fn.win_getid() ~= winid then
		pcall(vim.api.nvim_win_set_cursor, winid, { 1, 1 })
	end
end

function M:open()
	assert(self, 'Messages:open() must be called on an instance')
	pcall(vim.api.nvim_win_close, vim.fn.bufwinid(self.bufnr), { force = true })
	-- vim.cmd('topleft split | resize 20')
	vim.cmd('botright split | resize 20')
	local winid = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(winid, self.bufnr)
	vim.api.nvim_set_current_win(winid)
	local text = vim.split(vim.trim(table.concat(self.messages, '\n')), '\n')
	vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, true, text)
	vim.cmd('wincmd p')
end

M:setup()

M:open()

return M
