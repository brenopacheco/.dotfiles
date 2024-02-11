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
;;  (x 3 4) => called (x 3 4) => 7 hi
;;
;; TODO: (untrace name)

(fn trace [fun]
  (local fname (. fun 1))
  `(values ;;
           (when (not (. _G :traced)) (tset _G :traced {})) ;;
           (tset (. _G :traced) ,fname ,fun) ;;
           (fn ,fun
             [& args#]
             (let [fun# (. (. _G :traced) ,fname)
                   res# [(fun# (unpack args#))]
                   tostr# (fn [pargs#]
                            (var str# "")
                            (for [i# 1 (length pargs#) 1]
                              (local parg# (. pargs# i#))
                              (if (= parg# nil)
                                  (set str# (string.format "%s nil" str#))
                                  (set str# (string.format "%s %s" str# parg#))))
                            str#)]
               (print (string.format "(%s%s) => %s" ,fname (tostr# args#)
                                     (tostr# res#)))
               (unpack res#)))))

(fn untrace [fun]
  (assert-compile (. _G :traced) "No functions are traced")
  (local fname (. fun 1))
  (assert-compile fun "Function is not traced")
  `(values ;;
           (fn ,fun
             [& args#]
             (let [fun# (. (. _G :traced) ,fname)]
               (fun# (unpack args#))))))

{: trace : untrace}
