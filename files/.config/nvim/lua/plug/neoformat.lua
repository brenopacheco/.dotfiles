vim.cmd([[
let g:neoformat_enabled_javascript = ['prettiereslint']
let g:neoformat_enabled_javascriptreact = ['prettiereslint']
let g:neoformat_enabled_typescript = ['prettiereslint']
let g:neoformat_enabled_typescriptreact = ['prettiereslint']
let g:neoformat_enabled_lua = ['luaformat']
let g:neoformat_enabled_python = ['yapf']
let g:neoformat_enabled_c = ['clangformat']
]])

local luaformat = [[
let g:neoformat_lua_luaformat = {
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

local clangformat = [[
let g:neoformat_c_clangformat = {
        'exe': 'clang-format',
        'args': [
          '-style="{BasedOnStyle: Mozilla}"',
        ],
        'stdin': 1
      }
]]

local lua = string.gsub(luaformat, '\n', '')
local clang = string.gsub(clangformat, '\n', '')

vim.cmd(lua)
vim.cmd(clang)
-- vim.cmd([[let g:neoformat_verbose = 1]])
