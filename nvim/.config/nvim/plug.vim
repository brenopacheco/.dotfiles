if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs 
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
    let g:plug_timeout=99999
    Plug 'kana/vim-textobj-user'            " create textobjects
    Plug 'somini/vim-textobj-fold'          " adds fold text object
    Plug 'glts/vim-textobj-comment'         " adds comment text object
    Plug 'kana/vim-textobj-function'
    Plug 'gcmt/wildfire.vim'                " expand/contract select
    Plug 'alvan/vim-closetag'                 " closes html/xml tags
    Plug 'jiangmiao/auto-pairs'             " auto close ([{
    Plug 'tpope/vim-commentary'             " comment lines of code
    Plug 'tpope/vim-repeat'                 " repeats commands with .
    Plug 'tpope/vim-surround'               " surrounds elements in text
    Plug 'tpope/vim-abolish'                " make :s/ keeps uppercase
    Plug 'AndrewRadev/bufferize.vim'        " gets cmd result into buffer
    Plug 'easymotion/vim-easymotion'        " easy jump 
    Plug 'farmergreg/vim-lastplace'         " open file in last edited line
    Plug 'markonm/traces.vim'               " preview substitution
    Plug 'mbbill/undotree'                  " visual undo tree
    Plug 'junegunn/vim-easy-align'          " align text blocks
    Plug 'ludovicchabant/vim-gutentags'     " automatic tags files
    Plug 'majutsushi/tagbar'                " tags bar using tags file
    Plug 'liuchengxu/vista.vim'             " extends/beautifies tagbar
    Plug 'junegunn/limelight.vim'           " fades unfocused text
    Plug 'junegunn/goyo.vim'                " distraction-free screen
    Plug 'effkay/argonaut.vim'              " argonaut theme
    Plug 'dracula/vim', { 'as': 'dracula' } " dracula theme
    Plug 'itchyny/lightline.vim'            " statusline configuration
    Plug 'junegunn/fzf.vim', { 'commit': '18205e071dc701ed9ca51971466b9997cd3d0778' }
    Plug 'rbgrouleff/bclose.vim'            " required by lf
    Plug 'brenopacheco/lf.vim'                " file browser
    Plug 'voldikss/vim-floaterm'            " pops up floating terminal 
    Plug 'brenopacheco/vim-hydra'           " hydras
    Plug 'tpope/vim-fugitive'               " git tools wrapper
    Plug 'mhinz/vim-signify'                " adds git marks to gutter
    Plug 'rhysd/git-messenger.vim'          " show git messsages at cursor pos.
    Plug 'sodapopcan/vim-twiggy'            " branch browser
    Plug 'junegunn/gv.vim'                  " git log browser
    Plug 'aperezdc/vim-template'            " inserts template on new file
    Plug 'KabbAmine/zeavim.vim'             " interfaces to zeal
    Plug 'sheerun/vim-polyglot'             " syntax highlight and indent 
    Plug 'neovim/nvim-lsp'                  " language server features
    Plug 'neovim/nvim-lspconfig'            " lsp default configurations
    Plug 'nvim-lua/completion-nvim'         " lsp compatible autocomplete
    Plug 'steelsojka/completion-buffers'    " word completion for buffers
    Plug 'nvim-lua/diagnostic-nvim'         " lsp diagnostics
    Plug 'nvim-lua/lsp-status.nvim'         " lsp status for statusline
    Plug 'hrsh7th/vim-vsnip'                " snippets engine
    Plug 'hrsh7th/vim-vsnip-integ'          " lsp/completion integration
    Plug 'honza/vim-snippets'

    " Plug 'nvim-treesitter/nvim-treesitter'  " syntax highlight and folds
    Plug 'brenopacheco/vim-tree'
    Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
    Plug 'glepnir/zephyr-nvim'
    Plug 'chrisbra/Colorizer'
    Plug 'bluz71/vim-nightfly-guicolors'
call plug#end()
