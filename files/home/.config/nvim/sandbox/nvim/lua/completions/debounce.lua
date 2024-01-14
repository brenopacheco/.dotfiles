return function(delay, callback)
	local timer = vim.loop.new_timer()
	return function(...)
		if timer:is_active() then
			timer:stop()
		end
		local args = { ... }
		timer:start(
			delay,
			0,
			vim.schedule_wrap(function()
				callback(unpack(args))
			end)
		)
	end
end
