set runtimepath=/home/breno/.config/nvim/notes/playground/vim,$VIMRUNTIME

call plug#begin('/home/breno/.cache/nvim/plug/')
    let g:plug_timeout=99999
    Plug 'brenopacheco/vim-hydra'
call plug#end()

" PlugInstall

call hydra#hydras#register({
  \    'name':        'test',
  \    'title':       'test',
  \    'show':        'popup',
  \    'position':    's:bottom_right',
  \    'exit_key':    'q',
  \    'feed_key':    v:false,
  \    'foreign_key': v:true,
  \    'keymap':      [ { 'name': '[test]', 'keys': [ ['a', '', ''] ]} ]
  \  })

" Hydra test
