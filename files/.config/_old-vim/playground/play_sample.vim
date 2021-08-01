set runtimepath=/home/breno/.config/nvim/playground,$VIMRUNTIME

call plug#begin('/tmp/plug')
    let g:plug_timeout=99999
    Plug 'tpope/vim-commentary'
call plug#end()
