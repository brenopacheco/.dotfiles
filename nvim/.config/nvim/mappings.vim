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
  xmap ga :EasyAlign<cr>
  nmap ga :EasyAlign<cr>
  " map  + <Plug>(wildfire-fuel)
  " vmap - <Plug>(wildfire-water)
  nmap <CR> <Plug>(wildfire-fuel)
  vmap <Backspace> <Plug>(wildfire-water)
  nnoremap - :OTree<CR>
  " nnoremap - :GTree<CR>

"}}}
" NAVIGATION {{{
  " e: errors,      s: stack(tags), t: tags
  " a: arglist,     b: buffer,      q: quickfix
  " c: gitchunk     l: loclist      c: diffnext
  " L: loc history  Q: qf history
  nnoremap ]s :tag<CR>    | nnoremap [s :pop<CR>
  nnoremap ]t :tnext<CR>  | nnoremap [t :tprevious<CR>
  nnoremap ]a :next<CR>   | nnoremap [a :previous<CR>
  nnoremap ]b :bnext<CR>  | nnoremap [b :bprevious<CR>
  nnoremap <silent> ]q :try \| cnext \| catch \| cfirst \| catch \| endtry<CR>
  nnoremap <silent> [q :try \| cprev \| catch \| clast \| catch \| endtry<CR>
  nnoremap ]l :lnext<CR>  | nnoremap [l :lprevious<CR>
  nnoremap ]L :lnewer<CR> | nnoremap [L :lolder<CR>
  nnoremap ]Q :cnewer<CR> | nnoremap [Q :colder<CR>
  nmap ]c <plug>(signify-next-hunk) 
  nmap [c <plug>(signify-prev-hunk)
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
"}}}
" HELP{{{
  nnoremap <leader>? :Hydra help<CR>
  nnoremap <silent> <leader>r :Rename<CR>
"}}}
" SEARCH/QF {{{

    " _*  grep word under cursor / selection
    " _/  grep input
    nnoremap <leader>*       :silent exec 'grep! "' . expand('<cword>') . '" ' . <SID>root()<CR>:copen<CR>:wincmd p<CR>
    vnoremap <leader>/       "zy:silent exec 'grep! "' . @z . '" ' . <SID>root()<CR>:copen<CR>:wincmd p<CR>
    nnoremap <expr><leader>/ ':silent grep! "" '. Root() .' \| copen \| wincmd p<Home><C-right><C-right><C-right><Left>'

    " q*  grep word under cursor / selection
    " q/  grep input
    nnoremap q*              :silent exec 'grep! "' . expand('<cword>') . '" %'<CR>:copen<CR>:wincmd p<CR>
    vnoremap q*              "zy:silent exec 'grep! "' . expand('<cword>') . '" %'<CR>:copen<CR>:wincmd p<CR>
    nnoremap q/              :silent grep! "" % \| copen \| wincmd p<Home><C-right><C-right><C-right><Left>

    " substitute word under cursor
    nnoremap <expr><leader>s ':%s/'.expand('<cword>').'/'.expand('<cword>').'/g<left><left>'
    nnoremap <expr><leader>S :Rename<CR>

    " nnoremap qv :QFReject<CR>
    " nnoremap qf :QFKeep<CR>
    " nnoremap qr :QFRestore<CR>

" }}}
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

  command! Vimrc          :so ~/.config/nvim/init.vim
  command! Trim           :%s/\s\+$//e
  command! TabReplace     :%s/\t/    /g
  command! SpaceReplace   :%s/    /\t/g
  command! Format         :norm maggVG=`a
  command! Fork           :silent exec '!kitty & disown'
  command! NetrwToggle    :call s:toggle('netrw', 'Lexplore')
  command! TreeToggle     :call s:toggle('vimtree', 'VGTree')
  command! TerminalToggle :call s:toggle('term', 'TermOpen')
  command! QuickfixToggle :call s:toggle('qf', 'copen')
  command! VGTree         :call s:vgtree()
  command! OTree          :call s:otree()
  command! TermOpen       :call s:termopen()
  command! Args           :call fzf#run(fzf#wrap('FZF',{'source':argv(),'sink':'e',}))
  command! PFiles         :call fzf#vim#files(s:root(),fzf#vim#with_preview())
  command! Rename         :call s:rename()

  function s:otree() abort
    if s:root() == './'
        Tree
    else
        GTree
    endif
  endfunction

  function s:vgtree() abort
    if s:root() == './'
        VTree
    else
        vsp | GTree
    endif
  endfunction

  function! s:qf_filter(pat)
    let all = getqflist()
    for d in all
      if bufname(d['bufnr']) !~ a:pat && d['text'] !~ a:pat
          call remove(all, index(all,d))
      endif
    endfor
    call setqflist(all)
  endfunction


  function SearchList(A,L,P)
      return join(['**/*', '%', '*', '##'], "\n")
  endfunction

  function YesNo(A,L,P)
      return join(['n', 'y'], "\n")
  endfunction

  command! Root :echo s:root()
  function s:root() abort
     let l:root = system('git rev-parse --show-toplevel 2>/dev/null')
     let l:root = substitute(l:root, '\n', '', '')
     return len(l:root) == 0 ? './' : l:root
  endfunction

  function s:toggle(filetype, open) abort
      for i in range(1, winnr('$'))  " if buf is in a window, close
          let bnum = winbufnr(i)
          if getbufvar(bnum, '&ft') == a:filetype
              silent exe i . 'close'
              return
          endif
      endfor
      exec a:open
  endfunction

  function s:termopen()
      let bufnr = index(map(range(1, bufnr("$")), {_,s -> getbufvar(s, '&ft')}), "term") + 1
      echo "bufnr: " . bufnr
      belowright sp | exec bufnr > 0 ? bufnr . "b" : "term"
  endfunction

  function Jump(filetype, open) abort
      for i in range(1, winnr('$'))
          let bnum = winbufnr(i)
          if getbufvar(bnum, '&ft') == a:filetype
              silent call win_gotoid(win_getid(i))
              return
          endif
      endfor
      silent exec a:open
  endfunction

  function s:rename()
    let old_ignc  = &ignorecase
    let old_repo  = &report
    set noignorecase
    set report=0
    norm mR
    let word      = expand('<cword>')
    let replace   = input('global replace: ' . word . ' -> ', word)
    let root  = system('git rev-parse --show-toplevel 2>/dev/null')
    let root  = substitute(root, '\n', '', '')
    let root  = len(root) == 0 ? './' : root
    let files = substitute(system('fd "." -t f -a ' . root), '\n', ' ', 'g')
    let buffers = join(map(split(execute('ls', 'silent'), "\n"), 
          \ { _,s -> matchstr(s, '".*"')[1:-2] }), ' ')
    let cmd       = 'set hidden | %s/' . word . '/' . replace . '/gie | echo "-> ".expand("%")'
    exec 'args ' . files . ' ' . buffers
    exec 'args ' . join(uniq(sort(argv())), ' ')
    let substitutions = split(execute('argdo '.cmd,'silent'), '\n')
    let i = 0
    for line in substitutions
        if len(matchstr(line, 'substitution')) > 0
          echo substitutions[i+1] . ": " . line
        endif
        let i = i + 1
    endfor
    let &ignorecase = old_ignc
    let &report     = old_repo
    norm 'R
  endfunction

  function g:Root() abort
     let l:root = system('git rev-parse --show-toplevel 2>/dev/null')
     let l:root = substitute(l:root, '\n', '', '')
     return len(l:root) == 0 ? './' : l:root
  endfunction


  function g:Buflist() abort
      return map(split(execute('ls', 'silent'), "\n"), 
          \ { _,s -> matchstr(s, '".*"')[1:-2] })
  endfunction


    let preview_file = $HOME.'/.fzf/bin/preview.sh'
    command! -bang -nargs=* Tags
      \ call fzf#vim#tags(<q-args>, {
      \      'options': '
      \         --with-nth 1,2
      \         --prompt "=> "
      \         --preview-window="50%"
      \         --preview ''' . preview_file . ' {2}:$(echo {3} | cut -d ";" -f 1)'''
      \ }, <bang>0)

"}}}
" autocmds {{{

    au Filetype vim set foldmethod=marker

" }}}
