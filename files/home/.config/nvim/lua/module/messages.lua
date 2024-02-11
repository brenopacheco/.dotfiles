--- Messages buffer
--
-- Keep a message buffer always available for printed messages.

_G._print = _G.print
_G.print = function(...)
	_G._print('intercepted print:')
	_G._print(...)
end
