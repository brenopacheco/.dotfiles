

local function _map(...)
  for _,v in pairs({...}) do
    vim.api.nvim_set_keymap(unpack(v))
  end
end

local l = function(key) return "<leader>" .. key end

_map(
    {"i", "jk", "<C-[>l", { noremap = true }},
    {"i", "kj", "<C-[>l", { noremap = true }},
    {"c", "jk", "<C-c>", { noremap = true }},
    {"c", "kj", "<C-c>", { noremap = true }},
    {"n", l("b"), "<cmd>lua cfn.goto_buf()<CR>", { noremap = true }},
    {"n", "#", ":so %<CR>", { noremap = true}},
    {"n", l("t"), ":Telescope<CR>", { noremap = true}},
    {"n", l("fv"), ":lua require('plugins/telescope').dotfiles()<CR>", { noremap = true}}
)

_G.cfn = {}
_G.cfn.goto_buf = function()
    vim.api.nvim_command('ls')
    local buf = vim.api.nvim_eval("input('> ', '', 'buffer')")
    -- TODO: check if buf is a string, if so get bufnr from string
    vim.api.nvim_set_current_buf(buf)
end

--[[
what do i want
    1. jumps
        cnext,cprev,copen,
        lnext(e]),lprev,lopen,
        bn,bp,b jump
    2. qf/ll filters
    3. align, surround, comment
 ]]


vim.cmd([[
inoremap <silent><expr> <C-Space> pumvisible() ? compe#close() : compe#complete()
inoremap <silent><expr> <TAB>     compe#confirm({'keys': '<TAB>', 'select': v:true})
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-b>     compe#scroll({ 'delta': -4 })
]])



vim.cmd([[
smap <Backspace> a<Backspace>
inoremap <silent> <C-k> <cmd>lua require'luasnip'.jump(1)<Cr>
inoremap <silent> <C-j> <cmd>lua require'luasnip'.jump(-1)<Cr>
vnoremap <silent> <C-k> <cmd>lua require('luasnip').jump(1)<Cr>
vnoremap <silent> <C-j> <cmd>lua require('luasnip').jump(-1)<Cr>

" smap <Backspace> a<Backspace>
" inoremap <silent> <C-k> <Plug>(vsnip-jump-next)<CR>
" inoremap <silent> <C-j> <Plug>(vsnip-jump-prev)<CR>
" vnoremap <silent> <C-k> <Plug>(vsnip-jump-next)<CR>
" vnoremap <silent> <C-j> <Plug>(vsnip-jump-prev)<CR>
" xmap s <Plug>(vsnip-cut-text)
]])
