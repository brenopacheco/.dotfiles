-- TODO: install deps programatically

package.path = package.path
	.. ';'
	.. vim.fn.stdpath('config')
	.. '/rocks/lua_modules/share/lua/5.1/?.lua'
package.path = package.path
	.. ';'
	.. vim.fn.stdpath('config')
	.. '/rocks/lua_modules/share/lua/5.1/?/init.lua'
package.cpath = package.cpath
	.. ';'
	.. vim.fn.stdpath('config')
	.. '/rocks/lua_modules/lib/lua/5.1/?.so'
