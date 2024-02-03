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
	if key ~= nil then package.loaded[key] = nil end
	package.loaded['keymaps'] = nil
	package.loaded['utils.maps'] = nil
	require('keymaps')
	require(dkey)
	vim.notify("Package '" .. dkey .. "' reloaded")
end

-- setup
vim.api.nvim_create_autocmd('BufWritePost', {
	nested = true,
	group = vim.api.nvim_create_augroup('Reloader', { clear = true }),
	pattern = { '*.lua', '*.fnl' },
	desc = 'Reload nvim lua modules on save',
	callback = function(context)
		vim.schedule(function()
			local regex = '(.*)/%.config/nvim/[lf][un][al]/(.*)%.[lf][un][al]'
			local module, matches = string.gsub(context.match, regex, '%2')
			if matches ~= 1 then return end
      if module:match("macros?$") then return end
			reload(module)
		end)
	end,
})
