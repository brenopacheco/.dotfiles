(import-macros {: trace : trace2} :trace)

(fn x [] 1)

(macrodebug (trace2 xxx))
(trace2 xxx)

(macrodebug (trace x))
(trace x)
