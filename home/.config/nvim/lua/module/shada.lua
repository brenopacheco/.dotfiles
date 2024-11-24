--- Shada
--
-- Configures shada to clear registers before saving
--

local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

local function wipe_alpha()
	local _ = chars:gsub('.', function(v) vim.fn.setreg(v, '') end)
end

-- setup
local group = vim.api.nvim_create_augroup('ShadaRegisters', { clear = true })

vim.api.nvim_create_autocmd('VimLeavePre', {
	nested = true,
	desc = 'Clear registers before saving shada file',
	group = group,
	callback = wipe_alpha,
})
