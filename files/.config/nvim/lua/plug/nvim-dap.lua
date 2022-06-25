--[[
Language     Adapter      Repository
------------------------------------
c,cpp        lldb         official
dotnet       netcoredbg   community
javascript   -            -
golang       delve        official
lua          ?

Use cases for debugging
------------------------
1. attach to process           (e.g: attach to running server)
2. launch an process           (e.g: run c executable)
3. run task and attach process (e.g: run dotnet test in debug more and attach)
4. run task and launch process (e.g: compile c program and launch)

adapter can be a function. they take a callback and run dap.run()

--]]

-- IMPORTS
local dap = require('dap')
local dotnet = require('plug.dap.dotnet')

-- GENERAL
dap.set_log_level('TRACE')
vim.fn.sign_define('DapBreakpoint',
                   {text = '●', texthl = '', linehl = '', numhl = ''})

-- ADAPTERS AND CONFIGURATIONS


dap.adapters = {
  [dotnet.type] = dotnet.adapter;
}

dap.configurations = {
  [dotnet.ft] = dotnet.configurations;
}






-- dap.adapters = {
--   lldb = {
--     type = 'executable',
--     command = '/usr/bin/lldb-vscode',
--     name = 'lldb'
--   },
--   coreclr = {
--     type = 'executable',
--     command = '/usr/bin/netcoredbg',
--     args = {'--interpreter=vscode'}
--   },
--   netcoredbg = function(callback, config)
--     assert(config.mode == 'attach' or config.mode == 'launch' or config.mode == 'task',
--            'Invalid configuration mode for connecting to the adapter.')
--     local conf = {
--       type = 'executable',
--       command = '/usr/bin/netcoredbg',
--       args = {'--interpreter=vscode'}
--     }
--     if (config.mode == 'task') then
--       return config.task(callback, config)
--     end
--     if (config.mode == 'attach') then
--       local cmd = [[ss -lpn | grep netcore | awk '{print $5}']]
--       local address = vim.fn.system(cmd)
--       assert(string.len(address) > 0, 'Adapter is not running.')
--       local parts = vim.fn.split(string.gsub(address, '\n', ''), ':')
--       local host = parts[1]
--       local port = parts[2]
--       conf = {type = 'server', port = port, host = host}
--     end
--     callback(conf)
--   end
-- }

-- -- CONFIGURATIONS
-- -- TODO: fix here
-- dap.configurations = {
--   c = {
--     {
--       name = 'Launch',
--       type = 'lldb',
--       request = 'launch',
--       program = function()
--         return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/',
--                             'file')
--       end,
--       cwd = '${workspaceFolder}',
--       stopOnEntry = true,
--       args = {}
--     }
--   },
--   cs = {
--     {
--       type = 'netcoredbg',
--       name = 'Attach to adapter and attach to PID',
--       request = 'attach',
--       processId = function() return vim.fn.input('Attach to PID: ') end,
--       cwd = '${workspaceFolder}',
--       stopOnEntry = true,
--       mode = 'attach'
--     }, {
--       type = 'netcoredbg',
--       name = 'Attach to adapter and lauch dll',
--       request = 'launch',
--       program = function()
--         return vim.fn.input('Path for the dll: ', '', 'file')
--       end,
--       cwd = '${workspaceFolder}',
--       stopOnEntry = true,
--       mode = 'attach'
--     }, {
--       type = 'netcoredbg',
--       name = 'Launch adapter and attach to PID',
--       request = 'attach',
--       processId = function() return vim.fn.input('Attach to PID: ') end,
--       cwd = '${workspaceFolder}',
--       stopOnEntry = true,
--       mode = 'launch'
--     }, {
--       type = 'netcoredbg',
--       name = 'Launch adapter and lauch dll',
--       request = 'launch',
--       program = function()
--         return vim.fn.input('Path for the dll: ', '', 'file')
--       end,
--       cwd = '${workspaceFolder}',
--       stopOnEntry = true,
--       mode = 'launch'
--     },
--     {
--       type = 'netcoredbg',
--       name = 'Launch adapter and lauch dll',
--       request = 'launch',
--       program = function()
--         return vim.fn.input('Path for the dll: ', '', 'file')
--       end,
--       cwd = '${workspaceFolder}',
--       stopOnEntry = true,
--       mode = 'task',
--       task = function(callback, config)
--         print("experimental. runs tasks and then calls the callback")
--         callback(config)
--       end
--     }
--   }
-- }
