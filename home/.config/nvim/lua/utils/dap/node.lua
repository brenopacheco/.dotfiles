local fileutil = require('utils.file')
local rootutil = require('utils.root')

---@alias bool boolean

local M = {}

M.adapters = {
	['pwa-node'] = {
		type = 'server',
		host = 'localhost',
		port = '${port}',
		executable = {
			command = 'node',
			args = { '/usr/lib/vscode-js-debug/src/dapDebugServer.js', '${port}' },
		},
	},
}

local function package_root()
	local roots = rootutil.upward_roots({
		dir = vim.fn.getcwd() or '.',
		patterns = { 'package.json' },
	})
	local root = roots[1]
	assert(root, 'No package.json found')
	return root
end

local function get_package_json()
	local root = package_root()
	local filepath = root.path .. '/' .. root.file
	local data = fileutil.read(filepath)
	assert(data, 'Failed to read package.json')
	local status, decoded = pcall(vim.json.decode, table.concat(data, '\n'))
	assert(status, 'Failed to decode package.json')
	---@type table<string, any>
	return decoded
end

local function get_scripts()
	local json = get_package_json()
	---@type table<string, string>|nil
	local scripts = json.scripts
	assert(scripts, 'No scripts field found in package.json')
	local targets = vim
		.iter(scripts)
		:map(function(k, v) return { name = k, cmd = v } end)
		:totable()
	assert(#targets > 0, 'No scripts found in package.json')
	return targets
end

local is_module = function()
	local json = get_package_json()
	return json.type == 'module'
end

local function get_pids()
	local cmd = [[
    ps a -o "pid:1,cmd" --no-header | sed 's/\ /;/' |
      jq --slurp --raw-input --raw-output \
      '[split("\n") | .[1:] | map(split(";")) | map({"pid": .[0], "cmd": .[1:] | join(";")}) | .[] | select( .pid != null )]'
  ]]
	local out = vim.fn.system(cmd)
	local data = vim.json.decode(tostring(out))
	---@type PidResult[]
	return vim
		.iter(data)
		:filter(function(item) return item.pid ~= nil and item.cmd ~= nil end)
		:filter(
			function(item) return item.cmd:match('/bin/node .* --inspect') ~= nil end
		)
		:map(
			function(item)
				return {
					cmd = item.cmd:gsub('^%S+/([%w%-%_]+)', '%1'),
					pid = tonumber(item.pid),
				}
			end
		)
		:totable()
end

local T = {}

T.root = function() return package_root().path end

function T.pick_script()
	return coroutine.create(function(dap_run_co)
		vim.ui.select(get_scripts(), {
			prompt = 'Script:',
			format_item = function(item)
				local fmt = '  %-10s %s'
				return string.format(fmt, item.name, item.cmd)
			end,
		}, function(choice)
			assert(choice, 'No script selected')
			coroutine.resume(dap_run_co, { 'run-script', choice.name })
		end)
	end)
end

function T.pick_process()
	local pids = get_pids()
	assert(#pids > 0, 'No node processes found')
	if #pids == 1 then return pids[1].pid end
	return coroutine.create(function(dap_run_co)
		vim.ui.select(pids, {
			prompt = 'Process:',
			format_item = function(item)
				local fmt = '  %-10s %s'
				return string.format(fmt, item.pid, item.cmd)
			end,
		}, function(choice)
			assert(choice, 'No process selected')
			coroutine.resume(dap_run_co, choice.pid)
		end)
	end)
end

---@param opts { file: boolean }
function T.jest_runtime_args_fn(opts)
	return function()
		local args = {
			'--inspect-brk',
			T.root() .. '/node_modules/.bin/jest',
			'--runInBand',
		}
		if opts.file then
			local file = vim.fn.expand('%:p')
			table.insert(args, '--testMatch="**/' .. file .. '"')
			table.insert(args, file)
		end
		return args
	end
end

M.configurations = {
	javascript = {
		{
      -- Note: launch with `node --inspect-brk {file}`
			name = '  attach {process}',
			type = 'pwa-node',
			request = 'attach',
			processId = T.pick_process,
			cwd = T.root,
			skipFiles = { '<node_internals>/**', 'node_modules/**' },
		},
		{
			name = '  node {file}',
			type = 'pwa-node',
			request = 'launch',
			program = '${file}',
			cwd = T.root,
			skipFiles = { '<node_internals>/**', 'node_modules/**' },
		},
		{
			name = '  npm {script}',
			type = 'pwa-node',
			request = 'launch',
			runtimeExecutable = 'npm',
			runtimeArgs = T.pick_script,
			cwd = T.root,
			skipFiles = { '<node_internals>/**', 'node_modules/**' },
		},
		{
			name = '  jest {file}',
			type = 'pwa-node',
			request = 'launch',
			runtimeArgs = T.jest_runtime_args_fn({ file = true }),
			cwd = T.root,
			skipFiles = { '<node_internals>/**', 'node_modules/**' },
		},
		{
			name = '  jest **/*.js',
			type = 'pwa-node',
			request = 'launch',
			runtimeArgs = T.jest_runtime_args_fn({ file = false }),
			cwd = T.root,
			skipFiles = { '<node_internals>/**', 'node_modules/**' },
		},
	},
	typescript = {
		{
      -- Note: launch with `node --import tsx --inspect-brk {file}`
			name = '  attach {process}',
			type = 'pwa-node',
			request = 'attach',
			processId = T.pick_process,
			cwd = T.root,
			skipFiles = { '<node_internals>/**', 'node_modules/**' },
		},
		{
			name = '  launch {file}',
			type = 'pwa-node',
			request = 'launch',
			runtimeArgs = { '--import', 'tsx' },
			runtimeExecutable = 'node',
			args = { vim.fn.expand('%:p') },
			cwd = T.root,
			skipFiles = { '<node_internals>/**', 'node_modules/**' },
		},
		{
			name = '  npm {script}',
			type = 'pwa-node',
			request = 'launch',
			runtimeExecutable = 'npm',
			runtimeArgs = T.pick_script,
			cwd = T.root,
			skipFiles = { '<node_internals>/**', 'node_modules/**' },
		},
		{
			name = '  jest {file}',
			type = 'pwa-node',
			request = 'launch',
			runtimeArgs = T.jest_runtime_args_fn({ file = true }),
			cwd = T.root,
			skipFiles = { '<node_internals>/**', 'node_modules/**' },
		},
		{
			name = '  jest **/*.js',
			type = 'pwa-node',
			request = 'launch',
			runtimeArgs = T.jest_runtime_args_fn({ file = false }),
			cwd = T.root,
			skipFiles = { '<node_internals>/**', 'node_modules/**' },
		},
	},
}

return M
