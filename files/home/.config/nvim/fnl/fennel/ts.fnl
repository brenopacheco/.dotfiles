;;; treesitter utils for fennel
;
;; NOTE: Utils I want here:
;; + get current form
;; + get current forms in range
;; + get top level form
;; + get all forms in buffer
;; + get current <thing> (symbol name)
;;
;; NOTE: how to integrate with the REPL:
;; + Evaluate current form
;; + Evaluate forms in range
;; + Evaluate top level form
;; + Evaluate whole buffer
;; + View docs of <thing>
;; + View apropos of <thing>

;; + Switch back and from repl

; C-a C-a	Switch to REPL or back to editor
; C-^	Open editor in REPL
; g g V G =	Indent file
; C-a C-a :doc <thing>	View docs of thing (ECL)
; C-a C-a (apropos <thing>)	Search for things
