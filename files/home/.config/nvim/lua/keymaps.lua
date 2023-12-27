--- Keymaps

local maps = require('utils.maps')

-- stylua: ignore
local keyboard = {
  leader = ' ',
  prefixes = {
    d     = { name = ' debug'  },
    f     = { name = ' find'   },
    g     = { name = '󰊢 git'    },
    t     = { name = '󰙨 test'   },
    w     = { name = '󰖳 window' },
  },
  mappings = {
    action = { -- [[
      { { 'n',     }, 'gr',             maps.goto_references,    { desc = ' references'           } },
      { { 'n',     }, 'gy',             maps.goto_typedef,       { desc = ' typedef'              } },
      { { 'n',     }, 'gu',             maps.goto_implementation,{ desc = ' implementation'       } },
      { { 'n',     }, 'gi',             maps.goto_incoming,      { desc = ' incoming-calls'       } },
      { { 'n',     }, 'go',             maps.goto_outgoing,      { desc = ' outgoing-calls'       } },
      { { 'n',     }, 'gd',             maps.goto_declaration,   { desc = ' declaration'          } },
      { { 'n',     }, '<c-]>',          maps.goto_definition,    { desc = ' definition'           } },
      { { 'n',     }, 'g+',             maps.args_add,           { desc = ' argsadd',             } },
      { { 'n',     }, 'g-',             maps.args_delete,        { desc = ' argsdel',             } },
      { { 'n',     }, 'g0',             maps.args_clear,         { desc = ' argsclr',             } },
      { { 'n',     }, '<c-p>',          maps.show_signature,     { desc = ' signature'            } },
      { { 'n',     }, '<c-h>',          maps.show_highlight,     { desc = ' highlight'            } },
      { { 'n',     }, '<c-k>',          maps.show_hover,         { desc = ' hover'                } },
      { { 'n',     }, '<leader>e',      maps.errors_buffer,      { desc = ' errors-buf'           } },
      { { 'n',     }, '<leader>E',      maps.errors_workspace,   { desc = ' errors-ws'            } },
      { { 'n', 'x' }, 'ga',             maps.run_align,          { desc = ' align'                } },
      { { 'n', 'x' }, 'gx',             maps.run_gx,             { desc = ' browse',              } },
      { { 'n', 'x' }, '<leader>r',      maps.run_replace,        { desc = ' replace'              } },
      { { 'n', 'x' }, '<leader>p',      maps.run_zknew,          { desc = ' zk-new',              } },
      { { 'n',     }, '<leader>m',      maps.run_make,           { desc = ' make',                } },
      { { 'n', 'x' }, '<leader>a',      maps.run_code,           { desc = ' code-action'          } },
      { { 'n', 'x' }, '<leader>i',      maps.run_neogen,         { desc = ' neogen',              } },
      { { 'n',     }, '<leader>!',      maps.run_spawn,          { desc = ' spawn'                } },
      { { 'n', 'x' }, '<leader>#',      maps.run_source,         { desc = ' source'               } },
      { { 'n', 'x' }, '<leader>=',      maps.run_format,         { desc = ' format'               } },
      { { 'n', 'x' }, '<leader>/',      maps.run_grep,           { desc = ' grep',                } },
      { { 'n', 'x' }, '<leader>*',      maps.run_star,           { desc = ' star',                } },
      { { 'n',     }, '<leader>x',      maps.run_bd,             { desc = ' bufdelete'            } },
    }, -- ]]
    debug = { -- [[
      { {'n',      }, '<leader>d?',     maps.run_dummy,          { desc = 'not implemented'        } },
    }, -- ]]
    find = { -- [[
      { { 'n',     }, '<leader>fa',     maps.find_args,          { desc = ' arglist'              } },
      { { 'n',     }, '<leader>fb',     maps.find_buffers,       { desc = ' buffer'               } },
      { { 'n',     }, '<leader>fc',     maps.find_recent,        { desc = ' recent'               } },
      { { 'n',     }, '<leader>ff',     maps.find_files,         { desc = ' git-files'            } },
      { { 'n',     }, '<leader>fg',     maps.find_gitstatus,     { desc = ' git-diffs'            } },
      { { 'n',     }, '<leader>fh',     maps.find_helptag,       { desc = ' helptags'             } },
      { { 'n',     }, '<leader>fl',     maps.find_config,        { desc = ' lua-configs'          } },
      { { 'n',     }, '<leader>fm',     maps.find_make,          { desc = ' makefile'             } },
      { { 'n',     }, '<leader>fp',     maps.find_project,       { desc = ' root-files'           } },
      { { 'n',     }, '<leader>fq',     maps.find_quickfix,      { desc = ' quickfix'             } },
      { { 'n',     }, '<leader>fr',     maps.find_roots,         { desc = ' roots'                } },
      { { 'n',     }, '<leader>f.',     maps.find_curdir,        { desc = ' curdir'               } },
      { { 'n',     }, '<leader>f/',     maps.find_grep,          { desc = ' grep'                 } },
      { { 'n',     }, '<leader>f*',     maps.find_star,          { desc = ' star'                 } },
      { { 'n',     }, '<leader>fz',     maps.find_zk,            { desc = ' zk-notes'             } },
      { { 'n',     }, '<leader>f\'',    maps.find_mark,          { desc = ' marks'                } },
    }, -- ]]
    git = { -- [[
      { { 'n',     }, '<leader>gg',     maps.git_fugitive,       { desc = ' fugitive'             } },
      { { 'n',     }, '<leader>gl',     maps.git_log,            { desc = ' logs'                 } },
      { { 'n',     }, '<leader>gs',     maps.git_stage,          { desc = ' stage'                } },
      { { 'n',     }, '<leader>gu',     maps.git_unstage,        { desc = ' unstage'              } },
      { { 'n',     }, '<leader>gp',     maps.git_preview,        { desc = ' preview'              } },
      { { 'n',     }, '<leader>gr',     maps.git_reset,          { desc = ' reset'                } },
      { { 'n',     }, '<leader>gb',     maps.git_blame,          { desc = ' blame'                } },
      { { 'n', 'x' }, '<leader>gy',     maps.git_link,           { desc = ' gitlink'              } },
    }, -- ]]
    quickfix = { -- [[
      { { 'n',     }, 'q/',             maps.qf_global,          { desc = ' global'               } },
      { { 'n',     }, 'qv',             maps.qf_vglobal,         { desc = ' vglobal'              } },
      { { 'n',     }, 'qp',             maps.qf_colder,          { desc = ' colder'               } },
      { { 'n',     }, 'qn',             maps.qf_cnewer,          { desc = ' cnewer'               } },
    }, -- ]]
    test = { -- [[
      { { 'n',     }, '<leader>tt',     maps.test_nearest,       { desc = ' nearest'              } },
      { { 'n',     }, '<leader>tf',     maps.test_file,          { desc = ' file'                 } },
      { { 'n',     }, '<leader>tv',     maps.test_visit,         { desc = ' visit'                } },
      { { 'n',     }, '<leader>ts',     maps.test_suite,         { desc = ' suite'                } },
      { { 'n',     }, '<leader>tp',     maps.test_previous,      { desc = ' previous'             } },
    }, -- ]]
    window = { -- [[
      { { 'n',     }, '<leader>w',      '<c-w>',                 {                                 } },
      { { 'n',     }, '<leader>wt',     maps.run_tabnew,         { desc = ' tabnew',              } },
      { { 'n',     }, '<leader>we',     maps.run_enew,           { desc = ' enew',                } },
      { { 'n',     }, '<leader>wm',     maps.run_maximize,       { desc = ' maximize',            } },
    }, -- ]]
    jump = { -- [[
      { { 'n',     }, ']a',             maps.jump_argnext,      { desc = '󰒭 arg-file'             } },
      { { 'n',     }, '[a',             maps.jump_argprev,      { desc = '󰒮 arg-file'             } },
      { { 'n',     }, ']b',             maps.jump_bufnext,      { desc = '󰒭 buffer'               } },
      { { 'n',     }, '[b',             maps.jump_bufprev,      { desc = '󰒮 buffer'               } },
      { { 'n',     }, ']c',             maps.jump_chunknext,    { desc = '󰒭 chunk'                } },
      { { 'n',     }, '[c',             maps.jump_chunkprev,    { desc = '󰒮 chunk'                } },
      { { 'n',     }, ']e',             maps.jump_errornext,    { desc = '󰒭 error'                } },
      { { 'n',     }, '[e',             maps.jump_errorprev,    { desc = '󰒮 error'                } },
      { { 'n',     }, ']f',             maps.jump_filenext,     { desc = '󰒭 file-tree'            } },
      { { 'n',     }, '[f',             maps.jump_fileprev,     { desc = '󰒮 file-tree'            } },
      { { 'n',     }, ']q',             maps.jump_qfnext,       { desc = '󰒭 qf-entry'             } },
      { { 'n',     }, '[q',             maps.jump_qfprev,       { desc = '󰒮 qf-entry'             } },
      { { 'n',     }, ']l',             maps.jump_locnext,      { desc = '󰒭 loc-entry'            } },
      { { 'n',     }, '[l',             maps.jump_locprev,      { desc = '󰒮 loc-entry'            } },
      { { 'n',     }, ']t',             maps.jump_tabnext,      { desc = '󰒭 tab'                  } },
      { { 'n',     }, '[t',             maps.jump_tabprev,      { desc = '󰒮 tab'                  } },
      { { 'n',     }, ']\'',            maps.jump_termnext,     { desc = '󰒭 terminal'             } },
      { { 'n',     }, '[\'',            maps.jump_termprev,     { desc = '󰒮 terminal'             } },
    }, -- ]]
    toggles = { -- [[
      { { 'n',     }, '<leader><tab>',  maps.toggle_outline,    { desc = ' outline'              } },
      { { 'n',     }, '<leader>q',      maps.toggle_quickfix,   { desc = ' quickfix'             } },
      { { 'n',     }, '<leader>z',      maps.toggle_zen,        { desc = ' zen'                  } },
      { { 'n',     }, '<leader>n',      maps.toggle_ntree,      { desc = ' ntree'                } },
      { { 'n',     }, '<leader>u',      maps.toggle_dapui,      { desc = ' dapui'                } },
      { { 'n',     }, '<leader>o',      maps.toggle_option,     { desc = ' option'               } },
      { { 'n',     }, '<leader>`',      maps.toggle_term,       { desc = ' terminal'             } },
      { { 'n',     }, '<leader>~',      maps.newterm,           { desc = '󱓞 newterm'              } },
      { { 'n',     }, '´',              maps.toggle_lf,         { desc = '󱓞 lf'                   } },
      { { 'n',     }, '-',              maps.toggle_oil,        { desc = '󱓞 oil'                  } },
    }, -- ]]
    defaults = { -- [[
      { { 'i',     }, 'jk', '<c-[>l'                                 },
      { { 'i',     }, 'kj', '<c-[>l'                                 },
      { { 's',     }, 'jk', '<esc>'                                  },
      { { 's',     }, 'kj', '<esc>'                                  },
      { { 'c',     }, 'jk', '<esc>'                                  },
      { { 'c',     }, 'kj', '<esc>'                                  },
      { { 't',     }, 'jk', '<C-\\><C-n>'                            },
      { { 't',     }, 'kj', '<C-\\><C-n>'                            },
      { { 'x',     }, '<',  '<gv'                                    },
      { { 'x',     }, '>',  '>gv'                                    },
      { { 'n',     }, '>',  '>>'                                     },
      { { 'n',     }, '<',  '<<'                                     },
      { { 'n',     }, '', '<cmd>nohlsearch<cr>'                    },
      { { 'n',     }, 'Y',  'v$hy'                                   },
      { { 'n',     }, 'Q',  '<Nop>'                                  },
      { { 'x',     }, 'p',  'pgvy'                                   },
      { { 'n', 'x' }, 'K',   maps.keywordprg                         },
      { { 'x',     }, '*',  [["zy/\V<C-r>=escape(@z, '\/')<cr><cr>]] },
    } -- ]]
  }
}

local function register(mappings)
	vim.tbl_map(function(...)
		local status, _ = pcall(vim.keymap.set, unpack(...))
		if not status then
			vim.notify(
				'Failed to set keymap: ' .. vim.inspect({ ... }),
				vim.log.levels.ERROR
			)
		end
	end, mappings)
end

vim.g.mapleader = keyboard.leader
vim.z.keyboard = keyboard

vim.tbl_map(register, keyboard.mappings)

--[[ *:map-arguments*
buffer: current buffer only                                   (default false)
remap:  recursive mapping                                     (default false)
nowait: don't wait for other mappings, immediatly evaluate    (default false)
silent: don't echo the command                                (default false)
script: use {rhs} mappings defined in the script - <SID>      (default false)
expr:   evaluate {rhs} as an expression                       (default false)
unique: don't remap if already mapped                         (default false)
desc:   human-readable description                            (default '')
vim:fdl=0:fdm=marker:fmr=[[,]]
--]]
