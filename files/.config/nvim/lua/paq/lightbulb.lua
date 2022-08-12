require'nvim-lightbulb'.update_lightbulb {
    sign = {
        enabled = true,
        priority = 10,
    }
}
vim.fn.sign_define("LightBulbSign", {text = "" --[[]], priority = 10})
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
