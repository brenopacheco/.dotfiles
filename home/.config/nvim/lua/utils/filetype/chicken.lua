local M = {}

local _system = function(cmd)
	local obj = vim.system(cmd, { text = true }):wait()
	if obj.code == 0 then return vim.split(vim.trim(obj.stdout), '\n') end
	log(obj)
	return nil
end

--- TODO: instead of creating a single doc, let's add all entries to the
---quickfix or loclist and create separate unlisted buffers for each doc
---chicken-doc:///beaker#chicken-status   use # as separator

local get_docs = function(pattern)
	local docs = {}
	for _, line in ipairs(assert(_system({ 'chicken-doc', '-m', pattern }))) do
		local node = vim.split(line:match('^%([%w%s%-%/%_%*]+%)'):sub(2, -2), ' ')
		for _, _line in ipairs(assert(_system({ 'chicken-doc', unpack(node) }))) do
			table.insert(docs, _line)
		end
	end
	vim.print(table.concat(docs, '\n'))
end

-- get_docs('alist-ref')

-- M.setup = function()
-- 	vim.api.nvim_create_user_command('ChickenDoc', M.chickendoc, { nargs = 1 })
-- end
