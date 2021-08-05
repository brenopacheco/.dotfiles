let g:fennel_dir = get(g:, 'fennel_dir', $HOME . '/.cache/nvim/fnl')

" TODO: 1. remove files from fennel_dir that are not in the original dict
" 	2. write this plugin in fennel
fun! fennel#compile()
    if !executable('fennel')
        echohl WarningMsg
        echo 'The fennel executable must be installed'
        echohl None
        return
    endif
    set efm=Parse\ error\ in\ %f:%l
    let dict = {}
    let dirs = split(&runtimepath, ',')
    for dir in dirs
        let files = split(globpath(dir, '**/*.fnl'), '\n')
        if !empty(files)
            let dict[dir] = files
        endif
    endfor
    let errors = []
    let fs_errors = []
    let transpilations = []
    for dir in keys(dict)
        let paths = dict[dir]
        let basedir = g:fennel_dir . '/' . substitute(dir, '/', '#', 'g')
        for path in paths
            let output = basedir . substitute(fnamemodify(path, ':r'), dir, '', '') . '.lua'
            let dirname = fnamemodify(output, ':h')
            let &runtimepath.=','.basedir
            if !isdirectory(dirname)
                call mkdir(dirname, 'p')
            endif
            if getftime(path) > getftime(output)
                let res = systemlist('fennel --compile ' . path)
                if v:shell_error
                    let errors += [ { 'file': path, 'error': res } ]
                else
                    try
                        call writefile(res, output)
                        let transpilations += [{ 'fnl': path, 'lua': output }]
                    catch /.*/
                        let fs_errors += v:exception
                    endtry
                endif
            endif
        endfor
    endfor
    if !empty(transpilations)
        let files = map(copy(transpilations), { _,trans -> trans.fnl })
        echomsg 'Fennel transpiled files: ' . join(files, ' ')
    endif
    if !empty(errors)
        let error_file = tempname()
        let messages = map(copy(errors), { _,entry -> entry['error'] })
        let files = map(copy(errors), { _,entry -> entry['file'] })
        echomsg 'Fennel compilation failed for files: ' . join(files, ' ')
        call writefile(flatten(messages, 1), error_file)
        exec 'cgetfile ' error_file | copen | wincmd p
    endif
    " TODO: cleanup. remove files in g:fennel_dir that are not in the
    " runtimepath
    return {
    \   'errors': errors,
    \   'transpilations': transpilations
    \ }
endf
