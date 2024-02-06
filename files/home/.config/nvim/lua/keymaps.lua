--- Keymaps

local maps = require('utils.maps')
local treeutil = require('utils.treesitter')

-- stylua: ignore
local keyboard = {
  leader = ' ',
  prefixes = { -- [[
    d     = { name = ' debug'  },
    f     = { name = ' find'   },
    g     = { name = '󰊢 git'    },
    t     = { name = '󰙨 test'   },
    w     = { name = '󰖳 window' },
  }, -- ]]
  mappings = {
    action = { -- [[
      { { 'n',     }, 'gr',             maps.goto_references,    { desc = ' references'           } },
      { { 'n',     }, 'gy',             maps.goto_typedef,       { desc = ' typedef'              } },
      { { 'n',     }, 'gu',             maps.goto_implementation,{ desc = ' implementation'       } },
      { { 'n',     }, 'gi',             maps.goto_incoming,      { desc = ' incoming-calls'       } },
      { { 'n',     }, 'go',             maps.goto_outgoing,      { desc = ' outgoing-calls'       } },
      { { 'n',     }, 'gd',             maps.goto_declaration,   { desc = ' declaration'          } },
      { { 'n',     }, '<c-]>',          maps.goto_definition,    { desc = ' definition'           } },
      { { 'n',     }, 'g=',             maps.args_add,           { desc = ' argsadd',             } },
      { { 'n',     }, 'g-',             maps.args_delete,        { desc = ' argsdel',             } },
      { { 'n',     }, 'g0',             maps.args_clear,         { desc = ' argsclr',             } },
      { { 'n',     }, '<c-n>',          maps.args_next,          { desc = ' argsnext'             } },
      { { 'n',     }, '<c-p>',          maps.args_prev,          { desc = ' argsprev'             } },
      -- { { 'n',     }, '<c-p>',          maps.show_signature,     { desc = ' signature'            } },
      { { 'n',     }, '<c-h>',          maps.show_highlight,     { desc = ' highlight'            } },
      { { 'n',     }, '<c-k>',          maps.show_hover,         { desc = ' hover'                } },
      { { 'n',     }, '<leader>e',      maps.errors_buffer,      { desc = ' errors-buf'           } },
      { { 'n',     }, '<leader>E',      maps.errors_workspace,   { desc = ' errors-ws'            } },
      { { 'n', 'x' }, 'ga',             maps.run_align,          { desc = ' align'                } },
      { { 'n', 'x' }, 'gx',             maps.run_gx,             { desc = ' browse',              } },
      { { 'n',     }, 'gm',             maps.messages,           { desc = ' messages'             } },
      { { 'n',     }, 'gl',             maps.lsp_info,           { desc = ' lsp-info'             } },
      { { 'n', 'x' }, '<leader>r',      maps.run_rename,         { desc = ' rename'               } },
      { { 'n', 'x' }, '<leader>s',      maps.run_replace,        { desc = ' replace'              } },
      { { 'n', 'x' }, '<leader>z',      maps.run_zknew,          { desc = ' zk-new',              } },
      { { 'n',     }, '<leader>m',      maps.run_make,           { desc = ' make',                } },
      { { 'n', 'x' }, '<leader>a',      maps.run_code,           { desc = ' code-action'          } },
      { { 'n', 'x' }, '<leader>i',      maps.run_neogen,         { desc = ' neogen',              } },
      { { 'n',     }, '<leader>!',      maps.run_spawn,          { desc = ' spawn'                } },
      { { 'n', 'x' }, '<leader>#',      maps.run_source,         { desc = ' source'               } },
      { { 'n', 'x' }, '<leader>=',      maps.run_format,         { desc = ' format'               } },
      { { 'n', 'x' }, '<leader>/',      maps.run_grep,           { desc = ' grep',                } },
      { { 'n', 'x' }, '<leader>*',      maps.run_star,           { desc = ' star',                } },
      { { 'n',     }, '<leader>x',      maps.run_bd,             { desc = ' bufdelete'            } },
      { { 'n',     }, '<leader>p',      maps.switch_project,     { desc = ' switch project'       } },
    }, -- ]]
    debug = { -- [[
      { {'n',      }, '<leader>dd',     maps.debug_start,        { desc = '/ start/continue'     } },
      { {'n',      }, '<leader>dr',     maps.debug_restart,      { desc = '/ restart/last'       } },
      { {'n',      }, '<leader>dx',     maps.debug_terminate,    { desc = ' terminate'            } },
      { {'n',      }, '<leader>ds',     maps.debug_pause,        { desc = '󱇫 pause thread'         } },
      { {'n',      }, '<leader>di',     maps.debug_step_into,    { desc = '󰆹 step into'            } },
      { {'n',      }, '<leader>do',     maps.debug_step_out,     { desc = '󰆸 step out'             } },
      { {'n',      }, '<leader>dn',     maps.debug_step_over,    { desc = '󰆷 step over'            } },
      { {'n',      }, '<leader>db',     maps.debug_bp_toggle,    { desc = ' breakpoint toggle'    } },
      { {'n',      }, '<leader>dv',     maps.debug_bp_condition, { desc = '󰊕 breakpoint condition' } },
      { {'n',      }, '<leader>dc',     maps.debug_bp_clear,     { desc = ' breakpoint clear'     } },
      { {'n',      }, '<leader>dq',     maps.debug_bp_list,      { desc = ' breakpoint list'      } },
      { {'n',      }, '<leader>dk',     maps.debug_hover,        { desc = '󱄑 info hover'           } },
      { {'n',      }, '<leader>dp',     maps.debug_preview,      { desc = '󰩣 info preview'         } },
      { {'n',      }, '<leader>d.',     maps.debug_to_cursor,    { desc = '󰇀 run to cursor'        } },
      { {'n',      }, '<leader>dm',     maps.debug_open_log,     { desc = ' dap log'              } },
      -- { {'n',      }, '<leader>du',     maps.debug_toggle_repl,  { desc = ' toggle repl'          } },
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
      { { 'n',     }, '<leader>fs',     maps.find_doc_symbol,    { desc = ' doc-symbol'           } },
      { { 'n',     }, '<leader>fw',     maps.find_ws_symbol,     { desc = ' ws-symbol'            } },
    }, -- ]]
    git = { -- [[
      { { 'n',     }, '<leader>gg',     maps.git_fugitive,       { desc = ' fugitive'             } },
      { { 'n',     }, '<leader>gl',     maps.git_log,            { desc = ' logs'                 } },
      { { 'n',     }, '<leader>gs',     maps.git_stage,          { desc = ' stage'                } },
      { { 'n',     }, '<leader>gu',     maps.git_unstage,        { desc = ' unstage'              } },
      { { 'n',     }, '<leader>gp',     maps.git_preview,        { desc = ' preview'              } },
      { { 'n',     }, '<leader>gr',     maps.git_reset,          { desc = ' reset'                } },
      { { 'n',     }, '<leader>gb',     maps.git_blame,          { desc = ' blame'                } },
      { { 'n',     }, '<leader>gy',     maps.git_link,           { desc = ' gitlink'              } },
    }, -- ]]
    quickfix = { -- [[
      { { 'n',     }, 'qf',             maps.qf_global,          { desc = ' global'               } },
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
      { { 'n',     }, ']`',             maps.jump_termnext,     { desc = '󰒭 terminal'             } },
      { { 'n',     }, '[`',             maps.jump_termprev,     { desc = '󰒮 terminal'             } },
    }, -- ]]
    toggles = { -- [[
      { { 'n',     }, '<leader><tab>',  maps.toggle_outline,    { desc = ' outline'              } },
      { { 'n',     }, '<leader>q',      maps.toggle_quickfix,   { desc = ' quickfix'             } },
      -- { { 'n',     }, '<leader>z',      maps.toggle_zen,        { desc = ' zen'                  } },
      { { 'n',     }, '<leader>n',      maps.toggle_ntree,      { desc = ' ntree'                } },
      { { 'n',     }, '<leader>u',      maps.toggle_dapui,      { desc = ' dapui'                } },
      { { 'n',     }, '<leader>o',      maps.toggle_option,     { desc = ' option'               } },
      { { 'n',     }, '<leader>`',      maps.toggle_term,       { desc = ' terminal'             } },
      { { 'n',     }, '<leader>~',      maps.newterm,           { desc = '󱓞 newterm'              } },
      { { 'n',     }, '<leader>l',      maps.toggle_lf,         { desc = '󱓞 lf'                   } },
      { { 'n',     }, '-',              maps.toggle_oil,        { desc = '󱓞 oil'                  } },
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
      { { 'n', 'x' }, 'K',           maps.keywordprg                         },
      { { 's',     }, '<bs>',       '<bs>i'                                  },
      { { 'x',     }, '*',  [["zy/\V<C-r>=escape(@z, '\/')<cr><cr>]]         },
    } -- ]]
  },
  abbreviations = {
    go = { -- [[
      ['eq']  = ':=',
      ['ife'] = 'if err != nil {<cr><cr>}<up><tab>',
      ['fn']  = 'func() {}<left><cr>.<cr><up><tab><del>',
    }, -- ]]
    fennel = { -- [[
      ['lambda']  = 'λ',
    } -- ]]
  }
}

-- [[ setup

vim.g.mapleader = keyboard.leader
vim.z.keyboard = keyboard

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

vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileType' }, {
	desc = 'Load buffer local abbreviations',
	group = vim.api.nvim_create_augroup('abbreviations', { clear = true }),
	pattern = vim.tbl_keys(keyboard.abbreviations),
	callback = function(ev)
		local ft = vim.api.nvim_get_option_value('ft', { buf = ev.buf })
		for lhs, rhs in pairs(keyboard.abbreviations[ft]) do
			vim.keymap.set(
				'ia',
				lhs,
				function() return treeutil.is_comment() and lhs or rhs end,
				{ buffer = ev.buf, expr = true }
			)
		end
	end,
})

-- ]]

--[[ *:map-arguments*
buffer: current buffer only                                   (default false)
remap:  recursive mapping                                     (default false)
nowait: don't wait for other mappings, immediatly evaluate    (default false)
silent: don't echo the command                                (default false)
script: use {rhs} mappings defined in the script - <SID>      (default false)
expr:   evaluate {rhs} as an expression                       (default false)
unique: don't remap if already mapped                         (default false)
desc:   human-readable description                            (default '')
vim:fdl=0:tw=103:cc=103:fdm=marker:fmr=[[,]]
--]]
