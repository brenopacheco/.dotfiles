(macro find [[x lst] & expr]
  `(foo)
  `(do
     (local res# [])
     (icollect [_# ,x (ipairs ,lst) :into res#]
       (when (do
               ,(unpack expr))
         ,x))
     (. res# 1)))

(find [x [1 2 3]] (local y 2) (> x y))



; (macro list [& expr]
;   "usage: (list 1 2 (unpack [3 4]) (unpack [4 5]))"
;   `(icollect [_# arg# (ipairs ,expr)]
;      arg#))

; (find x :in [1 2 3] :where (= x 1))

; (macro find [& expr]
;   (match expr
;     (where (or [needle :in haystack :where clause]
;                [needle :where clause :in haystack])) `(do
;                                                             (var elem# nil)
;                                                             (each [_# ,needle (ipairs ,haystack)
;                                                                    :until elem#]
;                                                               (if ,clause
;                                                                   (set elem#
;                                                                        ,needle)))
;                                                             elem#)
;     _ nil))

; (macrodebug (find x :in [1 2 3] :where (= x 1)))
; (vim.print (find x :in [1 2 3] :where (= x 1)))
; (vim.print (find x :where (> x 4) :in [0 -1 2 6 3]))

; (icollect [key value iterator] expr)
; (find [var list] expr)


