" DEFAULTS {{{

  " FIXES
  nnoremap Y :norm v$hy<cr>
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
  imap jj <c-e><Down>
  imap kk <c-e><Up>
  vnoremap * "zy/\V<C-r>=escape(@z, '\/')<CR><CR>
  nnoremap  :nohlsearch<CR>

  " add spaces below and up
  nnoremap <silent> ]<space>  :<C-u>call append(line("."),   repeat([""], v:count1))<CR>
  nnoremap <silent> [<space>  :<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>

  " yank vim cmd and run
  nnoremap # yy:@"<CR>
  xnoremap # y:@"<CR>

  " move text in visual mode
  xnoremap <C-j> :m '>+1<CR>gv=gv
  xnoremap <C-k> :m '<-2<CR>gv=gv
  xnoremap <C-l> <Esc>`<<C-v>`>odp`<<C-v>`>lol
  xnoremap <C-h> <Esc>`<<C-v>`>odhP`<<C-v>`>hoh

  " MISC
  nmap "" 0v$hS"
  xmap ga :EasyAlign<cr>
  nmap ga :EasyAlign<cr>
  vmap gp :call Justify('tw',4)<CR>
  vmap gl :s/\s\+/ /g<CR>
  nmap <CR> <Plug>(wildfire-fuel)
  vmap <CR> <Plug>(wildfire-fuel)
  vmap <Backspace> <Plug>(wildfire-water)
  nnoremap <leader>- :OTree<CR>
  runtime macros/justify.vim

"}}}
" NAVIGATION {{{
  nnoremap <silent> ]s :tag<CR>    
 nnoremap <silent> [s :pop<CR>
  nnoremap <silent> ]t :tnext<CR>  
 nnoremap <silent> [t :tprevious<CR>
  nnoremap <silent> ]a :next<CR>   
 nnoremap <silent> [a :previous<CR>
  nnoremap <silent> ]b :bnext<CR>  
 nnoremap <silent> [b :bprevious<CR>
  nnoremap <silent> ]q :try \| cnext \| catch \| cfirst \| catch \| endtry<CR>
  nnoremap <silent> [q :try \| cprev \| catch \| clast \| catch \| endtry<CR>
  nnoremap <silent> ]l :lnext<CR>  
 nnoremap <silent> [l :lprevious<CR>
  nmap <silent> ]c <plug>(signify-next-hunk) 
  nmap <silent> [c <plug>(signify-prev-hunk)
"}}}
" FIND{{{
  nnoremap <silent> <leader>f~ :Files ~<CR>
  nnoremap <silent> <leader>f. :Files .<CR>
  nnoremap <silent> <leader>fg :GFiles?<CR>
  nnoremap <silent> <leader>fp :PFiles<CR>
  nnoremap <silent> <leader>fa :Args<CR>
  nnoremap <silent> <leader>fb :Buffers<CR>
  nnoremap <silent> <leader>fc :Classes<CR>
  nnoremap <silent> <leader>f/ :Rg<CR>
  nnoremap <silent> <leader>f* :exec 'Rg ' . expand("<cword>")<CR>
  nnoremap <silent> <leader>fs :Tags<CR>
  nnoremap <silent> <leader>fo :BTags<CR>
  nnoremap <silent> <leader>fm :Marks<CR>
  nnoremap <silent> <leader>fr :History<CR>
  nnoremap <silent> <leader>f: :History:<CR>
  nnoremap <silent> <leader>fh :Helptags<CR>
"}}}
" TOGGLES{{{
  nnoremap <leader>' :TerminalToggle<CR>
  nnoremap <leader>n :TreeToggle<CR>
  nnoremap <leader><tab> :TagbarToggle<CR>
  nnoremap <leader>l :Lf<CR>
  nnoremap <leader>u :UndotreeToggle<CR>
  nnoremap <leader>q :QuickfixToggle<CR>
  nnoremap <leader>g :Goyo<CR>
"}}}
" WINDOWS{{{

  nnoremap <C-w>t :tabnew<CR>
  nnoremap <C-w>e :enew<CR>

  nnoremap <leader>ws <C-W>s
  nnoremap <leader>wv <C-W>v
  nnoremap <leader>wq <C-W>q
  nnoremap <leader>wc <C-W>c
  nnoremap <leader>wo <C-W>o
  nnoremap <leader>ww <C-W>w
  nnoremap <leader>wm <C-W>_<C-W>\|
  nnoremap <leader>we :enew<CR>
  nnoremap <leader>wt :tabnew<CR>

  nnoremap <leader>wh <C-W>h
  nnoremap <leader>wj <C-W>j
  nnoremap <leader>wk <C-W>k
  nnoremap <leader>wl <C-W>l

  nnoremap <leader>wK <C-W>K
  nnoremap <leader>wJ <C-W>J
  nnoremap <leader>wH <C-W>H
  nnoremap <leader>wL <C-W>L
  nnoremap <leader>wT <C-W>T
  nnoremap <leader>w= <C-W>=
  nnoremap <leader>w- <C-W>-
  nnoremap <leader>w+ <C-W>+
  nnoremap <leader>w_ <C-W>_
  nnoremap <leader>w< <C-W><
  nnoremap <leader>w> <C-W>>
  nnoremap <leader>w\| <C-W>\|


"}}}
" PLUG {{{

    nnoremap <leader>pi <cmd>PlugInstall<CR>
    nnoremap <leader>pc <cmd>PlugClean<CR>
    nnoremap <leader>pd <cmd>PlugDiff<CR>
    nnoremap <leader>pu <cmd>PlugUpdate<CR>
    nnoremap <leader>pr <cmd>Vimrc<CR>

"}}}
" HELP{{{ 

  nnoremap <leader>w? :call quickhelp#toggle("window")<CR>
  nnoremap <space>? :call quickhelp#toggle("noft")<CR>
  nmap <S-h> <Plug>(git-messenger)

"}}}
" SEARCH/QF {{{
    
    " TODO: REFACTOR THIS INTO FUNCTIONS

    " _*  grep word under cursor / selection
    " _/  grep input
    nnoremap <leader>*       :silent exec 'grep! "' . expand('<cword>') . '" ' . <SID>root()<CR>:copen<CR>:wincmd p<CR>
    vnoremap <leader>/       "zy:silent exec 'grep! "' . @z . '" ' . <SID>root()<CR>:copen<CR>:wincmd p<CR>
    nnoremap <expr><leader>/ ':silent grep! "" '. Root() .' \| copen \| wincmd p<Home><C-right><C-right><C-right><Left>'

    " substitute word under cursor or selection
    nnoremap <expr><leader>s ':%s/'.expand('<cword>').'/'.expand('<cword>').'/g<left><left>'
    xnoremap <leader>s "zy:%s/<c-r>z/<c-r>z/g<left><left>


    " q*  grep word under cursor / selection
    " q/  grep input
    nnoremap q* :silent exec 'grep! "' . expand('<cword>') . '" %'<CR>:copen<CR>:wincmd p<CR>
    vnoremap q* "zy:silent exec 'grep! "' . expand('<cword>') . '" %'<CR>:copen<CR>:wincmd p<CR>
    nnoremap q/ :silent grep! "" % \| copen \| wincmd p<Home><C-right><C-right><C-right><Left>
    nnoremap qf :call <SID>qf_filter(input('QF Filter: /'))<CR>
    nnoremap qp :silent! colder<CR>
    nnoremap qn :silent! cnewer<CR>


" }}}
" COMPILE / RUN {{{

    nnoremap <leader>fm :Make<CR>
    nnoremap <leader># :Run<CR>
    nnoremap <leader>m :make % \| copen \| wincmd p<CR>

" }}}
" &FT MAPPINGS {{{
"}}}
" ========== COMMANDS/FUNCS {{{

  command! Vimrc          so ~/.config/nvim/init.vim
  command! Trim           %s/\s\+$//e
  command! TabReplace     %s/\t/    /g
  command! SpaceReplace   %s/    /\t/g
  command! Fork           silent exec '!kitty & disown'
  command! NetrwToggle    call utils#toggle('netrw', 'Lexplore')
  command! TreeToggle     call utils#toggle('vimtree', 'VGTree')
  command! TerminalToggle call utils#toggle('term', 'Term')
  command! QuickfixToggle call utils#toggle('qf', 'copen') | wincmd p
  command! VGTree         call s:vgtree()
  command! OTree          call s:otree()
  command! Term           call s:termopen()



  command! -nargs=+ QFFilter :call quickfix#filter(<q-args>)
  command! -nargs=? G let @a='' | silent execute 'g/<args>/y A' | tabnew | setlocal bt=nofile | put! a



  " open tree depending if it's a project
  function s:otree() abort
    if utils#root() == './'
        Tree
    else
        GTree
    endif
  endfunction

  " open tree in left navigator
  function s:vgtree() abort
    vertical topleft 40split
    let old_mappings = deepcopy(g:vimtree_mappings)
    let g:vimtree_mappings['e'] = { 'cmd': 'Tree_edit_open()', 'desc': 'edit in right window' } 
    let g:vimtree_mappings['q'] = { 'cmd': 'tree#close() \| close', 'desc': 'close (special)' } 
    call s:otree()
    let g:vimtree_mappings = old_mappings
  endfunction

  function Tree_edit_open() abort
    let path = tree#path()
    if len(tabpagebuflist()) == 1
        exec '80vsp ' . path
    else
        wincmd l
        exec 'e ' . path
    endif
  endfunction

  function s:termopen()
      let bufnr = index(map(range(1, bufnr('$')),
          \ {_,s -> getbufvar(s, '&ft')}), 'term') + 1
      if index(tabpagebuflist(), bufnr) != -1
          silent exe bufwinnr(bufnr) . 'close'
      endif
      belowright 13sp | exec bufnr > 0 ? bufnr . 'b' : 'term'
  endfunction

"}}}
" notes {{{
"
" CTRL-] is equivalent to nnoremap <c-]> :silent exec 'tag /' . expand('<cword>')<CR>
"
" }}}
