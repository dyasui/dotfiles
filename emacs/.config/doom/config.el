;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrains Mono NerdFont" :size 16 ))
     ;; doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font" :size 22))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
(setq load-theme 'kanagawa-wave)

(setq display-line-numbers-type t)

;; Org mode default directory
(setq org-directory "~/Org")
;; setup files to hold agenda entries
(setq org-agenda-diary-file "~/Org/agenda.org")
;; inbox org file holds wip notes
(setq org-agenda-files (list "inbox.org"))
(setq org-capture-templates
       `(("i" "Inbox" entry  (file "inbox.org")
        ,(concat "* TODO %?\n"
                 "/Entered on/ %U"))))
(define-key global-map (kbd "C-c c") 'org-capture)

(map! :leader
      :desc "Open neotree (E)xplorer" "e" #'neotree)

;; Elfeed feeds
(setq elfeed-feeds (quote
                    (("https://www.reddit.com/r/unixporn.rss" reddit linux))
                    ))
