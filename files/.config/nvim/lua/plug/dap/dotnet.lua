local M = {}

M.ft = 'cs'
M.type = 'netcoredbg'

local netcoredbg = {
  type = 'executable',
  command = '/usr/bin/netcoredbg',
  args = {'--interpreter=vscode'}
}

local function server()
  local cmd = [[ss -lpn | grep netcore | awk '{print $5}']]
  local address = vim.fn.system(cmd)
  assert(string.len(address) > 0, 'Adapter is not running.')
  local parts = vim.fn.split(string.gsub(address, '\n', ''), ':')
  local host = parts[1]
  local port = parts[2]
  return host, port
end

local function connector(callback)
  vim.ui.select({
    {mode = 'start', text = 'Start an adapter instance'},
    {mode = 'connect', text = 'Connect to adapter on port'}
  }, {
    prompt = 'Adapter connection:',
    format_item = function(item) return item.text end
  }, function(choice)
    if choice.value.mode == 'start' then
      callback(netcoredbg)
    else
      local host, port = server()
      callback({type = 'server', port = port, host = host})
    end
  end)
end

M.adapter = function(callback, config)
  assert(config.task, 'dotnet dap configuration is missing task')
  config.task(callback, config)
end

local debug_attach = {
  type = M.type,
  name = 'Attach to running program',
  task = function(connect, config)
    config.processId = 1
    config.request = 'attach'
    config.stopOnEntry = true
    config.cwd = '/'
    -- connect(callback)
    connect(netcoredbg)
  end
}

local debug_app = {
  type = M.type,
  name = 'Launch application',
  task = function(connect, config) connect(netcoredbg) end
}

local debug_unit = {
  type = M.type,
  name = 'Launch unit tests',
  task = function(connect, config) connect(netcoredbg) end
}

local debug_integration = {
  type = M.type,
  name = 'Launch integration tests',
  task = function(connect, config) connect(netcoredbg) end
}

local debug_test = {
  type = M.type,
  name = 'Launch test under cursor',
  task = function(connect, config) connect(netcoredbg) end
}

M.configurations = {
  debug_attach, debug_app, debug_integration, debug_test, debug_unit
}

return M
