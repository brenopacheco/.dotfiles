vim.cmd([[
augroup Zeavim_Config
  au!
  autocmd FileType lua,go,javascript,typescript,javascriptreact,typescriptreact,elixir nmap <buffer> <S-k> <Plug>Zeavim
  autocmd FileType lua,go,javascript,typescript,javascriptreact,typescriptreact,elixir vmap <buffer> <S-k> <Plug>ZVVisSelection
augroup end
]])
