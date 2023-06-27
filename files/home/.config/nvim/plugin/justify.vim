if exists('g:loaded_justify_plugin')
    finish
endif
let g:loaded_justify_plugin = 1

" TODO: add range, concatenate with gq
fun! Justify() abort
    let lnum = line('.')
    let line = getline(lnum)
    let words = filter(split(line, " "), '!empty(v:val)')
    let missing = &textwidth - len(join(words, ''))
    if missing < 0 | return | endif
    let spaces = missing / (len(words) - 1)
    let remainder = missing % (len(words) - 1)
	for n in range(len(words) - 1)
        let padding = spaces + (remainder > 0 ? 1 : 0)
        let words[n] = join([words[n]] + [repeat(' ', padding)], '')
        let remainder = remainder - 1
	endfor
    let formatted = join(words, '')
    call setline(lnum, formatted)
endf

command! Justify call Justify()
