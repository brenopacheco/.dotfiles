vim.cmd([[
let g:neoformat_enabled_javascript      = ['prettierd', 'eslint_d' ] ", 'biome']
let g:neoformat_enabled_javascriptreact = ['prettierd', 'eslint_d' ] ", 'biome']
let g:neoformat_enabled_typescript      = ['prettierd', 'eslint_d' ] ", 'biome']
let g:neoformat_enabled_typescriptreact = ['prettierd', 'eslint_d' ] ", 'biome']
let g:neoformat_enabled_json            = ['prettierd', 'eslint_d' ] ", 'biome']

let g:neoformat_enabled_c               = ['clangformat']
let g:neoformat_enabled_lua             = ['stylua']
let g:neoformat_enabled_perl            = ['perltidy']
let g:neoformat_enabled_shell           = ['shfmt']
let g:neoformat_enabled_go              = ['gofmt']

let g:neoformat_run_all_formatters = 1
let g:neoformat_verbose = 0
]])
