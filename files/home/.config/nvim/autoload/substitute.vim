fun! substitute#buffer_substitute()
    let word = expand('<cword>')
    if mode() ==? 'v'
        norm! "xy
        let word = @x
    endif
    call feedkeys(':%s/'.word.'/'.word.'/g'. "\<Left>\<Left>")
endf
