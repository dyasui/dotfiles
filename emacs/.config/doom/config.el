;; See 'C-h v doom-font' for documentation and more examples of what they
(setq doom-font (font-spec :family "Noto Nerd Font" :size 16 ))
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
