" File: after/plugin/mappings.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 23, 2021
" Description: mappings setup

" TODO: refactor this

" DEFAULTS
    nnoremap Y           :norm v$hy<cr>
    nnoremap Q           <Nop>
    xnoremap p           pgvy
    xnoremap <expr>      p 'pgv"'.v:register.'y`>'
    xnoremap <           <gv
    xnoremap >           >gv
    nnoremap >           >>
    nnoremap <           <<
    inoremap jk          <C-[>l
    inoremap kj          <C-[>l
    xnoremap *           "zy/\V<C-r>=escape(@z, '\/')<CR><CR>
    nnoremap           :nohlsearch<CR>
    nnoremap <silent>    ]<space>  :<C-u>call append(line("."),   repeat([""], v:count1))<CR>
    nnoremap <silent>    [<space>  :<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>
    nmap     ""          0v$hS"
    xmap     ga          :EasyAlign<cr>
    nmap     ga          :EasyAlign<cr>
    nmap     <CR>        <Plug>(wildfire-fuel)
    xmap     <CR>        <Plug>(wildfire-fuel)
    xmap     <Backspace> <Plug>(wildfire-water)
    nnoremap <leader>-   :Tree<CR>
    nnoremap <leader>!   :Fork<CR>
    nnoremap <leader>Q   :qa!<CR>
    " runtime macros/justify.vim
    " xmap gp :call Justify('tw',4)<CR>
    " xmap gl :s/\s\+/ /g<CR>
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
    nmap     <silent> ]c <plug>(signify-next-hunk)
    nmap     <silent> [c <plug>(signify-prev-hunk)
" FUZZY
    nnoremap <silent> <leader>f~ <cmd>Files ~<CR>
    nnoremap <silent> <leader>f. <cmd>Files .<CR>
    nnoremap <silent> <leader>fg <cmd>GFiles?<CR>
    nnoremap <silent> <leader>fp <cmd>PFiles<CR>
    nnoremap <silent> <leader>fa <cmd>Args<CR>
    nnoremap <silent> <leader>fb <cmd>Buffers<CR>
    nnoremap <silent> <leader>ff <cmd>Sources<CR>
    nnoremap <silent> <leader>f/ <cmd>Rg<CR>
    nnoremap <silent> <leader>f* <cmd>exec 'Rg ' . expand("<cword>")<CR>
    nnoremap <silent> <leader>fs <cmd>Tags<CR>
    nnoremap <silent> <leader>fo <cmd>BTags<CR>
    nnoremap <silent> <leader>fm <cmd>Marks<CR>
    nnoremap <silent> <leader>fr <cmd>History<CR>
    nnoremap <silent> <leader>f: <cmd>History:<CR>
    nnoremap <silent> <leader>fh <cmd>Helptags<CR>
    nnoremap <silent> <leader>fi <cmd>Snippets<CR>
" TOGGLES
    nnoremap <leader>l     <cmd>Lf<CR>
    nnoremap <leader>'     <cmd>TerminalToggle<CR>
    nnoremap <leader>n     <cmd>TreeToggle<CR>
    nnoremap <leader><tab> <cmd>TagbarToggle<CR>
    nnoremap <leader>u     <cmd>UndotreeToggle<CR>
    nnoremap <leader>q     <cmd>QuickfixToggle<CR>
" WINDOWS
    nmap <leader>w <C-W>
    nnoremap <C-w>t :tabnew<CR>
    nnoremap <C-w>e :enew<CR>
    nnoremap <C-w>m <C-W>_<C-W>\|
    nnoremap <C-w>e :enew<CR>
" PLUG
    nnoremap <leader>pi <cmd>PlugInstall<CR>
    nnoremap <leader>pc <cmd>PlugClean<CR>
    nnoremap <leader>pd <cmd>PlugDiff<CR>
    nnoremap <leader>pu <cmd>PlugUpdate<CR>
    nnoremap <leader>pr <cmd>Vimrc<CR>
" HELP
    nnoremap <leader>w? <cmd>call quickhelp#toggle("window")<CR>
    nnoremap <space>?   <cmd>call quickhelp#toggle("noft")<CR>
" GREP/SEARCH
    xnoremap <leader>* <cmd>call quickfix#global_star()<CR>
    nnoremap <leader>* <cmd>call quickfix#global_star()<CR>
    nnoremap <leader>/ <cmd>call quickfix#global_grep()<CR>
    xnoremap q*        <cmd>call quickfix#buffer_star()<CR>
    nnoremap q*        <cmd>call quickfix#buffer_star()<CR>
    nnoremap q/        <cmd>call quickfix#buffer_grep()<CR>
    nnoremap qf        <cmd>call quickfix#filter(input("QF/"))<CR>
    nnoremap qs        <cmd>call quickfix#source()<CR>
    nnoremap qp        <cmd>call quickfix#colder()<CR>
    nnoremap qn        <cmd>call quickfix#cnewer()<CR>
" MISC
    xnoremap <leader>s <cmd>call tools#buffer_substitute()<CR>
    nnoremap <leader>s <cmd>call tools#buffer_substitute()<CR>
    xnoremap <leader>S <cmd>call tools#global_substitute()<CR>
    nnoremap <leader>S <cmd>call tools#global_substitute()<CR>
    nnoremap <leader>g <cmd>call tools#global_print()<CR>
" MAKE/EVAL
    nnoremap #          <cmd>call make#eval_line()<CR>
    xnoremap #          <cmd>call make#eval_range()<CR>
    nnoremap <leader>#  <cmd>call make#eval_buffer()<CR>
    nnoremap <leader>m  <cmd>call make#lint()<CR>
    nnoremap <leader>M  <cmd>call make#build()<CR>
" LSP
    nnoremap <silent> <C-]>    <cmd>call lsp#goto_definition()<CR>
    nnoremap <silent> gd       <cmd>call lsp#goto_declaration()<CR>
    nnoremap <silent> gr       <cmd>call lsp#goto_references()<CR>
    nnoremap <silent> gi       <cmd>call lsp#goto_implementation()<CR>
    nnoremap <silent> gy       <cmd>call lsp#goto_type_definition()<CR>
    nnoremap <silent> go       <cmd>call lsp#goto_document_symbol()<CR>
    nnoremap <silent> gs       <cmd>call lsp#goto_workspace_symbol()<CR>
    nnoremap <silent><leader>= <cmd>call lsp#format()<CR>
    xnoremap <silent><leader>= <cmd>call lsp#format()<CR>
    xnoremap <silent>=         <cmd>call lsp#format()<CR>
    nnoremap <silent><leader>e <cmd>call lsp#toggle_diagnostics()<CR>
    nnoremap <silent>[e        <cmd>call lsp#goto_prev_diagnostic()<CR>
    nnoremap <silent>]e        <cmd>call lsp#goto_next_diagnostic()<CR>
    nnoremap <silent><leader>a <cmd>call lsp#code_action(v:false)<CR>
    vnoremap <silent><leader>a :<c-u>call lsp#code_action(v:true)<CR>
    nnoremap <silent><leader>r <cmd>call lsp#rename()<CR>
    nnoremap <silent><c-h>     <cmd>call lsp#show_signature_help()<CR>
    inoremap <silent><c-k>     <cmd>call lsp#show_signature_help()<CR>
    nnoremap <silent><c-k>     <cmd>call lsp#show_hover()<CR>
    nnoremap <silent><c-p>     <cmd>call lsp#show_preview()<CR>
    nnoremap <silent><C-n>     <cmd>call lsp#scrolldown_hover()<CR>
    nnoremap <silent><C-p>     <cmd>call lsp#scrollup_hover()<CR>
" DAP
    nnoremap <F1>  <cmd>call dap#step_out()<CR>
    nnoremap <F2>  <cmd>call dap#step_in()<CR>
    nnoremap <F3>  <cmd>call dap#step_over()<CR>
    nnoremap <F4>  <cmd>call dap#play_pause()<CR>
    nnoremap <F5>  <cmd>call dap#start_restart()<CR>
    nnoremap <F6>  <cmd>call dap#toggle_breakpoint()<CR>
    nnoremap <F7> <cmd>call dap#hover()<CR>
    nnoremap <F8> <cmd>call dap#scope()<CR>
    nnoremap <F9>  <cmd>call dap#breakpoints()<CR>
    " nnoremap <F10> <cmd>call dap#toggle_repl()<CR>
    " nnoremap <F11>  <cmd>call dap#stack_up()<CR>
    " nnoremap <F12>  <cmd>call dap#stack_down()<CR>
    nnoremap <leader>d <cmd>call quickhelp#toggle("debug")<CR>
