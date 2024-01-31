(macro list [& expr]
  "usage: (list 1 2 (unpack [3 4]) (unpack [4 5]))"
  `(icollect [_# arg# (ipairs ,expr)]
     arg#))
