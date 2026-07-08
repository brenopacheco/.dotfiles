-- vim:tw=80:cc=+1:fdm=marker
-- stylua: ignore start
-- 1. MISC ============================================================== {{{
-- where should this junk be placed???
vim.cmd('filetype indent on')
vim.cmd('filetype plugin on')
vim.cmd('syntax on')
vim.env.MANPAGER = ''
vim.g.c_syntax_for_h = 1
vim.g.vim_indent_cont = 4
vim.g.editorconfig = true
vim.diagnostic.config({ virtual_text = true })
vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('ts_ls')
-- vim.lsp.enable('filepaths_ls')
-- }}}
-- 2. OPTIONS =========================================================== {{{
vim.opt.autochdir      = false -- don't auto-change cwd to file's directory
vim.opt.autoindent     = true -- copy indent from current line when starting a new line
vim.opt.autoread       = true -- auto-reload file if changed outside vim
vim.opt.autowriteall   = false -- don't auto-save on commands like :next, :quit
vim.opt.autowrite      = false -- don't auto-save before running commands like :make
vim.opt.bomb           = false -- don't write a byte-order-mark to the file
vim.opt.breakindent    = true -- when wraping, mainain indentention of wraped lines
vim.opt.cdhome         = false -- ':cd' without args goes to '' instead of home dir
vim.opt.clipboard      = 'unnamed,unnamedplus' -- use system clipboard for yank/delete/paste
vim.opt.cmdheight      = 1 -- height (in lines) of the command line
vim.opt.colorcolumn    = "+1" -- highlight 1 column after textwidth
vim.opt.conceallevel   = 0 -- show concealed text normally (no hiding)
vim.opt.confirm        = true -- ask to save changes instead of failing the command
vim.opt.cursorline     = true -- highlight the line the cursor is on
vim.opt.encoding       = 'utf-8' -- internal character encoding (hardlocked in neovim)
vim.opt.expandtab      = false -- use real tabs instead of spaces
vim.opt.fileencodings  = { 'utf-8', 'latin1', 'ucs-bom', 'default' } -- encodings tried when reading a file
vim.opt.fileencoding   = 'utf-8' -- encoding used when writing the file
vim.opt.fileformat     = 'unix' -- use unix (LF) line endings
vim.opt.foldcolumn     = 'auto:9' -- show a fold column, auto-sized up to 9 wide
vim.opt.foldlevelstart = 99 -- start with all folds open
vim.opt.foldmarker     = '{{{,}}}' -- markers used to define fold start/end
vim.opt.foldmethod     = 'marker' -- fold based on markers in the text
vim.opt.foldminlines   = 1 -- minimum lines a fold must span to be closed
vim.opt.foldnestmax    = 6 -- max nesting depth for folds
vim.opt.foldopen       = { 'insert', 'quickfix', 'mark', 'search', 'tag', 'undo' } -- reopen folds automatically on these actions
vim.opt.formatoptions  = 'jnq' -- text-formatting behavior (join comments, numbered lists, gq)
vim.opt.grepformat     = '%f:%l:%c:%m' -- format of lines produced by 'grepprg'
vim.opt.grepprg        = 'rg -uu --vimgrep' -- replace grep
vim.opt.hidden         = true -- allow switching buffers without saving them
vim.opt.history        = 10000 -- number of commands/searches remembered
vim.opt.hlsearch       = true -- highlight all search matches
vim.opt.ignorecase     = true -- searches are case-insensitive by default
vim.opt.inccommand     = 'nosplit' -- live-preview :substitute results in the buffer
vim.opt.incsearch      = true -- show search matches as you type
vim.opt.joinspaces     = false -- use one space (not two) after '.' when joining lines
vim.opt.jumpoptions    = "clean" -- restore cursor column when jumping to old positions
vim.opt.keywordprg     = ':help!' -- program used for 'K' keyword lookup (vim help)
vim.opt.laststatus     = 3 -- single global statusline for all windows
vim.opt.lazyredraw     = true -- don't redraw screen during macros/scripts (faster)
vim.opt.linebreak      = true -- wrap long lines at word boundaries
vim.opt.listchars      = { tab = [[» ]], trail = '¬', nbsp = '␣', extends = '›', precedes = '‹' } -- eol = '$' } -- characters used to display whitespace
vim.opt.list           = true -- show whitespace characters defined in 'listchars'
vim.opt.more           = true -- pause long output with --more--
vim.opt.number         = true -- show line numbers
vim.opt.path           = '.,,**' -- directories searched by :find and gf (current, file's dir, recursive)
vim.opt.pumheight      = 6 -- max number of items in the popup completion menu
vim.opt.pumwidth       = 15 -- minimum width of the popup completion menu
vim.opt.relativenumber = true -- show line numbers relative to the cursor
vim.opt.report         = 0 -- always report number of lines changed by a command
vim.opt.scrolloff      = 10 -- keep 10 lines visible above/below the cursor
vim.opt.shada          = "!,'100,<50,s10,h" -- what's saved in the shada file (marks, registers, history)
vim.opt.shell          = 'fish' -- vim executes {shell} {shellcmdflag} {command}
vim.opt.shellcmdflag   = '-c' -- tells the shell to evaluate the following cmdline
vim.opt.shiftwidth     = 4 -- number of spaces used for each step of (auto)indent
vim.opt.shortmess      = 'cltOCTFso'  -- options for the messages below statusline
vim.opt.showbreak      = '↪ ' -- string shown before wrapped lines
vim.opt.showcmd        = true -- show partial command in the bottom right
vim.opt.showmatch      = true -- briefly jump to matching bracket when inserted
vim.opt.showmode       = true -- show current mode (Insert, Visual, etc.) in command line
vim.opt.signcolumn     = 'yes:1' -- always show a 1-wide sign column (e.g. for diagnostics)
vim.opt.smartcase      = true -- case-sensitive search if query contains uppercase
vim.opt.smartindent    = false -- disable smartindent (autoindent/filetype indent used instead)
vim.opt.spell          = false -- spell-checking disabled by default
-- splitbelow=true and splitright=true mimick tmux and i3's behavior
vim.opt.splitbelow     = true -- new horizontal splits open below current window
vim.opt.splitright     = true  -- new vertical splits open to the right of current window
vim.opt.splitkeep      = 'topline' -- keep the same topline visible when splitting/closing windows
vim.opt.startofline    = false -- keep cursor column on commands like G, gg, Ctrl-D
vim.opt.suffixesadd    = '' -- no extra suffixes tried when looking up filenames (gf)
vim.opt.tabstop        = 4 -- width (in spaces) a tab character is displayed as
vim.opt.tagcase        = "followic" -- tag search case-sensitivity follows 'ignorecase'/'smartcase'
vim.opt.tagstack       = true -- use the tag stack with Ctrl-] and :tag commands
vim.opt.tags           = 'tags;~' -- where to look for tags files (search upward to home)
vim.opt.termguicolors  = true -- enable 24-bit RGB colors in the terminal
vim.opt.textwidth      = 78 -- max width of text before automatic line break
vim.opt.timeout        = false -- disable timeout for mapped key sequences
vim.opt.timeoutlen     = 0 -- time (ms) to wait for a mapped sequence (unused since timeout=false)
vim.opt.undofile       = true -- persist undo history across sessions
vim.opt.undolevels     = 500 -- number of undo states kept per buffer
vim.opt.updatetime     = 300 -- ms of inactivity before triggering CursorHold / swap write
vim.opt.virtualedit    = 'onemore' -- allow cursor one character past the end of a line
vim.opt.visualbell     = true -- use a visual flash instead of an audible beep
vim.opt.wildignore     = { '.git', 'node_modules', '*.o', '*.obj' } -- patterns ignored in file/command completion
vim.opt.wildmenu       = true -- enhanced command-line completion menu
vim.opt.wildmode       = 'longest:full,full' -- completion behavior: complete longest match, then full menu
vim.opt.wrap           = false -- don't visually wrap long lines
vim.opt.wrapscan       = false -- searches don't wrap around end of file
-- }}}
-- stylua: ignore end
