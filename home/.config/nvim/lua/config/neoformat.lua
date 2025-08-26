vim.cmd([[
let g:neoformat_enabled_javascript      = ['biome']
let g:neoformat_enabled_javascriptreact = ['biome']
let g:neoformat_enabled_typescript      = ['biome']
let g:neoformat_enabled_typescriptreact = ['biome']
let g:neoformat_enabled_json            = ['biome']

let g:neoformat_enabled_c               = ['clangformat']
let g:neoformat_enabled_lua             = ['stylua']
let g:neoformat_enabled_perl            = ['perltidy']
let g:neoformat_enabled_shell           = ['shfmt']
let g:neoformat_enabled_go              = ['gofmt']

let g:neoformat_run_all_formatters = 1
let g:neoformat_verbose = 0


let g:biome_formatter = {
        \ 'exe': 'biome',
        \ 'try_node_exe': 1,
        \ 'args': ['check', '--stdin-file-path="%:p"', '--fix', '--unsafe'],
        \ 'no_append': 1,
        \ 'stdin': 1,
        \ }

let g:neoformat_javascript_biome = g:biome_formatter
let g:neoformat_javascriptreact_biome = g:biome_formatter
let g:neoformat_typescript_biome = g:biome_formatter
let g:neoformat_typescriptreact_biome = g:biome_formatter
let g:neoformat_json_biome = g:biome_formatter
]])

-- 'prettierd', 'eslint_d',
-- 'prettierd', 'eslint_d',
-- 'prettierd', 'eslint_d',
-- 'prettierd', 'eslint_d',
-- 'prettierd', 'eslint_d',
