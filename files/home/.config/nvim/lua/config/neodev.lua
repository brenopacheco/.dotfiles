local lsputil = require('utils.lsp')
local rootutil = require('utils.root')

local is_rockspec_project = function(root_dir)
	local root_dirs =
		rootutil.upward_roots({ dir = root_dir, patterns = { '%.rockspec$' } })
	return #root_dirs ~= 0
end

require('neodev').setup({
	-- This makes any root trigger neodev's setup. Otherwise, only neovim files
	-- will trigger it. we want to disable these configurations for luarocks projects
	override = function(root_dir, library)
		library.enabled = not is_rockspec_project(root_dir)
		library.runtime = true
		library.plugins = true -- this slows down startup, but allows goto def.
		library.types = true
	end,
	lspconfig = true,
	pathStrict = true,
})

local capabilities = lsputil.capabilities

local lsp = require('lspconfig')

lsp.lua_ls.setup({
	capabilities = capabilities,
	root_dir = lsp.util.root_pattern(
		'.luarc.json',
		'.luarc.jsonc',
		'.luacheckrc',
		'.stylua.toml',
		'stylua.toml',
		'.git',
		'*.rockspec'
	),
	on_new_config = function(new_config, new_root_dir)
		if not is_rockspec_project(new_root_dir) then return end
		local ver = '5.4'
		new_config.settings.Lua.runtime.version = string.format('Lua %s', ver)
		new_config.settings.Lua.runtime.path = {
			new_root_dir .. '/?.lua',
			new_root_dir .. '/?/init.lua',
			new_root_dir .. '/lua/?.lua',
			new_root_dir .. '/lua/?/init.lua',
			new_root_dir .. '/lua_modules/share/lua/' .. ver .. '/?.lua',
			new_root_dir .. '/lua_modules/share/lua/' .. ver .. '/?/init.lua',
		}
		new_config.settings.Lua.workspace.library = {
			[new_root_dir .. '/lua_modules/share/lua/' .. ver .. '/'] = true,
			['/usr/share/lua/' .. ver .. '/'] = true,
		}
		pdebug(new_config)
	end,
	-- https://luals.github.io/wiki/settings/
	-- https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
				path = {
					vim.fn.stdpath('config') .. '/lua/?.lua',
					vim.fn.stdpath('config') .. '/lua/?/init.lua',
				},
			},
			workspace = {
				-- checkThirdParty = 'ApplyInMemory',
				checkThirdParty = 'Ask',
				userThirdParty = { '/usr/lib/lls-addons' },
			},
			completion = {
				keywordSnippet = 'Disable',
			},
		},
	},
})
