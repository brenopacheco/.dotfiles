---@class fennel.Fennel : table
---@field repl fun(opts: fennel.ReplOpts):thread
---@field eval fun(str: string, opts?: { filename?: string }, ...:any):nil
---@field dofile fun(filename: string, ...:any):nil
---@field compileString fun(str: string, opts?: fennel.CompileOpts):string,fennel.CompileMetadata
---@field compile fun(ast: fennel.AST, opts?: fennel.CompileOpts):string,fennel.CompileMetadata
---@field parser fun(str: string):Iterator
local M = {}

---@class fennel.ReplOpts : table
---@field readChunk fun(str: string):nil
---@field pp fun(ast: fennel.AST):string
---@field onValues fun(out: string[]):nil
---@field onError fun(err_type: string, err: string[]):nil
---@field env table[]

---@class fennel.AST : table

---@alias fennel.Iterator fun():boolean,fennel.AST

---@class fennel.CompileMetadata : table
---@field key string
---@field short_src string
---@field [integer] { [1]: string, [2]: integer}

---@class fennel.InstallOpts
---@field allowedGlobals? string[]|false
---@field env? table<string, string>
---@field compilerEnv? table<string, string>
---@field requireAsInclude? boolean
---@field correlate? boolean
---@field useMetadata? boolean

---@class fennel.CompileOpts : fennel.InstallOpts
---@field filename? string
---@field indent? string 

---@class fennel.SetupOpts
---@field install? fennel.InstallOpts
---@field path string

---@type fennel.SetupOpts
local defaults = {
	install = {
		allowedGlobals = false,
		compilerEnv = _G,
		env = _G,
		requireAsInclude = false,
		correlate = false,
		useMetadata = true,
	},
	path = table.concat({
		vim.fn.stdpath('config') .. '/fnl/?.fnl',
		vim.fn.stdpath('config') .. '/fnl/?/init.fnl',
		vim.fn.stdpath('config') .. '/lua/?.fnl',
		vim.fn.stdpath('config') .. '/lua/?/init.fnl',
		vim.fn.stdpath('config') .. '/lua/?.lua',
		vim.fn.stdpath('config') .. '/lua/?/init.lua',
	}, ';'),
}

---@param opts? fennel.SetupOpts
M.setup = function(opts)
	---@type fennel.SetupOpts
	opts = vim.tbl_extend('force', defaults, opts or {})
  local bin = vim.fn.glob('/usr/share/lua/*/fennel.lua')
  assert(vim.fn.filereadable(bin) == 1, 'fennel not found')
	local fennel = dofile(bin).install(opts.install)
	fennel.path = opts.path
	table.insert(package.loaders, fennel.searcher)
	debug.traceback = fennel.traceback
	setmetatable(M, { __index = fennel })
  _G.fennel = fennel
	return M
end

return M
