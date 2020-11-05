" DEFAULTS{{{

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

  " MISC
  xmap ga :EasyAlign<cr>
  nmap ga :EasyAlign<cr>
  map  + <Plug>(wildfire-fuel)
  vmap - <Plug>(wildfire-water)

"}}}
" NAVIGATION [ ] {{{
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
"}}}
" FUZZY{{{
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
  " nnoremap <leader>a viW<cmd>lua vim.lsp.buf.code_action()<CR><ESC>
  " xnoremap <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
  " nnoremap <leader>= <cmd>lua vim.lsp.buf.formatting()<CR>
  " xnoremap <leader>= <cmd>lua vim.lsp.buf.range_formatting()<CR>
"}}}
" LIST{{{
  nnoremap <leader>o :lua vim.lsp.buf.document_symbol()<CR>
  nnoremap <leader>* :References<CR>
  nnoremap <leader>s :lua vim.lsp.buf.workspace_symbol()<CR>
  nnoremap <leader>/ :gr//**/*<left><left><left><left><left>
"}}}
" GOTOS{{{
  nnoremap <silent> gA viW<cmd>lua vim.lsp.buf.code_action()<CR><ESC>
  xnoremap <silent> gA <cmd>lua vim.lsp.buf.code_action()<CR>
  nnoremap <silent> g= <cmd>lua vim.lsp.buf.formatting()<CR>
  xnoremap <silent> g= <cmd>lua vim.lsp.buf.range_formatting()<CR>
  nnoremap <silent> gR <cmd>lua vim.lsp.buf.rename()<CR>
  xnoremap <silent> gR <cmd>lua vim.lsp.buf.rename()<CR>
  nnoremap <silent> gr :References<CR>
  nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent> gy <cmd>lua vim.lsp.buf.type_definition()<CR>
"}}}
" TOGGLES{{{
  nnoremap <leader>' :TerminalToggle<CR>
  nnoremap <leader>n :NetrwToggle<CR>
  nnoremap <leader>t :TagbarToggle<CR>
  nnoremap <leader>l :Lf<CR>
  nnoremap <leader>u :UndotreeToggle<CR>
  nnoremap <leader>q :QuickfixToggle<CR><C-w><C-p>
"}}}
" MISC/LEADER{{{
  " silent nmap f             <Plug>(easymotion-sn)
  " nnoremap <leader>        :Hydra leader_help<CR>
  nnoremap <leader>f       :Hydra fuzzy_help<CR>
  nnoremap g?               :Hydra goto_help<CR>
  nnoremap <S-h>            :lua vim.lsp.buf.hover()<CR>
  nnoremap ´                :Lf<CR>

  nnoremap - :Tree<CR>
  nnoremap _ :vsp<CR>:Tree<CR>

  xnoremap <C-j> :m '>+1<CR>gv=gv
  xnoremap <C-k> :m '<-2<CR>gv=gv
  xnoremap <C-l> <Esc>`<<C-v>`>odp`<<C-v>`>lol
  xnoremap <C-h> <Esc>`<<C-v>`>odhP`<<C-v>`>hoh

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
" ---- command/func defs {{{

  command! LspStatus      :lua print(vim.inspect(vim.lsp.buf_get_clients()))<CR>
  command! DirView        :tabnew! | term tree
  command! References     :call s:references()
  command! Backup         :call Backup()
  command! Vimrc          :so ~/.config/nvim/init.vim
  command! Trim           :%s/\s\+$//e
  command! Fork           :silent exec '!fork'
  command! NetrwToggle    :call s:toggle('netrw', 'Lexplore')
  command! QuickfixToggle :call s:toggle('quickfix', 'copen')
  command! Args           :call fzf#run(fzf#wrap('FZF',{'source':argv(),'sink':'e',}))
  command! PFiles         :call fzf#vim#files(s:root(),fzf#vim#with_preview())
  command! Load           :exec 'ar ' . s:root() . '/**/*.' . input('ft: ')

  function s:references() abort
     let l:winnr = winnr()
     silent lua vim.lsp.buf.references()
     if empty(getqflist())
       exec 'vimgrep /' . expand('<cWORD>') . '/j **/*.' . &ft
     endif
     copen
     wincmd p
  endfunction

  command! Root :echo s:root()
  function s:root() abort
     let l:root = system('git rev-parse --show-toplevel 2>/dev/null')
     let l:root = substitute(l:root, '\n', '', '')
     return len(l:root) == 0 ? './' : l:root
  endfunction

  function s:toggle(filetype, open) abort
      for i in range(1, winnr('$'))
          let bnum = winbufnr(i)
          if getbufvar(bnum, '&buftype') == a:filetype
              silent exe "bwipeout " . bnum
              return
          endif
      endfor
      silent exec a:open
  endfunction


"}}}
