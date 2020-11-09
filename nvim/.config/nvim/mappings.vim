" DEFAULTS {{{

  " FIXES
  nnoremap Y :norm v$y<cr>
  xnoremap v v0v$h
  nnoremap Q <Nop>
  xnoremap p pgvy
  xnoremap <expr> p 'pgv"'.v:register.'y`>'
  vnoremap < <gv
  vnoremap > >gv
  nnoremap > >>
  nnoremap < <<
  inoremap jk <C-[>l
  inoremap kj <C-[>l
  vnoremap * "zy/\V<C-r>=escape(@z, '\/')<CR><CR>
  nnoremap  :nohlsearch<CR>
  nnoremap [<space> mmo<Esc>`m
  nnoremap ]<space> mmO<Esc>`m

  xnoremap <C-j> :m '>+1<CR>gv=gv
  xnoremap <C-k> :m '<-2<CR>gv=gv
  xnoremap <C-l> <Esc>`<<C-v>`>odp`<<C-v>`>lol
  xnoremap <C-h> <Esc>`<<C-v>`>odhP`<<C-v>`>hoh

  " MISC
  xmap ga :EasyAlign<cr>
  nmap ga :EasyAlign<cr>
  map  + <Plug>(wildfire-fuel)
  vmap - <Plug>(wildfire-water)
  nnoremap - :Tree<CR>
  nnoremap _ :vsp<CR>:Tree<CR>

"}}}
" NAVIGATION {{{
  " e: errors,      s: stack(tags), t: tags
  " a: arglist,     b: buffer,      q: quickfix
  " g: gitchunk     l: loclist      c: diffnext
  nnoremap ]e <cmd>NextDiagnostic<CR>
  nnoremap [e <cmd>PrevDiagnostic<CR>
  nnoremap ]g <plug>(signify-next-hunk)
  nnoremap [g <plug>(signify-prev-hunk)
  nnoremap ]s :tag<CR>
  nnoremap [s :pop<CR>
  nnoremap ]t :tnext<CR>
  nnoremap [t :tprevious<CR>
  nnoremap ]a :next<CR>
  nnoremap [a :previous<CR>
  nnoremap ]b :bnext<CR>
  nnoremap [b :bprevious<CR>
  nnoremap ]q :cnext<CR>
  nnoremap [q :cprevious<CR>
  nnoremap ]l :lnext<CR>
  nnoremap [l :lprevious<CR>
  nmap q] ]q
  nmap q[ [q
  nmap l] ]l
  nmap l[ [l
"}}}
" FIND{{{
  nnoremap <silent> <leader>f~ :Files ~<CR>
  nnoremap <silent> <leader>f. :Files .<CR>
  nnoremap <silent> <leader>fg :GFiles?<CR>
  nnoremap <silent> <leader>fp :PFiles<CR>
  nnoremap <silent> <leader>fa :Args<CR>
  nnoremap <silent> <leader>fb :Buffers<CR>
  nnoremap <silent> <leader>f/ :Rg<CR>
  nnoremap <silent> <leader>f* :exec 'Rg ' . expand("<cword>")<CR>
  nnoremap <silent> <leader>fs :Vista finder!<CR>
  nnoremap <silent> <leader>fo :Vista finder<CR>
  nnoremap <silent> <leader>fm :Marks<CR>
  nnoremap <silent> <leader>fr :History<CR>
  nnoremap <silent> <leader>f: :History:<CR>
  nnoremap <silent> <leader>fh :Helptags<CR>
"}}}
" ACTIONS{{{
  " code-action, format, rename, hover, align, comment
  nnoremap <silent> <leader>a viW<cmd>lua vim.lsp.buf.code_action()<CR><ESC>
  xnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
  nnoremap <silent> <leader>= <cmd>lua vim.lsp.buf.formatting()<CR>
  xnoremap <silent> <leader>= <cmd>lua vim.lsp.buf.range_formatting()<CR>
  " xnoremap <silent> <leader>r <cmd>lua vim.lsp.buf.rename()<CR>
  " nnoremap <silent> <leader>r <cmd>lua vim.lsp.buf.rename()<CR>
  nnoremap <silent> <leader>r :Rename<CR>
  nnoremap <silent> <leader>* :exec 'vimgrep /' . expand('<cword>') 
			  \ . '/j **/*'<CR>:copen<CR>:wincmd p<CR>
  nnoremap <leader>/ :call <SID>vimgrep()<CR>
"}}}
" GOTOS{{{
  " nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent> gr :References<CR>
  nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent> gy <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent> go <cmd>lua vim.lsp.buf.document_symbol()<CR>
  nnoremap <silent> gs <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
"}}}
" TOGGLES{{{
  nnoremap <leader>' :TerminalToggle<CR>
  nnoremap <leader>n :TreeToggle<CR>
  nnoremap <leader>t :TagbarToggle<CR>
  nnoremap <leader>l :Lf<CR>
  nnoremap <leader>u :UndotreeToggle<CR>
  nnoremap <leader>q :QuickfixToggle<CR>
"}}}
" HELP{{{
  nnoremap <leader>?        :Hydra help<CR>
"}}}
" &FT MAPPINGS {{{
  au TermOpen * set ft=term
  augroup terminal-maps
    au!
    au Filetype term tnoremap <buffer> <Esc> <C-\><C-n>
    au Filetype term tnoremap <buffer> <C-[> <C-\><c-n>
    au Filetype term tnoremap <buffer> jk <C-\><C-n>
    au Filetype term tnoremap <buffer> kj <C-\><C-n>
    au Filetype fzf  tnoremap <buffer> jk <Esc>
    au Filetype fzf  tnoremap <buffer> kj <Esc>
    au Filetype fzf  tnoremap <buffer> <Esc> <Esc>
    au Filetype lf   tunmap <buffer> jk
    au Filetype lf   tunmap <buffer> kj
    au Filetype netrw  nnoremap <buffer> zh gh
  augroup end
"}}}
" ========== COMMANDS/FUNCS {{{

  command! LspStatus      :lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>
  command! TermOpen       :vsp | term
  command! References     :exec 'vimgrep /' . expand('<cword>') . '/j **/*' | copen | wincmd p
  command! Backup         :call Backup()
  command! Vimrc          :so ~/.config/nvim/init.vim
  command! Trim           :%s/\s\+$//e
  command! Fork           :silent exec '!fork'
  command! NetrwToggle    :call s:toggle('netrw', 'Lexplore')
  command! TreeToggle     :call s:toggle('vimtree', 'VTree')
  command! TerminalToggle :call s:toggle('term', 'TermOpen')
  command! QuickfixToggle :call s:toggle('qf', 'copen')
  command! Args           :call fzf#run(fzf#wrap('FZF',{'source':argv(),'sink':'e',}))
  command! PFiles         :call fzf#vim#files(s:root(),fzf#vim#with_preview())
  command! Rename         :call s:rename()
  command! ArgsGrep       :exec 'vimgrep /'.input('/').'/j ##' | copen | wincmd p
  command! Search         :exec 'gr "'.input('Pattern/').'" '.input('Files (#,%,**/*) /', '**/*')

  command! Root :echo s:root()
  function s:root() abort
     let l:root = system('git rev-parse --show-toplevel 2>/dev/null')
     let l:root = substitute(l:root, '\n', '', '')
     return len(l:root) == 0 ? './' : l:root
  endfunction

  function s:toggle(filetype, open) abort
      for i in range(1, winnr('$'))
          let bnum = winbufnr(i)
          if getbufvar(bnum, '&ft') == a:filetype
              silent exe "bwipeout! " . bnum
              return
          endif
      endfor
      silent exec a:open
  endfunction

  function! Backup()
  	let b:timestamp = strftime('%Y-%m-%d_%Hh%Mm')
  	let b:expanded = expand('%:p')
  	let b:subst = substitute(b:expanded, "/", "\\\\%", "g")
  	let b:dir = g:backupdir
  	let b:backupfile = b:dir . b:timestamp . "_" . b:subst
  	silent exec ':w! ' b:backupfile
  endfunction

  function s:vimgrep() abort
	  let pattern = input(":vimgrep /")
	  let files   = input(":vimgrep /" . pattern . "/j ", "**/*", "file")
	  silent exec "vimgrep /" . pattern . "/j " . files
	  copen
      wincmd p
  endfunction

  function s:rename() abort
    let old_ignc  = &ignorecase
    let old_repo  = &report
    set report=0
    set noignorecase
    " let mark      = getcurpos()
    let word      = expand('<cword>')
    let replace   = input('Replace: ' . word . ' -> ', word)
    let sglobal    = input('Global? [y/n]: ', 'n')
    if sglobal == 'n'
        let files = expand('%')
    elseif sglobal == 'y'
        let root  = system('git rev-parse --show-toplevel 2>/dev/null')
        let root  = substitute(root, '\n', '', '')
        let root  = len(root) == 0 ? './' : root
        let files = substitute(system('fd "." -t f -a ' . root), '\n', ' ', 'g')
    else
        echo "Invalid option"
        return 1
    endif
    let cmd       = '%s/' . word . '/' . replace . '/gie | echo "-> ".expand("%")'
    exec 'args ' . files
    redir => l:subs
    exec 'silent argdo ' . cmd
    redir END
    let l:subs = split(l:subs, '\n')
    let i = 0
    for line in l:subs
        if len(matchstr(line, 'substitution')) > 0
          echo l:subs[i+1] . ": " . line
        endif
        let i = i + 1
    endfor
    " call setpos('.', mark)
    let &ignorecase = old_ignc
    let &report     = old_repo
  endfunction

"}}}
