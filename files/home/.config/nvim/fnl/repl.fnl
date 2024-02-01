; (local fennel (require :fennel))

(local bufname "fennel:///repl")
(local prompt "fennel> ")
(var group nil)

(λ prompt-callback [text]
  (vim.print {: text})
  (vim.fn.append (vim.fn.line "$") text))

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

(fn make-buffer []
  (let [bufnr (vim.api.nvim_create_buf true true)]
    (vim.api.nvim_buf_set_name bufnr bufname)
    (set-option :filetype :fennel)
    (set-option :buftype :prompt)
    (set-option :complete ".,w") ; TODO: add keymaps
    (vim.fn.prompt_setprompt bufnr prompt)
    (vim.fn.prompt_setcallback bufnr prompt-callback)
    (autocmd [:BufEnter] (fn [] (vim.cmd :startinsert)))
    (autocmd [:LspAttach] (wrap detach-copilot))
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

(fn reset []
  (let [winid (get-window)
        bufnr (get-buffer)]
    (if winid (vim.api.nvim_win_close winid true))
    (if bufnr (vim.api.nvim_buf_delete bufnr {:force true}))))

(fn open []
  (reset)
  (set group (make-augroup))
  (let [bufnr (or (get-buffer) (make-buffer))
        winid (or (get-window) (make-window))]
    (assert bufnr "failed to create buffer")
    (assert winid "failed to create window")
    (focus winid)
    (vim.print {: bufnr : winid})))

(open)

; export module
(let [M {: open}] M)
