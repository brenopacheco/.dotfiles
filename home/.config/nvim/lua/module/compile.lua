--- Compile
--
-- Provides :Compile <cmd>  - works like M-x compile

local function compile(tbl)
	local cmd = tbl.args
	vim.cmd('bo te! ' .. cmd)
end

for _, command in pairs({ 'C', 'Compile' }) do
	vim.api.nvim_create_user_command(
		command,
		compile,
		{ nargs = '+', complete = 'shellcmdline' }
	)
end
