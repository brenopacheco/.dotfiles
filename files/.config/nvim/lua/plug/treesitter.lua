-- File: lua/treesitter.lua
-- Description: treesitter configuration file

local supported = {
  "bash",
  "c",
  "c_sharp",
  "cmake",
  "commonlisp",
  "cpp",
  "css",
  "dockerfile",
  "fennel",
  "go",
  "graphql",
  "html",
  "java",
  "javascript",
  "jsdoc",
  "json",
  "latex",
  "lua",
  "php",
  "python",
  "ql",
  "query",
  "regex",
  "ruby",
  "scss",
  "tsx",
  "typescript",
  "yaml"
}

require'nvim-treesitter.configs'.setup {
    ensure_installed      = supported,
    indent                = { enable = true },
    highlight             = { enable = true },
    incremental_selection = { enable = false },
    textobjects           = { enable = true }
}

vim.cmd([[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
]])
