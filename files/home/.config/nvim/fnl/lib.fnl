;;; helpers lib fennel lang
;; (find   needle :in haystack :where condition) -> needle
;; (filter needle :in haystack :where condition ?:into ?buffer) -> needle[]"
;; (map    needle :in haystack :where expr) -> needle[]

(macro find [needle & rest]
  "(find needle :in haystack :where condition) -> needle"
  (assert-compile needle "expected symbol for needle" needle)
  (let [{: parse-opts} (require :helpers)
        {:where condition :in haystack} (parse-opts rest)]
    (assert-compile haystack "expected :in haystack" rest)
    (assert-compile condition "expected :where condition" rest)
    `(do
       (var match# nil)
       (each [_# ,needle (ipairs ,haystack) &until match#]
         (when ,condition (set match# ,needle)))
       match#)))

;; (macrodebug (find x :in [1 2 3] :where (= x 1)))

(macro filter [needle & rest]
  "(filter needle :in haystack :where condition ?:into ?buffer) -> needle[]"
  (let [{: parse-opts} (require :helpers)
        {:where condition :in haystack :into ?buffer} (parse-opts rest)]
    `(icollect [_# ,needle (ipairs ,haystack) ,(when ?buffer
                                                 (values :into ?buffer))]
       (when ,condition ,needle))))

(macro map [needle & rest]
  "(map needle :in haystack :where expr ?:into ?buffer) -> needle[]"
  (let [{: parse-opts} (require :helpers)
        {:where expr :in haystack :into ?buffer} (parse-opts rest)]
    `(icollect [_# ,needle (ipairs ,haystack) ,(when ?buffer
                                                 (values :into ?buffer))]
       ,expr)))

(lambda _find [list cond]
  "_find [1 2 3] (fn [x] (= x 1))"
  (var match# nil)
  (each [_ x (ipairs list) &until match#]
    (when (cond x) (set match# x)))
  match#)

(macro find* [x cond lst]
  `(do
     (var match# nil)
     (each [_# ,x (ipairs ,lst) &until match#]
       (when ,cond (set match# ,x)))
     match#))

(macro filter* [x cond lst & rest]
  "filter* x cond    list    [&into buf]"
  "filter* x (> x 1) [1 2 3]"
  "filter* x (> x 1) [1 2 3] &into buf"
  (let [into `&into
        buf (case rest [into buf] buf)]
    `(icollect [_# ,x (ipairs ,lst) ,(when buf (values into buf))]
       (when ,cond ,x))))

; ,(when buf (values `&into ,buf))


; (_find [1 2 3] (fn [x] (= x 1)))
; (find* x (= x 1) [1 2 3])
; (find x :in [1 2 3] :where (= x 1))
