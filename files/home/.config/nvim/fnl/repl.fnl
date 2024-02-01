; https://github.com/gpanders/fennel-repl.nvim/blob/master/fnl/fennel-repl.fnl
; https://wiki.fennel-lang.org/Repl

; TODO: [ ] - fix io.write WARNING that happens on start (where?)
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

(λ set-option [name value]
  (vim.api.nvim_set_option_value name value {:buf (get-buffer)}))

(λ autocmd [events callback]
  (let [opts {: group : callback :buffer (get-buffer) :nested false}]
    (vim.api.nvim_create_autocmd events opts)))

(λ set-mapping [modes lhs rhs desc]
  (vim.keymap.set modes lhs rhs {:buffer (get-buffer) : desc}))

(fn make-augroup []
  (vim.api.nvim_create_augroup :fennel-repl {:clear true}))

(fn get-copilot []
  (let [clients (vim.lsp.get_clients)]
    (accumulate [client# nil _ client (ipairs clients) &until (not= client# nil)]
      (if (= client.name :copilot)
          client))))

(fn detach-copilot []
  (let [bufnr (get-buffer)
        copilot (get-copilot)]
    (if (and bufnr copilot)
        (if (vim.lsp.buf_is_attached bufnr copilot.id)
            (vim.lsp.buf_detach_client bufnr copilot.id)))))

(fn clear-prompt []
  (vim.print :clear-prompt)
  (vim.api.nvim_buf_set_lines (get-buffer) 0 -1 false [complete-prompt]))

(fn cancel-prompt []
  (vim.print :cancel-prompt)
  (vim.cmd :stopinsert)
  (vim.fn.setline "$" complete-prompt))

(fn exit-prompt []
  (vim.print :exit-prompt)
  (vim.cmd :stopinsert))

(local mappings [[[:i] :<C-l> clear-prompt "Clear fennel prompt"]
                 [[:i] :<C-c> cancel-prompt "Clear fennel prompt"]
                 [[:i] :<esc> exit-prompt "Exit fennel prompt"]
                 [[:i] :jk exit-prompt "Exit fennel prompt"]
                 [[:i] :kj exit-prompt "Exit fennel prompt"]])

(λ on-repl-out [output] ; output is a list of strings with \n inside them
  (local lines [])
  (icollect [_ str (ipairs output)]
    (icollect [_ line (ipairs (vim.split str "\n")) :into lines]
      line))
  (vim.fn.append (- (vim.fn.line "$") 1) lines))

(λ on-repl-err [err-type msg] ; msg is a single string with \n inside it
  (local lines [])
  (icollect [_ line (ipairs (vim.split msg "\n")) :into lines]
    line)
  (vim.fn.append (- (vim.fn.line "$") 1) lines))

(fn send-to-repl [input]
  (let [(_ {: stack-size}) (coroutine.resume repl (.. input "\n"))]
    (set incomplete? (not= 0 stack-size))))

(λ start-repl []
  (set repl (coroutine.create fennel.repl))
  (coroutine.resume repl {:readChunk coroutine.yield
                          :onValues on-repl-out
                          :onError on-repl-err
                          :pp fennel.view
                          :env _G}))

(fn reset-repl []
  (let [winid (get-window)
        bufnr (get-buffer)]
    (if winid (vim.api.nvim_win_close winid true))
    (if bufnr (vim.api.nvim_buf_delete bufnr {:force true})))
  (set group (make-augroup))
  (set repl nil)
  (set incomplete? false))

(fn close []
  (reset-repl))

(λ prompt-callback [text]
  (if (= text ",exit")
      (close)
      (do
        (send-to-repl text)
        (let [prompt (if incomplete? incomplete-prompt complete-prompt)]
          (vim.fn.prompt_setprompt (get-buffer) prompt)))))

(fn make-buffer []
  (let [bufnr (vim.api.nvim_create_buf true true)]
    (vim.api.nvim_buf_set_name bufnr bufname)
    (set-option :filetype :fennel)
    (set-option :buftype :prompt)
    (set-option :complete ".,w")
    (vim.fn.prompt_setprompt bufnr complete-prompt)
    (vim.fn.prompt_setcallback bufnr prompt-callback)
    (autocmd [:BufEnter] (fn [] (vim.cmd :startinsert)))
    (autocmd [:LspAttach] (wrap detach-copilot))
    (each [_ map (ipairs mappings)]
      (set-mapping (unpack map)))
    (start-repl)
    bufnr))

(fn make-window []
  (vim.cmd :vsplit)
  (let [bufnr (get-buffer)
        winid (vim.api.nvim_get_current_win)]
    (vim.api.nvim_win_set_buf winid bufnr)
    winid))

(fn focus []
  (let [winid (get-window)]
    (vim.api.nvim_set_current_win winid)))

(fn open []
  (reset-repl)
  (or (get-buffer) (make-buffer))
  (or (get-window) (make-window))
  (focus)
  (send-to-repl ",help"))

(vim.api.nvim_create_user_command :FennelRepl open {:nargs 0})

(let [M {: open}] M)
