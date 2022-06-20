_G.P = function(v)
  vim.pretty_print(v)
end

_G.R = function(...)
  return require('reloader').reload(...)
end
