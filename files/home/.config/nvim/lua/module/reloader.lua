--- Reloader
--
-- Attaches an autocmd to reload a lua module on config file save
--

local function reload(module)
	module = module or ''
	local dkey = string.gsub(module, '/', '.')
	local skey = string.gsub(module, '%.', '/')
	local key = (package.loaded[dkey] and dkey)
		or (package.loaded[skey] and skey)
		or nil
	if key ~= nil then
		package.loaded[key] = nil
	end
	require(dkey)
	vim.notify("Package '" .. dkey .. "' reloaded")
end

-- setup
vim.api.nvim_create_autocmd('BufWritePost', {
	group = vim.api.nvim_create_augroup('Reloader', { clear = true }),
	pattern = '*.lua',
	desc = 'Reload nvim lua modules on save',
	callback = function(context)
		vim.schedule(function()
			local regex = '(.*)/%.config/nvim/lua/(.*)%.lua'
			local module, matches = string.gsub(context.match, regex, '%2')
			if matches == 1 then
				reload(module)
			end
		end)
	end,
})
