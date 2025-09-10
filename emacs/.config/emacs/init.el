;; Load literate config file
(org-babel-load-file
  (expand-file-name
    "config.org"
    user-emacs-directory))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("ac07bc082e9eb2953b165ee2d61f5ed54ee202baa2ff31ede775fe077ad9b452" "4594d6b9753691142f02e67b8eb0fda7d12f6cc9f1299a49b819312d6addad1d" "0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1" "f1e8339b04aef8f145dd4782d03499d9d716fdc0361319411ac2efc603249326" default))
 '(org-agenda-files '("~/Org/agenda.org"))
 '(org-modern-checkbox
   '((88 .
	 #("□✔" 0 2
	   (composition
	    ((2)))))
     (32 . "□")
     (45 .
	 #("□–" 0 2
	   (composition
	    ((2)))))))
 '(org-modern-internal-target '(" ↪ " t " "))
 '(org-modern-list '((43 . "•") (45 . "◦") (42 . "∗")))
 '(org-modern-radio-target '(" ✒ " t " "))
 '(org-modern-replace-stars "◉○❖◈◇")
 '(package-selected-packages '(gptel mixed-pitch auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
