--- Compile
--
-- Provides :Compile <cmd>  - works like M-x compile

local function compile(tbl)
	local cmd = tbl.args
	--vim.cmd('sp | wincmd p | te! ' .. cmd)
	vim.cmd('bo te! ' .. cmd)
end

vim.api.nvim_create_user_command(
	'Compile',
	compile,
	{ nargs = '+', complete = 'shellcmdline' }
)
