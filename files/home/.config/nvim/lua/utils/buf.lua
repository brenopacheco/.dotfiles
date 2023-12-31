local M = {}

---@class Pos
---@field bufnum number
---@field col number
---@field line number
---@field off number

---@class Visual
---@field start Pos
---@field finish Pos
---@field pos {start: Pos, finish: Pos}
---@field text string[]

---@return boolean
function M.is_visual()
	local mode = vim.fn.mode()
	return mode == 'v' or mode == 'V'
end

---@return Visual
function M.get_visual()
	assert(M.is_visual(), 'Not in visual mode')
	local start = vim.fn.getpos('v')
	local finish = vim.fn.getpos('.')
	assert(start ~= nil and finish ~= nil, 'No visual selection')
	if start[2] > finish[2] then
		start, finish = finish, start
	elseif start[2] == finish[2] and start[3] > finish[3] then
		start, finish = finish, start
	end
	local text = vim.api.nvim_buf_get_text(
		start[1],
		start[2] - 1,
		start[3] - 1,
		finish[2] - 1,
		finish[3],
		{}
	)
	return {
		start = {
			bufnum = start[1],
			line = start[2],
			col = start[3],
			off = start[4],
		},
		finish = {
			bufnum = finish[1],
			line = finish[2],
			col = finish[3],
			off = finish[4],
		},
		pos = {
			start = start,
			finish = finish,
		},
		text = text,
	}
end

---@param visual Visual
function M.set_visual(visual)
	vim.fn.setpos("'<", visual.pos.finish)
	vim.fn.setpos("'>", visual.pos.start)
end

---@param buftype string
---@param command fun()
function M.toggle(buftype, command)
	if buftype == nil or command == nil then
		return vim.notify('Missing arguments', vim.log.levels.WARN)
	end
	for _, winnr in ipairs(vim.fn.range(1, vim.fn.winnr('$')) or {}) do
		local bufnr = vim.fn.winbufnr(winnr)
		if bufnr ~= nil then
			local ft = vim.fn.getbufvar(bufnr, '&ft')
			if ft == buftype then
				return vim.cmd(winnr .. 'close')
			end
		end
	end
	command()
end

---@param bufnr number|nil
function M.is_file(bufnr)
	bufnr = bufnr or vim.fn.bufnr()
	return vim.fn.bufname(bufnr) ~= ''
end

-- Delete buffer
M.delete = function()
	local status, _ = pcall(vim.api.nvim_buf_delete, 0, {})
	if not status then
		local x = vim.fn.confirm('buffer has been modified', '&qCancel\n&xDelete')
		if x == 2 then
			return vim.cmd('bd!')
		end
	end
end

--- Checks if any visible window has a buffer of the given filetype
---@param filetype string
---@return boolean, number, number : is visible, winid, bufnr
M.is_visible = function(filetype)
	for _, winnr in ipairs(vim.fn.range(1, vim.fn.winnr('$')) or {}) do
    local winid = vim.fn.win_getid(winnr) or -1
		local bufnr = vim.fn.winbufnr(winnr)
		if bufnr ~= nil then
			local ft = vim.fn.getbufvar(bufnr, '&ft')
			if ft == filetype then
				return true, winid, bufnr
			end
		end
	end
  return false, -1, -1
end

return M
