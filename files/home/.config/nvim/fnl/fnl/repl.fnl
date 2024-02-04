;;; Fennel repl module
;;
;; This module provides a repl for fennel.
;; A special prompt buffer is used to capture input and output.
;;
;; References:
;; https://wiki.fennel-lang.org/Repl
;; https://github.com/gpanders/fennel-repl.nvim/blob/master/fnl/fennel-repl.fnl
;;
;; WARN: OUTDATED
;; Functions: 
;; - start          starts the repl
;; - reset          restarts the repl
;; - teardown       terminate the repl
;; - open           open window (starts repl if not started)
;; - close          closes the repl window
;; - toggle         toggle the repl window
;; - send           sends a string to the repl
;; - setup          configures the repl, optionally creating commands
;;   + help?         boolean - if true, starts repl with the ,help message (default: true)
;;   + cmds         boolean - if true, creates commands (default: true)
;;   + mappings     boolean - apply default prompt mappings (default: see *mappings*)
;; - exit-prompt    leaves the prompt
;; - cancel-prompt  leaves prompt and clears it
;; - clear-prompt   clears prompt
;; - clear-repl     clears the repl buffer
;;
;; WARN: OUTDATED
;; Commands provided (optionally):
;; - :FennelReplOpen    opens the repl window (starts repl if not started)
;; - :FennelReplClose   closes the repl window
;; - :FennelReplToggle  toggles repl window open or closed
;; - :FennelReplReset   restarts repl (open window)
;; - :FennelReplEvalExpr    sends expression under cursor to repl
;; - :FennelReplEvalRange   sends range to repl
;; - :FennelReplEvalBuffer  sends buffer to repl

; TODO: [ ] - document functions
; TODO  [ ] - make docs

(local fennel (require :fennel))

(local bufname "fennel:///repl")
(local complete-prompt ">> ")
(local incomplete-prompt ".. ")

(local config {:help? true
               :cmds? true
               :mappings? true
               :macro-files [":macros"]
               :plugins [:repl.plugins]
               :on-out (λ [ok out-or-err] nil)})

(local options {:useMetadata true
                :compiler-env _G
                :compilerEnv _G
                :env _G
                :allowedGlobals false
                :error-pinpoint false})

(var group nil)
(var repl nil)
(var incomplete? false)
(var history [])
(var history-index 0)

(λ wrap [body]
  (vim.schedule_wrap body))

(λ extend [orig tbl]
  "extend original table"
  (icollect [k v (pairs tbl)]
    (tset orig k v))
  orig)

(λ accept-line? [text]
  (let [is-empty? (text:match "^%s*$")
        is-comment? (text:match "^%s*;")]
    (not (or is-empty? is-comment?))))

(fn get-buffer []
  (let [bufnr (vim.fn.bufnr bufname)]
    (if (= -1 bufnr) nil bufnr)))

(fn get-window []
  (select 1 (unpack (vim.fn.win_findbuf (get-buffer)))))

(λ set-option [name value]
  (vim.api.nvim_set_option_value name value {:buf (assert (get-buffer))}))

(λ autocmd [events callback]
  (let [opts {: group : callback :buffer (assert (get-buffer)) :nested false}]
    (vim.api.nvim_create_autocmd events opts)))

(λ set-mapping [modes lhs rhs]
  (let [desc (fennel.doc rhs)]
    (vim.keymap.set modes lhs rhs {:buffer (assert (get-buffer)) : desc})))

(fn make-augroup []
  (vim.api.nvim_create_augroup :fennel-repl {:clear true}))

(fn get-copilot []
  (let [clients (vim.lsp.get_clients)]
    (accumulate [client# nil _ client (ipairs clients) &until (not= client# nil)]
      (if (= client.name :copilot)
          client))))

(fn detach-copilot []
  (let [bufnr (assert (get-buffer))
        copilot (get-copilot)]
    (if (and bufnr copilot)
        (if (vim.lsp.buf_is_attached bufnr copilot.id)
            (vim.lsp.buf_detach_client bufnr copilot.id)))))

(fn clear-repl []
  "Clear fennel repl"
  (vim.api.nvim_buf_set_lines (assert (get-buffer)) 0 -1 false
                              [complete-prompt]))

(fn clear-prompt []
  "Clear fennel prompt"
  (vim.cmd :stopinsert)
  (set history-index 0)
  (vim.fn.setbufline (assert (get-buffer)) "$" complete-prompt))

(fn exit-prompt []
  "Exit fennel prompt"
  (vim.cmd :stopinsert))

(λ history-jump [direction]
  (let [index (match direction
                :next (+ history-index 1)
                :prev (- history-index 1))
        elem (. history index)]
    (when elem
      (do
        (set history-index index)
        (vim.fn.setline "$" (.. complete-prompt elem))))))

(fn history-next []
  "Jump to next history entry"
  (history-jump :next))

(fn history-prev []
  "Jump to prev history entry"
  (history-jump :prev))

(local mappings [[[:i] :<c-l> clear-repl]
                 [[:i] :<c-c> clear-prompt]
                 [[:i] :<esc> exit-prompt]
                 [[:i] :jk exit-prompt]
                 [[:i] :kj exit-prompt]
                 [[:i] :<up> history-next]
                 [[:i] :<c-p> history-next]
                 [[:i] :<down> history-prev]
                 [[:i] :<c-n> history-prev]])

(λ append-prompt [lines]
  (let [buf (assert (get-buffer))
        lnum (- (vim.api.nvim_buf_line_count buf) 1)]
    (vim.fn.appendbufline buf lnum lines)))

(λ repl-on-out [output] ; output is a list of strings with \n inside them
  (local lines [])
  (icollect [_ str (ipairs output)]
    (icollect [_ line (ipairs (vim.split str "\n")) :into lines]
      line))
  (config.on-out true lines)
  (append-prompt lines))

(λ repl-on-err [err-type msg] ; msg is a single string with \n inside it
  (local lines [])
  (icollect [_ line (ipairs (vim.split msg "\n")) :into lines]
    line)
  (config.on-out false [err-type lines])
  (append-prompt lines))

(fn repl-send [input]
  (assert repl "Repl not started")
  (let [(_ {: stack-size}) (coroutine.resume repl (.. input "\n"))]
    (set incomplete? (not= 0 stack-size))))

(fn teardown []
  (let [winid (get-window)
        bufnr (get-buffer)]
    (when winid (vim.api.nvim_win_close winid true))
    (when bufnr (vim.api.nvim_buf_delete bufnr {:force true})))
  (set group (make-augroup))
  (set repl nil)
  (set incomplete? false)
  (set history-index 0)
  (set history []))

(λ history-update [was-completing? incomplete? text]
  (local current-history (or (. history 1) ""))
  (local add-entry (fn []
                     (table.insert history 1 text)
                     (set history-index 0)))
  (local update-entry
         (fn []
           (tset history 1 (.. current-history " " text))))
  (if (accept-line? text)
      (match [was-completing? incomplete?]
        [false false] (add-entry)
        [true false] (update-entry)
        [false true] (add-entry)
        [true true] (update-entry))))

(λ prompt-callback [text]
  (local was-completing? incomplete?)
  (repl-send text)
  (history-update was-completing? incomplete? text)
  (let [prompt (if incomplete? incomplete-prompt complete-prompt)]
    (vim.fn.prompt_setprompt (assert (get-buffer)) prompt))
  (if (= text ",exit")
      (teardown)))

(λ send [lines]
  (each [_ line (ipairs lines)]
    (let [prefix (if incomplete? incomplete-prompt complete-prompt)]
      (if (accept-line? line)
          (do
            (append-prompt [(.. prefix line)])
            (prompt-callback line))))))

(fn make-buffer []
  (let [bufnr (vim.api.nvim_create_buf true true)]
    (vim.api.nvim_buf_set_name bufnr bufname)
    (set-option :filetype :fennel)
    (set-option :buftype :prompt)
    (set-option :complete ".,w")
    (vim.fn.prompt_setprompt bufnr complete-prompt)
    (vim.fn.prompt_setcallback bufnr prompt-callback)
    (autocmd [:LspAttach] (wrap detach-copilot))
    (when config.mappings?
      (each [_ [mode lhs rhs] (ipairs mappings)]
        (set-mapping mode lhs rhs)))
    (set repl (coroutine.create fennel.repl))
    (let [options (extend options
                          {:readChunk coroutine.yield
                           :onValues repl-on-out
                           :onError repl-on-err})]
      (coroutine.resume repl options))
    (when config.help? (repl-send ",help"))
    (send (icollect [_ module (ipairs config.macro-files)]
            (.. "(require-macros " module ")")))
    bufnr))

(fn make-window []
  (vim.cmd :vsplit)
  (let [bufnr (assert (get-buffer))
        winid (vim.api.nvim_get_current_win)]
    (vim.api.nvim_win_set_buf winid bufnr)
    winid))

(fn focus []
  (let [winid (get-window)]
    (vim.api.nvim_set_current_win winid)
    (vim.cmd :startinsert)))

(fn close []
  (let [win (get-window)]
    (when win (vim.api.nvim_win_close win true))))

(fn start []
  (or (get-buffer) (make-buffer)))

(fn open []
  (or (get-buffer) (make-buffer))
  (or (get-window) (make-window))
  (focus))

(fn toggle []
  (if (get-window) (close) (open)))

(fn reset []
  (teardown)
  (open))

(fn eval-expr []
  (local bufnr (vim.api.nvim_get_current_buf))
  (: (vim.treesitter.get_parser bufnr) :parse)
  (var text "")
  (var node (vim.treesitter.get_node))
  (while (node:parent)
    (set text (vim.treesitter.get_node_text node bufnr))
    (set node (node:parent)))
  (send (vim.split text "\n")))

(fn eval-range []
  (error "Not implemented"))

(fn eval-buffer []
  (local buf (vim.api.nvim_buf_get_lines 0 0 -1 true))
  (send buf))

(local cmds [[:FennelReplOpen open]
             [:FennelReplClose close]
             [:FennelReplToggle toggle]
             [:FennelReplReset reset]
             [:FennelReplEvalExpr eval-expr]
             [:FennelReplEvalRange eval-range]
             [:FennelReplEvalBuffer eval-buffer]])

(fn cmds-add []
  (each [_ [name fun] (ipairs cmds)]
    (vim.api.nvim_create_user_command name fun {})))

(fn cmds-del []
  (each [_ [name] (ipairs cmds)]
    (pcall vim.api.nvim_del_user_command name)))

(λ setup [?config ?options]
  (extend config (or ?config {}))
  (extend options (or ?options {}))
  (if config.cmds? (cmds-add) (cmds-del)))

;; export
{: start
 : reset
 : teardown
 : open
 : close
 : toggle
 : send
 : eval-expr
 : eval-buffer
 : setup
 : focus
 : clear-repl
 : clear-prompt
 : exit-prompt
 : history-next
 : history-prev}
