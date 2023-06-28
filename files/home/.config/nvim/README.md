# Standard plugins

## GIT (ok)

- n _gg fugitive
- n _gr reset hunk
- n _gs stage hunk
- n _gp preview hunk
- n _gc checkout
- n _gb blame
- n _gd diff
- n _gy yank link
- n _gl log (gv)

- n _gh history 
  0,$Gclog! | open vsplit, change back, run: 

        local list = vim.fn.getqflist()
        table.insert(list, 1, {
            bufnr = vim.fn.bufnr(),
            col = vim.fn.getcurpos()[3],
            lnum = vim.fn.getcurpos()[2],
            filename = vim.fn.expand('%'),
            text = "HEAD",
        })
        vim.fn.setqflist(list)

## Quickfox

- write custom plugin
    * hijack loclist and put data into qf (autocmd)
    * define qnext, qprevious, qpop, qpush, qf, qv, etc... functions
    * extend gO


## Text objects

- z folds
- c comments

## Mappings


## Config

## Status line

    redo it


## LSP

> nvim-treesitter/nvim-treesitter-context
>   show code context on top

## Utilities

> kylechui/nvim-surround                # surround commands
> lewis6991/gitsigns.nvim               # gutter git info + hunk commands
> ruifm/gitlinker.nvim                  # yarn git remote url for region
> junegunn/gv.vim                       # interactive git log
> editorconfig/editorconfig-vim         # loads editorconfig settings
> numToStr/Comment.nvim                 # comment/uncomment
> gelguy/wilder.nvim                    # extend wild menu
> petertriho/nvim-scrollbar             # show right side scrollbar
> declancm/cinnamon.nvim                # smooth scroll
> lukas-reineke/indent-blankline.nvim   # show indent lines on the left
> folke/which-key.nvim                  # keymap helper and definitions
