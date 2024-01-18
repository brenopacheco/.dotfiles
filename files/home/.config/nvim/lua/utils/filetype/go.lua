local M = {}

---@class GoDocArgs
---@field args string

---@param tbl GoDocArgs
local get_patterns = function(tbl)
	local patterns = {}
	vim.list_extend(patterns, vim.split(tbl.args, ' '))
	local bufname = tostring(vim.fn.bufname())
	local pkg = bufname:match('^godoc:///(.*)')
	local extra_patterns = {}
	if pkg then
		for _, word in ipairs(patterns) do
			table.insert(extra_patterns, pkg .. '.' .. word)
		end
	end
	vim.list_extend(patterns, extra_patterns)
	return patterns
end

---@param patterns string[]
---@return { content: string[], package: string }|nil
local get_docs = function(patterns)
	local content = nil ---@cast content +string[]
	local match = nil ---@cast match +string[]
	for _, pattern in ipairs(patterns) do
		local out = vim
			.system({ 'go', 'doc', '-all', pattern }, { text = true })
			:wait()
		if out.code == 0 then
			content = vim.split(out.stdout, '\n')
			match = pattern
			break
		end
	end
	if not content or not match then
		return nil
	end
	return { content = content, package = match }
end

---@param docs { content: string[], package: string }
---@return number bufnr
local get_docs_buffer = function(docs)
	local bufname = 'godoc:///' .. docs.package
	local bufnr = vim.fn.bufnr('^' .. bufname .. '$') or -1
	if bufnr > 0 then
		return bufnr
	end
	bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, docs.content)
	vim.api.nvim_set_option_value('buftype', 'nofile', { buf = bufnr })
	vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = bufnr })
	vim.api.nvim_set_option_value('buflisted', false, { buf = bufnr })
	vim.api.nvim_set_option_value('swapfile', false, { buf = bufnr })
	vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
	vim.api.nvim_set_option_value('readonly', true, { buf = bufnr })
	vim.api.nvim_set_option_value('filetype', 'go', { buf = bufnr })
	vim.api.nvim_buf_set_name(bufnr, bufname)
	return bufnr
end

---If bang, then use args as words to search for.
---@param tbl GoDocArgs
M.godoc = function(tbl)
	local patterns = get_patterns(tbl)
	local docs = get_docs(patterns)
	assert(docs, 'No docs found for ' .. table.concat(patterns, ', '))
	local bufnr = get_docs_buffer(docs)
	if not vim.fn.bufname(vim.fn.bufnr()):match('godoc:///') then
		vim.cmd('split')
	end
	vim.api.nvim_win_set_buf(0, bufnr)
  -- for some reason, I need to add this here, otherwise the buffer is set
  -- as listed (probably by nvim_win_set_buf)
	vim.api.nvim_set_option_value('buflisted', false, { buf = bufnr })
end

plevel(vim.log.levels.DEBUG)

M.setup = function()
	vim.api.nvim_create_user_command('GoDoc', M.godoc, { nargs = 1 })
end

return M
