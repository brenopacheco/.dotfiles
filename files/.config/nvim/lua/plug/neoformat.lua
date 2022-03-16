vim.cmd([[
let g:neoformat_enabled_javascript = ['prettiereslint']
let g:neoformat_enabled_javascriptreact = ['prettiereslint']
let g:neoformat_enabled_typescript = ['prettiereslint']
let g:neoformat_enabled_typescriptreact = ['prettiereslint']
let g:neoformat_enabled_lua = ['luaformat']
let g:neoformat_enabled_python = ['yapf']
]])

local luaformat = [[
let g:neoformat_lua_neoformat = {
        'exe': 'lua-format',
        'args': [
          '--column-limit=78',
          '--indent-width=2',
          '--tab-width=2',
          '--no-use-tab',
          '--double-quote-to-single-quote'
        ]
      }
]]

local cmd = string.gsub(luaformat, '\n', '')

vim.cmd(cmd)
