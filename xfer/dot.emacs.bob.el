(add-to-list 'load-path "~/Dropbox/Development/emacs")

(set-face-attribute 'default t
		    :height 110)

(normal-erase-is-backspace-mode 1)
(global-unset-key (kbd "s-w"))

(put 'narrow-to-page 'disabled nil)

(setq TeX-source-correlate-method 'synctex)
(setq TeX-view-program-list '( ("Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline -b %n %o %b")
                               ("Preview" "open -a Preview.app %o")))
(setq TeX-view-program-selection '( ((output-dvi style-pstricks) "dvips and gv")
                                    (output-dvi "xdvi")
                                    (output-pdf "Skim")
                                    (output-html "xdg-open")))

(setq ns-alternate-modifier 'super)
(setq ns-command-modifier 'meta)

(setq rwc-paths '("/Users/rcrosby/Development/local/gcc"
                  "/Users/rcrosby/Development/local/gnubin-tar"
                  "/Users/rcrosby/Development/local/gnubin-sed"
                  "/Users/rcrosby/Development/local/gnubin-coreutils"
                  "/Users/rcrosby/Development/local/bin"
                  "/usr/local/bin"
                  "/usr/texbin"
                  )
      )

(setq rwc-lldb '/Users/rcrosby/Dropbox/FDivT/lldb-run)
(setq rwc-lldb-cmdline (mapconcat 'identity '("") " "))

(load "init-global.el")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(sh-heredoc ((((class color) (background light)) (:foreground "navy")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-indent-comment-alist
   (quote
    ((anchored-comment column . 50)
     (end-block space . 1)
     (cpp-end-block space . 2)
     (other align column . 50))))
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(diredp-hide-details-initially-flag nil)
 '(grep-find-command "find . -type f -exec grep -nIH -e \"\\b\\b\" {} +")
 '(pr-ps-printer-alist
   (quote
    ((Artisan\ 710 "lpr" nil "-P" "EPSON_Artisan_710")
     (Artisan\ 730 "lpr" nil "-P" "EPSON_Artisan_730")
     (HRBB\ Third\ Floor "lpr" nil "-P" "CS_Dept"))))
 '(reftex-ref-macro-prompt nil)
 '(safe-local-variable-values (quote ((require-final-newline))))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
