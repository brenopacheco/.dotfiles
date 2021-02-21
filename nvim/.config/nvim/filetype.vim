if exists("did_load_custom_filetypes")
    finish
endif
let did_load_custom_filetypes = 1

augroup filetypedetect_custom
    au BufRead,BufNewFile *.org setfiletype org
    au TermOpen * setfiletype term
augroup END
