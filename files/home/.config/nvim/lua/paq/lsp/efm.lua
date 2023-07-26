local gcc = require("efmls-configs.linters.gcc")
local golangci = require("efmls-configs.linters.golangci")

local M = {
	init_options = { documentFormatting = false },
	settings = {
		rootMarkers = { ".git/" },
	},
}

local efmls = require("efmls-configs")
efmls.init({
	default_config = false,
})
efmls.setup({
	c = { linter = gcc },
	go = { linter = golangci },
})

return M
