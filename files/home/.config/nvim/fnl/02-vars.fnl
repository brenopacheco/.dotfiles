; transpiles to `local a = 1` (local to file)
(local a 1)

; this fails
; (set a 2) 

; transpiles to `local a = 1` (local to file)
(var b 1)

(set b 2)

; transpiles to `do local a = 1 end` (local to enclojure)
(let [c 1] 1)

; transpiles to `do local d, e, f = 1, 2, 3 end` (local to enclojure)
(let [d 1] (local e 2) (var f 3) (print (+ d e f)))

; last statement is what the module file returns
(let [z {}] z)
