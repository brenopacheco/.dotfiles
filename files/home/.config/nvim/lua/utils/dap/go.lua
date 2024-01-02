local rootutil = require('utils.root')

local M = {}

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

local function get_arguments()
	return coroutine.create(function(dap_run_co)
		local args = {}
		vim.ui.input({ prompt = 'Args: ' }, function(input)
			args = vim.split(input or '', ' ')
			coroutine.resume(dap_run_co, args)
		end)
	end)
end

local function get_pid()
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

local function go_root()
	local roots = rootutil.upward_roots({
		dir = tostring(vim.fn.getcwd()),
		patterns = { '^go%.mod$' },
	})
	assert(#roots > 0, 'go.mod not found')
	return roots[1].path
end

local function go_test_file()
	local path = vim.fn.expand('%:p')
	assert(type(path) == 'string' and path ~= '', 'Buffer is not a valid file')
	assert(vim.bo.filetype == 'go', 'File is not a go file')
	if string.match(path, '_test.go$') then
		return path
	end
	local files = rootutil.downward_roots({
		dir = go_root(),
		patterns = {
			'^' .. vim.fn.expand('%:r') .. '_test.go$',
		},
	})
	assert(#files > 0, 'No test file')
	return files[1].path .. '/' .. files[1].file
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
		--- NOTE: OK
		{
			name = '  Debug program       (launch)',
			type = 'delve',
			request = 'launch',
			mode = 'debug',
			program = go_root,
			args = {},
      buildFlags = {}
		},

		--- NOTE: OK
		{
			name = '  Debug program+args  (launch)',
			type = 'delve',
			request = 'launch',
			mode = 'debug',
			program = go_root,
			args = get_arguments,
      buildFlags = {}
		},

		--- TODO: check this with http-server
		{
			name = '  Debug process       (attach)',
			type = 'delve',
			request = 'attach',
			mode = 'local',
			processId = get_pid,
		},

		--- NOTE: OK
		{
			name = '  Debug test          (go.mod)',
			type = 'delve',
			request = 'launch',
			mode = 'test',
			program = go_root,
			args = {},
      buildFlags = {}
		},

		--- TODO: not working for some reason? missing build flag?
		{
			name = '  Debug test            (file)',
			type = 'delve',
			request = 'launch',
			mode = 'test',
			program = '${file}',
			-- program = go_test_file,
			args = {},
      buildFlags = {}
		},

		--- TODO: needs a function for args that pulls the current closes test
		{
			name = '  Debug test         (closest)',
			type = 'delve',
			request = 'launch',
			mode = 'test',
			program = '${file}',
			-- args = { "-test.run", "^" .. testname .. "$" },
			args = {},
      buildFlags = {}
		},
	},
}

return M

-- NOTES: ====================================================================

--[[

What do I want to debug?

- Package/program  - debugs the main function
- Test package     - debugs the whole test package
- Test file        - debugs the current test file or pick one
- Test function    - debugs the current test function or pick one

To debug tests, we allways want to launch the process (i.e: run `go test`)
To debug the package, we can either launch the process or attach to a
running process. Do we want to allow attaching to a running process? Yes

Use cases:
1. Debug package (launch)
2. Debug package (attach)
3. Debug test package (launch)
4. Debug test file (launch)
5. Debug test function (launch)

How can I perform these use cases using dlv?

It seems we configure the delve adapter as a server, adding instructions on
how to spawn it. nvim-dap will launch the server and for each session and
connect to it via socket.

https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md

**The dap plugin does not `launch` the application. It simply sends either
a `launch` or `attach` request to the debugger. The debugger then launches
or attaches to the application.**

For debugging the program/package, We have 3 options:
1. Launch the program ourselves and ask delve to attach (like 'dlv attach')
   This won't work well for programs that exit before the debugger can attach
2. Ask delve to launch the program (like 'dlv debug')
   This is probably the easiest option, as delve is responsible for building
3. Build the binaries and ask delve to launch the binary (like 'dlv exec')
   This is the most versatile option, as we can build the binary ourselves
   in any way (Makefile, go build, etc) with the flags we want

What about tests? We need to ask delve to build and run test (like dlv test)

In conclusion, we need to:

-. Launch delve in headless DAP mode
1. Debug package (launch)
   - request: `launch`
   - mode: `debug`
   - program: go_mod_dir()
   - args: get_arguments()
2. Debug package (attach)
   - request: `attach`
   - mode: `local`
   - processId = ...,
3. Test package (launch)
   - request: `launch`
   - mode: `test`
   - program: go_mod_dir(),
4. Test file
   - request: `launch`
   - mode: `test`
   - program: "${file}",

Reference: https://github.com/leoluz/nvim-dap-go/blob/main/lua/dap-go.lua#L132

TODO: 
- [x] write missing functions
- [ ] check all configurations work
- [ ] tidy up configuration

--]]
