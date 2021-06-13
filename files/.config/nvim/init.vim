"  File: init.vim
"  Author: Breno Leonhardt Pacheco
"  Email: brenoleonhardt@gmail.com
"  Last Modified: February 23, 2021
"   _       _ _         _
"  (_)_ __ (_) |___   _(_)_ __ ___
"  | | '_ \| | __\ \ / / | '_ ` _ \
"  | | | | | | |_ \ V /| | | | | | |
"  |_|_| |_|_|\__(_)_/ |_|_| |_| |_|

" TODO: 1. fix or alter Make for easily running targets
"       2. run node debugger and jest/mocha tests debug
"       3. fix lsp#format() - make use of editorconfig
"       10. add documentation to files
"       6. mapping/command to browse docs
"       4. add notetaking plugin
"       8. revisit autoload
"       5. add command to browse templates
"       7. revisit "how"
"       9. rethink plugin structure
"       10. revisit debugger
"       11. revisit fzf & lsp integration or take a look at telescope
"       12. learn how best to use git


set secure
set noexrc
call plug#begin(globals#get('plugdir'))
    let g:plug_timeout=99999
    Plug 'tweekmonster/startuptime.vim'
    Plug 'editorconfig/editorconfig-vim'    " load configs from .editorconfig
    Plug 'gcmt/wildfire.vim'                " expand/contract select
    Plug 'tpope/vim-commentary'             " comment lines of code
    Plug 'tpope/vim-repeat'                 " repeats commands with .
    Plug 'tpope/vim-surround'               " surrounds elements in text
    Plug 'tpope/vim-fugitive'               " git tools wrapper
    Plug 'AndrewRadev/bufferize.vim'        " gets cmd result into buffer
    Plug 'farmergreg/vim-lastplace'         " open file in last edited line
    Plug 'markonm/traces.vim'               " preview substitution
    Plug 'mbbill/undotree'                  " visual undo tree
    Plug 'junegunn/vim-easy-align'          " align text blocks
    Plug 'ludovicchabant/vim-gutentags'     " automatic tags files
    Plug 'majutsushi/tagbar'                " tags bar using tags file
    Plug 'itchyny/lightline.vim'            " statusline configuration
    Plug 'junegunn/fzf'                     " fuzzy completion binary
    Plug 'junegunn/fzf.vim'                 " fzf vim's interface
    Plug 'mhinz/vim-signify'                " adds git marks to gutter
    Plug 'rhysd/git-messenger.vim'          " show git messsages at cursor pos.
    Plug 'sodapopcan/vim-twiggy'            " branch browser
    Plug 'junegunn/gv.vim'                  " git log browser
    Plug 'brenopacheco/vim-tree'            " show directory structure as tree
    Plug 'diepm/vim-rest-console'           " CURL tool for http requests
    Plug 'neovim/nvim-lspconfig'            " lsp default configurations
    Plug 'hrsh7th/vim-vsnip'                " snippets engine
    Plug 'brenopacheco/nvim-compe'
    Plug 'nvim-lua/lsp-status.nvim'         " lsp status for statusline
    Plug 'glepnir/lspsaga.nvim'             " lsp UI utils
    Plug 'cohama/lexima.vim'                " auto close {} () / smarter
    Plug 'vim-test/vim-test'                " run tests
    Plug 'brenopacheco/vim-quickhelp'       " call :Help for visual help
    Plug 'brenopacheco/vim-hydra'       " call :Help for visual help
    Plug 'junegunn/goyo.vim'                " like vscode writer mode
    Plug 'junegunn/limelight.vim'           " lights only hovered block
    Plug 'haishanh/night-owl.vim'           " theme
    Plug 'bluz71/vim-nightfly-guicolors'    " theme
    Plug 'endel/vim-github-colorscheme'     " theme
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " Plug 'puremourning/vimspector'
    " Plug 'mfussenegger/nvim-dap'            " debugger lsp equivalent
    " Plug 'theHamsta/nvim-dap-virtual-text'
    " Plug 'mfussenegger/nvim-dap-python'
    "
    " Plug 'neomake/neomake'
    " Plug 'sbdchd/neoformat'
    " Plug 'tpope/vim-projectionist'          " jump around alt files i.e: .c .h
    " Plug 'KabbAmine/zeavim.vim'             " interfaces to zeal
    " Plug 'mfussenegger/nvim-jdtls'
call plug#end()
