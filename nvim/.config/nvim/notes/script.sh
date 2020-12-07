#!/bin/bash

# set of cmds to run with vim on a buffer
cat <<-EOF > cmds
    :norm ihello
    :norm ohello
    :g/el/s/llo/WOO
    :wq!
EOF

# -n : disable swap files
# -E : run as Ex mode (vim, not vi. vi is -e)
# -s : runs cmds silently
# file : file with buffer contents
# -S : source the file with cmds
# cmds.vim : file with vim ex-mode cmds

vim -E file -S cmds


