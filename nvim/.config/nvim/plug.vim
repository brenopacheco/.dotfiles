" Bootstrap Plug manager {{{

if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs 
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"}}}
" Load plugins {{{

call plug#begin(g:plugdir)
    let g:plug_timeout=99999

    Plug 'tweekmonster/startuptime.vim'
    Plug 'editorconfig/editorconfig-vim'    " load configs from .editorconfig
    Plug 'gcmt/wildfire.vim'                " expand/contract select
    Plug 'alvan/vim-closetag'               " closes html/xml tags
    Plug 'tpope/vim-commentary'             " comment lines of code
    Plug 'tpope/vim-repeat'                 " repeats commands with .
    Plug 'tpope/vim-surround'               " surrounds elements in text
    Plug 'tpope/vim-fugitive'               " git tools wrapper
    " Plug 'tpope/vim-projectionist'          " jump around alt files i.e: .c .h
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
    Plug 'rbgrouleff/bclose.vim'            " required by lf
    Plug 'brenopacheco/lf.vim'              " file browser
    Plug 'brenopacheco/vim-hydra'           " hydras
    Plug 'mhinz/vim-signify'                " adds git marks to gutter
    Plug 'rhysd/git-messenger.vim'          " show git messsages at cursor pos.
    Plug 'sodapopcan/vim-twiggy'            " branch browser
    Plug 'junegunn/gv.vim'                  " git log browser
    " Plug 'aperezdc/vim-template'            " inserts template on new file
    Plug 'KabbAmine/zeavim.vim'             " interfaces to zeal
    Plug 'brenopacheco/vim-tree'            " show directory structure as tree
    Plug 'diepm/vim-rest-console'           " CURL tool for http requests
    Plug 'hrsh7th/vim-vsnip'                " snippets engine
    Plug 'hrsh7th/vim-vsnip-integ'          " lsp/completion integration
    Plug 'neovim/nvim-lsp'                  " language server features
    Plug 'neovim/nvim-lspconfig'            " lsp default configurations
    Plug 'brenopacheco/completion-nvim', { 'branch': 'custom' }
    Plug 'steelsojka/completion-buffers'
    Plug 'nvim-lua/lsp-status.nvim'         " lsp status for statusline
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  
    Plug 'cohama/lexima.vim'
    Plug 'skywind3000/asyncrun.vim'
    Plug 'mfussenegger/nvim-dap'
    Plug 'haishanh/night-owl.vim'
    Plug 'bluz71/vim-nightfly-guicolors'    " treesitter compatible theme

call plug#end()

"}}}
" deprecated {{{

    " vim-lsp
    " Plug 'prabirshrestha/vim-lsp'
    " Plug 'mattn/vim-lsp-settings'
    " Plug 'prabirshrestha/asyncomplete.vim'
    " Plug 'prabirshrestha/asyncomplete-lsp.vim'
    " Plug 'prabirshrestha/asyncomplete-buffer.vim'
    " Plug 'prabirshrestha/asyncomplete-file.vim'
    " Plug 'prabirshrestha/asyncomplete-tags.vim'

    " Plug 'effkay/argonaut.vim'              " argonaut theme
    " Plug 'dracula/vim', { 'as': 'dracula' } " dracula theme

" }}}
" to review {{{

    " Plug 'kana/vim-textobj-user'            " create textobjects
    " Plug 'somini/vim-textobj-fold'          " adds fold text object
    " Plug 'glts/vim-textobj-comment'         " adds comment text object
    " Plug 'jiangmiao/auto-pairs'             " auto close ([{
    " Plug 'easymotion/vim-easymotion'        " easy jump 
    " Plug 'liuchengxu/vista.vim'             " extends/beautifies tagbar
    " Plug 'junegunn/limelight.vim'           " fades unfocused text
    " Plug 'junegunn/goyo.vim'                " distraction-free screen
    " Plug 'metakirby5/codi.vim'              " inline REPL
    " Plug 'rstacruz/vim-closer'
    " Plug 'jceb/vim-orgmode'
    " Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

" }}}
