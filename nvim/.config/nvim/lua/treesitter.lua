-- File: lua/treesitter.lua
-- Author: Breno Leonhardt Pacheco
-- Email: brenoleonhardt@gmail.com
-- Last Modified: February 23, 2021
-- Description: treesitter configuration file

local supported = {
    "bash", "c", "css", "html",
    "java", "javascript", "json",
    "lua", "typescript"
}

require'nvim-treesitter.configs'.setup {
    ensure_installed = supported,
    highlight = {
        enable = true
    }
}
