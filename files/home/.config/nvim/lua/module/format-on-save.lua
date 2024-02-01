--- Format on save
--

local fts = { '*.lua', '*.fnl' }

local enabled = true

---@param ev { buf: number }
local function format(ev)
	if not enabled then return end
	if vim.api.nvim_win_get_buf(0) ~= ev.buf then return end
	vim.cmd('undojoin')
	vim.cmd('Neoformat')
end

local function toggle()
	enabled = not enabled
	vim.notify('Format on save ' .. (enabled and 'enabled' or 'disabled'))
end

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	desc = 'Format filetypes on save',
	group = vim.api.nvim_create_augroup('format_on_save', { clear = true }),
	pattern = fts,
	callback = function() pcall(format) end,
	nested = false,
})

vim.api.nvim_create_user_command('AutosaveToggle', toggle, { nargs = 0 })
