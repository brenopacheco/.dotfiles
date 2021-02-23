
" "  File: filetype.vim
" "  Author: Breno Leonhardt Pacheco
" "  Email: brenoleonhardt@gmail.com
" "  Last Modified: February 22, 2021
" "  Description: recognize custom filetypes

" if exists("did_load_custom_filetypes")
"     finish
" endif
" let did_load_custom_filetypes = 1

" augroup filetypedetect_custom
" augroup END
au BufRead,BufNewFile *.org setfiletype org
