  (defvar elpaca-installer-version 0.10)
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
	      evil-want-C-u-scroll t ;; override emacs-like use of C-u to repeat
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

  (use-package doom-themes
    :ensure t
    :config
    ;; (load-theme 'doom-one t)
    (setq doom-themes-enable-bold t
	  doom-themes-enable-italic t)
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

  (set-face-attribute 'default nil
		      :font "JetBrainsMono Nerd Font"
		      :height 160
		      :weight 'medium)
  (set-face-attribute 'variable-pitch nil
		      :font "Menlo"
		      :height 160
		      :weight 'medium)
  (set-face-attribute 'fixed-pitch nil
		      :font "JetBrainsMono Nerd Font"
		      :height 160
		      :weight 'medium)
  ;; italicizes commented text and keywords
  (set-face-attribute 'font-lock-comment-face nil
		      :slant 'italic)
  (set-face-attribute 'font-lock-keyword-face nil
		      :slant 'italic)
  ;;sets default font on all graphical frames after restarting emacs
  ;; (add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font-10"))

  ;;set default line spacing
  ;; (setq-default line-spacing 0.08)

  (global-set-key (kbd "C-=") 'text-scale-increase)
  (global-set-key (kbd "C--") 'text-scale-decrease)
  (global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
  (global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(add-to-list 'custom-theme-load-path "~/.config/emacs/themes/")
(load-theme 'kanagawa t)

(use-package rainbow-mode
  :ensure t
  :hook org-mode prog-mode)

(setq ring-bell-function 'ignore)
(setq tab-bar-close-button-show nil)       ;; hide tab close / X button
(setq tab-bar-new-tab-choice "*dashboard*");; buffer to show in new tabs

  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)

  (global-display-line-numbers-mode nil)
  (global-visual-line-mode t)

;; save temp files to ~/.config/emacs/auto-save
(setq auto-save-file-name-transforms
          `((".*" ,(concat user-emacs-directory "auto-save/") t)))

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

  (use-package company
    :defer 2
    :custom
    (company-begin-commands '(self-insert-command))
    (company-idle-delay .a)
    (company-minimum-prefix-length 2)
    (company-show-numbers t)
    (company-tooltip-align-annotations 't)
    (global-company-mode t))
  (set (make-local-variable 'company-backends) '((company-yasnippet company-capf company-keywords)))

    (use-package company-box
      :after company
      :hook (company-mode . company-box-mode))

(use-package dired-open
  :config
  (setq dired-open-extensions '(("gif" . "sxiv")
				("jpg" . "sxiv")
				("png" . "sxiv")
				("mkv" . "mpv")
				("mp4" . "mpv"))))

(use-package gptel
  :load-path "~/.config/emacs/elpa/gptel-0.9.8/")

  (fido-vertical-mode t)
;; (icomplete-vertical-mode t)

(use-package ob-mermaid
  :load-path "~/.config/emacs/elpa/ob-mermaid-20250124.1831/"
  :config
  (setq ob-mermaid-cli-path "/opt/homebrew/bin/mmdc")
  )

(use-package projectile
  :config
  (projectile-mode 1))

(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)

;; (add-to-list 'load-path "~/.emacs/")
;; (require 'tabspaces)

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
	which-key-allow-imprecise-window-fit nil
	which-key-separator "  " ))

(use-package yasnippet
  :ensure t
  :load-path "./elpa/yasnippet-0.14.2/"
  :config
  (setq yas-snippet-dirs '("~/.config/emacs/snippets"))
  (yas-global-mode 1))

;; weight by frequency
(setq company-transformers '(company-sort-by-occurrence))

;; Add yasnippet support for all company backends
;; https://github.com/syl20bnr/spacemacs/pull/179
(defvar company-mode/enable-yas t "Enable yasnippet for all backends.")

(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas) (and (listp backend)    (member 'company-yasnippet backend)))
  backend
(append (if (consp backend) backend (list backend))
        '(:with company-yasnippet))))

(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

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

    (general-define-key
     :keymaps 'override
     "M-n" '(make-frame :wk "Open new frame")
     "M-w" '(delete-frame :wk "Close current frame")
     "M-." '(dired :wk "Dired"))

    (dy/leader-keys
      "SPC" '(execute-extended-command :wk "M-x")
      "c s" '(cheat-sheet :wk "Cheat Sheet"))

    (dy/leader-keys
      "f f" '(project-find-file :wk "Find file")
      "f c" '((lambda () (interactive) (find-file "~/.config/emacs/config.org")) :wk "Edit emacs config")
      "f i" '(imenu :wk "Find heading in imenu")
      "f r" '(recentf :wk "Find recent files")
      "f s" '(affe-grep :wk "Find string in current project"))

    (dy/leader-keys
      "b" '(:ignore t :wk "buffer")
      "b s" '(switch-to-buffer :wk "Switch buffer")
      "b q" '(kill-this-buffer :wk "Kill buffer")
      "b n" '(next-buffer :wk "Next buffer")
      "b p" '(previous-buffer :wk "Previous buffer")
      "b r" '(revert-buffer :wk "Reload buffer")
      "b i" '(ibuffer :wk "Buffer Index"))

    (dy/leader-keys
      "c" '(:ignore t :wk "comment")
      "c c" '(comment-line :wk "comment line")
      "c r" '(comment-region :wk "comment region")
      "c b" '(comment-box :wk "comment box"))

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
      "h k" '(describe-key :wk "Describe keybinding")
      "h v " '(describe-variable :wk "Describe variable")
      "h r r" '((lambda () (interactive) (load-file "~/.config/emacs/init.el")) :wk "Reload emacs config"))

    (dy/leader-keys
      "o" '(:ignore t :wk "Org")
      "o a" '(org-agenda :wk "Org agenda")
      "o e" '(org-export-dispatch :wk "Org export dispatch")
      "o i" '(org-toggle-item :wk "Org toggle item")
      "o t" '(org-todo :wk "Org todo")
      "o b t" '(org-babel-tangle :wk "Org babel tangle")
      "o T" '(org-todo-list :wk "Org todo list"))

    (dy/leader-keys
      "o d" '(:ignore t :wk "Dates/times")
      "o d t" '(org-time-stamp :wk "Org time stamp"))
      
    (dy/leader-keys
      "p" '(:ignore :wk "Project")
      "p f" '(project-find-file :wk "Find files in current project")
      "p s" '(project-switch-project :wk "switch project")
      "p b" '(project-list-buffers :wk "List project buffers")
      "p k" '(project-kill-buffers :wk "Close all project buffers")
      )
      
    (dy/leader-keys
      "r" '(:ignore :wk "R")
      "r d" '(ess-rdired  :wk "open R object directory"))
    
    (dy/leader-keys
      "s" '(:ignore :wk "snippets")
      "s n" '(yas-new-snippet :wk "new snippet"))
      
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

    (dy/leader-keys
      ;; "TAB" '(:ignore t :wk "Tabs")
      "t n" '(tab-new :wk "Open new tab")
      "t q" '(tab-close :wk "Close tab")
      "t r" '(tab-rename :wk "Rename tab")
      "TAB" '(tab-next :wk "Next tab")
      "DEL" '(tab-previous :wk "Previous tab")
      )
  )

(use-package toc-org
:ensure t
:commands toc-org-enable
:init (add-hook 'org-mode-hook 'toc-org-enable))

(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets
  :ensure t)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(use-package citar
  :custom
  (citar-bibliography '("~/betterbibtex.bib"))
  :hook
  (LaTeX-mode . citar-capf-setup)
  (org-mode . citar-capf-setup))

(setq electric-indent-mode -1)
(setq org-src-preserve-indentation t)
(setq org-edit-src-content-indentation 0)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((julia . t)
   (mermaid . t)
   (R . t)))

(require 'org-tempo)

;; (use-package org-latex-preview
;;   :ensure t
;;   :config
;;   (plist-put org-latex-preview-appearance-options
;; 	     :page-width 0.8)
;;   (setq org-latex-preview-live t))

(use-package ess
  :ensure t
  :config
  (load "ess-autoloads")
  (load-library "ob-R")
  (load-library "ob-julia")
  (setq org-confirm-babel-evaluate nil))

(use-package auctex
  :ensure t
  :config
  (setq TeX-PDF-mode t))

(use-package cdlatex
  :ensure t
  :load-path "~/.config/emacs/cdlatex-4.18.5"
  :config
  (add-hook 'org-mode-hook #'turn-on-org-cdlatex))

(use-package pdf-tools
  :ensure t
  :load-path "~/.config/emacs/elpa/pdf-tools-1.1.0")
