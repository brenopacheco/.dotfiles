--- Winresize
--
-- Resize small non-floating windows on focus
-- NOTE: does not work for nvim-tree

local group = vim.api.nvim_create_augroup('winresize', { clear = true })

local min = {
	width = 40,
	height = 15,
}

vim.api.nvim_create_autocmd({ 'WinEnter' }, {
	nested = true,
	desc = 'Window resize on enter',
	group = group,
	callback = vim.schedule_wrap(function()
		local is_floating = vim.api.nvim_win_get_config(0).zindex ~= nil
		if not is_floating then
			local win_height = vim.api.nvim_win_get_height(0)
			local win_width = vim.api.nvim_win_get_width(0)
			if win_height < min.height then
				vim.api.nvim_win_set_height(0, min.height)
			end
			if win_width < min.width then
				vim.api.nvim_win_set_width(0, min.width)
			end
		end
	end),
})
