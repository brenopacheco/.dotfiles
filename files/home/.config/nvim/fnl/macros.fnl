(lambda find [x lst cond]
  ;; (print (find x [1 2 3] (= x 2)))
  `(do
     (var item# nil)
     (each [_# ,x (ipairs ,lst) &until item#]
       (when ,cond (set item# ,x)))
     item#))

(lambda map [x lst cond]
  ;; (vim.print (map* x [1 2 3] (* x x)))
  `(icollect [_# ,x (ipairs ,lst)]
     ,cond))

(lambda filter [x lst cond]
  ;; (vim.print (filter* x [1 2 3] (> x 1)))
  `(icollect [_# ,x (ipairs ,lst)]
     (when ,cond ,x)))

(lambda each* [x lst cond]
  ;; (each* x [1 2 3] (print (.. "x = " x)))
  `(each [_# ,x (ipairs ,lst) &until item#]
     ,cond))

(lambda any? [x lst cond]
  ;; (print (any? x [1 2 3] (= x 4)))
  `(accumulate [match?# false _# ,x (ipairs ,lst) &until match?#]
     ,cond))

(lambda all? [x lst cond]
  ;; (print (all? x [1 2 3] (> x 1)))
  `(accumulate [match?# true _# ,x (ipairs ,lst) &until (not match?#)]
     ,cond))

(fn in? [elem list]
  ;; (vim.print (in? 1 [0 2 2 3]))
  (accumulate [match? false _ x (ipairs list) &until match?]
    (= x elem)))

(fn flatten [list depth buf]
  ;; (vim.print (flatten [1 [2 3] [[4]] 5 nil] 3))
  (local depth (or depth 1))
  (local buf (or buf []))
  (if (or (< depth 0) (not= :table (type list)))
      (do
        (table.insert buf list)
        buf)
      (each [_ item (ipairs list)]
        (flatten item (- depth 1) buf)))
  buf)

(fn extend [list1 list2 ...]
  ;; (vim.print (extend [1 [2] 3] [4 5 6] [7]))
  (flatten [list1 list2 ...] 1))

(fn take [n list]
  ;; (vim.print (take 2 [1 2 3 4 5]))
  (fcollect [i 1 n 1]
    (. list i)))

(fn skip [n list]
  ;; (vim.print (skip 3 [1 2 3 4 5 6]))
  (select (+ n 1) (unpack list)))

{: find
 : map
 : filter
 : each*
 : any?
 : all?
 : in?
 : flatten
 : extend
 : take
 : skip}
