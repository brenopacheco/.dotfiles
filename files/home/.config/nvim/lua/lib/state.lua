local M = {}

local c = require('lib.classes')

---@param state lib.State
---@return string
local view = function(state)
	local str = {}
	vim.iter(state.tabs):each(function(tab)
		table.insert(str, 'tab [' .. tab.id .. ']')
		vim.iter(tab.wins):each(
			function(win)
				table.insert(
					str,
					string.format(
						' win %-4s -> buf %-5s %s',
						'[' .. tostring(win.id) .. ']',
						'[' .. tostring(win.buf.id) .. ']',
						win.buf.name
					)
				)
			end
		)
	end)
	return table.concat(str, '\n')
end

---@return lib.State
M.get = function()
	local tab_map = {}
	local win_map = {}
	local buf_map = {}

	local tab_ids = vim.api.nvim_list_tabpages()

	for _, tab_id in ipairs(tab_ids) do
		local tab = c.Tab:new(tab_id)
		tab_map[tab_id] = tab
		local win_ids = vim.api.nvim_tabpage_list_wins(tab_id)
		for _, win_id in ipairs(win_ids) do
			local win = c.Win:new(win_id)
			win_map[win_id] = win
			win:attach(nil, tab)
			tab:attach(win)
			local buf_id = vim.api.nvim_win_get_buf(win_id)
			local buf = buf_map[buf_id] or c.Buf:new(buf_id)
			buf_map[buf_id] = buf
			buf:attach(win)
			win:attach(buf, nil)
		end
	end

	-- TODO: create Buf objects for the remaining buffers

	---@type lib.State
	local state = {
		tabs = vim.tbl_values(tab_map),
		wins = vim.tbl_values(win_map),
		bufs = vim.tbl_values(buf_map),
	}

	print(view(state))

	return state
end

M.get()

---@param state lib.State
---@param query lib.Query
---@return lib.State
M.filter = function(state, query)
	-- TODO:
	error('not implemented')
end

return M
