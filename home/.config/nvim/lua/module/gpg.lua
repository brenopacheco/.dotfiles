--- GPG helper
--
-- Decrypts .gpg/.asc files on opening
-- Encrypts .gpg/.asc files on saving
-- Provides GPG [decrypt/encrypt] command

---@param buf? integer
---@param mode 'encrypt' | 'decrypt'
---@param cb? fun(ok: boolean)
local function run_gpg(buf, mode, cb)
	buf = buf or vim.api.nvim_get_current_buf()
	mode = mode == 'encrypt' and 'encrypt' or 'decrypt'
	cb = cb or function() end
	local cmd_arg = mode == 'decrypt' and '-dq' or '-easq'
	local end_line = vim.api.nvim_buf_line_count(buf)
	-- TODO: disable leaky options
	-- vim.bo.backup = false (global, this fails)
	-- vim.bo.writebackup = false
	-- vim.bo.swapfile = false
	-- vim.bo.undofile = false
	local text = vim.api.nvim_buf_get_lines(buf, 0, end_line, false)
	local obj = vim
		---@diagnostic disable-next-line: missing-fields
		.system({ 'gpg', cmd_arg }, {
			env = vim.fn.environ(),
			text = true,
			stdin = text,
		})
		:wait()
	if obj.code ~= 0 then
		vim.notify(
			'GPG: failed ' .. mode .. ' - ' .. obj.stderr,
			vim.log.levels.ERROR
		)
		return cb(false)
	end
	local decrypted = vim.split(vim.trim(obj.stdout), '\n')
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
	vim.api.nvim_buf_set_lines(buf, 0, #decrypted, false, decrypted)
	vim.notify(obj.stderr, vim.log.levels.INFO)
	cb(true)
end

---@param buf? integer
---@param cb? fun(result: boolean)
local function encrypt(buf, cb) run_gpg(buf, 'encrypt', cb) end

---@param buf? integer
---@param cb? fun(result: boolean)
local function decrypt(buf, cb) run_gpg(buf, 'decrypt', cb) end

-- setup
local group = vim.api.nvim_create_augroup('gpg_helper', { clear = true })

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
	desc = 'Decrypts GPG file when buffer loads',
	group = group,
	pattern = { '*.gpg', '*.asc' },
	callback = function(ev) decrypt(ev.buf) end,
	nested = true,
})

vim.api.nvim_create_autocmd('BufWritePre', {
	desc = 'Encrypts GPG file before saving',
	group = group,
	pattern = { '*.gpg', '*.asc' },
	callback = function(ev) encrypt(ev.buf) end,
	nested = true,
})

vim.api.nvim_create_user_command('GPG', function(cmd)
	if cmd.args == 'encrypt' then
		return encrypt()
	elseif cmd.args == 'decrypt' then
		return decrypt()
	else
		vim.notify('GPG: unknown command.')
	end
end, {
	nargs = 1,
	complete = function() return { 'encrypt', 'decrypt' } end,
})
