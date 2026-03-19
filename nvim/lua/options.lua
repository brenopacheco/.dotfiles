-- vim:tw=80:cc=+1:fdm=marker
-- stylua: ignore start
-- 1. MISC ============================================================== {{{
-- where should this junk be???
--require('vim._core.ui2').enable({ enable = true })
vim.cmd('filetype indent on')
vim.cmd('filetype plugin on')
vim.cmd('syntax on')
vim.env.MANPAGER = ''
vim.g.c_syntax_for_h = 1
vim.g.vim_indent_cont = 4
vim.g.editorconfig = true
vim.diagnostic.config({ virtual_text = true })
vim.lsp.enable('lua_ls')
-- vim.lsp.enable('filepaths_ls')
-- }}}
-- 2. OPTIONS =========================================================== {{{
vim.opt.autochdir = false
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.autowriteall = false
vim.opt.autowrite = false
vim.opt.bomb = false
vim.opt.cdhome = false
vim.opt.clipboard = 'unnamed,unnamedplus'
vim.opt.cmdheight = 1
vim.opt.colorcolumn = { 78 }
vim.opt.conceallevel = 0
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.encoding = 'utf-8'
vim.opt.expandtab = false
vim.opt.fileencodings = { 'utf-8', 'latin1', 'ucs-bom', 'default' }
vim.opt.fileencoding = 'utf-8'
vim.opt.fileformat = 'unix'
vim.opt.foldcolumn = 'auto:9'
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = 'marker'
vim.opt.foldmarker = '{{{,}}}'
vim.opt.foldminlines = 1
vim.opt.foldnestmax = 6
vim.opt.foldopen = { 'insert', 'quickfix', 'mark', 'search', 'tag', 'undo' }
vim.opt.formatoptions = 'j,n,q'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.grepprg = table.concat({ 'rg', '--hidden', '--smart-case', '--color=never', '--no-heading', '--column', '--with-filename', '--line-number', '-e', '$*', }, ' ')
vim.opt.hidden = true
vim.opt.history = 10000
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.inccommand = 'nosplit'
vim.opt.incsearch = true
vim.opt.joinspaces = false
vim.opt.jumpoptions = "clean"
vim.opt.keywordprg = ':help!'
vim.opt.laststatus = 3
vim.opt.lazyredraw = true
vim.opt.linebreak = true
vim.opt.listchars = { tab = [[» ]], trail = '¬', nbsp = '␣', extends = '›', precedes = '‹', eol = '$' }
vim.opt.list = true
vim.opt.more = true
vim.opt.number = true
vim.opt.path = '.,,**'
vim.opt.pumheight = 6
vim.opt.pumwidth = 15
vim.opt.relativenumber = true
vim.opt.report = 0
vim.opt.scrolloff = 10
vim.opt.shada = "!,'100,<50,s10,h"
vim.opt.shellcmdflag = '-O globstar -c'
vim.opt.shiftwidth = 4
vim.opt.shortmess:append('cs')
vim.opt.showbreak = '↪ '
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.showmode = false
vim.opt.signcolumn = 'yes:1'
vim.opt.smartcase = true
vim.opt.smartindent = false
vim.opt.spell = false
vim.opt.splitbelow = false
vim.opt.splitkeep = 'topline'
vim.opt.splitright = true
vim.opt.startofline = false
vim.opt.suffixesadd = ''
vim.opt.tabstop = 4
vim.opt.tagcase = "followic"
vim.opt.tagstack = true
vim.opt.tags = 'tags;~'
vim.opt.termguicolors = true
vim.opt.textwidth = 78
vim.opt.timeout = false
vim.opt.timeoutlen = 0
vim.opt.undolevels = 500
vim.opt.updatetime = 300
vim.opt.virtualedit = 'onemore'
vim.opt.visualbell = true
vim.opt.wildignore = { '.git', 'node_modules', '*.o', '*.obj' }
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.wrap = false
vim.opt.wrapscan = false
-- }}}
-- 3. WON'T SET ========================================================= {{{
-- allowrevins
-- ambiwidth
-- arabic
-- arabicshape
-- autocomplete
-- autocompletedelay
-- autocompletetimeout
-- background
-- backspace
-- backup
-- backupcopy
-- backupdir
-- backupext
-- backupskip
-- belloff
-- binary
-- breakat
-- breakindent
-- breakindentopt
-- browsedir
-- bufhidden
-- buflisted
-- buftype
-- busy
-- casemap
-- cdpath
-- cedit
-- charconvert
-- chistory
-- cindent
-- cinkeys
-- cinoptions
-- cinscopedecls
-- cinwords
-- cmdwinheight
-- columns
-- comments
-- commentstring
-- complete
-- completefunc
-- completeitemalign
-- completeopt
-- completeslash
-- completetimeout
-- concealcursor
-- copyindent
-- cpoptions
-- cursorbind
-- cursorcolumn
-- cursorlineopt
-- debug
-- define
-- delcombine
-- dictionary
-- diff
-- diffanchors
-- diffexpr
-- diffopt
-- digraph
-- directory
-- display
-- eadirection
-- emoji
-- endoffile
-- endofline
-- equalalways
-- equalprg
-- errorbells
-- errorfile
-- errorformat
-- eventignore
-- eventignorewin
-- exrc
-- fileformats
-- fileignorecase
-- filetype
-- fillchars
-- findfunc
-- fixendofline
-- foldclose
-- foldenable
-- foldexpr
-- foldignore
-- foldlevel
-- foldmarker
-- foldtext
-- formatexpr
-- formatlistpat
-- formatprg
-- fsync
-- guicursor
-- guifont
-- guifontwide
-- helpfile
-- helpheight
-- helplang
-- icon
-- iconstring
-- iminsert
-- imsearch
-- include
-- includeexpr
-- indentexpr
-- indentkeys
-- infercase
-- isfname
-- isident
-- iskeyword
-- isprint
-- keymap
-- keymodel
-- langmap
-- langmenu
-- langremap
-- lhistory
-- lines
-- linespace
-- lisp
-- lispoptions
-- lispwords
-- loadplugins
-- makeef
-- makeencoding
-- makeprg
-- matchpairs
-- matchtime
-- maxfuncdepth
-- maxmapdepth
-- maxmempattern
-- maxsearchcount
-- menuitems
-- messagesopt
-- mkspellmem
-- modeline
-- modelineexpr
-- modelines
-- modifiable
-- modified
-- mouse
-- mousefocus
-- mousehide
-- mousemodel
-- mousemoveevent
-- mousescroll
-- mousetime
-- nrformats
-- numberwidth
-- omnifunc
-- operatorfunc
-- packpath
-- paragraphs
-- patchexpr
-- patchmode
-- preserveindent
-- previewheight
-- previewwindow
-- pumblend
-- pumborder
-- pummaxwidth
-- pyxversion
-- quickfixtextfunc
-- quoteescape
-- readonly
-- redrawdebug
-- redrawtime
-- regexpengine
-- revins
-- rightleft
-- rightleftcmd
-- ruler
-- rulerformat
-- runtimepath
-- scroll
-- scrollback
-- scrollbind
-- scrolljump
-- scrollopt
-- sections
-- selection
-- selectmode
-- sessionoptions
-- shadafile
-- shell
-- shellpipe
-- shellquote
-- shellredir
-- shellslash
-- shelltemp
-- shellxescape
-- shellxquote
-- shiftround
-- shortmess
-- showcmdloc
-- showfulltag
-- showtabline
-- sidescroll
-- sidescrolloff
-- smarttab
-- smoothscroll
-- softtabstop
-- spellcapcheck
-- spellfile
-- spelllang
-- spelloptions
-- spellsuggest
-- statuscolumn
-- statusline
-- suffixes
-- swapfile
-- switchbuf
-- synmaxcol
-- syntax
-- tabclose
-- tabline
-- tabpagemax
-- tagbsearch
-- tagfunc
-- taglength
-- tagrelative
-- termbidi
-- termpastefilter
-- termsync
-- thesaurus
-- thesaurusfunc
-- tildeop
-- title
-- titlelen
-- titleold
-- titlestring
-- ttimeout
-- ttimeoutlen
-- undodir
-- undofile
-- undoreload
-- updatecount
-- varsofttabstop
-- vartabstop
-- verbose
-- verbosefile
-- viewdir
-- viewoptions
-- warn
-- whichwrap
-- wildchar
-- wildcharm
-- wildignorecase
-- wildoptions
-- winaltkeys
-- winbar
-- winblend
-- winborder
-- window
-- winfixbuf
-- winfixheight
-- winfixwidth
-- winheight
-- winhighlight
-- winminheight
-- winminwidth
-- winwidth
-- wrapmargin
-- write
-- writeany
-- writebackup
-- writedelay
-- }}}
-- stylua: ignore end
