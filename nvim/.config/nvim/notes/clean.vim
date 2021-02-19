nvim -u NONE -u clean.vim
" silent !curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o plug.vim
" silent source plug.vim
" silent !mkdir plug
call plug#begin($PWD . '/plug')
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
call plug#end()
" silent PlugInstall

fun! Q(timer)
	wincmd p
endf

fun! S(arg)
    vsp | exec 'term echo ' . a:arg
    call timer_start(200, 'Q', {'repeat': 1})
endf

fun! T()
    call fzf#run(fzf#wrap({
        \   'source': [1],
        \   'sink': funcref('S')
        \}))
endf
