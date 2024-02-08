;; fennel-ls: macro-file

;;; trace macros
;;
;; (trace name) will override fun so that it prints the name of the the
;; function and its arguments when it is called and print the result when it
;; returns.
;;
;; e.g
;;  (fn x [a b] (values (+ a b) :hi))
;;  (trace x)
;;  (x 3 4 nil 4) => called (x 3 4 nil 4) => 7 hi
;;
;; TODO: (untrace name)

(lambda trace [fun]
  (local fun# (sym (.. "_" (. fun 1))))
  `(values (local ,fun# ,fun)))

;;          (fn ,fun
;;                               [...]
;;                               (let [z# (fn [...]
;;                                          (var sarg# "")
;;                                          (local args# [...])
;;                                          (for [i# 1 (select "#" ...)]
;;                                            (set sarg#
;;                                                 (.. sarg# " "
;;                                                     (vim.inspect (. args# i#)))))
;;                                          (values sarg# [...]))
;;                                     (sarg#) (z# ...)
;;                                     (sres# res#) (z# (,fun# ...))]
;;                                 (print (string.format "called (x%s) => %s"
;;                                                       sarg# sres#))
;;                                 (unpack res#)))))

(fn trace2 [fun]
  (local fun# (sym (.. "_" (. fun 1))))
  `(values (local ,fun# (fn [] :hi))))

{: trace : trace2}
