--[[
██╗███╗   ██╗██╗████████╗   ██╗     ██╗   ██╗ █████╗
██║████╗  ██║██║╚══██╔══╝   ██║     ██║   ██║██╔══██╗
██║██╔██╗ ██║██║   ██║      ██║     ██║   ██║███████║
██║██║╚██╗██║██║   ██║      ██║     ██║   ██║██╔══██║
██║██║ ╚████║██║   ██║   ██╗███████╗╚██████╔╝██║  ██║
╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
                              Breno Leonhardt Pacheco
                             brenoleonhardt@gmail.com
--]]

vim.z = {}
require('globals')
require('options')
require('packadd')
require('plugins')
require('keymaps')
vim.z.packadd({ 'folke/which-key.nvim' })
