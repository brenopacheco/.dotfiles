--- Event-stream
--
-- Provides Events command to open a buffer that captures all events
--
-- Skips `SafeState` and `UserGettingBored`
-- Skips Cmd-event: 'BufReadCmd', 'BufWriteCmd', 'FileAppendCmd', 'FileReadCmd', 'FileWriteCmd', 'SourceCmd',
-- Skips 'BufRead' as it is 'BufReadPre' repeated

local bufname = '__events__'

-- stylua: ignore start
local all_events = {
  'BufAdd', 'BufDelete', 'BufEnter', 'BufFilePost', 'BufFilePre', 'BufHidden',
  'BufLeave', 'BufModifiedSet', 'BufNew', 'BufNewFile', 'BufReadPost',
  'BufReadPre', 'BufUnload', 'BufWinEnter', 'BufWinLeave', 'BufWipeout',
  'BufWrite', 'BufWritePre', 'BufWritePost', 'ChanInfo', 'ChanOpen',
  'CmdUndefined', 'CmdlineChanged', 'CmdlineEnter', 'CmdlineLeave',
  'CmdwinEnter', 'CmdwinLeave', 'ColorScheme', 'ColorSchemePre',
  'CompleteChanged', 'CompleteDonePre', 'CompleteDone', 'CursorHold',
  'CursorHoldI', 'CursorMoved', 'CursorMovedI', 'DiffUpdated', 'DirChanged',
  'DirChangedPre', 'ExitPre', 'FileAppendPost', 'FileAppendPre',
  'FileChangedRO', 'FileChangedShell', 'FileChangedShellPost', 'FileReadPost',
  'FileReadPre', 'FileType', 'FileWritePost', 'FileWritePre',
  'FilterReadPost', 'FilterReadPre', 'FilterWritePost', 'FilterWritePre',
  'FocusGained', 'FocusLost', 'FuncUndefined', 'UIEnter', 'UILeave',
  'InsertChange', 'InsertCharPre', 'InsertEnter', 'InsertLeavePre',
  'InsertLeave', 'MenuPopup', 'ModeChanged', 'OptionSet', 'QuickFixCmdPre',
  'QuickFixCmdPost', 'QuitPre', 'RemoteReply', 'SearchWrapped',
  'RecordingEnter', 'RecordingLeave', 'SessionLoadPost', 'ShellCmdPost',
  'Signal', 'ShellFilterPost', 'SourcePre', 'SourcePost', 'SpellFileMissing',
  'StdinReadPost', 'StdinReadPre', 'SwapExists', 'Syntax', 'TabEnter',
  'TabLeave', 'TabNew', 'TabNewEntered', 'TabClosed', 'TermOpen', 'TermEnter',
  'TermLeave', 'TermClose', 'TermResponse', 'TextChanged', 'TextChangedI',
  'TextChangedP', 'TextChangedT', 'TextYankPost', 'User', 'VimEnter',
  'VimLeave', 'VimLeavePre', 'VimResized', 'VimResume', 'VimSuspend',
  'WinClosed', 'WinEnter', 'WinLeave', 'WinNew', 'WinScrolled', 'WinResized',
}
-- stylua: ignore end

---@class VimEvent
---@field id number : autocommand id
---@field event string : name of the triggered event
---@field group number|nil : autocommand group id, if any
---@field match string : expanded value of |<amatch>|
---@field buf number : expanded value of |<abuf>|
---@field file string : expanded value of |<afile>|
---@field data any : arbitrary data

---@param bufnr number
---@param winid number
---@param ev VimEvent
local function handler(bufnr, winid, ev)
	if ev.buf == bufnr then return end
	local data = vim.split(vim.inspect(ev.data), '\n')
	local head = {
		ev.id .. ': ' .. ev.event,
		'\tbuf:   ' .. ev.buf,
		'\tmatch: ' .. ev.match,
		'\tfile:  ' .. ev.file,
		'\tdata:  ',
	}
	local long_text = vim.list_extend(head, data)
	local short_text = string.format('(%s): %12s - %s', ev.id, ev.event, ev.file)
	local timer = vim.uv.new_timer()
	timer:start(100, 0, function()
		-- why is this necessary? I don't know
		-- dont rely on print inside this callback
		vim.print(short_text)
	end)
	vim.schedule(function()
		---@diagnostic disable-next-line: param-type-mismatch
		vim.fn.appendbufline(bufnr, '$', long_text)
		if vim.fn.win_getid() ~= winid then
			pcall(vim.api.nvim_win_set_cursor, winid, { 1, 1 })
		end
	end)
end

---@return boolean : whether the event stream buffer is open
local function is_open()
	---@type number[]
	local buffers = vim.fn.tabpagebuflist()
	for _, bufnr in ipairs(buffers) do
		if vim.fn.bufname(bufnr) == bufname then return true end
	end
	return false
end

---@return number, number : buffer id, window id
local function open_win()
	pcall(vim.api.nvim_buf_delete, vim.fn.bufnr(bufname), { force = true })
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.cmd('vsplit')
	local winid = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(winid, bufnr)
	vim.api.nvim_set_current_win(winid)
	return bufnr, winid
end

---@param bufnr number
---@param winid number
---@param events string[]
local function add_autocmds(bufnr, winid, events)
	local group = vim.api.nvim_create_augroup('event_stream', { clear = true })
	for _, event in ipairs(events) do
		vim.api.nvim_create_autocmd({ event }, {
			nested = true,
			desc = 'Event stream handler for ' .. event,
			group = group,
			pattern = { '*' },
			callback = function(ev) handler(bufnr, winid, ev) end,
			-- callback = vim.schedule_wrap(function(ev)
			-- 	handler(bufnr, winid, ev)
			-- end),
		})
	end
	vim.api.nvim_create_autocmd({ 'WinClosed' }, {
		nested = true,
		desc = 'Delete event stream buffer when window is closed',
		group = group,
		pattern = { tostring(winid) },
		callback = function()
			pcall(vim.api.nvim_del_augroup_by_name, group)
			pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
		end,
	})
end

---@param events string[]
local function eventstream(events)
	if is_open() then
		return vim.notify('Events buffer is already open', vim.log.levels.WARN)
	end
	local bufnr, winid = open_win()
	add_autocmds(bufnr, winid, events)
end

---@param word string
---@param full string
---@return string[]
local function complete(word, full)
	local cur_list = vim.tbl_filter(
		function(event) return vim.list_contains(all_events, event) end,
		vim.fn.split(full, ' ')
	)
	local remaining_list = vim.tbl_filter(
		function(event)
			return vim.startswith(event, word)
				and not vim.list_contains(cur_list, event)
		end,
		all_events
	)
	return remaining_list
end

---@param tbl { args: string }
local function command(tbl)
	local events = vim.tbl_filter(
		function(event) return vim.list_contains(all_events, event) end,
		vim.split(tbl.args, ' ')
	)
	if #events == 0 then events = all_events end
	vim.notify('Events: ' .. vim.inspect(events))
	eventstream(events)
end

vim.api.nvim_create_user_command('Events', command, {
	nargs = '*',
	complete = complete,
})
