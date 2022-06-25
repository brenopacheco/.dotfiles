_G.P = function(v)
  vim.pretty_print(v)
end

_G.R = function(...)
  return require('reloader').reload(...)
end

_G.M = function()
  vim.cmd([[Bufferize lua require('reloader').modules()]])
end

vim.ui.select = require('utils.picker').select
