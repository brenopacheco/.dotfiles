---@meta packadd
--- Packadd - custom minimal package manager

local plugin_dir = vim.fn.stdpath('data')

local packages = {}
local modules = {}

local function register(repo)
	local user, name, branch = repo:match('([^/]+)/([^@]+)@?(.*)')
	local dir = plugin_dir .. '/pack/site/opt/' .. name
	packages[name] = {
		config = nil,
		repo = user .. '/' .. name,
		name = name,
		dir = dir,
		branch = branch,
		installed = vim.fn.isdirectory(dir) ~= 0,
		url = 'https://github.com/' .. user .. '/' .. name .. '.git',
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
	if pkg.branch then
		table.insert(cmd, '--branch')
		table.insert(cmd, pkg.branch)
	end
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

local function update()
	for name, pkg in pairs(packages) do
		vim.notify('Packadd: updating ' .. name)
		install(pkg)
	end
end

---@param repos string[]
local function packadd(repos)
	for _, repo in ipairs(repos) do
		local pkg = register(repo)
		if not pkg.installed then install(pkg) end
		if not pkg.loaded then
			pkg.loaded = true
			vim.cmd('packadd ' .. pkg.name)
			local config = 'config/' .. pkg.name
			config = string.gsub(config, '%.nvim$', '')
			config = string.gsub(config, '%.vim$', '')
			config = string.gsub(config, '%.lua$', '')
			config = string.gsub(config, '%.cmp$', '')
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

local function packinstall(cmd) packadd(vim.split(cmd.args, '\n')) end

local function packlist(cmd)
	if cmd.args:len() > 0 then
		for _, package in pairs(packages) do
			if string.match(package.name, cmd.args) then
				vim.print(package)
				return
			end
		end
		vim.notify('Package not found', vim.log.levels.WARN)
	else
		vim.print({ packages = packages, modules = { modules } })
	end
end

local function enabled(repo)
	local name = string.gsub(repo, '^.*/', '')
	local pkg = packages[name]
	if pkg ~= nil then return pkg.installed and pkg.loaded end
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
vim.api.nvim_create_user_command('Packinstall', packinstall, { nargs = '?' })
vim.api.nvim_create_user_command('Packlist', packlist, { nargs = '?' })
vim.api.nvim_create_user_command('Packupdate', update, { nargs = 0 })

vim.z.enabled = enabled
vim.z.packadd = packadd
vim.z.modload = modload
