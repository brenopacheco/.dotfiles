" Vim syntax file
" Language: Lynx dump output
" Maintainer: Custom
" Latest Revision: 2025-10-16

if exists("b:current_syntax")
  finish
endif

" Link references in the text [1], [2], etc.
syn match lynxLinkRef '\[\d\+\]'

" Headers (lines that are all caps or start with common header patterns)
syn match lynxHeader '^\s*[A-Z][A-Z0-9 ]\+$'

" The "References" section header and similar
syn match lynxSection '^\s*References\s*$'
syn match lynxSection '^\s*Visible links\s*$'

" Reference list items (numbered lines at bottom)
syn match lynxRefNum '^\s*\d\+\.'

" URLs in the reference section
syn match lynxURL 'https\?://[^ ]\+'
syn match lynxURL 'ftp://[^ ]\+'
syn match lynxURL 'file://[^ ]\+'

" Email addresses
syn match lynxEmail '[a-zA-Z0-9._%+-]\+@[a-zA-Z0-9.-]\+\.[a-zA-Z]\{2,}'

" Horizontal rules (common in lynx output)
syn match lynxRule '^[_*=-]\{3,}$'

" Bullet points and list markers
syn match lynxBullet '^\s*[*+•·-]\s'

" Define highlighting
hi def link lynxLinkRef Special
hi def link lynxHeader Title
hi def link lynxSection PreProc
hi def link lynxRefNum Number
hi def link lynxURL Underlined
hi def link lynxEmail Underlined
hi def link lynxRule Comment
hi def link lynxBullet Statement

" Command to lookup link references
command! -buffer -nargs=1 LynxHelp call s:LynxLookup(<q-args>)

" Function to lookup link references
function! s:LynxLookup(word)
  " Strip brackets from the link number
  let link_num = substitute(a:word, '[\[\]]', '', 'g')
  
  " Search from bottom up for the reference
  " Save current position
  let save_pos = getpos('.')
  
  " Go to end of file
  call cursor(line('$'), 1)

  " Search backward for the pattern: "  445. " at start of line
  let pattern = '^\s*' . link_num . '\.\s\+'
  let found_line = search(pattern, 'bW')
  
  if found_line > 0
    " Extract the URL (everything after the number and dot)
    let line_text = getline(found_line)
    let url = substitute(line_text, '^\s*\d\+\.\s\+', '', '')
    call LynxOpen(url)
  else
    echo 'Reference [' . link_num . '] not found'
  endif
  
  " Restore position
  call setpos('.', save_pos)
endfunction

" Function to open URLs in lynx
function! LynxOpen(url)
  " Check URL type and open in a new buffer
  if a:url =~# '^file://'
    " File URL - use lynx directly
    enew
    execute 'read !lynx -dump -width=120 ' . shellescape(a:url)
    setfiletype lynx
    normal! ggdd
  elseif a:url =~# '^https\?://'
    " HTTP/HTTPS URL - use curl piped to lynx
    enew
    execute 'read !curl -s ' . shellescape(a:url) . ' | lynx -dump -width=120 -stdin'
    setfiletype lynx
    normal! ggdd
  elseif a:url =~# '^ftp://'
    " FTP URL - use curl with ftp support piped to lynx
    enew
    execute 'read !curl -s ' . shellescape(a:url) . ' | lynx -dump -width=120 -stdin'
    setfiletype lynx
    normal! ggdd
  else
    echo 'Unknown URL type: ' . a:url
  endif
endfunction

" Set up keywordprg
setlocal keywordprg=:LynxHelp
setlocal iskeyword=48-57,91,93 " Add [ and ] to keyword chars

let b:current_syntax = "lynx"
