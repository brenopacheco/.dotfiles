if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let b:is_chicken = 1 " for syntax highlighting

compiler csi

setlocal iskeyword+=-
setlocal keywordprg=:ChickenDoc

let b:undo_ftplugin='setl mp< efm< isk<'
