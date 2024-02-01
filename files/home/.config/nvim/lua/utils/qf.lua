-- local bufutil = require('utils.buf')

local M = {}

-- Returns the current quickfix list and whether it is empty
---@return table, boolean
M.qf = function()
	local qf = vim.fn.getqflist()
	return qf, qf.total == 0
end

---@params string cmd
local pcmd = function(cmd)
	---@diagnostic disable-next-line: param-type-mismatch
	return pcall(vim.cmd, cmd)
end

M.prev_entry = function()
	if not pcmd('cprevious') then vim.cmd('clast') end
end

-- Jump to next quickfix entry
M.next_entry = function()
	if not pcmd('cnext') then pcmd('cfirst') end
end

---@param opts { workspace: boolean }
M.errors = function(opts)
	local bufnr = opts.workspace and nil or vim.fn.bufnr()
	local diagnostics = vim.diagnostic.get(bufnr)
	local qfitems = vim.diagnostic.toqflist(diagnostics)
	vim.fn.setqflist(qfitems)
	M.open()
	-- bufutil.toggle('qf', { cb = M.open })
end

---@param select 'cfirst' | 'clast' | nil
M.open = function(select)
	vim.cmd('botright copen | wincmd p' .. (select and ' | ' .. select or ''))
end

return M
