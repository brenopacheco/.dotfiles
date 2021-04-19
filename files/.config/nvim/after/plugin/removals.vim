" delcommand

" GutentagsUpdate   0                        :call s:manual_update_tags(<bang>0)
" Ag                *                        call fzf#vim#ag(<q-args>, fzf#vim#with_preview(), <bang>0)
" BCommits          0                        call fzf#vim#buffer_commits(fzf#vim#with_preview({ "placeholder": "" }), <bang>0)
" BLines            *                        call fzf#vim#buffer_lines(<q-args>, <bang>0)
" BTags             *                        call fzf#vim#buffer_tags(<q-args>, fzf#vim#with_preview({ "placeholder": "{2}:{3}" }), <bang>0)
" Bufferize         *            command     call bufferize#Run(<q-args>)
" BufferizeSystem   *            command     Bufferize echo system(<q-args>)
" BufferizeTimer    *            command     call bufferize#RunWithTimer(<q-args>)
" Buffers           ?            buffer      call fzf#vim#buffers(<q-args>, fzf#vim#with_preview({ "placeholder": "{1}" }), <bang>0)
" ClearCache        0                        call cache#clear()
" Colors            0                        call fzf#vim#colors(<bang>0)
" Commands          0                        call fzf#vim#commands(<bang>0)
" Commentary        0    .                   call s:go(<line1>,<line2>)
" Commits           0                        call fzf#vim#commits(fzf#vim#with_preview({ "placeholder": "" }), <bang>0)
" DapBreakpoints    0                        call dap#breakpoints()
" DapHover          0                        call dap#hover()
" DapPlayPause      0                        call dap#play_pause()
" DapScope          0                        call dap#scope()
" DapStackDown      0                        call dap#stack_down()
" DapStackUp        0                        call dap#stack_up()
" DapStartRestart   0                        call dap#start_restart()
" DapStepIn         0                        call dap#step_in()
" DapStepOut        0                        call dap#step_out()
" DapStepOver       0                        call dap#step_over()
" DapToggleBreakpoint 0                      call dap#toggle_breakpoint()
" DapToggleRepl     0                        call dap#toggle_repl()
" DoMatchParen      0                        call s:DoMatchParen()
" Docset            ?            customlist  call zeavim#DocsetInBuffer(<f-args>)
" EasyAlign         *    .                   <line1>,<line2>call easy_align#align(<bang>0, 0, 'command', <q-args>)
" EditorConfigDisable 0                      call s:EditorConfigEnable(0)
" EditorConfigEnable 0                       call s:EditorConfigEnable(1)
" EditorConfigReload 0                       call s:UseConfigFiles() " Reload EditorConfig files
" Eval              0                        call make#eval()  " eval line through interpreter
" Explore           *    0c ?    dir         call netrw#Explore(<count>,0,0+<bang>0,<q-args>)
" FZF               *            dir         call s:cmd(<bang>0, <f-args>)
" Files             ?            dir         call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
" Filetypes         0                        call fzf#vim#filetypes(<bang>0)
" Fork              0                        silent call system('st 1>/dev/null 2>&1 & disown')
" G                 ?    .       customlist  exe fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>)
" GBrowse           *    .       customlist  exe fugitive#BrowseCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" GDelete           0            customlist  exe fugitive#DeleteCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" GFiles            ?                        call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(<q-args> == "?" ? { "placeholder": "" } : {}), <b
" GMove             1            customlist  exe fugitive#MoveCommand(  <line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" GPGDecrypt        0                        call gpg#decrypt()
" GPGEncrypt        0                        call gpg#encrypt()
" GRemove           0            customlist  exe fugitive#RemoveCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" GRename           1            customlist  exe fugitive#RenameCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" GTree             0                        call tree#open_root()
" GV                *    0       customlist  call s:gv(<bang>0, <count>, <line1>, <line2>, <q-args>)
" Gblame            ?    .       customlist  echohl WarningMSG|echo ":Gblame is deprecated in favor of :Git blame\n"|echohl NONE| exe fugitive#Comm
" Gbrowse           *    .       customlist  exe fugitive#BrowseCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" GcLog             ?    .       customlist  :exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "c")
" Gcd               ?            customlist  exe fugitive#Cd(<q-args>, 0)
" Gcgrep            ?    .  win  customlist  exe fugitive#GrepCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>)
" Gclog             ?    .       customlist  :exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "c")
" Gcommit           ?    .       customlist  echohl WarningMSG|echo ":Gcommit is deprecated in favor of :Git commit\n"|echohl NONE| exe fugitive#Co
" Gdelete           0            customlist  exe fugitive#DeleteCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" Gdiffsplit        *            customlist  exe fugitive#Diffsplit(1, <bang>0, "<mods>", <q-args>, [<f-args>])
" Ge                *            customlist  exe fugitive#Open("edit<bang>", 0, "<mods>", <q-args>, [<f-args>])
" Gedit             *            customlist  exe fugitive#Open("edit<bang>", 0, "<mods>", <q-args>, [<f-args>])
" Gfetch            ?    .       customlist  echohl WarningMSG|echo ":Gfetch is deprecated in favor of :Git fetch\n"|echohl NONE| exe fugitive#Comm
" Ggrep             ?    .  win  customlist  exe fugitive#GrepCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>)
" Ghdiffsplit       *            customlist  exe fugitive#Diffsplit(0, <bang>0, "<mods>", <q-args>, [<f-args>])
" Git               ?    .       customlist  exe fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>)
" GitFiles          ?                        call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(<q-args> == "?" ? { "placeholder": "" } : {}), <b
" GitMessenger      0                        call gitmessenger#new(expand('%:p'), line('.'), bufnr('%'))
" GitMessengerClose 0                        call gitmessenger#close_popup(bufnr('%'))
" GlLog             ?    .       customlist  :exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "l")
" Glcd              ?            customlist  exe fugitive#Cd(<q-args>, 1)
" Glgrep            ?    .  win  customlist  exe fugitive#GrepCommand(0, <count> > 0 ? <count> : 0, +"<range>", <bang>0, "<mods>", <q-args>)
" Gllog             ?    .       customlist  :exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "l")
" Glog              ?    .       customlist  :exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "")
" Gmerge            ?    .       customlist  echohl WarningMSG|echo ":Gmerge is deprecated in favor of :Git merge\n"|echohl NONE| exe fugitive#Comm
" Gmove             1            customlist  exe fugitive#MoveCommand(  <line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" Goyo              ?                        call goyo#execute(<bang>0, <q-args>)
" Gpedit            *            customlist  exe fugitive#Open("pedit", <bang>0, "<mods>", <q-args>, [<f-args>])
" Gpull             ?    .       customlist  echohl WarningMSG|echo ":Gpull is deprecated in favor of :Git pull\n"|echohl NONE| exe fugitive#Comman
" Gpush             ?    .       customlist  echohl WarningMSG|echo ":Gpush is deprecated in favor of :Git push\n"|echohl NONE| exe fugitive#Comman
" Gr                *    .       customlist  exe fugitive#ReadCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" Gread             *    .       customlist  exe fugitive#ReadCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" Grebase           ?    .       customlist  echohl WarningMSG|echo ":Grebase is deprecated in favor of :Git rebase\n"|echohl NONE| exe fugitive#Co
" Gremove           0            customlist  exe fugitive#RemoveCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" Grename           1            customlist  exe fugitive#RenameCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" Grevert           ?    .       customlist  echohl WarningMSG|echo ":Grevert is deprecated in favor of :Git revert\n"|echohl NONE| exe fugitive#Co
" Gsplit            *    .       customlist  exe fugitive#Open((<count> > 0 ? <count> : "").(<count> ? "split" : "edit"), <bang>0, "<mods>", <q-arg
" Gstatus           0    .                   exe fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>)
" Gtabedit          *    .  tab  customlist  exe fugitive#Open((<count> >= 0 ? <count> : "")."tabedit", <bang>0, "<mods>", <q-args>, [<f-args>])
" Gvdiffsplit       *            customlist  exe fugitive#Diffsplit(0, <bang>0, "vert <mods>", <q-args>, [<f-args>])
" Gvsplit           *    .       customlist  exe fugitive#Open((<count> > 0 ? <count> : "").(<count> ? "vsplit" : "edit!"), <bang>0, "<mods>", <q-a
" Gw                *            customlist  exe fugitive#WriteCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" Gwq               *            customlist  exe fugitive#WqCommand(   <line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" Gwrite            *            customlist  exe fugitive#WriteCommand(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, [<f-args>])
" Help              0                        call quickhelp#toggle()
" Helptags          0                        call fzf#vim#helptags(<bang>0)
" Hexplore          *    0c ?    dir         call netrw#Explore(<count>,1,2+<bang>0,<q-args>)
" History           *                        call s:history(<q-args>, fzf#vim#with_preview(), <bang>0)
" Justify           *    .                   <line1>,<line2>call Justify(<f-args>)
" Lexplore          *    0c ?    dir         call netrw#Lexplore(<count>,<bang>0,<q-args>)
" Lf                0                        call <SNR>21_open()
" Limelight         ?    .                   call limelight#execute(<bang>0, <count> > 0, <line1>, <line2>, <f-args>)
" Lines             *                        call fzf#vim#lines(<q-args>, <bang>0)
" Lint              0                        call make#lint()  " lint current file ... make %
" LiveEasyAlign     *    .                   <line1>,<line2>call easy_align#align(<bang>0, 1, 'command', <q-args>)
" Locate            +            dir         call fzf#vim#locate(<q-args>, fzf#vim#with_preview(), <bang>0)
" Lsp               1            customlist  call utils#cmd_exec('lsp',<q-args>)
" LspInfo           ?                        lua require'lspconfig'["_root"].commands["LspInfo"][1](<f-args>)
" Lspsaga           +            custom      lua require('lspsaga.command').load_command(<f-args>)
" Make              0                        call make#make()  " make project target
" Man               *    .       customlist  if <bang>0 | set ft=man | else | call man#open_page(<count>, <q-mods>, <f-args>) | endif
" Maps              0                        call fzf#vim#maps("n", <bang>0)
" Marks             0                        call fzf#vim#marks(<bang>0)
" MatchDebug        0                        call matchit#Match_debug()
" NetUserPass       *                        call NetUserPass(<f-args>)
" NetrwClean        0                        call netrw#Clean(<bang>0)
" NetrwSettings     0                        call netrwSettings#NetrwSettings()
" Nexplore          *                        call netrw#Explore(-1,0,0,<q-args>)
" NoMatchParen      0                        call s:NoMatchParen()
" Nread             *    1c ?                let s:svpos= winsaveview()|call netrw#NetRead(<count>,<f-args>)|call winrestview(s:svpos)
" Nsource           *                        let s:svpos= winsaveview()|call netrw#NetSource(<f-args>)|call winrestview(s:svpos)
" Ntree             ?                        call netrw#SetTreetop(1,<q-args>)
" Nwrite            *    %                   let s:svpos= winsaveview()|<line1>,<line2>call netrw#NetWrite(<f-args>)|call winrestview(s:svpos)
" PFiles            0                        call fzf#run(wrappers#project())
" Pexplore          *                        call netrw#Explore(-2,0,0,<q-args>)
" Plug              +                        call plug#(<args>)
" PlugClean         0                        call s:clean(<bang>0)
" PlugDiff          0                        call s:diff()
" PlugInstall       *            customlist  call s:install(<bang>0, [<f-args>])
" PlugSnapshot      ?            file        call s:snapshot(<bang>0, <f-args>)
" PlugStatus        0                        call s:status()
" PlugUpdate        *            customlist  call s:update(<bang>0, [<f-args>])
" PlugUpgrade       0                        if s:upgrade() | execute 'source' s:esc(s:me) | endif
" QuickfixToggle    0                        call quickfix#toggle()
" Rg                *                        call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape
" Run               0                        call make#run()   " run file through interpreter
" Sexplore          *    0c ?    dir         call netrw#Explore(<count>,1,0+<bang>0,<q-args>)
" SignifyDebug      0                        call sy#repo#debug_detection()
" SignifyDiff       0                        call sy#repo#diffmode(<bang>1)
" SignifyDisable    0                        call sy#stop()
" SignifyDisableAll 0                        call sy#stop_all()
" SignifyEnable     0                        call sy#start()
" SignifyEnableAll  0                        call sy#start_all()
" SignifyFold       0                        call sy#fold#dispatch(<bang>1)
" SignifyHunkDiff   0                        call sy#repo#diff_hunk()
" SignifyHunkUndo   0                        call sy#repo#undo_hunk()
" SignifyList       0                        call sy#debug#list_active_buffers()
" SignifyRefresh    0                        call sy#util#refresh_windows()
" SignifyToggle     0                        call sy#toggle()
" SignifyToggleHighlight 0                   call sy#highlight#line_toggle()
" Snippets          0                        call fzf#run(wrapper#snippets())
" SpaceReplace      0                        %s/    /\t/g
" StartupTime       *            file        call startuptime#profile(<f-args>)
" TOhtml            0    %                   :call tohtml#Convert2HTML(<line1>, <line2>)
" TSBufDisable      1            custom      lua require'nvim-treesitter.configs'.commands.TSBufDisable.run(<f-args>)
" TSBufEnable       1            custom      lua require'nvim-treesitter.configs'.commands.TSBufEnable.run(<f-args>)
" TSBufToggle       1            custom      lua require'nvim-treesitter.configs'.commands.TSBufToggle.run(<f-args>)
" TSConfigInfo      0                        lua require'nvim-treesitter.configs'.commands.TSConfigInfo.run(<f-args>)
" TSDisableAll      +            custom      lua require'nvim-treesitter.configs'.commands.TSDisableAll.run(<f-args>)
" TSEnableAll       +            custom      lua require'nvim-treesitter.configs'.commands.TSEnableAll.run(<f-args>)
" TSInstall         +            custom      lua require'nvim-treesitter.install'.commands.TSInstall.run(<f-args>)
" TSInstallFromGrammar +         custom      lua require'nvim-treesitter.install'.commands.TSInstallFromGrammar.run(<f-args>)
" TSInstallInfo     0                        lua require'nvim-treesitter.info'.commands.TSInstallInfo.run(<f-args>)
" TSInstallSync     +            custom      lua require'nvim-treesitter.install'.commands.TSInstallSync.run(<f-args>)
" TSModuleInfo      ?            custom      lua require'nvim-treesitter.info'.commands.TSModuleInfo.run(<f-args>)
" TSToggleAll       +            custom      lua require'nvim-treesitter.configs'.commands.TSToggleAll.run(<f-args>)
" TSUninstall       +            custom      lua require'nvim-treesitter.install'.commands.TSUninstall.run(<f-args>)
" TSUpdate          *            custom      lua require'nvim-treesitter.install'.commands.TSUpdate.run(<f-args>)
" TabReplace        0                        %s/\t/    /g
" Tagbar            0                        call tagbar#ToggleWindow()
" TagbarClose       0                        call tagbar#CloseWindow()
" TagbarCurrentTag  ?                        echo tagbar#currenttag('%s', 'No current tag', <f-args>)
" TagbarDebug       ?                        call tagbar#debug#start_debug(<f-args>)
" TagbarDebugEnd    0                        call tagbar#debug#stop_debug()
" TagbarForceUpdate 0                        call tagbar#ForceUpdate()
" TagbarGetTypeConfig 1                      call tagbar#gettypeconfig(<f-args>)
" TagbarJump        0                        call tagbar#jump()
" TagbarOpen        ?                        call tagbar#OpenWindow(<f-args>)
" TagbarOpenAutoClose 0                      call tagbar#OpenWindow('fcj')
" TagbarSetFoldlevel 1                       call tagbar#SetFoldLevel(<args>, <bang>0)
" TagbarShowTag     0                        call tagbar#highlighttag(1, 1)
" TagbarToggle      0                        call tagbar#ToggleWindow()
" TagbarTogglePause 0                        call tagbar#toggle_pause()
" Tags              *                        call fzf#vim#tags(<q-args>, {      'options': '         --with-nth 1,2         --prompt "=> "
" Template          0                        call s:templates()
" TerminalToggle    0                        call utils#toggle('term', 'call term#open()')
" TestFile          *            file        call test#run('file', split(<q-args>))
" TestLast          *                        call test#run_last(split(<q-args>))
" TestNearest       *                        call test#run('nearest', split(<q-args>))
" TestSuite         *                        call test#run('suite', split(<q-args>))
" TestVisit         0                        call test#visit()
" Texplore          *    0c ?    dir         call netrw#Explore(<count>,0,6        ,<q-args>)
" ToggleBackup      0                        call cache#toggle_backup()
" Tree              ?            dir         call tree#open(<f-args>)
" TreeToggle        0                        call utils#toggle('vimtree', 'VGTree')
" Trim              0                        call s:trim()
" Tutor             ?            custom      call tutor#TutorCmd(<q-args>)
" Twiggy            *            custom      call twiggy#Branch(<f-args>)
" UndotreeFocus     0                        :call undotree#UndotreeFocus()
" UndotreeHide      0                        :call undotree#UndotreeHide()
" UndotreeShow      0                        :call undotree#UndotreeShow()
" UndotreeToggle    0                        :call undotree#UndotreeToggle()
" UpdateRemotePlugins 0                      call remote#host#UpdateRemotePlugins()
" VTree             ?            dir         vsp | call tree#open(<f-args>)
" Vexplore          *    0c ?    dir         call netrw#Explore(<count>,1,4+<bang>0,<q-args>)
" Vimrc             0                        so ~/.config/nvim/init.vim
" Vimuntar          ?            file        call tar#Vimuntar(<q-args>)
" VsnipOpen         0                        call s:open_command(<bang>0, 'vsplit')
" VsnipOpenEdit     0                        call s:open_command(<bang>0, 'edit')
" VsnipOpenSplit    0                        call s:open_command(<bang>0, 'split')
" VsnipOpenVsplit   0                        call s:open_command(<bang>0, 'vsplit')
" VsnipYank         ?    .                   call s:add_command(<line1>, <line2>, <q-args>)
" Windows           0                        call fzf#vim#windows(<bang>0)
" ZVKeyDocset       0                        Zeavim!
" Zeavim            0    .                   call zeavim#SearchFor('<bang>', expand('<cword>'), '')
" ZeavimV           0    .                   call zeavim#SearchFor('', '', 'v')
" ZvV               0    .                   ZeavimV


