local M = {}

local dap = function()
	return require('dap')
end

local is_running = function()
	return string.len(dap().status() or '') > 0
end

--- Open dap.log file
M.log = function()
	local path = vim.fn.stdpath('cache') .. '/dap.log'
	vim.cmd('vsp ' .. path)
end

M.debug = function()
	vim.notify('Debugging ' .. vim.fn.expand('%'))
  require('dap').repl.open()
  -- require('dap').run_last()
end

vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<leader>dn', function() require('dap').continue() end)
vim.keymap.set({'n', 'v'}, '<leader>dp', function() require('dap.ui.widgets').hover() end)

return M
