set noshowmode
set updatetime=200
set shortmess+=c
set completeopt=menu,menuone,noselect
set pumwidth=20
set pumheight=8
set wrapscan
set dictionary=/usr/share/dict/words

imap <expr> <tab>
            \ pumvisible() ?
            \     complete_info()["selected"] != "-1" ?
            \       "\<c-y>"
            \       :
            \       "\<c-n>\<c-y>" :
            \     "\<tab>"

au! CursorHoldI * call s:complete(0)

let s:completions = [
	\	"\<c-x>\<c-f>",
	\	"\<c-x>\<c-o>",
	\	"\<c-x>\<c-n>",
	\	"\<c-x>\<c-k>"
	\]
	
let s:try = 0
let s:started = v:false

fun! s:complete(id)
	let s:try = a:id == 0 ? a:id : s:try
	if !pumvisible() && getline('.')[col('.')-2] =~ '\S' && s:try < len(s:completions)
		if mode() != 'i' 
			return
		endif
		call feedkeys(s:completions[s:try])
		call timer_start(75, function('s:complete'))
		let s:try = s:try + 1
	endif
endf

