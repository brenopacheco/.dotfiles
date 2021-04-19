
let s:invalid = [ '\t', ' ', '.', '(', ')', '[', ']', '=', '&' ]

function AbbrevOmni(findstart, base)
    if a:findstart 
        let line = getline('.')
        let col = col('.') - 1
        let char = line[col]
        while(col > 0 && index(s:invalid, char) < 0)
            "echo "char: " . char
            let col = col - 1
            let char = line[col]
        endwhile
        return col == 0 ? 0 : col + 1
    endif

    let s:base = a:base
    let abbs = map(split(execute('iab'), "\n"), 
                \ 'split(v:val, " ")[2]')
    let matches = []
    for ab in abbs
        if matchstr(ab, a:base) != ""
            let matches = matches + [ab]
        endif
    endfor
    return matches
endfunction

set omnifunc=AbbrevOmni
