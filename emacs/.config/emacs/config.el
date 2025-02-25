(defvar elpaca-installer-version 0.9)
  (defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
  (defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
  (defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
  (defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
				:ref nil :depth 1 :inherit ignore
				:files (:defaults "elpaca-test.el" (:exclude "extensions"))
				:build (:not elpaca--activate-package)))
  (let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
	 (build (expand-file-name "elpaca/" elpaca-builds-directory))
	 (order (cdr elpaca-order))
	 (default-directory repo))
    (add-to-list 'load-path (if (file-exists-p build) build repo))
    (unless (file-exists-p repo)
      (make-directory repo t)
      (when (< emacs-major-version 28) (require 'subr-x))
      (condition-case-unless-debug err
	  (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
		    ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
						    ,@(when-let* ((depth (plist-get order :depth)))
							(list (format "--depth=%d" depth) "--no-single-branch"))
						    ,(plist-get order :repo) ,repo))))
		    ((zerop (call-process "git" nil buffer t "checkout"
					  (or (plist-get order :ref) "--"))))
		    (emacs (concat invocation-directory invocation-name))
		    ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
					  "--eval" "(byte-recompile-directory \".\" 0 'force)")))
		    ((require 'elpaca))
		    ((elpaca-generate-autoloads "elpaca" repo)))
	      (progn (message "%s" (buffer-string)) (kill-buffer buffer))
	    (error "%s" (with-current-buffer buffer (buffer-string))))
	((error) (warn "%s" err) (delete-directory repo 'recursive))))
    (unless (require 'elpaca-autoloads nil t)
      (require 'elpaca)
      (elpaca-generate-autoloads "elpaca" repo)
      (load "./elpaca-autoloads")))
  (add-hook 'after-init-hook #'elpaca-process-queues)
  (elpaca `(,@elpaca-order))
  ;; (elpaca example-package)
;; Install use-package support
(elpaca elpaca-use-package
  ;; Enable :elpaca use-package keyword.
  (elpaca-use-package-mode)
  ;; Assume :elpaca t unless otherwise specified.
  (setq elpaca-use-package-by-default t))

;; Block until current queue processed.
(elpaca-wait)

;;When installing a package which modifies a form used at the top-level
;;(e.g. a package which adds a use-package key word),
;;use `elpaca-wait' to block until that package has been installed/configured.
;;For example:
;;(use-package general :demand t)
;;(elpaca-wait)

;;Turns off elpaca-use-package-mode current declartion
;;Note this will cause the declaration to be interpreted immediately (not deferred).
;;Useful for configuring built-in emacs features.
;;(use-package emacs :elpaca nil :config (setq ring-bell-function #'ignore))

;; Don't install anything. Defer execution of BODY
;;(elpaca nil (message "deferred"))

(provide 'elpaca-setup)

;;; elpaca-setup.el ends here

;; Expands to: (elpaca evil (use-package evil :demand t))
(use-package evil
    :init      ;; tweak evil's configuration before loading it
    (setq evil-want-integration t  ;; This is optional since it's already set to t by default.
          evil-want-keybinding nil
          evil-vsplit-window-right t
          evil-split-window-below t
          evil-undo-system 'undo-redo)  ;; Adds vim-like C-r redo functionality
    (evil-mode))

(use-package evil-collection
  :after evil
  :config
  ;; Do not uncomment this unless you want to specify each and every mode
  ;; that evil-collection should works with.  The following line is here 
  ;; for documentation purposes in case you need it.  
  ;; (setq evil-collection-mode-list '(calendar dashboard dired ediff info magit ibuffer))
  (add-to-list 'evil-collection-mode-list 'help) ;; evilify help mode
  (evil-collection-init))

;; Using RETURN to follow links in Org/Evil 
;; Unmap keys in 'evil-maps if not done, (setq org-return-follows-link t) will not work
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))
;; Setting RETURN key in org-mode to follow links
  (setq org-return-follows-link  t)

(require 'windmove)

;;;###autoload
(defun buf-move-up ()
  "Swap the current buffer and the buffer above the split.
If there is no split, ie now window above the current one, an
error is signaled."
;;  "Switches between the current buffer, and the buffer above the
;;  split, if possible."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'up))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No window above this one")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-down ()
"Swap the current buffer and the buffer under the split.
If there is no split, ie now window under the current one, an
error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'down))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (or (null other-win) 
            (string-match "^ \\*Minibuf" (buffer-name (window-buffer other-win))))
        (error "No window under this one")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-left ()
"Swap the current buffer and the buffer on the left of the split.
If there is no split, ie now window on the left of the current
one, an error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'left))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No left split")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-right ()
"Swap the current buffer and the buffer on the right of the split.
If there is no split, ie now window on the right of the current
one, an error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'right))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No right split")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

(use-package dashboard
:ensure t
:init
(setq initial-buffer-choice 'dashboard-open)
(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)
(setq dashboard-banner-logo-title "Welcome to Emacs")
(setq dashboard-startup-banner 'logo)
(setq dashboard-center-content t)
(setq dashboard-items '((recents . 5)
                      (agenda . 5)
                      (bookmarks . 3)
                      (projects . 3)
                      (registers . 3)))
;; (dashboard-modify-heading-icons '((recents . "file-text")
;;                                  (bookmarks . "book")))
:config
(dashboard-setup-startup-hook))

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t)
  (doom-themes-org-config))
;; solaire darkens non-standard buffers' backgrounds
(use-package solaire-mode
  :ensure t
  :config
  (solaire-global-mode +1))
;; doom's fancy modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; Must be used *after* the theme is loaded
;; (custom-set-faces
;;   `(org-block ((t (:background , #16161D))))
;; )

(use-package ess
  :ensure t
  :config
  (load "ess-autoloads")
  (load-library "ob-R")
  (load-library "ob-julia")
  (setq org-confirm-babel-evaluate nil))

(setq treesit-language-source-alist
      '((julia "https://github.com/tree-sitter/tree-sitter-julia")))
(setq treesit-auto-install 'prompt)

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration
    '(julia-ts-mode . "julia")))
(setq lsp-julia-package-dir nil)
;; (after! lsp-julia
;;   (setq lsp-julia-default-environment "~/.julia/environments/v1.10")
;;   (setq-hook! 'julia-ts-mode-hook +format-with-lsp nil))
;; 
;; (after! julia-ts-mode
;;   (add-hook! 'julia-ts-mode-hook
;;     (setq-local lsp-enable-folding t
;;                 lsp-folding-range-limit 100)))
;;
;;
;; Julia REPL
(defun open-popup-new-frame (buffer &optional alist) (+popup-display-buffer-fullframe-fn buffer alist))
(use-package julia-repl
  :hook (julia-ts-mode . julia-repl-mode)
  :config
  (setq julia-repl-executable-records '((default "julia" :basedir "/Users/foo/applications/julia10/usr/share/julia/base/")
                                        (dev "julia11" :basedir    "/Users/foo/applications/julia11/usr/share/julia/base/")))
  (setq julia-repl-executable-key 'default)
  (setq julia-repl-switches "-q -t 4,1")
  (set-popup-rule! "^\\*julia\\:.*\\*$" :actions '(display-buffer-pop-up-frame . inhibit-switch-frame)))

(set-face-attribute 'default nil
		    :font "JetBrainsMono Nerd Font"
		    :height 200
		    :weight 'medium)
(set-face-attribute 'variable-pitch nil
		    :font "Noto Sans"
		    :height 200
		    :weight 'medium)
(set-face-attribute 'fixed-pitch nil
		    :font "JetBrainsMono Nerd Font"
		    :height 200
		    :weight 'medium)
;; italicizes commented text and keywords
(set-face-attribute 'font-lock-comment-face nil
		    :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
		    :slant 'italic)
;;sets default font on all graphical frames after restarting emacs
(add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font-12"))

;;set default line spacing
(setq-default line-spacing 0.12)

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(use-package general
  :ensure t
  :config
  (general-evil-setup)
  ;; set space bar as global leader key
  (general-create-definer dy/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC" ;; set leader
    :global-prefix "C-SPC") ;; access leader in insert mode

  (dy/leader-keys
    "." '(find-file :wk "Find file")
    "f c" '((lambda () (interactive) (find-file "~/.config/emacs/config.org")) :wk "Edit emacs config")
    "f r" '(recentf-open-files :wk "Find recent files")
    "TAB TAB" '(comment-line :wk "Comment lines"))

  (dy/leader-keys
    "b" '(:ignore t :wk "buffer")
    "b s" '(switch-to-buffer :wk "Switch buffer")
    "b q" '(kill-this-buffer :wk "Kill buffer")
    "b n" '(next-buffer :wk "Next buffer")
    "b p" '(previous-buffer :wk "Previous buffer")
    "b r" '(revert-buffer :wk "Reload buffer")
    "b i" '(ibuffer :wk "Buffer Index"))

  (dy/leader-keys
    "e" '(:ignore t :wk "Eshell/Evaluate")
    "e b" '(eval-buffer :wk "Evaluate elisp in buffer")
    "e d" '(eval-defun :wk "Evaluate defun containing or after point")
    "e e" '(eval-expression :wk "Evaluate an elisp expression")
    "e l" '(eval-last-sexp :wk "Evaluate elisp expression before point")
    "e r" '(eval-region :wk "Evaluate elisp in region")
    "e s" '(eshell :wk "Eshell"))

  (dy/leader-keys
    "h" '(:ignore t :wk "Help")
    "h f" '(describe-function :wk "Describe function")
    "h v " '(describe-variable :wk "Describe variable")
    "h r r" '((lambda () (interactive) (load-file "~/.config/emacs/init.el")) :wk "Reload emacs config"))

  (dy/leader-keys
   "t" '(:ignore t :wk "Toggle")
   "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
   "t t" '(visual-line-mode :wk "Toggle truncated lines")
   "t v" '(vterm-toggle :wk "Toggle vterm"))

  (dy/leader-keys
   "w" '(:ignore t :wk "Windows")
   ;; Window splits
   "w q" '(evil-window-delete :wk "Close window")
   "w n" '(evil-window-new :wk "New window")
   "w s" '(evil-window-split :wk "Horizontal split window")
   "w v" '(evil-window-vsplit :wk "Vertical split window")
   ;; Window motions
   "w h" '(evil-window-left :wk "Window left")
   "w j" '(evil-window-down :wk "Window down")
   "w k" '(evil-window-up :wk "Window up")
   "w l" '(evil-window-right :wk "Window right")
   "w w" '(evil-window-next :wk "Goto next window")
   ;; Move Windows
   "w H" '(buf-move-left :wk "Buffer move left")
   "w J" '(buf-move-down :wk "Buffer move down")
   "w K" '(buf-move-up :wk "Buffer move up")
   "w L" '(buf-move-right :wk "Buffer move right"))
)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)
(global-visual-line-mode t)

(fido-vertical-mode t)
;; (icomplete-vertical-mode t)

(use-package toc-org
:ensure t
:commands toc-org-enable
:init (add-hook 'org-mode-hook 'toc-org-enable))

(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets
  :ensure t)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(electric-indent-mode -1)

(require 'org-tempo)

(use-package projectile
:config
(projectile-mode 1))

(use-package rainbow-mode
  :ensure t
  :hook org-mode prog-mode)

(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)

(use-package vterm
  :ensure t)

(use-package vterm-toggle
  :ensure t
  :after vterm
  :config
  (setq vterm-toggle-fullscreen-p nil)
  (setq vterm-toggle-scope 'project)
  (add-to-list 'display-buffer-alist
     '((lambda (buffer-or-name _)
     (let ((buffer (get-buffer buffer-or-name)))
       (with-current-buffer buffer
	 (or (equal major-mode 'vterm-mode)
	     (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
  (display-buffer-reuse-window display-buffer-at-bottom)
  ;;(display-buffer-reuse-window display-buffer-in-direction)
  ;;display-buffer-in-direction/direction/dedicated is added in emacs27
  ;;(direction . bottom)
  ;;(dedicated . t) ;dedicated is supported in emacs27
  (reusable-frames . visible)
  (window-height . 0.3)))
  )

(add-to-list 'custom-theme-load-path "~/.config/emacs/themes/")
(load-theme 'kanagawa t)

(use-package which-key
:init
(which-key-mode 1)
:config
(setq which-key-side-window-location 'bottom
      which-key-sort-order #'which-key-key-order-alpha
      which-key-sort-uppercase-first nil
      which-key-add-column-padding 1
      which-key-max-display-columns nil
      which-key-min-display-lines 6
      which-key-side-window-slot -10
      which-key-side-window-max-height 0.25
      which-key-idle-delay 0.8
      which-key-max-description-length 25
      which-key-allow-imprecise-window-fit t
      which-key-separator "  " ))
