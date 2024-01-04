---@meta packadd
--- Packadd - custom minimal package manager
--
-- Configures &runtimepath and &packpath
-- Disables unwanted plugins
-- Provides the Packadd [!] command
-- Provides vim.ensure(tbl) lua function
--   * installs packages as opt and enables them
--   * loads lua/config/<pkg-name>.lua configuration
--
--  TODO: the following options to the package (see `lazy`)
--        - `deps`: calls `ensure` on the list of dependencies
--        - `opts`: configuration table passed to setup()
--        - `init`: makes sure that the packages are loaded
-- This changes the way that the packages are loaded:
-- 1. instead of reading configuration from lua/config/<pkg-name>.lua,
--    we call packadd passing the options
-- 2. we can use different configs that bundle multiple packages. i.e:
--    git, lsp, complete, dap, treesitter, tools, ui, test, misc

local plugin_dir = vim.fn.stdpath('config') -- alternatively, use ('data')

local packages = {}
local modules = {}

local function register(repo)
	local name = string.gsub(repo, '^.*/', '')
	local dir = plugin_dir .. '/pack/site/opt/' .. name
	packages[name] = {
		config = nil,
		repo = repo,
		name = name,
		dir = dir,
		installed = vim.fn.isdirectory(dir) ~= 0,
		url = 'https://github.com/' .. repo .. '.git',
		loaded = vim.tbl_contains(vim.opt.packpath:get(), dir),
	}
	return packages[name]
end

local function install(pkg)
	local cmd = pkg.installed
			and {
				'git',
				'pull',
				'--recurse-submodules',
				'--update-shallow',
			}
		or {
			'git',
			'clone',
			'--depth=1',
			'--recurse-submodules',
			'--shallow-submodules',
			pkg.url,
			pkg.dir,
		}
	local result = vim
		---@diagnostic disable-next-line: missing-fields
		.system(cmd, {
			text = true,
			cwd = pkg.installed and pkg.dir or nil,
			env = vim.tbl_extend(
				'force',
				vim.fn.environ(),
				{ GIT_TERMINAL_PROMPT = 0 }
			),
		})
		:wait()
	if result.code ~= 0 then
		error(
			'Packadd: failed ensuring ' .. pkg.repo .. ' - ' .. vim.inspect(result),
			vim.log.levels.ERROR
		)
	end
	pkg.installed = true
	vim.notify('Packadd: installed ' .. pkg.repo, vim.log.levels.INFO)
end

---@param repos string[]
local function packadd(repos)
	for _, repo in ipairs(repos) do
		local pkg = register(repo)
		if not pkg.installed then
			install(pkg)
		end
		if not pkg.loaded then
			pkg.loaded = true
			vim.cmd('packadd ' .. pkg.name)
			local config = 'config/' .. pkg.name
			config = string.gsub(config, '%.nvim$', '')
			config = string.gsub(config, '%.vim$', '')
			config = string.gsub(config, '%.lua$', '')
			local status, err = pcall(require, config)
			if status then
				pkg.config = config
			else
				pkg.config = false
				local pattern = [[module ']] .. config .. [[' not found:]]
				if string.sub(err, 1, string.len(pattern)) ~= pattern then
					vim.notify(
						'Error loading config ' .. config .. ':\n' .. err,
						vim.log.levels.ERROR
					)
				end
			end
		end
	end
	vim.cmd('helptags ALL')
end

local function packcmd(cmd)
	if cmd.bang then
		vim.tbl_map(install, packages)
	end
	vim.print({ packages = packages, modules = { modules } })
end

local function enabled(repo)
	local name = string.gsub(repo, '^.*/', '')
	local pkg = packages[name]
	if pkg ~= nil then
		return pkg.installed and pkg.loaded
	end
	local mod = modules[name]
	return mod ~= nil and mod.loaded
end

local function modload(mods)
	for _, mod in ipairs(mods) do
		local status, _ = pcall(require, 'module/' .. mod)
		if status then
			modules[mod] = {
				name = mod,
				loaded = true,
			}
		else
			vim.notify('Packadd: failed loading module ' .. mod, vim.log.levels.ERROR)
		end
	end
end

for _, plugin in pairs({
	'tohtml',
	'tutor',
	'matchit',
	'matchparen',
	'netrwPlugin',
	'rplugin',
	'spellfile',
}) do
	vim.g['loaded_' .. plugin] = 1
end

vim.opt.runtimepath = {
	vim.fn.stdpath('config'),
	vim.fn.stdpath('config') .. '/after',
	vim.env.VIMRUNTIME,
	'/usr/lib/nvim',
}
vim.opt.packpath = { plugin_dir }
vim.api.nvim_create_user_command('Packadd', packcmd, { bang = true })

vim.z.enabled = enabled
vim.z.packadd = packadd
vim.z.modload = modload
