--- Winresize
--
-- Resize small non-floating windows on focus
-- NOTE: does not work for nvim-tree

local group = vim.api.nvim_create_augroup('winresize', { clear = true })

local blacklist = {
	'dapui_.*$',
  'NvimTree',
  'Outline',
}

local min = {
	width = 40,
	height = 15,
}

local function enabled()
	local buftype = vim.api.nvim_get_option_value('buftype', { buf = 0 })
	local filetype = vim.api.nvim_get_option_value('filetype', { buf = 0 })
	local wintype = vim.fn.win_gettype() == 'popup'
	local is_floating = vim.api.nvim_win_get_config(0).zindex ~= nil
	local disabled = false
	for _, pattern in ipairs(blacklist) do
		if string.match(filetype, pattern) then disabled = true end
	end
	disabled = disabled or buftype == 'prompt'
	disabled = disabled or buftype == 'terminal'
	disabled = disabled or wintype == 'popup'
	disabled = disabled or is_floating
	return not disabled
end

vim.api.nvim_create_autocmd({ 'WinEnter' }, {
	nested = true,
	desc = 'Window resize on enter',
	group = group,
	callback = vim.schedule_wrap(function()
		if not enabled() then return end
		local win_height = vim.api.nvim_win_get_height(0)
		local win_width = vim.api.nvim_win_get_width(0)
		if win_height < min.height then
			vim.api.nvim_win_set_height(0, min.height)
		end
		if win_width < min.width then vim.api.nvim_win_set_width(0, min.width) end
	end),
})
