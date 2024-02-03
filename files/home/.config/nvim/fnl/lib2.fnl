(macro find* [x lst cond]
  ;; (print (find* x [1 2 3] (= x 2)))
  `(do
     (var item# nil)
     (each [_# ,x (ipairs ,lst) &until item#]
       (when ,cond (set item# ,x)))
     item#))

(macro map* [x lst cond]
  ;; (vim.print (map* x [1 2 3] (* x x)))
  `(icollect [_# ,x (ipairs ,lst)]
     ,cond))

(macro filter* [x lst cond]
  ;; (vim.print (filter* x [1 2 3] (> x 1)))
  `(icollect [_# ,x (ipairs ,lst)]
     (when ,cond ,x)))

(macro each* [x lst cond]
  ;; (each* x [1 2 3] (print (.. "x = " x)))
  `(each [_# ,x (ipairs ,lst) &until item#]
     ,cond))

(fn flat** [list depth buf]
  ;; (vim.print (flat** [1 [2 3] [[4]] 5 nil] 3))
  (local depth (or depth 1))
  (local buf (or buf []))
  (if (or (< depth 0) (not= :table (type list)))
      (do
        (table.insert buf list)
        buf)
      (each [_ item (ipairs list)]
        (flat** item (- depth 1) buf)))
  buf)

(fn in? [elem list]
  ;; (vim.print (in? 1 [0 2 2 3]))
  (not= nil (find* x list (= x elem))))

; (fn extend [...]
;   (local result [])
;   (each* list [...] (each* elem list (table.insert result elem)))
;   result)

(fn extend [...]
    ;; (vim.print (extend [1 [2] 3] [4 5 6] [7]))
    (flat** [...] 1))


;; any
;; all
;; take
;; skip
;; flatten
