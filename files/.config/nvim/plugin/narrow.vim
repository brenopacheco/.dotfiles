if exists('g:loaded_narrow_plugin')
    finish
endif
let g:loaded_narrow_plugin = 1

" TODO: Doesn't work yet
command! -range Narrow <line1>,<line2>call narrow#narrow_region(bufnr())
command! -range Widen <line1>,<line2>call narrow#widen(bufnr())
