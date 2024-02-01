local bufutil = require('utils.buf')

local function json_stringify()
	if not bufutil.is_visual() then vim.cmd('normal! gv') end
	local text = table.concat(bufutil.get_visual2(), '\\n')
  vim.cmd('normal! "zy') -- escape from insert mode
	assert(not bufutil.is_visual(), 'should not be in visual mode anymore')
	local escaped = vim.fn.shellescape(text)
	local cmd = [[console.log(JSON.stringify(]] .. escaped .. [[))]]
	local out = vim.system({ 'node', '-e', cmd }, { text = true }):wait()
	assert(out.code == 0, out.stderr)
	local result = assert(vim.json.decode(out.stdout))
	local lines = vim.split(result, '\n')
	bufutil.throwaway(lines, { filetype = 'json' })
	vim.cmd('silent! Neoformat')
	vim.cmd('wincmd p')
end

vim.api.nvim_create_user_command(
	'JsonStringify',
	json_stringify,
	{ nargs = 0, range = 2 }
)
