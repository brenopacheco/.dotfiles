-- File: lua/treesitter.lua
-- Author: Breno Leonhardt Pacheco
-- Email: brenoleonhardt@gmail.com
-- Last Modified: February 23, 2021
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
    highlight             = { enable = true },
    incremental_selection = { enable = true },
    textobjects           = { enable = true },
}
