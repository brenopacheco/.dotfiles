--- Shada
--
-- Configures shada to clear registers and marks before saving

local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-/'
local marks = "0123456789<>[]'"

local function wipe_alpha()
	chars:gsub('.', function(v) vim.fn.setreg(v, {}) end)
	marks:gsub('.', function(v) vim.api.nvim_buf_set_mark(0, v, 0, 0, {}) end)
	vim.cmd.wshada({ bang = true })
end

-- setup
local group = vim.api.nvim_create_augroup('ShadaRegisters', { clear = true })

vim.api.nvim_create_autocmd('VimLeavePre', {
	nested = true,
	desc = 'Clear registers before saving shada file',
	group = group,
	callback = wipe_alpha,
})
