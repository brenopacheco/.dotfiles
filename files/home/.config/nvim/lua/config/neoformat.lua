vim.cmd([[
let g:neoformat_enabled_c = ['clangformat']
let g:neoformat_enabled_javascript = ['prettierd']
let g:neoformat_enabled_javascriptreact = ['prettierd']
let g:neoformat_enabled_lua = ['stylua']
let g:neoformat_enabled_python = ['yapf']
let g:neoformat_enabled_rust = ['rustfmt']
let g:neoformat_enabled_shell = ['shfmt']
let g:neoformat_enabled_sql = ['sqlformat']
let g:neoformat_enabled_typescript = ['prettierd']
let g:neoformat_enabled_typescriptreact = ['prettierd']
let g:neoformat_enabled_go = ['goimports', 'gofumptextra', 'golines']
let g:neoformat_enabled_ocaml = ['ocpindent', 'ocamlformatcustom']
]])

vim.cmd([[
let g:neoformat_python_gofumptextra = {
        \ 'exe': 'gofumpt',
        \ 'args': ['-wextra'],
        \ 'stdin': 1,
        \ }
let g:neoformat_go_golines = {
        \ 'exe': 'golines',
        \ 'stdin': 1,
        \ }
let g:neoformat_ocaml_ocamlformatcustom = {
        \ 'exe': 'ocamlformat',
        \ 'no_append': 1,
        \ 'stdin': 1,
        \ 'args': ['--break-cases=fit-or-vertical', '--enable-outside-detected-project', '--name', '"%:p"', '-']
        \ }
]])

vim.cmd([[
let g:neoformat_run_all_formatters = 1
]])

vim.cmd([[let g:neoformat_verbose = 0]])
