require('luasnip').setup({
	history = true,
	delete_check_events = 'TextChanged',
})


require("luasnip.loaders.from_vscode").load()

-- require("luasnip.loaders.from_vscode").load({paths = "./my_snippets"})

-- keys = {
--     {
--       "<tab>",
--       function()
--         return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
--       end,
--       expr = true, silent = true, mode = "i",
--     },
--     { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
--     { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
--   },
