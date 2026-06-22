;https://codeberg.org/ashton314/emacs-bedrock/src/branch/main/init.el

(defun reload-config ()
  (interactive)
  (load-file user-init-file))

(defun restart-emacs-service ()
  (interactive)
  (start-process-shell-command
   "restart-emacs" nil "systemctl --user restart emacs"))

;; Put backup files in one place
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; Put auto-save files in one place
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-saves/" t)))

;; Make yes-or-no-p function use shorter y/n
(setq use-short-answers t)

;; When opening help, move pointer to window
(setq help-window-select t)

;; Open emacs in scratch buffer
(setopt inhibit-splash-screen t)

;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)

;; Save history for minibuffer
(savehist-mode)

(auto-save-mode -1)

;; Show the help buffer after startup
(add-hook 'after-init-hook 'help-quick)

;; which-key: shows a popup of available keybindings when typing a long key
;; sequence (e.g. C-x ...)
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(setopt enable-recursive-minibuffers t)                ; Use the minibuffer whilst in the minibuffer
(setopt completion-cycle-threshold 1)                  ; TAB cycles candidates
(setopt completions-detailed t)                        ; Show annotations
(setopt tab-always-indent 'complete)                   ; When I hit TAB, try to complete, otherwise, indent
(setopt completion-styles '(basic initials substring)) ; Different styles to match input to candidates

(setopt completion-auto-help 'always)                  ; Open completion always; `lazy' another option
(setopt completions-max-height 20)                     ; This is arbitrary
(setopt completions-format 'one-column)
(setopt completions-group t)
;(setopt completion-auto-select 'second-tab)            ; Much more eager

(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete) ; TAB acts more like how it does in the shell

;(icomplete-vertical-mode)
;(fido-vertical-mode)
;(setopt icomplete-delay-completions-threshold 4000)

;; Mode line information
(setopt line-number-mode t)                        ; Show current line in modeline
(setopt column-number-mode t)                      ; Show column as well

(setopt x-underline-at-descent-line nil)           ; Prettier underlines
(setopt switch-to-buffer-obey-display-actions t)   ; Make switching buffers more consistent

(setopt show-trailing-whitespace nil)      ; By default, don't underline trailing spaces
(setopt indicate-buffer-boundaries 'left)  ; Show buffer top and bottom in the margin

;; Enable horizontal scrolling
(setopt mouse-wheel-tilt-scroll t)
(setopt mouse-wheel-flip-direction t)

;; We won't set these, but they're good to know about
;;
;; (setopt indent-tabs-mode nil)
;; (setopt tab-width 4)

;; Misc. UI tweaks
(blink-cursor-mode -1)                                ; Steady cursor
(pixel-scroll-precision-mode)                         ; Smooth scrolling

;; Display line numbers in programming mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setopt display-line-numbers-width 3)           ; Set a minimum width

;; Nice line wrapping when working with text
(add-hook 'text-mode-hook 'visual-line-mode)

;; Swap buffer-menu for ibuffer
;; (global-set-key (kbd "C-x C-b") 'ibuffer)

(recentf-mode 1)
(fido-mode 1)
(load-theme 'modus-operandi)

;; Enable this if things get too overwhelming
;(use-package evil
;  :ensure t
;  :init
;  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
;  (setq evil-want-keybinding nil)
;  :config
;  (evil-mode 1))
;
;(use-package evil-collection
;  :after evil
;  :ensure t
;  :config
;  (evil-collection-init))

;; Emacs will throw trash here
