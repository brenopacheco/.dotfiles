;;; helpers lib fennel lang

;; (find     [var list]           expr)
;; (filter   [var list]           expr)
;; (map      [var list]           expr)
;; (any      [var list]           expr)
;; (all      [var list]           expr)
;; (each     [var list]           expr)
;; (fold     [acc init var list]  expr)
;; (flatten  [depth list]             )
;; (slice    [start end list]         )
;; (join     [sep list]               )
;; (take     [n list]                 )
;; (skip     [n list]                 )

;; (find     var list           expr)
;; (filter   var list           expr)
;; (map      var list           expr)
;; (any      var list           expr)
;; (all      var list           expr)
;; (each     var list           expr)
;; (fold     acc init var list  expr)
;; (flatten  depth list             )
;; (slice    start end list         )
;; (join     sep list               )
;; (take     n list                 )
;; (skip     n list                 )


;; (find     var :in list :if expr :into acc)
;; (filter   var list           expr)
;; (map      var list           expr)
;; (any      var list           expr)
;; (all      var list           expr)
;; (each     var list           expr)
;; (fold     acc init var list  expr)
;; (flatten  depth list             )
;; (slice    start end list         )
;; (join     sep list               )
;; (take     n list                 )
;; (skip     n list                 )


(fn in? [tbl key]
  "Check if a key is in a table.\n\n(in? tbl key) -> boolean"
  (not= nil (. tbl key)))

(in?)



; { :in? }
