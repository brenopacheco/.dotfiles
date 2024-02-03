;;; ~ pkgmgr
;;
;; Simple package manager
;;
;; DIRECTORY STRUCTURE:
;;
;;   fnl/
;;    plugins/
;;      fugitive.lua -> (ensure ...)
;;
;; STEPS
;; - installing:
;;     + downloads / clones
;;     + extracts
;;     + build?
;; - loading:
;;     + checks deps
;;     + adds to package.path / requires
;;     + setup()
;;     + init()
;;
;; USAGE:
;;   (ensure :plugin-name              ; plugin name
;;     :url ...                        ; allows defining a plugin as a file, a directory,
;;                                     ; a tarball/zip/etc, a git repository. e.g:
;;       :url "fnl/modules/bar.lua"    ;; loads a single file with require? (rel. or absolute)
;;       :url "/home/bar/modules/bar"  ;; adds path to package.path
;;       :url "https://.../tar.gzip"   ;; downloads, extracts, and adds path to package.path
;;       :url "https://.../foo.git"    ;; clones dir, adds path to package.path
;;     :branch    "master"             ; optional branch in case of a git url
;;     :commit    "ff3a2"              ; optional commit in case of a git url
;;     :tag       "v1.2.3"             ; optional tag in case of a git url
;;     :build     ":Cmd|make|main.sh"  ; optional build command (either shell, file to run or vim function)
;;     :setup     {...}|fn:{...}       ; optional setup table, evaled after load
;;     :init      (fn () ... )         ; optional init fn ran after plugin is loaded
;;     :deps      [:p1 :p2 ...]        ; optional list of dependencies
;;     :enabled?  true                 ; optional flag to enable/disable the plugin
;;     :lazy      {...}                ; optional opts to load the plugin on demand
;;       :ft  [:ft2 ...]]              ; on filetypes
;;       :ev  [:ev2 ...]]              ; on events
;;       :key [:lhs1 ...]]             ; on keys pressed
;;       :cmd [:cmd1 ...]]             ; on commands
;;     ]
;;
;; How to bootstrap this plugin manager?
;;   + lua/
;;   +   fennel.lua
;;   + fnl/
;;   +   pacmgr.fnl
;;   + init.lua -> require('fennel') -> require('pacmgr')

(macro ensure [name & opts]
  (assert-compile name "expected plugin name" name)

  (fn parse-opts []
    (faccumulate [args {} i 1 (length opts) 2]
      (let [key (. opts i)
            value (. opts (+ i 1))]
        (tset args key value)
        args)))

  (local {: url : setup} (parse-opts opts))
  (assert-compile url "expected :url in" opts)
  (assert-compile setup "expected :setup in" opts)
  `(print {:url ,url :setup ,setup}))

(macro ensure2 [name opts]
  (assert-compile name "expected plugin name" name)
  (assert-compile opts.url "expected :url in" opts)
  (assert-compile opts.setup "expected :setup in" opts)
  `(print {:url ,opts.url :setup ,opts.setup}))

(fn ensure3 [name opts]
  (vim.print {: name})
  (assert name "expected plugin name")
  (assert opts.url "expected :url in opts")
  (assert opts.setup "expected :setup in opts")
  (print {:url opts.url :setup opts.setup}))

; worst option
(macrodebug (ensure :foo :url "https://foo.git" :setup (+ 1 2) :init (+ 1 2 3 4)
                    :build :make))

; not so good option
(macrodebug (ensure2 :foo {:url "https://foo.git"
                          :setup (+ 1 2)
                          :init (+ 1 2 3 4)
                          :build :make}))

; best option (easiest, with access to surrounding)
(ensure3 :foo {:url "https://foo.git"
              :setup (fn [] (+ 1 2))
              :init (fn [] (+ 1 2 3 4))
              :build :make})
