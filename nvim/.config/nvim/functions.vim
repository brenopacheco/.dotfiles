" ClearCache{{{

command! ClearCache :call s:clear_cache()

fun! s:clear_cache()
    let s:base_dir = expand('~/.cache/nvim/')
    let s:cache_files = [ 'swap', 'backup', 'undo' ]
    for cache_file in s:cache_files
        echo 'rm -f ' . s:base_dir . cache_file . '/*'
        echo system('rm -f ' . s:base_dir . cache_file . '/*')
    endfor
endf

"}}}
" GPG {{{

"encrypt, armor, sign, quiet
command! GPGEncrypt silent exec 'g/^gpg:/d' | exec '%!gpg -easq'

"decrypt, quiet
command! GPGDecrypt exec '%!gpg -dq' | silent exec 'g/^gpg:/d'

"}}}
" Make {{{

" mvn targets for :make   -> [ 'validate', 'clean', 'compile', 'package', 'test', 'install' ] 
" c/cpp targets for :make -> systemlist('cat ' . s:root() . '/Makefile  | egrep "^[a-z]+:" | cut -d: -f1') 
" npm scripts (terminal)  -> systemlist('npm run-script | sed -n "/^  [a-zA-Z]/p" | tr -d " "')

" }}}
" Run {{{

" Run the current file through an interpreter
" Results are shown in qf
command! -nargs=? Run :call s:run(<q-args>)

function s:root() abort
    let l:root = system('git rev-parse --show-toplevel 2>/dev/null')
    let l:root = substitute(l:root, '\n', '', '')
    return len(l:root) == 0 ? './' : l:root
endfunction

let s:interpreters = {
    \ "lua":        "export LUA_PATH=\"" . s:root() . "/?.lua;;\" && lua",
    \ "python":     "python",
    \ "sh":         "export PATH=$PATH:./ &&",
    \ "javascript": "node",
    \ "typescript": "ts-node",
    \}

fun! s:run(arg)
    try
        if &ft == 'vim'
            source %
            return
        endif
        let interpreter = s:interpreters[&ft]
        let file = tempname()
        let cmd = (a:arg ? a:arg : interpreter) . ' ' . expand('%:p') . ' >> ' . file
        silent call writefile(["[" . expand('%:p') . "] " . cmd , ""], file, "a")
        let jobid = jobstart(cmd, { 
            \   'on_stdout':   { j,d,e -> s:run_callback(file) }
            \ })
    catch /.*/
        echomsg v:exception
    endtry
endfun

fun! s:run_callback(file)
    let olderrorfmt = &efm
    set efm=%E[%f]%m,%+Cm
    exec 'cf! '. a:file
    let &efm = olderrorfmt
    copen
    setlocal modifiable
    exe '%s/|//g'
    norm gg
    exec 's/^\(.\{-}\) \(.*\) >\(.*\)/[\2 >\3]'
    setlocal nomodifiable
    setlocal bufhidden=hide
    wincmd p
endf


" }}}
" Templates {{{

augroup templates
    au!
    au BufEnter * call s:templates()
augroup end

let g:template_dir = expand('~/.config/nvim/templates')
command! Template call s:templates()

fun! s:templates()
    if line('$') != 1 || getline(1) != '' | return | endif
    let templates = systemlist('ls ' . g:template_dir)
    let filename = expand('%')
    let template = ''
    for t in templates
        if match(filename, glob2regpat(t)) != -1
            let template = g:template_dir . '/' . t
            break
        endif
    endfor
    if template == '' | return | endif
    call append(0, readfile(template))
    " the next trick will evaluate vim expressions such as ${strftime("%c")}
    silent exec '%s/\${\(.\{-}\)}/\=eval(submatch(1))/e'
endf


" }}}
" FZFSnippets{{{

fun! s:source_snippets()
    let l:sources = eval(join(vsnip#source#find(bufnr('%')), '+'))
    return sort(map(l:sources, { _,s -> printf("%-15s%-20s%-30s", 
        \ s.prefix[0],  s.label, s.description)}))
endf

fun! s:sink_snippet(snippet)
    let prefix = matchstr(a:snippet, '^\S\+')
    exec 'norm i' . prefix . "\<plug>(vsnip-expand)"
endf

command! Snippets :call fzf#run(fzf#wrap('FZF',{
    \ 'source': s:source_snippets(),
    \ 'sink': function('s:sink_snippet')
    \ }))

nnoremap <leader>i :Snippet<CR>
"}}}
