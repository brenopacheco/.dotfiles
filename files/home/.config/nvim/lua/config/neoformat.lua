vim.cmd([[
let g:neoformat_enabled_javascript      = ['prettierd']
let g:neoformat_enabled_javascriptreact = ['prettierd']
let g:neoformat_enabled_typescript      = ['prettierd']
let g:neoformat_enabled_typescriptreact = ['prettierd']
let g:neoformat_enabled_c               = ['clangformat']
let g:neoformat_enabled_lua             = ['stylua']
let g:neoformat_enabled_perl            = ['perltidy']
let g:neoformat_enabled_shell           = ['shfmt']
let g:neoformat_enabled_go              = ['gofmt']

let g:neoformat_run_all_formatters = 1
let g:neoformat_verbose = 0
]])

-- TODO:
-- https://github.com/sbdchd/neoformat/issues/442
-- function! NeoformatExpr() abort " {{{
--     " if v:char != ''
--     "     return
--     " endif
--     let line1 = v:lnum
--     let line2 = v:lnum + v:count - 1
--     execute ':' . line1 . ',' . line2 . 'Neoformat'
-- endfunction "}}}
