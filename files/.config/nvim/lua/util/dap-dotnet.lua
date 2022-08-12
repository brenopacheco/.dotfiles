local dap = require('dap')
local notify = require('notify')

local M = {}

dap.adapters.netcoredbg = {
  type = 'server',
  port = '${port}',
  executable = {
    command = '/usr/bin/netcoredbg',
    args = {'--interpreter=vscode', '--server=${port}'}
  },
  enrich_config = function(config, on_config)
    if config.task then
      local task = config.task
      config.task = nil
      return task(vim.deepcopy(config), on_config)
    end
    on_config(config)
  end
}

dap.configurations.cs = {
  {
    name = 'Debug unit tests',
    request = 'attach',
    type = 'netcoredbg',
    task = function()
      return function(config, on_config)
        M.dotnet_test_debug(function(pid)
          config.processId = pid
          notify(vim.inspect(config), 'info',
                 {title = 'Dotnet test'})
          on_config(config)
        end)
      end
    end
  }
}

---@param callback fun(pid: number)
function M.dotnet_test_debug(callback)
  notify('Starting...', 'info', {title = 'Dotnet test'})
  callback = callback or function(pid)
    notify({'Debug session opened.', 'PID: ' .. pid}, 'info',
           {title = 'Dotnet test'})
  end
  local done = false
  local msg = {}
  vim.fn.jobstart({'dotnet', 'test', '--filter', '"Category=Unit"'}, {
    env = {VSTEST_HOST_DEBUG = 1},
    pty = true,
    cwd = require('util.fs').root('.*%.sln'),
    on_stdout = function(_, data)
      for _, str in pairs(data) do
        table.insert(msg, str)
        match = string.match(str, 'Id: (%d+)')
        if match and not done then
          done = true
          return callback(match)
        end
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        return notify(msg[#msg], 'error',
                      {title = 'Dotnet test'})
      end
      notify({'Debug session ended'}, 'info', {title = 'Dotnet test'})
    end
  })
end

return M

-- M.ft = 'cs'
-- M.type = 'netcoredbg'

-- local netcoredbg = {
--   type = 'executable',
--   command = '/usr/bin/netcoredbg',
--   args = {'--interpreter=vscode'}
-- }

-- local function server()
--   local cmd = [[ss -lpn | grep netcore | awk '{print $5}']]
--   local address = vim.fn.system(cmd)
--   assert(string.len(address) > 0, 'Adapter is not running.')
--   local parts = vim.fn.split(string.gsub(address, '\n', ''), ':')
--   local host = parts[1]
--   local port = parts[2]
--   return host, port
-- end

-- local function connector(callback)
--   vim.ui.select({
--     {mode = 'start', text = 'Start an adapter instance'},
--     {mode = 'connect', text = 'Connect to adapter on port'}
--   }, {
--     prompt = 'Adapter connection:',
--     format_item = function(item) return item.text end
--   }, function(choice)
--     if choice.value.mode == 'start' then
--       callback(netcoredbg)
--     else
--       local host, port = server()
--       callback({type = 'server', port = port, host = host})
--     end
--   end)
-- end

-- M.adapter = function(callback, config)
--   assert(config.task, 'dotnet dap configuration is missing task')
--   config.task(callback, config)
-- end

-- local debug_attach = {
--   type = M.type,
--   name = 'Attach to running program',
--   task = function(connect, config)
--     config.processId = 1
--     config.request = 'attach'
--     config.stopOnEntry = true
--     config.cwd = '/'
--     connect(netcoredbg)
--   end
-- }

-- -- TODO:
-- local debug_app = {
--   type = M.type,
--   name = 'Launch application',
--   task = function(connect, config) connect(netcoredbg) end
-- }

-- -- TODO:
-- local debug_unit = {
--   type = M.type,
--   name = 'Launch unit tests',
--   task = function(connect, config) connect(netcoredbg) end
-- }

-- -- TODO:
-- local debug_integration = {
--   type = M.type,
--   name = 'Launch integration tests',
--   task = function(connect, config) connect(netcoredbg) end
-- }

-- -- TODO:
-- local debug_test = {
--   type = M.type,
--   name = 'Launch test under cursor',
--   task = function(connect, config) connect(netcoredbg) end
-- }

-- -- TODO:
-- M.configurations = {
--   debug_attach, debug_app, debug_integration, debug_test, debug_unit
-- }

-- return M

-- local utils = require('utils')
-- local dap = require('dap')
-- local selector = require('utils.picker').selector

-- local M = {}

-- function M.debug_process()
--   local _, file = utils.find_root('^.*.sln$')
--   if not file then
--     print('sln file not found')
--     return nil
--   end

--   local pname = string.gsub(file, '.sln$', '')
--   local cmd = [[ps -aef | egrep 'bin/Debug/.*/]] .. pname ..
--                   [[' | egrep -v '(grep|bash|\sdotnet)']]

--   local results = vim.fn.systemlist(cmd)

--   if #results == 0 then
--     print('process not found')
--     return nil
--   end

--   local processes = {}

--   for _, p in pairs(results) do
--     local parts = vim.fn.split(string.gsub(p, '%s+', ' '), ' ')
--     local name = ''
--     for _, value in pairs({unpack(parts, 8, #parts)}) do
--       if string.len(name) ~= 0 then name = name .. ' ' end
--       name = name .. value
--     end

--     table.insert(processes, {pid = parts[2], name = name})
--   end

--   local choices = {'Selected process:'}
--   for i, v in pairs(processes) do
--     table.insert(choices, i .. '. [' .. v.pid .. ']: ' .. v.name)
--   end
--   local idx = vim.fn.inputlist(choices)
--   if idx < 1 or idx > #processes then
--     print()
--     print('invalid choice')
--     return nil
--   end
--   process = processes[idx]

--   return process.pid
-- end

-- function M.debug_dll()
--   root, file = utils.find_root('^.*.sln$')
--   local pname = string.gsub(file, '.sln$', '')
--   local cmd = [[fd -t f -p "bin/Debug/[^/]+/]] .. pname ..
--                   [[(\.[^/]+)?\.dll$" -HI ]] .. root
--   local results = vim.fn.systemlist(cmd)

--   local entries = {}

--   local max_len = 0
--   for _, v in ipairs(results) do
--     local entry = {
--       path = v,
--       fname = vim.fs.basename(v),
--       dir = vim.fs.dirname(string.sub(v, string.len(root) + 2))
--     }
--     table.insert(entries, entry)
--     local fname_len = string.len(entry.fname)
--     max_len = fname_len > max_len and fname_len or max_len
--   end

--   local format = '%-' .. tostring(max_len + 6) .. 's %s'

--   function entry_maker(entry)
--     return {
--       value = entry,
--       display = string.format(format, entry.fname, entry.dir),
--       ordinal = entry.path
--     }
--   end

--   function on_select(selection)
--     local config = {
--       type = 'coreclr',
--       name = 'Launch dll',
--       request = 'launch',
--       program = selection.value.path
--     }
--     dap.run(config)
--   end

--   selector('Select dll to launch', entries, on_select, entry_maker)
-- end

-- function M.debug_tests()
--   dir, _ = find_root('^.*.sln$')

--   vim.cmd([[bo 10sp | terminal cd ]] .. dir ..
--               [[; VSTEST_HOST_DEBUG=1 dotnet test --filter 'Category=Unit']])
--   vim.cmd([[wincmd p]])

--   local result = vim.fn.system('ps -ah | grep Debug | grep client')
--   if string.len(result) > 0 then
--     local pid = vim.fn.split(result, ' ')[1]
--     print('found pid ' .. pid)
--     return pid
--   end

--   dap.run({
--     type = 'coreclr',
--     name = 'Attach to unit tests',
--     request = 'attach',
--     processId = 1
--   })
-- end
