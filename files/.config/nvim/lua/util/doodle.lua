local notify = require('notify')
local M = {}

--[[




--]]

---Binding for vim.api create autocmd / create augroup
---@param event AutocmdEvent
---@param group_name string
---@param callback fun(context: any)
---@param desc string
function M.autocmd(event, group_name, desc, callback)
  vim.api.nvim_create_autocmd(event, {
    group = vim.api.nvim_create_augroup(group_name, {clear = true}),
    desc = desc,
    callback = callback
  });
end

function M.go_run()
  path = vim.fn.expand('%:p')
  ft = vim.o.ft
  cmds = {
    go = {'go', 'run', path},
    lua = {'lua', path},
    javascript = {'node', path},
    typescript = {'ts-node', path},
    sh = {'bash', path}
  }
  cmd = cmds[ft]
  assert(cmd ~= nil, 'Filetype not supported.')
  local callback = function()
    vim.fn.jobstart(cmd, {
      stdout_buffered = true,
      stderr_buffered = true,
      on_stdout = function(_, data)
        notify(data, vim.log.levels.INFO, {title = 'Output of: ' .. path})
      end,
      on_stderr = function(_, data)
        if data == nil or string.len(data[1]) == 0 then return end
        notify(data, vim.log.levels.ERROR, {title = 'Error of: ' .. path})
      end
    })
  end
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('Utils', {clear = true}),
    desc = 'Run buffer interpreter',
    buffer = vim.fn.bufnr(),
    callback = callback
  })
  callback()
end

function M.tabbuffers()
  ---@type Buffer[]
  local buffers = {}

  for _, bufnr in ipairs(vim.fn.tabpagebuflist()) do
    ---@class Buffer
    ---@field bufnr string
    ---@field name string
    ---@field ft string
    local buf = {
      bufnr = bufnr,
      name = vim.fn.bufname(bufnr),
      ft = vim.fn.getbufvar(bufnr, '&filetype')
    }
    table.insert(buffers, buf)
  end
  return buffers
end

--  TODO: check if buffer exist, create buffer, go_run

---@class Array
local Array = {}

---@return boolean
function Array:empty() return #self > 0 end

---@param arg any|fun(elem: any):boolean @element or callback to test
function Array:contains(arg)
  local compare = function(elem) return arg == elem end
  if type(arg) == 'function' then
    compare = arg
    for _, v in pairs(self) do if compare(v) then return true end end
    return false
  end
end

---@param callback fun(i: number, v: any)
function Array:forEach(callback) for i, v in pairs(self) do callback(i, v) end end

---@param callback function(i: number, v: any)
---@return Array
function Array:map(callback)
  local tbl = {}
  for i, v in pairs(self) do table.insert(tbl, callback(i, v)) end
  return Array:new(tbl)
end

---@param callback function(i: number, v: any)
---@return Array
function Array:filter(callback)
  local tbl = {}
  for i, v in pairs(self) do if callback(i, v) then table.insert(tbl, v) end end
  return Array:new(tbl)
end

---@param o table
---@return Array
function Array:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function M.test_map()
  local p = Array:new({'foo', 'bar', 'baz'}):filter(function(_, v)
    return v ~= 'bar'
  end):map(function(_, v) return {val = v} end)
  P(p)
end

return M
