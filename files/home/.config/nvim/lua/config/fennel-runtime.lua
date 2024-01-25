local fennel = require('fennel').setup()

local mt = getmetatable(fennel) or {}
mt.__call = function(_, ...) return fennel.eval(...) end

_G.fnl = fennel

require('hello')
