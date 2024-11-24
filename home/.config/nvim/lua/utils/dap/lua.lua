local M = {}

-- NOTE:
-- This adapter and configurations cannot be called directly:
-- we need to call `require('osv').run_this()` instead. What happens is `osv`
-- will start a new instance of Neovim, send a command to run 'osv.start()',
-- and attach to it. Then, on every setpoint added, it will require the server
-- to reload the file. The server needs to be explicitly told to load a file
-- if we want to debug it. There is no need to reload. In order to make it
-- work the same as other adapters, we'll have to copy the run_this function.

---@type integer|nil
local chan_id = nil

local start_server = function()
	if chan_id then
		vim.fn.jobstop(chan_id)
		chan_id = nil
	end
	local sock_path = os.tmpname() .. '.pipe'
	chan_id = vim.fn.jobstart(
		{ 'nvim', '--embed', '--headless', '--listen', sock_path },
		{ rpc = true, env = vim.fn.environ() }
	)
	assert(chan_id, 'Could not create neovim instance with jobstart!')
	---@type { mode: string, blocking: boolean }|nil
	local mode = vim.rpcrequest(chan_id, 'nvim_get_mode')
	assert(mode, 'Could not get neovim mode')
	assert(not mode.blocking, 'Neovim is waiting for input at startup. Aborting.')
	local server = vim.rpcrequest(
		chan_id,
		'nvim_exec_lua',
		---@diagnostic disable-next-line: param-type-mismatch
		'return require("osv").launch({ port = 8086 }) and true or false',
		{}
	)
	assert(server, 'Could not start osv server: check if port is already in use')
	require('dap').listeners.after['setBreakpoints']['osv'] = function()
		vim.schedule(function()
			pinfo('osv.lua: setBreakpoints')
			vim.fn.rpcnotify(
				chan_id,
				'nvim_command',
				'luafile ' .. vim.fn.expand('%:p')
			)
		end)
	end
end

---@type table<string, Adapter|fun(callback: fun(Adapter, Configuration): nil)>
M.adapters = {
	nlua = function(callback)
		pinfo('osv.lua: nlua adapter')
		start_server()
		callback({
			type = 'server',
			port = 8086,
			host = '127.0.0.1',
		})
	end,
}

M.configurations = {
	lua = {
		{
			name = '  Debug file',
			type = 'nlua',
			request = 'attach',
		},
	},
}

--- DEFAULT CONFIGURATION ====================================================
-- If using this default config  from 'osv', we need to configure debug_start
-- and debug_restart
--
-- M.debug_start = function()
--   if is_lua() and not is_running() then
--     return require('osv').run_this()
--   end
--   return dap.continue()
-- end
--
-- M.debug_restart = function()
--   if is_lua() then
--     return require('osv').run_this()
--   end
--   if is_running() then
--     return dap.restart()
--   end
--   dap.run_last()
-- end

-- M.adapters = {
-- 	nlua = function(callback, config)
-- 		callback({
-- 			type = 'server',
-- 			host = config.host or '127.0.0.1',
-- 			port = config.port or 8086,
-- 		})
-- 	end,
-- }

-- M.configurations = {
-- 	{
-- 		type = 'nlua',
-- 		request = 'attach',
-- 		name = 'Attach to running Neovim instance',
-- 	},
-- }

return M
