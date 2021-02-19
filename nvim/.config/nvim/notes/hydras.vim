
" TODO: toggles, navigation

let s:toggle_map =    {   'name': '[spc-] Toggle',
                     \    'keys': [
                     \       ["_'", 'norm gr', 'terminal'],
                     \       ['_n', 'norm gr', 'tree    '],
                     \       ['_t', 'norm gr', 'tagbar  '],
                     \       ['_l', 'norm gr', 'lf      '],
                     \       ['_u', 'norm gr', 'undotree'],
                     \       ['_q', 'norm gr', 'quickfix']
                     \ ]}

let s:navigate_map = {   'name': ']? Navigate',
                     \    'keys': [
                     \       [']e', '', 'diagnostic'],
                     \       [']g', '', 'git hunk  '],
                     \       [']s', '', 'tag buffer'],
                     \       [']t', '', 'tagstack  '],
                     \       [']a', '', 'arg       '],
                     \       [']b', '', 'buffer    '],
                     \       [']q', '', 'quickfix  '],
                     \ ]}



let s:goto_map = {   'name': '[g-] Goto',
                     \    'keys': [
                     \       ['gr', '', 'references      ',],
                     \       ['gD', '', 'declaration     ',],
                     \       ['gd', '', 'definition      ',],
                     \       ['gi', '', 'implementation  ',],
                     \       ['gy', '', 'type_definition ',],
                     \       ['go', '', 'document_symbol ',],
                     \       ['gs', '', 'workspace_symbol',],
                     \ ]}

let s:ffile_map =  { 'name': '[spc-f-] Find file',
                     \    'keys': [
                     \       ['_f~', '', 'home   '],
                     \       ['_f.', '', 'curdir '],
                     \       ['_fg', '', 'gitls  '],
                     \       ['_fp', '', 'project'],
                     \       ['_fr', '', 'recent '],
                     \       ['_fb', '', 'buffers'],
                     \       ['_fa', '', 'args']
                     \ ]}

let s:fmisc_map =  { 'name': '[spc-f-] Find misc',
                     \    'keys': [
                     \       ['_fm', '', 'marks'],
                     \       ['_fs', '', 'symbols'],
                     \       ['_fo', '', 'outline'],
                     \       ['_f/', '', 'rg pattern'],
                     \       ['_f*', '', 'rg <word>'],
                     \       ['_f:', '', 'cmd history'],
                     \       ['_fh', '', 'helptags']
                     \ ]}

let s:action_map = { 'name': '[spc-] Action',
                     \    'keys': [
                     \       ['_a', '', 'code-action'],
                     \       ['_=', '', 'format'],
                     \       ['_r', '', 'rename'],
                     \       ['_*', '', 'grep cursor'],
                     \       ['_/', '', 'grep pattern']
                     \ ]}

let s:help_hydra = {        'name':        'help',
                    \       'title':       'help',
                    \       'show':        'popup',
                    \       'position':    's:bottom_right',
                    \       'exit_key':    'q',
                    \       'feed_key':    v:false,
                    \       'foreign_key': v:true,
                    \       'keymap':      [ 
                    \           s:navigate_map,
                    \           s:goto_map,
                    \           s:toggle_map,
                    \           s:action_map,
                    \           s:ffile_map,
                    \           s:fmisc_map
                    \       ] }

silent call hydra#hydras#reset()
silent call hydra#hydras#register(s:help_hydra)
