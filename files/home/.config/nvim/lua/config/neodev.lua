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
		local ver = vim.fn
			.glob(new_root_dir .. '/lua_modules/lib/luarocks/rocks-*')
			:match('(%d%.%d)$')
		if not ver then
			vim.notify(
				'Error getting lua version: check luarocks/rocks-*',
				vim.log.level.ERROR
			)
			return
		end
		vim.tbl_extend('force', new_config.settings.Lua, {
			runtime = {
				version = string.format('Lua %s', ver),
				path = {
					new_root_dir .. '?.lua',
					new_root_dir .. '?/init.lua',
					new_root_dir .. 'lua_modules/share/lua/' .. ver .. '/?.lua',
					new_root_dir .. 'lua_modules/share/lua/' .. ver .. '/?/init.lua',
				},
			},
			workspace = {
				library = {
					new_root_dir .. '/lua_modules/share/lua/' .. ver .. '/',
					'/usr/share/lua/' .. ver .. '/',
				},
				checkThirdParty = 'Ask', -- 'ApplyInMemory', 'Disable'
				-- NOTE: even though this is setup, I still don't get completion in luassert for assert.True
				userThirdParty = { '/usr/lib/lls-addons' },
			},
		})
	end,
	-- https://luals.github.io/wiki/settings/
	-- https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			workspace = {},
			completion = {
				keywordSnippet = 'Disable',
			},
		},
	},
})
