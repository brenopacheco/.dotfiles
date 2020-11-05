
let s:goto_help_map = {   'name': 'Goto mapping [g]',
					 \    'keys': [
					 \       ['v', '', 'var. declaration'],
					 \       ['d', '', 'definition'],
					 \       ['i', '', 'implementation'],
					 \       ['y', '', 'type defintion'],
					 \       ['c', '', '-> comment'],
					 \       ['a', '', '-> align'],
					 \ ]}

let s:fuzzy_help_map = { 'name': 'Fuzzy [space-f]',
					 \    'keys': [
					 \       ['~', '', 'home    (file)'],
					 \       ['.', '', 'curdir  (file)'],
					 \       ['g', '', 'gitls   (file)'],
					 \       ['p', '', 'project (file)'],
					 \       ['r', '', 'recent  (file)'],
					 \       ['b', '', 'buffers'],
					 \       ['a', '', 'args'],
					 \       ['m', '', 'marks'],
					 \       ['s', '', 'symbols'],
					 \       ['o', '', 'outline'],
					 \       ['/', '', 'rg pattern'],
					 \       ['*', '', 'rg <word>'],
					 \       [':', '', 'cmd history'],
					 \       ['h', '', 'helptags']
					 \ ]}

let s:leader_help_map = { 'name': 'Leader [space]',
					 \    'keys': [
					 \       ['a', '', 'code-action'],
					 \       ['=', '', 'format'],
					 \       ['r', '', 'rename'],
					 \       ['-', '', 'align'],
					 \       ['c', '', 'comment'],
					 \       ['o', '', 'outline (qf)'],
					 \       ['s', '', 'symbols (qf)'],
					 \       ['*', '', 'refs.   (qf)'],
					 \       ['/', '', 'pattern (qf)'],
					 \       ["'", '', 'terminal'],
					 \       ['e', '', 'explorer'],
					 \       ['t', '', 'tagbar'],
					 \       ['l', '', 'lf'],
					 \       ['u', '', 'undotree'],
					 \       ['q', '', 'quickfix'],
					 \       ['f', 'Hydra fuzzy_help', '>>> fuzzy', 'exit']
					 \ ]}




let s:leader_help_hydra = { 'name':        'leader_help',
					\       'title':       'leader_help',
					\       'show':        'popup',
					\       'position':    's:bottom_right',
					\       'exit_key':    'q',
					\       'feed_key':    v:false,
					\       'foreign_key': v:true,
					\       'keymap':      [ s:leader_help_map ] }

let s:fuzzy_help_hydra = {  'name':        'fuzzy_help',
					\       'title':       'fuzzy_help',
					\       'show':        'popup',
					\       'position':    's:bottom_right',
					\       'exit_key':    'q',
					\       'feed_key':    v:false,
					\       'foreign_key': v:true,
					\       'keymap':      [ s:fuzzy_help_map ] }

let s:goto_help_hydra = {   'name':        'goto_help',
					\       'title':       'goto_help',
					\       'show':        'popup',
					\       'position':    's:bottom_right',
					\       'exit_key':    'q',
					\       'feed_key':    v:false,
					\       'foreign_key': v:true,
					\       'keymap':      [ s:goto_help_map ] }



silent call hydra#hydras#reset()
silent call hydra#hydras#register(s:leader_help_hydra)
silent call hydra#hydras#register(s:fuzzy_help_hydra)
silent call hydra#hydras#register(s:goto_help_hydra)
