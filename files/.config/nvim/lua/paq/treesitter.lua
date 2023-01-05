-- File: lua/treesitter.lua
-- Description: treesitter configuration file

local supported = {
  "bash",
  "c",
  "cmake",
  "commonlisp",
  "cpp",
  "c_sharp",
  "css",
  "dockerfile",
  "fennel",
  "go",
  "graphql",
  "html",
  "http",
  "java",
  "javascript",
  "jsdoc",
  "json",
  "latex",
  "lua",
  "markdown",
  "org",
  "php",
  "python",
  "ql",
  "query",
  "regex",
  "ruby",
  "scss",
  "tsx",
  "typescript",
  "vim",
  "yaml",
  "elixir"
}

require'nvim-treesitter.configs'.setup {
    ensure_installed      = supported,
    indent                = { enable = true },
    highlight             = { enable = true, additional_vim_regex_highlighting = {'org'}, disable = {'org'} },
    incremental_selection = { enable = false },
    textobjects = {
       select = {
         enable = true,
         lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
         keymaps = {
           ['af'] = '@function.outer',
           ['if'] = '@function.inner',
           ['ac'] = '@class.outer',
           ['ic'] = '@class.inner',
         }
       }
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?'
        }
    }
}
