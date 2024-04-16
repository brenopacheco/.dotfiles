---@diagnostic disable: lowercase-global
package = 'rocks'
version = 'dev-1'
source = {
	url = 'git+https://github.com/brenopacheco/.dotfiles',
}
description = {
	homepage = 'https://github.com/brenopacheco/.dotfiles',
	license = 'MIT',
}
dependencies = {
	-- 'lua ~> 5.1',
	'inspect >= 3.1.3-0',
	'fzy >= 1.0.3-1',
}
build = {
	type = 'builtin',
	modules = {},
}
