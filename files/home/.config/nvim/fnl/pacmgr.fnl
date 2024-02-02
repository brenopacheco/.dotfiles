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
;; - we need to bootstrap fennel?
;;   maybe we can transpile everything from fnl/ on save to lua/?
;;   maybe fnl/foo.fnl -> lua/.fnl/foo.lua
;;   we can add lua/.fnl/ into loaders path
;;   this way we ensure 'fennel' is loaded
