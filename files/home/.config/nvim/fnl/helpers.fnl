;;; macro helpers
;;
;; these need to be loaded with (require inside macros)

(lambda parse-opts [opts]
  "parses a list such as [:foo 1 :bar 2] into table {:foo 1 :bar 2}"
  (faccumulate [args {} i 1 (length opts) 2]
    (let [key (. opts i)
          value (. opts (+ i 1))]
      (tset args key value)
      args)))

; (fn print-compiler-env! []
;   (eval-compiler
;     (each [name (pairs _G)]
;       (print name))))

(fn inspect! [...]
  (vim.print ...))

{: parse-opts
 ; : print-compiler-env! 
 : inspect!}
