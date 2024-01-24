--- PDF helper
--
-- Swaps out PDF content by converting to text and back
-- Blocks from writing by setting readonly
-- Sets nomodified

-- setup
local group = vim.api.nvim_create_augroup('pdf_helper', { clear = true })

---@param path string
local function pdftotext(bufnr, path)
	local out = vim
		.system(
			{ 'pdftotext', '-layout', '-nopgbrk', '-eol', 'unix', path, '-' },
			{ text = true }
		)
		:wait()
	if out.code ~= 0 then return end
	local text = vim.split(vim.trim(out.stdout), '\n')
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, text)
	vim.api.nvim_set_option_value('readonly', true, { buf = bufnr })
	vim.api.nvim_set_option_value('modified', false, { buf = bufnr })
end

vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
	desc = 'Convert PDF to text on buf load',
	group = group,
	pattern = { '*.pdf' },
	callback = function(ev) pdftotext(ev.buf, ev.file) end,
	nested = false,
})
