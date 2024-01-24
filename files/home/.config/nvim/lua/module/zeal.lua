--- Zeal keywordprg
--

---@param tbl {args: string}
local function zeal(tbl)
	local query = tbl.args
	vim.system({ 'zeal', 'dash://' .. query })
end

vim.api.nvim_create_user_command('Zeal', zeal, { nargs = 1 })
