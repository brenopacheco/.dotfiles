; %(local fennel (require :fennel))

(local group (vim.api.nvim_create_augroup :fennel-repl {:clear true}))

(var input "")
(var buffer ["> "])

(macro mwrap [body]
  `(vim.schedule_wrap (fn [...] ,body)))

(lambda wrap [body]
  (vim.schedule_wrap body))

(fn find-window [bufnr]
  (let [winnrs (vim.api.nvim_tabpage_list_wins 0)]
    (accumulate [win nil _ winnr (ipairs winnrs) &until (not= win nil)]
      (let [win_bufnr (vim.api.nvim_win_get_buf winnr)]
        (if (= win_bufnr bufnr) winnr nil)))))

(fn set-option [bufnr name value]
  (vim.api.nvim_set_option_value name value {:buf bufnr}))

(fn autocmd [buffer events callback]
  (let [opts {: group : callback : buffer}]
    (vim.api.nvim_create_autocmd events opts)))

(lambda redraw-buffer [bufnr]
  (vim.api.nvim_buf_set_lines bufnr 0 -1 true buffer))

(lambda on-input-buffer-changed [input-buffer repl-buffer] ; get the tail of the buffer
  (let [lines (vim.api.nvim_buf_get_lines input-buffer 0 -1 false)] ; (log {: lines})
    (if (> (length lines) 1)
        (do
          (tset buffer (length buffer) (.. "> " input))
          (table.insert buffer "> ")
          (set input "")
          (vim.cmd (.. (tostring input-buffer) :bw!))
          (vim.cmd "norm! i"))
        (set input (. lines 1)))))

(fn on-input-buffer-leave [input-buffer repl-buffer]
  (vim.cmd (.. (tostring input-buffer) :bw!))
  (tset buffer (length buffer) (.. "> " input))
  (redraw-buffer repl-buffer))

(lambda make-input-buffer [repl-buffer]
  (let [bufname "fennel:///repl-input"
        bufnr (vim.fn.bufnr bufname)]
    (if (not= bufnr -1)
        (pcall vim.api.nvim_buf_delete bufnr {:force true}))
    (let [bufnr (vim.api.nvim_create_buf false true)]
      (vim.api.nvim_buf_set_lines bufnr -2 -1 true [input])
      (set-option bufnr :filetype :fennel)
      (autocmd bufnr [:BufLeave :InsertLeave]
               (wrap (fn [] (on-input-buffer-leave bufnr repl-buffer))))
      (autocmd bufnr [:TextChanged :TextChangedI :TextChangedP]
               (wrap (fn [] (on-input-buffer-changed bufnr repl-buffer))))
      bufnr)))

(lambda make-input-window [input-buffer repl-window]
  (let [width (vim.api.nvim_win_get_width repl-window)]
    (let [input-window (vim.api.nvim_open_win input-buffer true
                                              {:relative :win
                                               :row (- (vim.fn.line "$") 1)
                                               :col 8
                                               :width (- width 8)
                                               :height 1
                                               :focusable false
                                               :zindex 500
                                               :border :none
                                               :style :minimal
                                               :hide false})]
      (vim.api.nvim_win_set_cursor input-window [1 (length input)]))))

(fn on-repl-insert-enter [ev]
  (log :insert-enter)
  (let [repl-buffer (. ev :buf)
        repl-window (find-window repl-buffer)
        input-buffer (make-input-buffer repl-buffer)
        input-window (make-input-window input-buffer repl-window)]
    input-window))

(fn on-repl-buffer-changed [ev]
  (redraw-buffer ev.buf))

(fn make-repl-buffer [bufname]
  (let [bufnr (vim.api.nvim_create_buf true true)]
    (set-option bufnr :filetype :fennel)
    (vim.api.nvim_buf_set_name bufnr bufname)
    (autocmd bufnr [:TextChanged :TextChangedP :TextChangedI]
             (wrap on-repl-buffer-changed))
    (autocmd bufnr [:InsertEnter] (wrap on-repl-insert-enter))
    (redraw-buffer bufnr)
    bufnr))

(fn find-buffer [bufname]
  (let [bufnr (vim.fn.bufnr bufname)]
    (if (= -1 bufnr) nil bufnr)))

(lambda get-repl-buffer [bufname]
  (or (find-buffer bufname) (make-repl-buffer bufname)))

(fn make-repl-window [bufnr]
  (do
    (vim.cmd :vsplit)
    (let [winnr (vim.api.nvim_get_current_win)] ; (log {: winnr})
      (vim.api.nvim_win_set_buf winnr bufnr)
      winnr)))

(lambda get-repl-window [bufnr] ; (log {: bufnr})
  (let [winnr (or (find-window bufnr) (make-repl-window bufnr))]
    (vim.api.nvim_set_current_win winnr)
    winnr))

(fn open []
  (let [bufname "fennel:///repl-buffer"
        _ (pcall vim.api.nvim_buf_delete (find-buffer bufname) {:force true})
        bufnr (get-repl-buffer bufname)
        winnr (get-repl-window bufnr)]
    {: bufname : bufnr : winnr}))

(open)
