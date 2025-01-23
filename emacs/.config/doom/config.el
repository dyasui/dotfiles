;; See 'C-h v doom-font' for documentation and more examples of what they
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16 ))
(setq load-theme 'kanagawa-wave)

(setq display-line-numbers-type t)

;; Org mode default directory
(setq org-directory "~/Org")
;; setup files to hold agenda entries
(setq org-agenda-diary-file "~/Org/agenda.org")
;; inbox org file holds wip notes
(setq org-agenda-files (list "inbox.org"))
(setq org-capture-templates
       '(
         ("i" "inbox" entry  (file "inbox.org")
        ,(concat "* TODO %?\n"
                 "/Entered on/ %U"))
         ("d" "default" plain
          "%?"
          :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                             "#+title: ${title}\n#+options: author:nil, date:nil, toc:nil, num:5, H:5\n")
          :empty-lines 1
          :unnarrowed t)
         ("b" "bibliography notes" plain
          (file "~/roam/references/notes/notes-template.org")
          :target (file+head "references/notes/${citekey}.org"
                             "#+titlef; ${title}\n#+options: author:nil, date:nil, toc:nil, num:5, H:5\n")
          :empty-lines 1)
         )
       )
(define-key global-map (kbd "C-c c") 'org-capture)

;; Org-roam zettelkasten dailies
(setq org-roam-dailies-directory "~/roam/")

(setq org-roam-dailies-capture-templates
      '(("d" "default" entry
         "* %?"
         :target (file+head "%<%Y%m%d>.org"
                            "#+title: %<%Y%m%d>\n"))))

(setq bibtex-completion-bibliography '("~/roam/references/master.bib"))
(setq bibtex-completion-find-additional-pdfs t)
(setq bibtex-completion-pdf-field "File")

(setq bibtex-completion-library-path '("~/roam/references/documents/"))
(setq bibtex-completion-notes-path "~/roam/references/notes/")

;; BEGIN: Change insert citation (<f3>) behaviouir of helm-bibtex for org-mode
(defun custom/bibtex-completion-format-citation-org (keys)
  "Custom cite definition for org-mode"
  (s-join ", "
          (--map (format "cite:&%s" it) keys)))

(setq bibtex-completion-format-citation-functions
      '((org-mode . custom/bibtex-completion-format-citation-org)
        (latex-mode . bibtex-completion-format-citation-cite)
        (markdown-mode . bibtex-completion-format-citation-pandoc-citeproc)
        (python-mode . bibtex-completion-format-citation-sphinxcontrib-bibtex)
        (default . bibtex-completion-format-citation-default))
      )
;; END: Change insert citation (<f3>) behaviouir of helm-bibtex for org-mode

(setq bibtex-autokey-year-length 4                          ; customisations for 'bibtex-generate-autokey'
      bibtex-autokey-name-year-separator "-"                ; press C-c C-c (bibtex-clean-entry) on a bib entry w/o %citekey
      bibtex-autokey-year-title-separator "-"               ; to automatically insert a %citekey based on meta data
      bibtex-autokey-titleword-separator "-"                ; use M-x crossref-add-bibtex-entry <ret>: to add an entry from
      bibtex-autokey-titlewords 2                           ; https://www.crossref.org/
      bibtex-autokey-titlewords-stretch 1
      bibtex-autokey-titleword-length 5)

(pdf-loader-install) ; use PDFView in place of Doc View

(setq org-noter-notes-search-path '("/Users/dante/roam/references/notes/"))

(setq orb-preformat-keywords '("citekey" "title" "url" "author-or-editor" "keywords" "file")
      orb-process-file-keyword t
      orb-attached-file-extensions '("pdf"))

(global-set-key (kbd "C-c f r") 'helm-bibtex)
