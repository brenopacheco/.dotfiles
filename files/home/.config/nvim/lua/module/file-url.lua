--- File-url
--
-- Copies current file url into clipboard

---@param tbl { bang: boolean }
local function copy_url(tbl)
	local bang = tbl.bang or false
	local path = vim.fn.expand('%:p')
	if bang then path = path .. ':' .. vim.fn.line('.') end
	vim.fn.setreg('+', path)
	vim.notify('Copied into clipboard: ' .. path, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('Url', copy_url, { nargs = 0, bang = true })
