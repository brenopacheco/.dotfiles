
https://github.com/mfussenegger/nvim-dap
https://github.com/igorlfs/nvim-dap-view
https://github.com/pocco81/dap-buddy.nvim
https://github.com/niuiic/dap-utils.nvim

start          - launch or attach, both program and debugger
restart        - stop → start again with the same configuration

continue       - resume execution
pause          - interrupt program, like with a breakpoint but wherever we are

disconnect     - detach debugger, program may continue
terminate      - exit program and debugger

step over      - (next) executes line, does not enter function call
step in        - executes line, steps into function call
step out       - run until the current function returns
breakpoint     - set or toggle, with/without condition, with/without message

run to cursor  - temporarily set breakpoint, run to point, untoggle
hover          - set value under cursor
repl
