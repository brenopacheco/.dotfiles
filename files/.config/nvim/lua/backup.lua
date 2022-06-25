local home = vim.env.HOME .. '/'
vim.g.backupdir     = home .. '.cache/nvim/backup/'
vim.g.plugdir       = home .. '.cache/nvim/plug/'
vim.g.undodir       = home .. '.cache/nvim/undo/'
vim.g.swapdir       = home .. '.cache/nvim/swap//'
vim.g.tagsdir       = home .. '.cache/nvim/tags'
vim.g.snippetdir    = home .. '.config/nvim/snippet/'
vim.g.templatedir   = home .. '.config/nvim/template/'
vim.g.dictionarydir = home .. '.config/nvim/dict/'
vim.g.fdignore      = home .. '.fdignore'
vim.g.rgignore      = home .. '.rgignore'

vim.cmd([[
set swapfile                  " enable swap file
let &directory=g:swapdir      " swap directory
set nobackup                  " no backup for current file
set nowritebackup             " no backup for current session
set undofile                  " enable undo tracking
let &undodir=g:undodir        " undo files directory
set backupskip+=*.asc,*.gpg   " disable backup of sensitive files
augroup backup
    au!
    au BufWritePost <buffer> call Backup()
augroup END

for dir in [ g:backupdir, g:plugdir, g:swapdir, g:undodir, g:tagsdir ]
        if !isdirectory(dir)
            silent call system('mkdir -p ' . dir)
            if v:shell_error
                throw 'Cannot create ' . dir . ': ' . v:shell_error
            endif
        endif
endfor
function Backup()
    let b:timestamp = strftime('%Y-%m-%d_%Hh%Mm')
    let b:expanded = expand('%:p')
    let b:subst = substitute(b:expanded, '/', "\\\\%", 'g')
    let b:dir = g:backupdir
    let b:backupfile = b:dir . b:timestamp . '_' . b:subst
    silent exec ':w! ' b:backupfile
endfunction

if !filereadable(g:fdignore) || !filereadable(g:rgignore)
    silent call writefile(['**/node_modules/', 'tags'], g:fdignore)
    silent call writefile(['**/.git/', '**/node_modules/', 'tags'], g:rgignore)
endif
]])
