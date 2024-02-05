local M = {}

local c = require('lib.classes')

---@param state lib.State
---@return string
M.view = function(state)
	local list = {}
	table.insert(list, 'tabs:')
	vim.iter(state.tabs):each(
		function(tab)
			table.insert(
				list,
				string.format(
					'  tab %3s -> win %6s -> buf %5s %s',
					'[' .. (tab.id or 'x') .. ']',
					'[' .. (tab.win.id or 'x') .. ']',
					'[' .. (tab.win.buf.id or 'x') .. ']',
					(tab.win.buf.bufname or 'x')
				)
			)
		end
	)
	table.insert(list, 'wins:')
	vim.iter(state.wins):each(
		function(win)
			table.insert(
				list,
				string.format(
					'  tab %3s <- win %6s -> buf %5s %s',
					'[' .. (win.tab.id or 'x') .. ']',
					'[' .. (win.id or 'x') .. ']',
					'[' .. (win.buf.id or 'x') .. ']',
					(win.buf.bufname or 'x')
				)
			)
		end
	)
	table.insert(list, 'bufs:')
	vim.iter(state.bufs):each(function(buf)
		table.insert(
			list,
			string.format('  buf %5s %s', '[' .. buf.id .. ']', buf.bufname)
		)
		vim.iter(buf.wins):each(
			function(win)
				table.insert(
					list,
					string.format(
						'   -> win %6s -> tab %3s',
						'[' .. (win.id or 'x') .. ']',
						'[' .. (win.tab.id or 'x') .. ']'
					)
				)
			end
		)
	end)
	return table.concat(list, '\n')
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
	vim.iter(vim.api.nvim_list_bufs()):map(function(buf_id)
		if not buf_map[buf_id] then buf_map[buf_id] = c.Buf:new(buf_id) end
	end)
	---@type lib.State
	local state = {
		tabs = vim.tbl_values(tab_map),
		wins = vim.tbl_values(win_map),
		bufs = vim.tbl_values(buf_map),
	}
	return state
end

---@param filter lib.TabQuery
---@param state lib.State
---@return lib.State
local function include_only_with_tab(state, filter)
	local tabs = vim
		.iter(state.tabs)
		:filter(function(tab)
			if filter.ids then
				local tab_ids = vim
					.iter(filter.ids)
					:map(function(id) return id == 0 and vim.fn.tabpagenr() or id end)
					:totable()
				if not vim.list_contains(tab_ids, tab.id) then return false end
			end
			return true
		end)
		:totable()

	local wins = vim
		.iter(state.wins)
		:filter(function(win)
			return vim.iter(tabs):any(function(tab) return tab.id == win.id end)
		end)
		:totable()

	local bufs = vim
		.iter(state.bufs)
		:filter(function(buf)
			return vim.iter(buf.wins):any(function(win)
				return vim.iter(tabs):any(function(tab) return tab.id == win.id end)
			end)
		end)
		:totable()

	return {
		tabs = tabs,
		wins = wins,
		bufs = bufs,
	}
end

---@param filter lib.WinQuery
---@param state lib.State
---@return lib.State
local function include_only_with_win(state, filter)
	local wins = vim
		.iter(state.wins)
		:filter(function(win)
			if filter.ids then
				local win_ids = vim.iter(filter.ids):map(
					function(id) return id == 0 and vim.fn.win_getid() or id end
				)
				if not vim.list_contains(win_ids, win.id) then return false end
			end
			if filter.wintype then
				if win.wintype ~= filter.wintype then return false end
			end
			return true
		end)
		:totable()

	-- TODO: this is broken
	---@param bufortab { wins: lib.Win[] }
	local function has_any_win_attached(bufortab)
		local buftabwins = bufortab.wins
		return vim.iter(buftabwins):any(function(buftabwin)
			for _, win in ipairs(wins) do
				if win.id == buftabwin then return true end
			end
			return false
		end)
	end

	local bufs = vim.iter(state.bufs):filter(has_any_win_attached):totable()
	local tabs = vim.iter(state.tabs):filter(has_any_win_attached):totable()

	return {
		tabs = tabs,
		wins = wins,
		bufs = bufs,
	}
end

---@param filter lib.BufQuery
---@param state lib.State
---@return lib.State
local function include_only_with_buf(state, filter) return state end

---@param state lib.State
---@param query lib.Query
---@return lib.State
M.filter = function(state, query)
	---@type lib.State
	local _state = vim.deepcopy(state)

	local has_tab_filter = query.tab ~= nil
	local has_win_filter = query.win ~= nil
	local has_buf_filter = query.buf ~= nil

	-- TODO: assert types for query

	if has_tab_filter then _state = include_only_with_tab(_state, query.tab) end

	if has_win_filter then _state = include_only_with_win(_state, query.win) end

	-- TODO: the missing part
	-- if has_buf_filter then _state = include_only_with_buf(_state, query.buf) end

	return _state
end

vim.print(M.view(M.filter(M.get(), { win = {} })))

return M
