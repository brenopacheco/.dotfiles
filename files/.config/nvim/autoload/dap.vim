" File: dap.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 25, 2021
" Description:

""
" Start or restart debugger.
fun! dap#start_restart()
    if dap#is_on()
        echo "Restarting..."
        lua require'dap'.run_last()
    else
        echo "Starting..."
        lua require"dap".continue()
    endif
endf

fun! dap#play_pause()
    try
        if luaeval('require"dap".session().stopped_thread_id')
            echo "Continuing..."
            lua require'dap'.continue()
        else
            echo "Pausing..."
            lua require'dap'.pause()
        endif
    catch
        call dap#start_restart()
    endtry
endf

fun! dap#goto()
    lua require'dap'.goto_(line('.'))
endf

fun! dap#step_over()
    lua require'dap'.step_over()
endf

fun! dap#step_out()
    lua require'dap'.step_out()
endf

fun! dap#step_in()
    lua require'dap'.step_into()
endf

fun! dap#toggle_breakpoint()
    lua require'dap'.toggle_breakpoint()
endf

fun! dap#breakpoints()
    lua require'dap'.list_breakpoints()
endf

fun! dap#stack_up()
    lua require'dap'.up()
endf

fun! dap#stack_down()
        lua require'dap'.down()
endf

fun! dap#hover()
    lua require'dap.ui.variables'.hover()
endf

fun! dap#scope()
    lua require'dap.ui.variables'.scopes()
endf

fun! dap#log()
    let log_path = luaeval('vim.fn.stdpath("cache")')
    let file_path = log_path . "/dap.log"
    exec 'vsplit | view  ' . file_path . ' | set autoread noswapfile'
endf

fun! dap#is_on()
    return luaeval("vim.inspect(require'dap'.session())") !=# "nil"
endf

fun! dap#session()
    if dap#is_on()
        tabnew
        set nobuflisted
        call append(0, split(luaeval("vim.inspect(require'dap'.session())"),"\n"))
    else
        echomsg "Dap has no session."
    endif
endf

fun! dap#adapter()
    tabnew
    set nobuflisted
    call append(0, split(luaeval("vim.inspect(require'dap')"),"\n"))
endf

" WINDOWS ===================================================================
"     The code window
"     The scopes window
"     The watch window
"     The call stack window.
"     The output window

fun! dap#toggle_watch()
    "
endf

fun! dap#toggle_call_stack()
endf

fun! dap#toggle_scope()
endf

fun! dap#toggle_repl()
    lua require'dap'.repl.toggle()
endf

