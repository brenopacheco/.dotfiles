" File: dap.vim
" Author: Breno Leonhardt Pacheco
" Email: brenoleonhardt@gmail.com
" Last Modified: February 25, 2021
" Description:

fun! dap#start_restart()
    if luaeval("vim.inspect(require'dap'.session())") !=# "nil"
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
