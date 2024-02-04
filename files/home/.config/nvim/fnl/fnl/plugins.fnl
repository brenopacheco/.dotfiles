;; Fennel repl module

(local fennel (require :fennel))

(fn locals [env _read on-values _on-error _scope]
  "Print all locals in repl session scope."
  (on-values [(fennel.view env.___replLocals___)]))

{:repl-command-locals locals}
