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
  map  + <Plug>(wildfire-fuel)
  vmap - <Plug>(wildfire-water)
  nnoremap - :Tree<CR>
  nnoremap g- :RTree<CR>

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
  nnoremap ]q :cnext<CR>  | nnoremap [q :cprevious<CR>
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
  nnoremap <silent> <leader>fo :Btags<CR>
  nnoremap <silent> <leader>fm :Marks<CR>
  nnoremap <silent> <leader>fr :History<CR>
  nnoremap <silent> <leader>f: :History:<CR>
  nnoremap <silent> <leader>fh :Helptags<CR>
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
  nnoremap <leader>? :Hydra help<CR>
  nnoremap <silent> <leader>r :Rename<CR>
"}}}
" SEARCH/QF {{{

    nnoremap <silent> g*        :exec 'grep! "' . expand('<cword>') . '" %'<CR>:copen<CR>:wincmd p<CR>
    nnoremap <silent><leader>*  :exec 'grep! "' . expand('<cword>') . '" ' . <SID>root()<CR>:copen<CR>:wincmd p<CR>
	nnoremap g/ :silent grep! "" % \| copen \| wincmd p<Home><C-right><C-right><C-right><Left>
    nnoremap <expr><leader>/ ':silent grep! "" '. Root() .' \| copen \| wincmd p<Home><C-right><C-right><C-right><Left>'
    nnoremap <expr> <leader>s ':%s/'.expand('<cword>').'/'.expand('<cword>').'/g<left><left>'

	command! QFReject  :call Jump('qf', 'copen') | exec 'Reject ' . input(':Reject ') | wincmd p
	command! QFKeep    :call Jump('qf', 'copen') | exec 'Keep '   . input(':Keep ')   | wincmd p
	command! QFRestore :call Jump('qf', 'copen') | exec 'Restore' | wincmd p
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

  command! RTree          :exec 'aboveleft 30vsplit | Tree ' . <SID>root()
  command! TermOpen       :call s:termopen()
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
              " silent exe "bwipeout! " . bnum
			  silent exe i . 'close'
              return
          endif
      endfor
      silent exec a:open
  endfunction

  function s:termopen()
      let bufnr = index(map(range(1, bufnr("$")), {s -> getbufvar(s, '&ft')}), "term")
      vsp | exec bufnr > -1 ? bufnr . "b" : "term"
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

  function! Backup()
  	let b:timestamp = strftime('%Y-%m-%d_%Hh%Mm')
  	let b:expanded = expand('%:p')
  	let b:subst = substitute(b:expanded, "/", "\\\\%", "g")
  	let b:dir = g:backupdir
  	let b:backupfile = b:dir . b:timestamp . "_" . b:subst
  	silent exec ':w! ' b:backupfile
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



	command! Changes call s:changes()
	function s:changes() abort
		call writefile(reverse(split(execute('changes'),"\n"))[1:-2], '/tmp/changelist')
		call system('sed -i "/-invalid-$/d" /tmp/changelist')
		call system('sed -i "s/^ \+[0-9]\+ \+//" /tmp/changelist')
		call system("awk -F' ' '!_[$1]++' /tmp/changelist > /tmp/tmpfile && mv /tmp/tmpfile /tmp/changelist")
		call system('sed -i "s/\([0-9]\+\)\([ ]\+\)\([0-9]\+\)/\1:\3:/" /tmp/changelist')
		call system('sed -i "s/^/'.expand('%').':/" /tmp/changelist')
		cfile! /tmp/changelist
	endfunction

	let preview_file = $HOME.'/.fzf/bin/preview.sh'
	command! -bang -nargs=* Tags
	  \ call fzf#vim#tags(<q-args>, {
	  \      'down': '40%',
	  \      'options': '
	  \         --with-nth 1,2
	  \         --prompt "=> "
	  \         --preview-window="50%"
	  \         --preview ''' . preview_file . ' {2}:$(echo {3} | cut -d ";" -f 1)'''
	  \ }, <bang>0)

"}}}
"
"TODO unify grep/vimgrep/rg/quickfix
