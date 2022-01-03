if exists('g:loaded_misc_plugin')
    finish
endif
let g:loaded_misc_plugin = 1

" :Bclear[!]
" wipe all deleted/unloaded buffers
command! -bar -bang Bclear call utils#bclear(<bang>0)
