--[[
██╗███╗   ██╗██╗████████╗   ██╗     ██╗   ██╗ █████╗
██║████╗  ██║██║╚══██╔══╝   ██║     ██║   ██║██╔══██╗
██║██╔██╗ ██║██║   ██║      ██║     ██║   ██║███████║
██║██║╚██╗██║██║   ██║      ██║     ██║   ██║██╔══██║
██║██║ ╚████║██║   ██║   ██╗███████╗╚██████╔╝██║  ██║
╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
                              Breno Leonhardt Pacheco
                             brenoleonhardt@gmail.com


1. debugger setup
2. tmux configuration
3. quick oversal fixes
  a. context aware grep/star fix/better behavior
  b. make jumplist not keep {}][ jumps
  c. add harpoon like behavior (maybe use arglist) or marks
  d. swap nvim-compe for nvim-cmp
  e. terminal management (termfloat behavior)
  f. fix quickix.lua
4. tasks and tests runners
  a. context-aware source/run/make (source %, lua %, make <target>, npm)
  b. constex-aware run tests - single, suite
  c. context-aware run debugger
  c. general task runner (e.g: prompt, create terminal and pipe result)
5. tree file nav: choose and configure (netwr, vim-tree, neotree)
6. re-do keymaps based on usage
7. plugin cleanup, selection and configuration
8. write own window manager
9. ansible configuration for system setup

Compile and install neovim from source: (are all flags necessary?)
sudo make install CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/usr"
--]]

-- require('quickfix')
require('options')
require('keymap')
require('backup')
require('plugs')
require('colors')
require('commands')
require('autocmd')
require('globals')
require('util.reloader')
_G.u = require('utils')
