return function(delay, callback)
	local timer = vim.loop.new_timer()
	local wraped_callback = vim.schedule_wrap(function(...)
		local args = { ... }
		callback(unpack(args))
	end)
	return function(...)
		if timer:is_active() then
			timer:stop()
		end
		timer:start(delay, 0, wraped_callback)
	end
end
