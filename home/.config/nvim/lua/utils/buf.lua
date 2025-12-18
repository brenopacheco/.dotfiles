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

---@return boolean, string : is visual, mode
function M.is_visual()
	local mode = vim.api.nvim_get_mode().mode
	local match = mode:find('^[vV\22]') -- v, V, <C-v>
	return match ~= nil, mode
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

---@return string[]
function M.get_visual2()
	local is_visual = M.is_visual()
	assert(is_visual, 'Not in visual mode')
	vim.cmd('normal! "zygv')
	local text = vim.split(vim.fn.getreg('z') or '', '\n')
	return text
end

---@param visual Visual
function M.set_visual(visual)
	vim.fn.setpos("'<", visual.pos.finish)
	vim.fn.setpos("'>", visual.pos.start)
end

function M.escape_visual()
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
		'n',
		true
	)
end

local function reset_dapui()
	if not vim.z.enabled('rcarriga/nvim-dap-ui') then return end
	local dapui = require('dapui')
	local is_open = false
	for _, winnr in ipairs(vim.fn.range(1, vim.fn.winnr('$')) or {}) do
		local bufnr = vim.fn.winbufnr(winnr)
		if bufnr ~= nil then
			local ft = vim.fn.getbufvar(bufnr, '&ft')
			if ft:match('dapui_.*') then is_open = true end
		end
	end
	if not is_open then return end
	dapui.close()
	dapui.open({ reset = true })
end

---@param filetype string
---@param opts? { mode?: 'toggle'|'open'|'close', focus?: boolean, cb?: fun() }
function M.toggle(filetype, opts)
	assert(filetype, 'Missing filetype')
	opts = opts or {}
	local mode = opts.mode or 'toggle'
	local focus = opts.focus or false
	local cb = opts.cb
	---@param on_win fun(winnr: integer, winid: integer, bufnr: integer)
	local function loop(on_win)
		for _, winnr in ipairs(vim.fn.range(1, vim.fn.winnr('$')) or {}) do
			local bufnr = vim.fn.winbufnr(winnr)
			if bufnr ~= nil then
				local ft = vim.fn.getbufvar(bufnr, '&ft')
				if ft == filetype then
					local winid = vim.fn.win_getid(winnr)
					return on_win(winnr, winid --[[@as integer]], bufnr)
				end
			end
		end
	end
	local is_open = false
	loop(function(winnr, winid, _)
		is_open = true
		if mode == 'close' or mode == 'toggle' then
			vim.cmd(winnr .. 'close')
			reset_dapui()
			return
		end
		if focus then vim.api.nvim_set_current_win(winid) end
	end)
	if cb ~= nil then
		if (mode == 'toggle' and not is_open) or mode == 'open' then
			cb()
			reset_dapui()
		end
	end
	if focus then
		loop(function(_, winid, _) vim.api.nvim_set_current_win(winid) end)
	end
end

---@param bufnr number|nil
function M.is_file(bufnr)
	bufnr = bufnr or vim.fn.bufnr()
	return vim.fn.bufname(bufnr) ~= ''
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
			if ft == filetype then return true, winid, bufnr end
		end
	end
	return false, -1, -1
end

---Create a new buffer throwaway buffer with the given content
---
---@param content string[]
---@param opts? { orientation?: 'vsplit' | 'split', filetype?: string, bufname?: string }
M.throwaway = function(content, opts)
	opts = opts or {}
	local split = opts.orientation or 'vsplit'
	local filetype = opts.filetype or ''
	local bufname = opts.bufname or ('throwaway:///' .. M.uuid())
	pcall(vim.api.nvim_buf_delete, vim.fn.bufnr(bufname), { force = true })
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.cmd(split)
	local winnr = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(winnr, bufnr)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, content)
	vim.api.nvim_set_current_win(winnr)
	vim.api.nvim_set_option_value('filetype', filetype, { buf = bufnr })
	-- vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
	vim.api.nvim_set_option_value('modifiable', true, { buf = bufnr })
	-- vim.api.nvim_set_option_value('readonly', true, { buf = bufnr })
	vim.api.nvim_set_option_value('readonly', false, { buf = bufnr })
	vim.api.nvim_buf_set_name(bufnr, bufname)
end

M.uuid = function()
	local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	return string.gsub(template, '[xy]', function(c)
		local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
		return string.format('%x', v)
	end)
end

---@param opts? { reverse?: boolean }
---@return string[]
M.get_cexprs = function(opts)
	opts = opts or {}
	local reverse = opts.reverse or false
	local line = vim.fn.getline('.')
	local cword = vim.fn.expand('<cexpr>'):gsub('[^%w%.%_%-]', '')
	local pat = '[%w%.%_%-%>]*' .. cword
	local cexpr = line:match(pat)
	if not cexpr then return { cword } end
	local matches = vim.split(cexpr, '%.')
	local words = {}
	local word = ''
	for i in ipairs(matches) do
		local match = matches[#matches - i + 1]
		word = word == '' and match or match .. '.' .. word
		table.insert(words, word)
	end
	if reverse then
		local reversed = {}
		for i in ipairs(words) do
			table.insert(reversed, words[#words - i + 1])
		end
		words = reversed
	end
	if M.is_visual() then
		local visual = table.concat(M.get_visual().text, '')
		table.insert(words, 1, visual)
	end
	return words
end

M.clear_buffers = function()
	local curbuf = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local modified = vim.api.nvim_get_option_value('modified', { buf = buf })
		if not modified and curbuf ~= buf then
			local bufname = vim.api.nvim_buf_get_name(buf)
			local isterm = bufname:match('^term://') ~= nil
			pcall(vim.api.nvim_buf_delete, buf, { force = isterm, unload = false })
		end
	end
	vim.notify('Cleared all buffers')
end

vim.api.nvim_create_user_command('Bclean', M.clear_buffers, { nargs = 0 })

return M
