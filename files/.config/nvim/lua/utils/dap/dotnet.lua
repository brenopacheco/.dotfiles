local utils = require('utils')
local dap = require('dap')
local selector = require('utils.picker').selector

local M = {}

function M.debug_process()
  local _, file = utils.find_root('^.*.sln$')
  if not file then
    print('sln file not found')
    return nil
  end

  local pname = string.gsub(file, '.sln$', '')
  local cmd = [[ps -aef | egrep 'bin/Debug/.*/]] .. pname ..
                  [[' | egrep -v '(grep|bash|\sdotnet)']]

  local results = vim.fn.systemlist(cmd)

  if #results == 0 then
    print('process not found')
    return nil
  end

  local processes = {}

  for _, p in pairs(results) do
    local parts = vim.fn.split(string.gsub(p, '%s+', ' '), ' ')
    local name = ''
    for _, value in pairs({unpack(parts, 8, #parts)}) do
      if string.len(name) ~= 0 then name = name .. ' ' end
      name = name .. value
    end

    table.insert(processes, {pid = parts[2], name = name})
  end

  local choices = {'Selected process:'}
  for i, v in pairs(processes) do
    table.insert(choices, i .. '. [' .. v.pid .. ']: ' .. v.name)
  end
  local idx = vim.fn.inputlist(choices)
  if idx < 1 or idx > #processes then
    print()
    print('invalid choice')
    return nil
  end
  process = processes[idx]

  return process.pid
end

function M.debug_dll()
  root, file = utils.find_root('^.*.sln$')
  local pname = string.gsub(file, '.sln$', '')
  local cmd = [[fd -t f -p "bin/Debug/[^/]+/]] .. pname ..
                  [[(\.[^/]+)?\.dll$" -HI ]] .. root
  local results = vim.fn.systemlist(cmd)

  local entries = {}

  local max_len = 0
  for _, v in ipairs(results) do
    local entry = {
      path = v,
      fname = vim.fs.basename(v),
      dir = vim.fs.dirname(string.sub(v, string.len(root) + 2))
    }
    table.insert(entries, entry)
    local fname_len = string.len(entry.fname)
    max_len = fname_len > max_len and fname_len or max_len
  end

  local format = '%-' .. tostring(max_len + 6) .. 's %s'

  function entry_maker(entry)
    return {
      value = entry,
      display = string.format(format, entry.fname, entry.dir),
      ordinal = entry.path
    }
  end

  function on_select(selection)
    local config = {
      type = 'coreclr',
      name = 'Launch dll',
      request = 'launch',
      program = selection.value.path
    }
    dap.run(config)
  end

  selector('Select dll to launch', entries, on_select, entry_maker)
end


function M.debug_tests()
  dir, _ = find_root('^.*.sln$')

  vim.cmd([[bo 10sp | terminal cd ]] .. dir ..
              [[; VSTEST_HOST_DEBUG=1 dotnet test --filter 'Category=Unit']])
  vim.cmd([[wincmd p]])

  local result = vim.fn.system('ps -ah | grep Debug | grep client')
  if string.len(result) > 0 then
    local pid = vim.fn.split(result, ' ')[1]
    print('found pid ' .. pid)
    return pid
  end

  dap.run({
    type = 'coreclr',
    name = 'Attach to unit tests',
    request = 'attach',
    processId = 1
  })
end



return M
