---@meta packadd
--- Packadd - custom minimal package manager

---@class Plug
---@field [1]  string
---@field as   string|nil
---@field tag  string|nil
---@example { 'Everblush/nvim', as = 'everblush', tag = "v1.2.3" }

---@class Package
---@field name   string
---@field alias   string
---@field dir    string
---@field config bool|nil

---@type table<string, Package>
local packages = {}

---@type table<string, boolean>
local modules = {}

---@param args string[]
---@param cwd  string|nil
local function git(args, cwd)
	local result = vim
		.system(vim.list_extend({ 'git' }, args), {
			text = true,
			cwd = cwd,
			env = vim.tbl_extend(
				'force',
				vim.fn.environ(),
				{ GIT_TERMINAL_PROMPT = 0 }
			),
		})
		:wait()
	if result.code ~= 0 then
		error('Git failed: ' .. vim.inspect(result), vim.log.levels.ERROR)
	end
end

---@param module string
local function load(module)
	local status, err = pcall(require, module)
	if not status then
		vim.notify(
			'Error loading module ' .. module .. ':\n' .. err,
			vim.log.levels.ERROR
		)
	end
	return status
end

---@param plugs Plug[]
local function packadd(plugs)
	for _, plug in ipairs(plugs) do
		local name = plug[1]
		local alias = plug.as or name:match('[^/]+/([^@]+)')
		local dir = vim.fn.stdpath('data') .. '/pack/site/opt/' .. alias
		---@type Package
		local pkg = { name = name, alias = alias, dir = dir }
		if vim.fn.isdirectory(dir) ~= 1 then
			local url = 'https://github.com/' .. plug[1] .. '.git'
			vim.notify('Installing ' .. url, vim.log.levels.INFO)
			git(
				vim.list_extend({
					'clone',
					'--depth=1',
					'--recurse-submodules',
					'--shallow-submodules',
					url,
					dir,
				}, plug.tag and { '--branch', plug.tag } or {}),
				nil
			)
		end
		vim.cmd('packadd ' .. alias)
		local config = 'config/' .. alias
		local path = vim.fn.stdpath('config') .. '/lua/' .. config .. '.lua'
		if vim.fn.filereadable(path) == 1 then pkg.config = load(config) end
		packages[name] = pkg
	end
	vim.cmd('helptags ALL')
end

---@param mods string[]
local function modload(mods)
	for _, mod in ipairs(mods) do
		modules[mod] = load('module/' .. mod) and true or nil
	end
end

---@param name string
local function enabled(name)
	if packages[name] then return true end
	for _, plugin in pairs(packages) do
		if plugin.alias == name then return true end
	end
	return false
end

local function list()
	vim.notify(vim.inspect({ modules = modules, packages = packages }))
end

local function update()
	for name, plugin in pairs(packages) do
		vim.notify('Updating ' .. name)
		git({ 'pull', '--recurse-submodules', '--update-shallow' }, plugin.dir)
	end
end

vim.g.loaded_2html_plugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
-- vim.g.loaded_remote_plugins = 1
-- vim.g.loaded_gzip = 1
-- vim.g.loaded_man = 1
-- vim.g.loaded_shada_plugin = 1
-- vim.g.loaded_tarPlugin = 1
-- vim.g.loaded_zipPlugin = 1

vim.opt.runtimepath = {
	vim.fn.stdpath('config'),
	vim.fn.stdpath('config') .. '/after',
	vim.env.VIMRUNTIME,
	'/usr/lib/nvim',
}
vim.opt.packpath = { vim.fn.stdpath('data') }

vim.z.enabled = enabled
vim.z.packadd = packadd
vim.z.modload = modload

vim.api.nvim_create_user_command('Packupdate', update, { nargs = 0 })
vim.api.nvim_create_user_command('Packlist', list, { nargs = 0 })
