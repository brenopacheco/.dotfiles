vim.cmd([[
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_javascriptreact = ['prettier']
let g:neoformat_enabled_typescript = ['prettier']
let g:neoformat_enabled_typescriptreact = ['prettier']
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

local csclangformat = [[
let g:neoformat_cs_clangformat = {
        'exe': 'clang-format',
        'args': [
          '-assume-filename=lorem.cs',
          '-style="{BasedOnStyle: Microsoft}"'
        ],
        'stdin': 1
      }
]]

local lua = string.gsub(luaformat, '\n', '')
local clang = string.gsub(clangformat, '\n', '')
local csclang = string.gsub(csclangformat, '\n', '')

vim.cmd(lua)
vim.cmd(clang)
vim.cmd(csclang)
vim.cmd([[let g:neoformat_enabled_cs = ['clangformat'] ]])


-- vim.cmd([[let g:neoformat_verbose = 1]])
