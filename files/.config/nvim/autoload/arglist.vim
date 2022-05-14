fun! arglist#next()
    try
        next
    catch 'E165: Cannot go beyond last file'
        first
    catch 'E163: There is only one file to edit'
        echomsg 'last file or arglist is empty'
    endtry
endf

fun! arglist#prev()
    try
        previous
    catch 'E164: Cannot go before first file'
        last
    catch 'E163: There is only one file to edit'
        echomsg 'last file or arglist is empty'
    endtry
endf
