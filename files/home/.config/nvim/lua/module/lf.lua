--- Lf
--
-- Lf file browser wrapper
-- TODO: fix this - it's broken

--@type string|nil
local selection_path = nil

local function fopen()
	if selection_path == nil then
		return
	end
	local fd = assert(vim.uv.fs_open(selection_path, 'r', 438))
	local stat = assert(vim.uv.fs_fstat(fd))
	local data = assert(vim.uv.fs_read(fd, stat.size, 0))
	assert(vim.uv.fs_close(fd))
	if type(data) == 'string' then
		local lines = {}
		for line in string.gmatch(data, '[^\r\n]+') do
			table.insert(lines, line)
		end
		return lines
	end
	return nil
end

local function lf()
	selection_path = vim.fn.tempname()
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)
	local opts = {
		relative = 'editor',
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2) - 1,
		col = math.floor((vim.o.columns - width) / 2),
		border = 'double',
	}
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, opts)
	vim.fn.setwinvar(win, '&winhl', 'Normal:Pmenu')

	vim.cmd(
		[[setlocal buftype=nofile nobuflisted bufhidden=wipe nonumber norelativenumber signcolumn=no noswapfile]]
	)

	-- TODO: fix this
	local cmd = 'lf -selection-path=' .. selection_path .. ' ""'
	vim.cmd('term ' .. cmd)
	vim.cmd('autocmd BufWipeout <buffer> call v:lua.fopen()')
	vim.cmd("autocmd TermClose <buffer> call v:lua.feedkeys('<CR>')")
	vim.cmd('silent! tunmap <buffer> jk')
	vim.cmd('silent! tunmap <buffer> kj')
	vim.cmd('silent! tunmap <buffer> <Esc>')
	vim.cmd('silent! tunmap <buffer> <C-[>')

end

vim.api.nvim_create_user_command('Lf', lf, {})
