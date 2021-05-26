" File: autoload#lsp.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 22, 2021
" Description:
" TODO: everything
"

" GOTO ======================================================================

fun! lsp#goto_definition()
    if lsp#is_on()
        lua vim.lsp.buf.definition()
    else
        exec 'tag /' . expand('<cword>')
    endif
endf


fun! lsp#goto_references()
    if lsp#is_on()
        lua vim.lsp.buf.references()
    else
        throw 'Not implemented'
    endif
endf

fun! lsp#goto_implementation()
    if lsp#is_on()
        lua vim.lsp.buf.implementation()
    else
        throw 'Not implemented'
    endif
endf

fun! lsp#goto_type_definition()
    if lsp#is_on()
        lua vim.lsp.buf.type_definition()
    else
        throw 'Not implemented'
    endif
endf

fun! lsp#goto_document_symbol()
    if lsp#is_on()
        lua vim.lsp.buf.document_symbol()
    else
        throw 'Not implemented'
    endif
endf

fun! lsp#goto_workspace_symbol()
    if lsp#is_on()
        lua vim.lsp.buf.workspace_symbol()
    else
        throw 'Not implemented'
    endif
endf

" SHOW HELP =================================================================

fun! lsp#scrolldown_hover()
    lua require('lspsaga.action').smart_scroll_with_saga(1)
endf

fun! lsp#scrollup_hover()
    lua require('lspsaga.action').smart_scroll_with_saga(-1)
endf

fun! lsp#show_hover()
    lua require('lspsaga.hover').render_hover_doc()
endf

fun! lsp#show_definition()
    lua require'lspsaga.provider'.preview_definition()
endf

fun! lsp#show_signature_help()
    lua require('lspsaga.signaturehelp').signature_help()
endf

" DIAGNOSTICS ===============================================================

fun! lsp#goto_next_diagnostic()
    lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()
endf

fun! lsp#goto_prev_diagnostic()
    lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()
endf

fun! lsp#show_line_diagnostic()
    lua require'lspsaga.diagnostic'.show_line_diagnostics()
endf

fun! lsp#toggle_diagnostics()
    let open = 'exec "lua vim.lsp.diagnostic.set_loclist()" | wincmd p'
    call utils#toggle('qf', open)
endf

" ACTIONS ===================================================================

fun! lsp#code_action(range) abort
    try
        if &ft ==# 'java'
            lua vim.lsp.buf.code_action()
            return
        endif
        if a:range
            '<,'>lua require('lspsaga.codeaction').range_code_action()
        else
            lua require('lspsaga.codeaction').code_action()
        endif
    catch /.*/
        echohl WarningMsg | echo 'No action here' | echohl None
    endtry
endf

fun! lsp#rename()
    lua require('lspsaga.rename').rename()
endf

fun! lsp#format() range
    let visual = v:false
    if mode() == 'v'
        exe "normal! \<ESC>"
        let visual = v:true
    endif
    if !s:equalprg_format(visual)
        call s:indentexpr_format(visual)
    endif
endf

fun! s:lsp_format(visual)
    " TODO: this doesnt work right. gotta be redone
endf

fun! s:equalprg_format(visual) range
    if &equalprg ==# "" | return v:false | endif
    let linenr = line('.')
    let err = ''
    if a:visual
        silent exec "'<,'>!" . &equalprg
    else
        silent exec '1,$! ' . &equalprg
    endif
    let err = getbufline(bufnr(), 1, '$')
    if v:shell_error != 0
        undo
        exec linenr
        echohl WarningMsg 
        echomsg '> Equalprg ' . &equalprg . ' failed...'
        echohl None
        for line in err
            echoerr line
        endfor
        return v:false
    endif
    exec linenr
    echohl WarningMsg | echomsg '> Formated with ' . &equalprg | echohl None
    return v:true
endf

fun! s:indentexpr_format(visual)
    let l:equalprg = &equalprg
    set equalprg=
    if a:visual
        norm! =
    else
        silent! norm! mzggVG=`z
    endif
    let &equalprg = l:equalprg
    echohl WarningMsg | echomsg "> Formated with indentexpr" | echohl None
    return v:true
endf

" SERVERS ===================================================================

fun! lsp#is_on()
    return luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
endf

fun! lsp#status() abort
    if lsp#is_on()
        let errornr = luaeval('vim.lsp.diagnostic.get_count(0, [[Error]])')
        let warnnr  = luaeval('vim.lsp.diagnostic.get_count(0, [[Warning]])')
        let hintnr  = luaeval('vim.lsp.diagnostic.get_count(0, [[Hint]])')
        let infonr  = luaeval('vim.lsp.diagnostic.get_count(0, [[Information]])')
        " return 'E['.errornr.'] W['. warnnr.'] H[' . hintnr.']'
        return 'EWHI['.errornr.'|'.warnnr.'|'.hintnr.'|'.infonr.']'
    else
        return 'LSP off'
    endif
endfunction

fun! lsp#servers()
    let info = luaeval('vim.inspect(vim.lsp.buf_get_clients())')
    let info = split(info, "\n")
    tabnew
    call appendbufline(bufnr(), 0, info)
    norm! gg
endf

fun! lsp#info()
    LspInfo
endf

fun! lsp#log()
    let path = luaeval('vim.lsp.get_log_path()')
    vsp
    exec 'e ' . path
endf


" HELPER FUNCS ==============================================================

""
" command complete used with -complete=customlist,lsp#funcs
" {required} a:1 = cmd prefix, a:2 = cmd origin, a:3 = length
fun! lsp#cmd_complete(...)
    return sort(filter(map(split(execute('function /^lsp#'), "\n"),
        \ { _,s -> matchstr(s[13:-1], '^\S\+()')[0:-3] }),
        \ { _,s -> match(s, '^' . a:1) != -1 }),
        \ { x,y -> len(x) - len(y) })
endf

""
" execute lsp#command by it's name.
" i.e: lsp#cmd_exec('goto_definition')
fun! lsp#cmd_exec(name)
    exec 'echo lsp#'.a:name.'()'
endf
