(lambda parse-opts [opts]
  "parses a list such as [:foo 1 :bar 2] into table {:foo 1 :bar 2}"
  (faccumulate [args {} i 1 (length opts) 2]
    (let [key (. opts i)
          value (. opts (+ i 1))]
      (tset args key value)
      args)))

{: parse-opts }
