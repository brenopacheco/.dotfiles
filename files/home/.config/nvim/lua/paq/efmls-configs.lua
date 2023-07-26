local efmls = require("efmls-configs")
local gcc = require("efmls-configs.linters.gcc")
local golangci = require("efmls-configs.linters.golangci_lint")

efmls.init({
	default_config = false,
})

efmls.setup({
	c = { linter = gcc },
	go = { linter = golangci },
})
