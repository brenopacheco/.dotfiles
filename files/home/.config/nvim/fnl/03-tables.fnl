; (local tbl {:foo 1 :bar :bar :baz (fn [x] (pinfo x))})

; (pwarn (. tbl :foo))
; (pwarn (. tbl :bar))
; (let [f (. tbl :baz)]
;   (f "foo bar"))

; ((. tbl :baz) "bar baz")

; (tset tbl :foo 2)

(pwarn (let [tbl {}
             key1 "first key"
             key2 "second key"]
         (tset tbl key1 "first value")
         (tset tbl key2 "second value")
         tbl))
