"  File: init.vim
"  Author: Breno Leonhardt Pacheco
"  Email: brenoleonhardt@gmail.com
"   _       _ _         _
"  (_)_ __ (_) |___   _(_)_ __ ___
"  | | '_ \| | __\ \ / / | '_ ` _ \
"  | | | | | | |_ \ V /| | | | | | |
"  |_|_| |_|_|\__(_)_/ |_|_| |_| |_|


" TODO: 
" [x] - st copy from terminal // CTRL+SHIFT+C
" [x] - rebase nvim-compte
" [ ] - Snippets final fix
" [ ] - Git integration (checkout, rebase, log, stash, conflicts, vimagit?)
" [ ] - Signify (hover,undo,redo,mappings)
" [ ] - Replace FZF w/ telescope
" [ ] - Simplify commands to use commonly
" [ ] - tsconfig/eslint/prettier/editorconfig integration (actions, format)
" [ ] - LSP (symbols, outline, references, refactor)
" [ ] - lsp#format()
" [ ] - Search Docs
" [ ] - Redefine shortcuts and hydra/which-key them?
" [ ] - Run Tests
" [ ] - Run Debugger
" [ ] - Migrate configs to Lua
" [ ] - Fix Make
" [ ] - Templates plugin
" [ ] - Revisit autoload/plugin sources
" [ ] - Notetaking plugin
" [ ] - How plugin
" [ ] - Document configs
" [ ] - UI customizations

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
    Plug 'brenopacheco/nvim-compe'               " completion that actually works
    Plug 'nvim-lua/lsp-status.nvim'         " lsp status for statusline
    Plug 'glepnir/lspsaga.nvim'             " lsp UI utils
    Plug 'cohama/lexima.vim'                " auto close {} () / smarter
    Plug 'vim-test/vim-test'                " run tests
    Plug 'brenopacheco/vim-quickhelp'       " call :Help for visual help
    Plug 'brenopacheco/vim-hydra'           " like abo-abo's hydras
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
