(local fennel (require :fennel)
(fn locals [env read on-values on-error scope]
  "Print all locals in repl session scope."
  (on-values [(fennel.view env.___replLocals___)]))

{:repl-command-locals locals}
