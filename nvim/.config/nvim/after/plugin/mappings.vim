" File: after/plugin/mappings.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 23, 2021
" Description: mappings setup

" DEFAULTS
    nnoremap Y :norm v$hy<cr>
    nnoremap Q <Nop>
    xnoremap p pgvy
    xnoremap <expr> p 'pgv"'.v:register.'y`>'
    xnoremap < <gv
    xnoremap > >gv
    nnoremap > >>
    nnoremap < <<
    inoremap jk <C-[>l
    inoremap kj <C-[>l
    xnoremap * "zy/\V<C-r>=escape(@z, '\/')<CR><CR>
    nnoremap  :nohlsearch<CR>
    nnoremap <silent> ]<space>  :<C-u>call append(line("."),   repeat([""], v:count1))<CR>
    nnoremap <silent> [<space>  :<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>
    nnoremap # yy:@"<CR>
    xnoremap # y:@"<CR>
    nmap "" 0v$hS"
    xmap ga :EasyAlign<cr>
    nmap ga :EasyAlign<cr>
    xmap gp :call Justify('tw',4)<CR>
    xmap gl :s/\s\+/ /g<CR>
    nmap <CR> <Plug>(wildfire-fuel)
    xmap <CR> <Plug>(wildfire-fuel)
    xmap <Backspace> <Plug>(wildfire-water)
    nnoremap <leader>- :Tree<CR>
    runtime macros/justify.vim
" NAVIGATION
    nnoremap <silent> ]s :tag<CR>    
    nnoremap <silent> [s :pop<CR>
    nnoremap <silent> ]t :tnext<CR>  
    nnoremap <silent> [t :tprevious<CR>
    nnoremap <silent> ]a :next<CR>   
    nnoremap <silent> [a :previous<CR>
    nnoremap <silent> ]b :bnext<CR>  
    nnoremap <silent> [b :bprevious<CR>
    nnoremap <silent> ]q <cmd>call quickfix#next()<CR>
    nnoremap <silent> [q <cmd>call quickfix#prev()<CR>
    nnoremap <silent> ]l :lnext<CR>  
    nnoremap <silent> [l :lprevious<CR>
    nmap <silent> ]c <plug>(signify-next-hunk) 
    nmap <silent> [c <plug>(signify-prev-hunk)
" FUZZY
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
    nnoremap <leader>'     :TerminalToggle<CR>
    nnoremap <leader>n     :TreeToggle<CR>
    nnoremap <leader><tab> :TagbarToggle<CR>
    nnoremap <leader>l     :Lf<CR>
    nnoremap <leader>u     :UndotreeToggle<CR>
    nnoremap <leader>q     :QuickfixToggle<CR>
    " nnoremap <leader>g     :Goyo<CR>
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
" PLUG
    nnoremap <leader>pi <cmd>PlugInstall<CR>
    nnoremap <leader>pc <cmd>PlugClean<CR>
    nnoremap <leader>pd <cmd>PlugDiff<CR>
    nnoremap <leader>pu <cmd>PlugUpdate<CR>
    nnoremap <leader>pr <cmd>Vimrc<CR>
" HELP
    nnoremap <leader>w? :call quickhelp#toggle("window")<CR>
    nnoremap <space>?   :call quickhelp#toggle("noft")<CR>
" SEARCH
    xnoremap <expr><leader>* quickfix#global_star()
    xnoremap <expr>q*        quickfix#buffer_star()
    nnoremap <leader>*       <cmd>call quickfix#global_star()<CR>
    nnoremap q*              <cmd>call quickfix#buffer_star()<CR>
    nnoremap <leader>/       <cmd>call quickfix#global_grep()<CR>
    nnoremap q/              <cmd>call quickfix#buffer_grep()<CR>
    nnoremap qf              <cmd>call quickfix#filter(input("QF/"))<CR>
    nnoremap qp              <cmd>call quickfix#colder()<CR>
    nnoremap qn              <cmd>call quickfix#cnewer()<CR>
" MISC
    " vnoremap <expr><leader>s tools#substitute()
    " nnoremap <leader>s       tools#substitute()<CR>
    " nnoremap <leader>g       tools#global()<CR>
    nnoremap <expr><leader>s ':%s/'.expand('<cword>').'/'.expand('<cword>').'/g<left><left>'
    xnoremap <leader>s "zy:%s/<c-r>z/<c-r>z/g<left><left>
    nnoremap <expr><leader>gg ":g//y A \| tabnew \| setlocal bt=nofile \| put! a\<Home>\<Right>\<Right>"
" MAKE 
    " nnoremap <leader>fm :Make<CR>
    " nnoremap <leader># :Run<CR>
    " nnoremap <leader>m :make % \| copen \| wincmd p<CR>

" LSP
    nnoremap <silent> <C-]>    <cmd>call lsp#goto_definition()<CR>
    nnoremap <silent> gd       <cmd>call lsp#goto_declaration()<CR>
    nnoremap <silent> gr       <cmd>call lsp#goto_references()<CR>
    nnoremap <silent> gi       <cmd>call lsp#goto_implementation()<CR>
    nnoremap <silent> gy       <cmd>call lsp#goto_type_definition()<CR>
    nnoremap <silent> go       <cmd>call lsp#goto_document_symbol()<CR>
    nnoremap <silent> gs       <cmd>call lsp#goto_workspace_symbol()<CR>
    nnoremap <silent><leader>= <cmd>call lsp#format()<CR>
    nnoremap <silent><leader>e <cmd>call lsp#toggle_diagnostics()<CR>
    nnoremap <silent>[e        <cmd>call lsp#goto_prev_diagnostic()<CR>
    nnoremap <silent>]e        <cmd>call lsp#goto_next_diagnostic()<CR>
    nnoremap <silent><leader>a <cmd>call lsp#code_action()<CR>
    nnoremap <silent><leader>r <cmd>call lsp#rename()<CR>
    nnoremap <silent><c-h>     <cmd>call lsp#show_signature_help()<CR>
    nnoremap <silent><c-k>     <cmd>call lsp#show_hover()<CR>
    nnoremap <silent><c-p>     <cmd>call lsp#show_preview()<CR>
    nnoremap <silent><c-d>     <cmd>call lsp#show_line_diagnostic()<CR>
    nnoremap <silent><C-n>     <cmd>call lsp#scrolldown_hover()<CR>
    nnoremap <silent><C-p>     <cmd>call lsp#scrollup_hover()<CR>
