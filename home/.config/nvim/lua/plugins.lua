--- Plugins

-- TODO:
-- + replace completion plugin with https://cmp.saghen.dev/
-- + replace nvim-lspconfig with v0.11 built-in lsp.config
--   https://github.com/neovim/neovim/discussions/32523#discussioncomment-12256014
-- + replace hedyhli/outline.nvim
-- + verify which modules are being used

-- stylua: ignore start
vim.z.packadd({
	{ 'nvim-lua/plenary.nvim'                                                        },
	{ 'tpope/vim-fugitive'                                                           },
	{ 'lewis6991/gitsigns.nvim',                       as = 'gitsigns'               },
	{ 'bluz71/vim-nightfly-guicolors',                 as = 'vim-nightfly-guicolors' },
	-- { 'Everblush/nvim',                                as = 'everblush'              },
	{ 'kyazdani42/nvim-web-devicons',                  as = 'nvim-web-devicons'      },
	{ 'norcalli/nvim-colorizer.lua',                   as = 'nvim-colorizer'         },
	{ 'shellRaining/hlchunk.nvim',                     as = 'hlchunk'                },
	{ 'kylechui/nvim-surround'                                                       },
	{ 'junegunn/vim-easy-align'                                                      },
	{ 'sbdchd/neoformat'                                                             },
	{ 'danymat/neogen'                                                               },
	{ 'kyazdani42/nvim-tree.lua',                      as = 'nvim-tree'              },
	{ 'stevearc/oil.nvim',                             as = 'oil'                    },
	{ 'j-hui/fidget.nvim',                             as = 'fidget'                 },
	{ 'nvim-lualine/lualine.nvim',                     as = 'lualine'                },
	{ 'zbirenbaum/copilot.lua',                        as = 'copilot'                },
	{ 'L3MON4D3/LuaSnip'                                                             },
	{ 'saadparwaiz1/cmp_luasnip'                                                     },
	{ 'onsails/lspkind.nvim'                                                         },
	{ 'hrsh7th/cmp-nvim-lsp'                                                         },
	{ 'hrsh7th/cmp-buffer'                                                           },
	{ 'hrsh7th/cmp-path'                                                             },
	{ 'hrsh7th/nvim-cmp'                                                             },
	{ 'windwp/nvim-autopairs'                                                        },
	{ 'b0o/schemastore.nvim',                          as = 'schemastore'            },
	{ 'neovim/nvim-lspconfig'                                                        },
	{ 'ray-x/lsp_signature.nvim',                      as = 'lsp-signature'          },
	{ 'chrishrb/gx.nvim',                              as = 'gx'                     },
	{ 'pmizio/typescript-tools.nvim',                  as = 'typescript-tools'       },
	{ 'nvim-treesitter/nvim-treesitter'                                              },
	{ 'nvim-treesitter/nvim-treesitter-textobjects'                                  },
	{ 'JoosepAlviste/nvim-ts-context-commentstring'                                  },
	{ 'numToStr/Comment.nvim',                         as = 'Comment'                },
	{ 'folke/todo-comments.nvim',                      as = 'todo-comments'          },
	{ 'simrat39/symbols-outline.nvim',                 as = 'symbols-outline'        },
	{ 'nvim-telescope/telescope.nvim',                 as = 'telescope'              },
	{ 'HiPhish/rainbow-delimiters.nvim',               as = 'rainbow-delimiters'     },
	{ 'Bekaboo/dropbar.nvim',                          as = 'dropbar'                },
	{ 'monkoose/matchparen.nvim',                      as = 'matchparen'             },
	{ 'brenopacheco/neodev.nvim',                      as = 'neodev'                 }, -- replace with 'folke/lazydev.nvim' and make vim global (slow loading)
	{ 'brenopacheco/gitlinker.nvim',                   as = 'gitlinker'              }, -- removes default keybinding
	{ 'brenopacheco/vim-floaterm'                                                    }, -- fixes Vim:E444 on-close last window
	{ 'brenopacheco/zk-nvim'                                                         }, -- loads ~/.config/zk/config.toml:notebook.dir
})
-- stylua: ignore end

vim.z.modload({
	'autochdir',
	'backup',
	'bufferizer',
	'file-url',
	'foldtext',
	'gpg',
	'last-place',
	'log',
	'macro-recording-unmap',
	'pdf',
	'reloader',
	'shada',
	'sniputil',
	'telescope-select',
	'trim',
	'yank-highlight',
})
