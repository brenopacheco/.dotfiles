"   _       _ _         _           
"  (_)_ __ (_) |___   _(_)_ __ ___  
"  | | '_ \| | __\ \ / / | '_ ` _ \ 
"  | | | | | | |_ \ V /| | | | | | |
"  |_|_| |_|_|\__(_)_/ |_|_| |_| |_|

if exists('g:vscode')
    source $HOME/.config/nvim/vscode.vim
else
    runtime defaults.vim    " general vim settings
    runtime plug.vim        " installed plugins
    runtime plugins.vim     " plugin settings
    runtime colors.vim      " colors
    runtime mappings.vim    " added mappings
    runtime lsp.vim         " LSP settings
    " runtime completion.vim  " completion settings
    runtime completion.vim  " completion settings
    runtime filetypes.vim   " filetype configurations
    runtime functions.vim   " filetype configurations
    runtime help.vim   
endif
