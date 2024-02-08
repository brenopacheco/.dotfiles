;; (| [1 2 3]
;;    |> map ([x] (x + 1))
;;    |> filter ([x] (x > 2))
;;    |> print ([x] (x))
;;
;; (print (filter (fn [x] (> x 2)) (map (fn [x] (+ x 1)) [1 2 3])))

(local |> "|>")

(macro | [lst & body] ; (local pipe_sym (sym "|>"))

  (fn step [...]
    (let [[pipe fun x expr & rest] [...]]
      ;;(assert-compile (= (. pipe 1) (. (sym :|>) 1)) "Missing |>")
      (if fun
          `(,fun (fn ,x
                   ,expr
                   ,(step (unpack rest))))
          `,lst)))

  (step (unpack body)))

;; (print (filter (fn [x] (> x 2)) (map (fn [x] (+ x 1)) [1 2 3])))

(fn filter [f lst]
  (icollect [_ x (ipairs lst)]
    (when (f x) x)))

(fn map [f lst]
  (icollect [_ x (ipairs lst)]
    (f x)))

; (macrodebug)

(macrodebug (| [1 2 3] |> map x (+ x 1) |> filter x (+ x > 1)))
