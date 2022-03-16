vim.cmd([[
augroup AU_NAME
  au!
  autocmd FileType lua,go,javascript,typescript,javascriptreact,typescriptreact nmap <buffer> <S-k> <Plug>Zeavim
  autocmd FileType lua,go,javascript,typescript,javascriptreact,typescriptreact vmap <buffer> <S-k> <Plug>ZVVisSelection
augroup end
]])
