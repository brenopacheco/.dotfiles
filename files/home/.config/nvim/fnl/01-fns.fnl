; (lambda print-x [x ?y z]
;   (pwarn (+ x (or ?y 0) z)))

; ; (print-x 5 3 4)

; (let [x 5
;       f (lambda [y] (+ x y))]
;   (pwarn (.. "f 3 -> " (f 3))))
