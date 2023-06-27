if exists('g:loaded_highlight_plugin')
    finish
endif
let g:loaded_highlight_plugin = 1

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=500}
augroup END
