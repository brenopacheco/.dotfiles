require("lsp_signature").setup({
    bind = true,
    handler_opts = {border = "single"},
    use_lspsaga = false,
    hint_prefix = "  ",
    max_height = 6,
    max_width = 20,
    floating_window = true,
    zindex = 50
})
