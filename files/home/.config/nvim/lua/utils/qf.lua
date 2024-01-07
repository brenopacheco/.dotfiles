local M = {}

-- Returns the current quickfix list and whether it is empty
---@return table, boolean
M.qf = function()
	local qf = vim.fn.getqflist()
	return qf, qf.total == 0
end

M.prev_entry = function()
	--@table {idx: string, size: string}
	local qfinfo = vim.fn.getqflist({ idx = 0, size = 0 })
	if qfinfo == nil or qfinfo.size == 0 then
		vim.notify('error: quickfix list is empty', vim.log.levels.WARN)
	elseif qfinfo.idx == 1 then
		vim.cmd('clast')
	else
		vim.cmd('cprev')
	end
end

-- Jump to next quickfix entry
M.next_entry = function()
	--@table {idx: string, size: string}
	local qfinfo = vim.fn.getqflist({ idx = 0, size = 0 })
	if qfinfo == nil or qfinfo.size == 0 then
		vim.notify('error: quickfix list is empty', vim.log.levels.WARN)
	elseif qfinfo.idx == qfinfo.size then
		vim.cmd('cfirst')
	else
		vim.cmd('cnext')
	end
end

---@param opts { workspace: boolean }
M.errors = function(opts)
	local bufnr = opts.workspace and nil or vim.fn.bufnr()
	local diagnostics = vim.diagnostic.get(bufnr)
	local qfitems = vim.diagnostic.toqflist(diagnostics)
	vim.fn.setqflist(qfitems)
	M.open()
end

---@param select 'cfirst' | 'clast' | nil
M.open = function(select)
	vim.cmd('botright copen | wincmd p' .. (select and ' | ' .. select or ''))
end

return M
