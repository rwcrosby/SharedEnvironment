(add-to-list 'load-path "~/Dropbox/Development/emacs")

(set-face-attribute 'default t
		    :height 90)

(setq TeX-view-program-list '(("Evince" "evince --page-index=%(outpage) %o")))
(setq TeX-view-program-selection '((output-pdf "Evince")))

(setq ispell-program-name '"aspell")
(setq lpr-switches (quote ("-PPDF")))

(setq rwc-lldb '/home/rwc/Dropbox/FDivT/lldb-run)
(setq rwc-lldb-cmdline (mapconcat 'identity '("") " "))

;; (setq rwc-lldb 'lldb)
;; (setq rwc-lldb-cmdline (mapconcat 'identity '("-s lldbinit.posix"
;; 				     "-f ~/Shared/python3.4_clang/bin/python3"
;; 				     " ") " "))

(setq rwc-paths '( "/home/rwc/usr/bin"
		   "/home/rwc/.local/bin" ))

(load "init-global.el")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(sh-heredoc ((t (:foreground "NavyBlue")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-indent-comment-alist (quote ((anchored-comment column . 50) (end-block space . 1) (cpp-end-block space . 2) (other align column . 50)))))
