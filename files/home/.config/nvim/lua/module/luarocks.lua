local rocks = vim.fn.stdpath('config') .. '/rocks'
local modules = rocks .. '/lua_modules'

package.path = package.path .. ';' .. modules .. '/share/lua/5.1/?.lua'
package.path = package.path .. ';' .. modules .. '/share/lua/5.1/?/init.lua'
package.cpath = package.cpath .. ';' .. modules .. '/lib/lua/5.1/?.so'

if vim.fn.isdirectory(modules) == 0 then
	vim.notify('Installing luarocks packages')
	local cmd = {
		'luarocks',
		'install',
		'--tree',
		modules,
		'--only-deps',
		'./rocks-dev-1.rockspec',
	}
	local out = vim.system(cmd, { cwd = rocks, text = true }):wait()
	assert(out.code == 0, out.stderr)
end
