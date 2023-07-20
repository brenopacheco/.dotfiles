local M = {
	init_options = { documentFormatting = false },
	settings = {
		rootMarkers = { ".git/" },
		languages = {
			-- lua = {
			-- 	{ formatCommand = "lua-format -i", formatStdin = true },
			-- },
		},
	},
}

--[[ 
go
  golangci-lint 
    - https://golangci-lint.run/usage/linters/
    - enable all
    disable:
      staticcheck
  staticcheck (needs to be run separately)


  
}
]]
return M
