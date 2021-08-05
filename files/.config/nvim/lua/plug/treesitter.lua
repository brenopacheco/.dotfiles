-- File: lua/treesitter.lua
-- Description: treesitter configuration file

local supported = {
    "bash",
    "c",
    "css",
    "html",
    "java",
    "javascript",
    "json",
    "lua",
    "python",
    "typescript"
}

require'nvim-treesitter.configs'.setup {
    ensure_installed      = supported,
    indent                = { enable = false },
    highlight             = { enable = true },
    incremental_selection = { enable = true },
    textobjects           = { enable = true },
}

vim.cmd([[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
]])
