;;; Fennel repl module
;;
;; This module provides a repl for fennel. 
;; A special prompt buffer is used to capture input and output.
;;
;; Functions:
;; - open!           starts the repl and open window
;; - close!          closes the repl window
;; - reset!          resets the repl, closing the window
;; - toggle!         toggle the repl open or closed
;; - send!           sends a string to the repl
;; - setup!          configures the repl, optionally creating commands
;;   + help?         boolean - if true, starts repl with the ,help message (default: true)
;;   + cmds?         boolean - if true, creates commands (default: true)
;;   + mappings      list    - mappings to add to the repl buffer (default: see *mappings*)
;;   + prompts       list    - complete and incomplete prompt strings
;;   + 
;; - exit-prompt!    leaves the prompt
;; - cancel-prompt!  leaves prompt and clears it
;; - clear-prompt!   clears prompt
;; - clear-repl!     clears the repl buffer
;;
;; Commands provided (optionally):
;; - :FennelReplOpen:   opens the repl window
;; - :FennelReplClose:  closes the repl window
;; - :FennelReplToggle: toggles repl window open or closed
;; - :FennelReplSend    <range> sends the range content to the repl

; https://github.com/gpanders/fennel-repl.nvim/blob/master/fnl/fennel-repl.fnl
; https://wiki.fennel-lang.org/Repl

; TODO: [ ] - fix io.write WARNING that happens on start ( in require :fennel)
; TODO: [ ] - fix repl not capturing stdout - e.g: (fn x [ ] (print "hi")) (x)
; TODO: [ ] - fix escape sequences not rendering in prompt buffer
; TODO: [x] - add command to open repl
; TODO: [ ] - toggle instead of resetting
; TODO: [ ] - add functions to send to repl (eval expr)
; TODO: [ ] - add mappings for evaling, reloading/toggling repl, etc
; TODO: [ ] - move locals into the open function

(local fennel (require :fennel))

(local bufname "fennel:///repl")
(local complete-prompt ">> ")
(local incomplete-prompt ".. ")

(var group nil)
(var repl nil)
(var incomplete? false)

(λ wrap [body]
  (vim.schedule_wrap body))

(fn get-buffer []
  (let [bufnr (vim.fn.bufnr bufname)]
    (if (= -1 bufnr) nil bufnr)))

(fn get-window []
  (select 1 (unpack (vim.fn.win_findbuf (get-buffer)))))

(λ set-option! [name value]
  (vim.api.nvim_set_option_value name value {:buf (get-buffer)}))

(λ autocmd! [events callback]
  (let [opts {: group : callback :buffer (get-buffer) :nested false}]
    (vim.api.nvim_create_autocmd events opts)))

(λ set-mapping! [modes lhs rhs desc]
  (vim.keymap.set modes lhs rhs {:buffer (get-buffer) : desc}))

(fn make-augroup! []
  (vim.api.nvim_create_augroup :fennel-repl {:clear true}))

(fn get-copilot []
  (let [clients (vim.lsp.get_clients)]
    (accumulate [client# nil _ client (ipairs clients) &until (not= client# nil)]
      (if (= client.name :copilot)
          client))))

(fn detach-copilot! []
  (let [bufnr (get-buffer)
        copilot (get-copilot)]
    (if (and bufnr copilot)
        (if (vim.lsp.buf_is_attached bufnr copilot.id)
            (vim.lsp.buf_detach_client bufnr copilot.id)))))

(fn clear-prompt! []
  (vim.print :clear-prompt)
  (vim.api.nvim_buf_set_lines (get-buffer) 0 -1 false [complete-prompt]))

(fn cancel-prompt! []
  (vim.print :cancel-prompt)
  (vim.cmd :stopinsert)
  (vim.fn.setline "$" complete-prompt))

(fn exit-prompt! []
  (vim.print :exit-prompt)
  (vim.cmd :stopinsert))

(local mappings [[[:i] :<C-l> clear-prompt! "Clear fennel prompt"]
                 [[:i] :<C-c> cancel-prompt! "Clear fennel prompt"]
                 [[:i] :<esc> exit-prompt! "Exit fennel prompt"]
                 [[:i] :jk exit-prompt! "Exit fennel prompt"]
                 [[:i] :kj exit-prompt! "Exit fennel prompt"]])

(λ repl-on-out! [output] ; output is a list of strings with \n inside them
  (local lines [])
  (icollect [_ str (ipairs output)]
    (icollect [_ line (ipairs (vim.split str "\n")) :into lines]
      line))
  (vim.fn.append (- (vim.fn.line "$") 1) lines))

(λ repl-on-err! [err-type msg] ; msg is a single string with \n inside it
  (local lines [])
  (icollect [_ line (ipairs (vim.split msg "\n")) :into lines]
    line)
  (vim.fn.append (- (vim.fn.line "$") 1) lines))

(fn repl-send! [input]
  (let [(_ {: stack-size}) (coroutine.resume repl (.. input "\n"))]
    (set incomplete? (not= 0 stack-size))))

(λ repl-start! []
  (set repl (coroutine.create fennel.repl))
  (coroutine.resume repl {:readChunk coroutine.yield
                          :onValues repl-on-out!
                          :onError repl-on-err!
                          :pp fennel.view
                          :env _G}))

(fn repl-reset! []
  (let [winid (get-window)
        bufnr (get-buffer)]
    (if winid (vim.api.nvim_win_close winid true))
    (if bufnr (vim.api.nvim_buf_delete bufnr {:force true})))
  (set group (make-augroup!))
  (set repl nil)
  (set incomplete? false))

(fn close! []
  (repl-reset!))

(λ prompt-callback [text]
  (repl-send! text)
  (let [prompt (if incomplete? incomplete-prompt complete-prompt)]
    (vim.fn.prompt_setprompt (get-buffer) prompt))
  (if (= text ",exit")
      (close!)))

(fn make-buffer! []
  (let [bufnr (vim.api.nvim_create_buf true true)]
    (vim.api.nvim_buf_set_name bufnr bufname)
    (set-option! :filetype :fennel)
    (set-option! :buftype :prompt)
    (set-option! :complete ".,w")
    (vim.fn.prompt_setprompt bufnr complete-prompt)
    (vim.fn.prompt_setcallback bufnr prompt-callback)
    (autocmd! [:BufEnter] (fn [] (vim.cmd :startinsert)))
    (autocmd! [:LspAttach] (wrap detach-copilot!))
    (each [_ map (ipairs mappings)]
      (set-mapping! (unpack map)))
    (repl-start!)
    bufnr))

(fn make-window! []
  (vim.cmd :vsplit)
  (let [bufnr (get-buffer)
        winid (vim.api.nvim_get_current_win)]
    (vim.api.nvim_win_set_buf winid bufnr)
    winid))

(fn focus! []
  (let [winid (get-window)]
    (vim.api.nvim_set_current_win winid)))

(fn open! [help?]
  (repl-reset!)
  (or (get-buffer) (make-buffer!))
  (or (get-window) (make-window!))
  (focus!)
  (if help? (repl-send! ",help")))

; (vim.api.nvim_create_user_command :FennelRepl open {:nargs 0})

;; export module
{: open! : close!}
