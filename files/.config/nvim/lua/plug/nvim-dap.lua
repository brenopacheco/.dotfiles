--[[
Language     Adapter      Repository
------------------------------------
c,cpp        lldb         official
dotnet       netcoredbg   community
javascript   ?
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

local dap = require('dap')
local dapui = require("dapui")

-- GENERAL
require('nvim-dap-virtual-text').setup()
require('dap-go').setup()
require('dapui').setup()
dap.set_log_level('TRACE')
vim.fn.sign_define('DapBreakpoint', {text = '●', texthl = '', linehl = '', numhl = ''})
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- ADAPTERS
dap.adapters = {
  lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
    name = 'lldb'
  },
  netcoredbg = {
    type = 'executable',
    command = '/usr/bin/netcoredbg',
    args = {'--interpreter=vscode'}
  },
  -- test = function(callback, config)
  --   print('blocking')
  --   vim.loop.sleep(3000)
  --   print('lorem')
  --   -- callback(config) -- this needs to be called async
  -- end
}

-- CONFIGURATIONS
-- TODO: fix here
dap.configurations = {
  c = {
    {
      name = 'Launch',
      type = 'lldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/',
                            'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = true,
      args = {}
    }
  },
  lua = {
    {
      name = 'Test',
      type = 'test',
      requrest = 'launch',
      program = '${file}',
      cwd = '${workspaceFolder}',
      stopOnEntry = true,
      args = {}
    }
  }
}

-- UI

