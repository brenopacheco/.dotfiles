--- Keymaps

-- stylua: ignore
local keyboard = {
  leader = ' ',
  mappings = {
    window = { -- [[
      { { 'n',     }, '<space>w',      '<c-w>',                 {                                 } },
    }, -- ]]
    defaults = { -- [[
      { { 'i',     }, 'jk',         '<c-[>l'                                 },
      { { 'i',     }, 'kj',         '<c-[>l'                                 },
      { { 's',     }, 'jk',         '<esc>'                                  },
      { { 's',     }, 'kj',         '<esc>'                                  },
      { { 'c',     }, 'jk',         '<esc>'                                  },
      { { 'c',     }, 'kj',         '<esc>'                                  },
      { { 't',     }, 'jk',         '<C-\\><C-n>'                            },
      { { 't',     }, 'kj',         '<C-\\><C-n>'                            },
      { { 'x',     }, '<',          '<gv'                                    },
      { { 'x',     }, '>',          '>gv'                                    },
      { { 'n',     }, '>',          '>>'                                     },
      { { 'n',     }, '<',          '<<'                                     },
      { { 'n',     }, '',         '<cmd>nohlsearch<cr>'                    },
      { { 'n',     }, 'Y',          'v$hy'                                   },
      { { 'n',     }, 'Q',          '<Nop>'                                  },
      { { 'x',     }, 'p',          'pgvy'                                   },
      -- { { 's',     }, '<bs>',       '<bs>i'                                  },
      { { 'x',     }, '*',  [["zy/\V<C-r>=escape(@z, '\/')<cr><cr>]]         },
    } -- ]]
  },
  abbreviations = {
    go = { -- [[
      ['eq']  = ':=',
      ['ife'] = 'if err != nil {<cr><cr>}<up><tab>',
      ['fn']  = 'func() {}<left><cr>.<cr><up><tab><del>',
    } -- ]]
  }
}

-- [[ setup

for _, group in pairs(keyboard.mappings) do
	for _, map in pairs(group) do
		local status, _ = pcall(vim.keymap.set, unpack(map))
		if not status then
			vim.notify(
				'Failed to set keymap: ' .. vim.inspect(map),
				vim.log.levels.ERROR
			)
		end
	end
end
