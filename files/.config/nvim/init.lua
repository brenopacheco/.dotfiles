--[[
██╗███╗   ██╗██╗████████╗   ██╗     ██╗   ██╗ █████╗
██║████╗  ██║██║╚══██╔══╝   ██║     ██║   ██║██╔══██╗
██║██╔██╗ ██║██║   ██║      ██║     ██║   ██║███████║
██║██║╚██╗██║██║   ██║      ██║     ██║   ██║██╔══██║
██║██║ ╚████║██║   ██║   ██╗███████╗╚██████╔╝██║  ██║
╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
                              Breno Leonhardt Pacheco
                             brenoleonhardt@gmail.com
-- version: 5b04e46d2
-- v0.8.0-dev+169-ge50b1fe60
-- make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/usr"
-- TODO:
-- context aware grep/star (monorepo/npm project)
-- make jumplist not keep {}][ jumps
-- add harpoon like behavior (maybe use arglist)
-- add fzf support as alternative to telescope
-- swap nvim-compe for nvim-cmp
-- fix source/run/make behavior (e.g: source %, lua %, make <target>)
-- add a test running plugin (run test under cursor, suite, etc)
-- fix terminal management (allow multiple, spawn new from cur dir, ]t/[t)
-- fix whichkey help
-- configure nvim-dap for node, go, lua, c#
-- easier map for cmd mode (e.g. spc-spc)
-- fix vim-tree WEIRD behavior
--]]

-- vim.go.packpath = vim.go.packpath .. "," .. vim.fn.stdpath("cache") .. '/paq'
-- require('quickfix')
require('options')
require('keymap')
require('backup')
require('plugs')
require('colors')
require('commands')
require('globals')

_G.u = require('utils')

require('reloader').config()
