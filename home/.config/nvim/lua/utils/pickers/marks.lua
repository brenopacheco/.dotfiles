local strutil = require('utils.strings')

local split_path = function(path)
	local vpath = path:gsub('[\\/]+$', '')
	local dir, filename = vpath:match('^(.-)([^/\\]+)$')
	return dir, filename .. (path:match('[\\/]$') and '/' or '')
end

local parse_path = function(str)
	local scheme, path = str:match('^([%w+.-]+)://(.+)$')
	if scheme then
		return scheme, path
	else
		return nil, str
	end
end

local function format_item(item, cols)
	local offset = 12
	local limit = cols - 19 - offset
	local scheme, path = parse_path(item.file)
	local dir, filename = split_path(path)
	dir = vim.fn.expand(dir)
	local max_len = limit
		+ (scheme and (-string.len(scheme) - 4) or -1)
		- string.len(filename)
		- offset
	local dirstr, dirstrlen = strutil.truncate_path(dir, max_len)
	if scheme then
		dirstr = scheme .. '://' .. dirstr
		dirstrlen = dirstrlen + string.len(scheme) + 3
	end
	if dirstr == "" then
		dirstr = 'buffer'
		dirstrlen = 6
	end
	local padding =
		string.rep(' ', limit - string.len(filename) - dirstrlen + offset)
	return string.format(
		'%-3s L%-4s %s %s [%s]',
		item.mark,
		tostring(item.pos[2]),
		filename,
		padding,
		dirstr
	)
end

return function()
	local buffer_marks = vim.iter(vim.fn.getmarklist(vim.fn.bufnr())):map(
		function(mark)
			mark.file = vim.fn.bufname()
			return mark
		end
	):totable()

	local global_marks = vim.fn.getmarklist()

	local all_marks = vim.list_extend(buffer_marks, global_marks)

	local marks = vim
		.iter(all_marks)
		:filter(function(item) return item.mark:match("^'[1-9a-z]$") end)
		:totable()

	vim.ui.select(marks, {
		prompt = 'Lua configurations:',
		format_item = format_item,
	}, function(choice, _, action)
		if choice ~= nil then
			local cmd = 'norm! `' .. choice.mark:sub(2, -1)
			if action == 'edit' then
				vim.cmd(cmd)
			else
				vim.cmd(action .. ' | ' .. cmd)
			end
		end
	end)
end
