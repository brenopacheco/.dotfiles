local wilder = require("wilder")

local gradient = {
	"#f4468f",
	"#fd4a85",
	"#ff507a",
	"#ff566f",
	"#ff5e63",
	"#ff6658",
	"#ff704e",
	"#ff7a45",
	"#ff843d",
	"#ff9036",
	"#f89b31",
	"#efa72f",
	"#e6b32e",
	"#dcbe30",
	"#d2c934",
	"#c8d43a",
	"#bfde43",
	"#b6e84e",
	"#aff05b",
}

for i, fg in ipairs(gradient) do
	gradient[i] = wilder.make_hl("WilderGradient" .. i, "Pmenu", {
		{ a = 1 },
		{ a = 1 },
		{ foreground = fg },
	})
end

wilder.set_option(
	"renderer",
	wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
		highlights = {
			gradient = gradient,
		},
		highlighter = wilder.highlighter_with_gradient({
			wilder.basic_highlighter(),
		}),
		border = "rounded",
		pumblend = 20,
		left = { " ", wilder.popupmenu_devicons() },
		right = { " ", wilder.popupmenu_scrollbar() },
	}))
)

wilder.setup({
	modes = { ":" },
	next_key = nil,
	previous_key = nil,
	accept_key = nil,
	reject_key = "<C-x>",
	accept_completion_auto_select = 0,
  enable_cmdline_enter = 0
})

vim.cmd([[
  cmap <expr> <C-n> wilder#next()
  cmap <expr> <Tab> wilder#next()
  cmap <expr> <C-p> wilder#previous()
  cmap <expr> <Tab> wilder#can_accept_completion() ?
      \ wilder#accept_completion(0) :
      \ "\<C-n>"
  cmap <expr> <C-x> wilder#can_reject_completion() ?
      \ wilder#reject_completion() :
      \ "\<C-w>"
]])
