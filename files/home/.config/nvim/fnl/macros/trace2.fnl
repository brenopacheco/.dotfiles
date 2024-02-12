(macro fun [name args body]
  (local form (sym :form))
  `(values ;;
           (fn ,name ,args ,body) ;;
           (local ,form ,name)))

(fun zed [x] (+ x 1))

(macro trace [fun]
  `(fn ,fun
     [...]
     (print "called " ,(. fun 1) " with" ...)
     (form ...)))

(trace zed)

(zed 1 2 3)
