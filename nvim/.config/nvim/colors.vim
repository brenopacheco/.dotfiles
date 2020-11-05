set background=dark
set termguicolors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

au! ColorSchemePre gruvbox  :set background=light 
au! ColorSchemePre argonaut :set notermguicolors
au! ColorScheme    argonaut :set termguicolors

colorscheme nightfly
let g:lightline.colorscheme = 'nightfly'
