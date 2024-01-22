--[[ TODO:

- Add nvim/rocks dir with luarocks deps for additional packages 
- Add to runtime.path
  + 'rocks/lua_modules/share/lua/5.1/?.lua',
  + 'rocks/lua_modules/share/lua/5.1/?/init.lua',
- Add to library
  + 'rocks/lua_modules/share/lua/5.1/',

--]]


local lsputil = require('utils.lsp')
local rootutil = require('utils.root')

---@param root_dir string
---@return boolean
local function is_rockspec_project(root_dir)
	local root_dirs =
		rootutil.upward_roots({ dir = root_dir, patterns = { '%.rockspec$' } })
	return #root_dirs ~= 0
end

---@param new_config lsp.ClientConfig
---@param new_root_dir string
local function extend_rockspec_config(new_config, new_root_dir)
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
	local c = new_config.settings.Lua
	c.runtime = c.runtime or {}
	c.runtime.path = c.runtime.path or {}
	c.runtime.version = string.format('Lua %s', ver)
	c.workspace = c.workspace or {}
	c.workspace.library = c.workspace.library or {}
	c.runtime.path = {
		'?.lua',
		'?/init.lua',
		'lua_modules/share/lua/' .. ver .. '/?.lua',
		'lua_modules/share/lua/' .. ver .. '/?/init.lua',
	}
	c.workspace.library = {
		'lua_modules/share/lua/' .. ver .. '/',
		'/usr/share/lua/' .. ver .. '/',
	}
  -- NOTE:With `Apply` lua_ls will create a .luarc.json file in the project root
  -- directory and automatically fill the workspace.library. For instance:
  --  {
  --      "workspace.library": [
  --          "${3rd}/luassert/library"
  --      ]
  --  }
  -- We need to manually add `busted`
	c.workspace.checkThirdParty = 'Apply' -- 'Disable', 'ApplyInMemory', 'Ask', 'Apply'
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
	on_new_config = extend_rockspec_config,
	-- https://luals.github.io/wiki/settings/
	-- https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
				path = { '?.lua', '?/init.lua' },
			},
			workspace = {
				-- For neovim we manually configure the addons. Currently lua_ls still
				-- ships with addons. In fact, adding our own messes up the way it
				-- looks up the addons.
				checkThirdParty = 'Disable',
				-- userThirdParty = { '/usr/lib/lls-addons' },
				library = {
					'${3rd}/busted/library',
					'${3rd}/luassert/library',
					'${3rd}/mirai/library',
					'${3rd}/REFramework-LLS/library',
					-- '/usr/lib/lls-addons/busted/library',
					-- '/usr/lib/lls-addons/luassert/library',
					-- '/usr/lib/lls-addons/mirai/library',
					-- '/usr/lib/lls-addons/REFramework-LLS/library',
				},
			},
			completion = {
				keywordSnippet = 'Disable',
			},
		},
	},
})
