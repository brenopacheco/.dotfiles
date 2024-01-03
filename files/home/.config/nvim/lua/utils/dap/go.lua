--[[ References:
https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
Reference: https://github.com/leoluz/nvim-dap-go/blob/main/lua/dap-go.lua#L132
]]

local M = {}

local fileutil = require('utils.file')
local rootutil = require('utils.root')
local treeutil = require('utils.treesitter')

local T = {}

---@class GoLaunchConfiguration : Configuration
---@field type 'delve'
---@field request 'launch'
---@field name string
---@field mode 'debug'|'test'
---@field args string[]|fun():string[]
---@field program string|fun():string
---@field buildFlags string[]|fun():string[]

---@class GoAttachConfiguration : Configuration
---@field type 'delve'
---@field request 'attach'
---@field name string
---@field mode 'local'
---@field processId number|fun():string

---@alias GoConfiguration GoLaunchConfiguration | GoAttachConfiguration

---@class PidResult
---@field pid number
---@field cmd string

---@return PidResult[]
local function get_pids()
	local cmd = [[
    ps a -o "pid:1,cmd" --no-header | sed 's/\ /;/' |
      jq --slurp --raw-input --raw-output \
      '[split("\n") | .[1:] | map(split(";")) | map({"pid": .[0], "cmd": .[1:] | join(";")}) | .[] | select( .pid != null )]'
  ]]
	local out = vim.fn.system(cmd)
	local data = vim.json.decode(tostring(out))
	---@type PidResult[]
	local result = {}
	for _, item in ipairs(data) do
		local pid = tonumber(item.pid, 10)
		if pid ~= nil then
			table.insert(result, {
				cmd = item.cmd,
				pid = pid,
			})
		end
	end
	return result
end

local function resolve_test_file()
	local path = tostring(vim.fn.expand('%:p'))
	if not string.match(path, '_test%.go$') then
		path = vim.fn.expand('%:p:r') .. '_test.go'
	end
	if fileutil.exists(path) then
		return path
	end
	return nil
end

---@param path string
---@return string[]
local function resolve_file_tests(path)
	local content = fileutil.read(path)
	assert(content ~= nil, 'file not found')
	local query = [[
    ((function_declaration 
       name: (identifier) @name)
     (#match? @name "^Test[A-Z].+$"))
  ]]
	local captures = treeutil.apply_query(content, 'go', query)
	local tests = vim.tbl_map(function(capture)
		return capture.value
	end, captures)
	return tests
end

local function resolve_nearest_test()
	---@type TSNode|nil
	local node = vim.treesitter.get_node()
	while node do
		local type = node:type()
		if type == 'function_declaration' then
			local name_field = node:field('name')[1]
			if name_field then
				local function_name = vim.treesitter.get_node_text(name_field, 0)
				local matches = string.match(function_name, '^Test[A-Z].+$')
				if matches then
					return function_name
				end
			end
		end
		node = node:parent()
	end
	return nil
end

T.launch_args = function()
	return coroutine.create(function(dap_run_co)
		local args = {}
		vim.ui.input({ prompt = 'Args: ' }, function(input)
			args = vim.split(input or '', ' ')
			coroutine.resume(dap_run_co, args)
		end)
	end)
end

T.attach_pid = function()
	return coroutine.create(function(dap_run_co)
		vim.ui.select(
			get_pids(),
			{
				prompt = 'Process pid:',
				---@param item PidResult
				format_item = function(item)
					local fmt = '  %-10s %s'
					return string.format(fmt, item.pid, item.cmd)
				end,
			},
			---@param choice PidResult|nil
			function(choice)
				choice = choice or {}
				coroutine.resume(dap_run_co, choice.pid)
			end
		)
	end)
end

T.go_root = function()
	local roots = rootutil.upward_roots({
		dir = tostring(vim.fn.getcwd()),
		patterns = { '^go%.mod$' },
	})
	assert(#roots > 0, 'go.mod not found')
	return roots[1].path
end

T.test_file_args = function()
	local path = resolve_test_file()
	assert(path, 'not a test file')
	local tests = resolve_file_tests(path)
	assert(#tests, 'no tests found')
	local patterns = table.concat(tests, '|')
	return { '-test.run', '^(' .. patterns .. ')$' }
end

T.test_pick_args = function()
	local tests = {}
	local path = resolve_test_file()
	if path then
		vim.print('path: ' .. path)
		vim.list_extend(tests, resolve_file_tests(path))
	end
	local matches = rootutil.downward_roots({
		dir = T.go_root(),
		patterns = { '_test%.go$' },
	})
	local files = vim.tbl_map(function(item)
		return item.path .. '/' .. item.file
	end, matches)
	for _, file in ipairs(files) do
		local file_tests = resolve_file_tests(file)
		for _, test in ipairs(file_tests) do
			if not vim.list_contains(tests, test) then
				table.insert(tests, test)
			end
		end
	end
	assert(#tests, 'no tests found')
	return coroutine.create(function(dap_run_co)
		local args = {}
		vim.ui.select(tests, { prompt = 'Test: ' }, function(test)
			args = { '-test.run', '^' .. test .. '$' }
			coroutine.resume(dap_run_co, args)
		end)
	end)
end

T.test_closest_args = function()
	local path = tostring(vim.fn.expand('%:p'))
	local matches = string.match(path, '_test%.go$')
	P({ path, matches })
	assert(matches, 'not a test file')
	local test = resolve_nearest_test()
	P({ test })
	assert(test, 'no test found')
	return { '-test.run', '^' .. test .. '$' }
end

---@type table<string, Adapter>
M.adapters = {
	delve = {
		type = 'server',
		port = '${port}',
		build_flags = '',
		executable = {
			command = 'dlv',
			args = { 'dap', '-l', '127.0.0.1:${port}' },
		},
	},
}

---@type table<string, GoConfiguration[]>
M.configurations = {
	go = {
		{
			name = '  Debug program',
			type = 'delve',
			request = 'launch',
			mode = 'debug',
			program = T.go_root,
			args = {},
			buildFlags = {},
		},

		{
			name = '  Debug program w/ args',
			type = 'delve',
			request = 'launch',
			mode = 'debug',
			program = T.go_root,
			args = T.launch_args,
			buildFlags = {},
		},

		{
			name = '  Debug attached to process',
			type = 'delve',
			request = 'attach',
			mode = 'local',
			processId = T.attach_pid,
		},

		{
			name = '  Debug all tests',
			type = 'delve',
			request = 'launch',
			mode = 'test',
			program = T.go_root,
			args = {},
			buildFlags = {},
		},

		{
			name = '  Debug file tests',
			type = 'delve',
			request = 'launch',
			mode = 'test',
			program = T.go_root,
			args = T.test_file_args,
			buildFlags = {},
		},

		{
			name = '  Debug closest test',
			type = 'delve',
			request = 'launch',
			mode = 'test',
			program = T.go_root,
			args = T.test_closest_args,
			buildFlags = {},
		},

		{
			name = '  Debug selected test',
			type = 'delve',
			request = 'launch',
			mode = 'test',
			program = T.go_root,
			args = T.test_pick_args,
			buildFlags = {},
		},
	},
}

return M
