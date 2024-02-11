(import-macros {: trace} :trace)
(import-macros {: each* : map} :list)

(vim.print (map x [1 2 3] (+ x 1)))
