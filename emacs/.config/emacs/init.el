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
   '("aef148b4f18571ab1c8b3b08bbd44e2490c8872e0e05038f4ed9339bbf21bd14" "c02311729276eb887d9cfb6168dd853f6c58e39621cb793c86debadc5cd0a837" "a240f471c77f9941525715c3ebec6a018921bb0bc8862e58dc68780c8ee54c56" "77f281064ea1c8b14938866e21c4e51e4168e05db98863bd7430f1352cab294a" "5e39e95c703e17a743fb05a132d727aa1d69d9d2c9cde9353f5350e545c793d4" "c5975101a4597094704ee78f89fb9ad872f965a84fb52d3e01b9102168e8dc40" "ac07bc082e9eb2953b165ee2d61f5ed54ee202baa2ff31ede775fe077ad9b452" "b51da17825e6d8d222d1906dc244745e5ac8aba3d53ed2aae5b0b426b53bfc15" "f3c00b39863ca415b2c6e56371e02cb9eaf26df3f24206c6c42f2ee422a5ba10" "a3d71b6d5995ff06289a4dba92280508581faad415b1802a4158aa96f0b05966" "541f17e868568c2b1da67794a1ddcb5c1f04d81a85f7a598f0f410ea68b6683f" "89799bb97caed35668a2059ed33200e5050b86d998c550958f2f6629461bae62" "6e95c2bc623b59fda96a681e88421065eb133a35bd45d61174240f8f50f9040e" "26c01d6d7e2379bda116c36c345552575a837cf288dbd0412173c69eb9be7213" "fc2269b55f6f81913cfdc8b9790f44253bdfe283be716d9aeb8141f543deca56" "cc785ff430ff0c85170e0a5ba5aebf2a932b7e27279855425b994b6f347d1ca1" "b55259deedde4dc127e3dbb3bfa4ca1216af3c05d7a2dbbd2affabb1a43993a3" "e873f0e13aac8a402b31ffb8bd259084740615f923ee0e7b03c9a082672ff8e7" "26344f5da10769c5a5365722025e11593beab576077a3dcc65aa81e2d27ba2ce" "9727fec7afa50a30b02fb9c651180503349ee5f0f458f6226b79dd9be3a88d77" "f387dd6f295196ca4cf4bde8c1c775392634adde9160b30806b3ee68e5de0742" "ad4c477a79c07ea83b7424511b1e7cac328b70f8704bca1ea7a1e1918c921127" "59eff7f6ef647c4d01f77d163c578b2740d7a2850f3347bf8e11ff8afdf8c37d" "4594d6b9753691142f02e67b8eb0fda7d12f6cc9f1299a49b819312d6addad1d" "d6b934330450d9de1112cbb7617eaf929244d192c4ffb1b9e6b63ad574784aad" "56044c5a9cc45b6ec45c0eb28df100d3f0a576f18eef33ff8ff5d32bac2d9700" "d2c86f899aa959d3399a2075735bfeb4bd4888eef9d79228b40657f1d86ce787" "8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098" "0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1" "48042425e84cd92184837e01d0b4fe9f912d875c43021c3bcb7eeb51f1be5710" "5d35166655c7fb33c18e55e18ea40e6f353b95164e27130e3595f40e8a6df735" "691d671429fa6c6d73098fc6ff05d4a14a323ea0a18787daeb93fde0e48ab18b" default))
 '(org-agenda-files
   '("/Users/dante/Org/agenda.org" "/Users/dante/Org/inbox.org" "/Users/dante/Org/index.org" "/Users/dante/Org/tracker.org"))
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
 '(package-selected-packages
   '(org-roam transient gptel meow modus-themes org-journal ivy org-modern ob-mermaid citar cdlatex pdf-tools yasnippet org-mode gpastel transient-cycles))
 '(package-vc-selected-packages
   '((org-mode :url "https://code.tecosaur.net/tec/org-mode" :branch "dev")))
 '(warning-suppress-log-types '((auto-save) (org-babel))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
