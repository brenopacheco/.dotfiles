local dap = require('dap')
local M = {}

M.config = function()
  dap.adapters.go = M.adapter
  dap.configurations.go = M.configurations
end

dap.adapters.delve = function(callback, config)
  local stdout = vim.loop.new_pipe(false)
  local handle
  local pid_or_err
  local host = config.host or '127.0.0.1'
  local port = config.port or '38697'
  local addr = string.format('%s:%s', host, port)
  local opts = {
    stdio = {nil, stdout},
    args = {'dap', '-l', addr},
    detached = true
  }
  handle, pid_or_err = vim.loop.spawn('dlv', opts, function(code)
    stdout:close()
    handle:close()
    if code ~= 0 then print('dlv exited with code', code) end
  end)
  assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
  stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      vim.schedule(function() require('dap.repl').append(chunk) end)
    end
  end)
  vim.defer_fn(function()
    callback({type = 'server', host = '127.0.0.1', port = port})
  end, 100)
end

M.configurations = {
  {type = 'delve', name = 'Debug', request = 'launch', program = '${file}'}
  -- {
  --   type = "go",
  --   name = "Debug Package",
  --   request = "launch",
  --   program = "${fileDirname}",
  -- },
}

--     {
--       type = "go",
--       name = "Debug",
--       request = "launch",
--       program = "${file}",
--     },
--     {
--       type = "go",
--       name = "Debug Package",
--       request = "launch",
--       program = "${fileDirname}",
--     },

return M



-- M.setup = function()
--   -- M.register({
--   --   lang = 'go',
--   --   name = 'Go attach',
--   --   type = 'generic',
--   --   request = 'attach', -- this defines the json message sent to the adapter
--   --   task = function(self, callback)
--   --     self.process = require('dap.utils').pick_process()
--   --     callback({
--   --       type = 'server',
--   --       port = '${port}',
--   --       executable = {
--   --         command = 'dlv',
--   --         args = {'dap', '-l', '127.0.0.1:${port}'}
--   --       }
--   --     })
--   --   end
--   -- })

--   M.register({
--     lang = 'go',
--     name = 'Go launch',
--     type = 'generic',
--     request = 'launch',
--     task = function()
--       return function(self, callback)
--         print('in task')
--         P(self)
--         self.cwd = vim.fn.getcwd()
--         self.program = vim.fn.input('Path to executable: ',
--                                     vim.fn.getcwd() .. '/', 'file')
--         self.task = nil
--         callback({
--           type = 'server',
--           port = '${port}',
--           executable = {
--             command = 'dlv',
--             args = {'dap', '-l', '127.0.0.1:${port}'}
--           }
--         })
--       end
--     end
--   })
-- end

-- M.register = function(conf)
--   assert(conf.lang, 'lang field is required')
--   dap.configurations[conf.lang] = dap.configurations[conf.lang] or {}
--   table.insert(dap.configurations[conf.lang], conf)
--   dap.adapters.generic = function(callback, config)
--     print('in generic')
--     P(config)
--     config:task(callback)
--   end
-- end
--
---- function config()
----  ---@type Adapter
----  local m = {}
----  ---@type Configuration
----  local p = {}
----  dap.adapters[m.name] = 
----  dap.configurations[p.name] = 
---- end

-----@alias AdapterFun fun(callback: fun(adapter: Adapter), config: Configuration)

-----@class Configuration @Debug configuration
-----@field name string @Configuration name
-----@field type string @Adapter name
-----@field request "'attach'" | "'launch'"
--local Configuration = {}

---- other information in the configuration are adapter specific
---- "program": "${workspaceFolder}/app.js",
---- "cwd": "${workspaceFolder}",
---- "args": ["${env:USERNAME}"]

-----@class Adapter
-----@field name string
--local Adapter = {}

-----@class ExecOpts
-----@field env? table        environment variables
-----@field cwd? string       working directory
-----@field detached? boolean spawn process in detached mode
--local ExecOpts = {}

-----@class Executable : Adapter @Adapter configuration for launching debugger
-----@field command           string command to invoke
-----@field args string[]     arguments for the command
-----@field options? ExecOpts process configuration
--local Executable = {}

-----@return Server
-----@param command string command to invoke
-----@param args string[] arguments for the command
-----@param options? ExecOpts (optional) process configuration
--function Executable:new(command, args, options)
--  assert(type(command) == 'string', 'command must be specified.')
--  assert(type(args) == 'table', 'args must be specified.')
--  options = options or {}
--  local o = {command = command, args = args, options = options}
--  setmetatable(o, {__index = self})
--  return o
--end

-----@class Server : Adapter @Adapter configuration for running debugger as a server
-----@field host string Adapter server's host
-----@field port string Adapter server's port
--local Server = {}

-----@param host? string [string] (optional) host to connect to, defaults to 127.0.0.1
-----@param port string [string] (required) port to connect to
-----@return Server
--function Server:new(host, port)
--  assert(type(port) == 'string', 'Port must be specified.')
--  host = host or '127.0.0.1'
--  local o = {host = host, port = port}
--  setmetatable(o, {__index = self})
--  return o
--end

--return M
