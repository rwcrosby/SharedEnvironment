; Initialization for loaded packages
; This is run as the after-init-hook

; Snippets
(setq yas-snippet-dirs '("~/win_d/SharedEnvironment/emacs/snippets"))
(yas-global-mode 1)

; Disabled 2/14/15 - Seems to be generating high cpu...
; tabbar
;; (require 'tabbar-ruler)
;; (setq tabbar-ruler-global-tabbar 't)
;; (setq tabbar-ruler-global-ruler 't)

;; (global-set-key (kbd "C-x C-t") 'tabbar-ruler-move)
;; (setq tabbar-use-images nil)

;; (defun my-tabbar-buffer-groups ()
;;    (list (cond ((string-equal "*" (substring (buffer-name) 0 1)) "Emacs")
;;                ((eq major-mode 'dired-mode) "Dired")
;;                ((eq major-mode 'c++-mode) "C++")
;;                ((eq major-mode 'python-mode) "Python")
;;                (t "Other"))))

;; (setq tabbar-buffer-groups-function 'my-tabbar-buffer-groups)
;; (tabbar-mode)

; Auctex
(require 'tex-site)
(require 'preview)

(setq reftex-bibliography-commands'("bibliography" "nobibliography" "makebibliography" "setupbibtex\\[.*?database="))
(setq reftex-default-bibliography '("~/win_h/Papers/nn.bib"))

(setq reftex-section-levels '(("part" . 0)
			      ("chapter" . 1)
			      ("section" . 2)
			      ("frametitle" . 3)
			      ("subsection" . 3)
			      ("subsubsection" . 4)
			      ("paragraph" . 5)
			      ("subparagraph" . 6)
			      ("addchap" . -1)
			      ("addsec" . -2)))

; org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(global-set-key "\C-ca" 'org-agenda)

(setq org-todo-keywords '((sequence "TODO" "WORKING" "|" "DONE")))
(setq org-directory "~/win_d/SharedEnvironment/orgmode")
(setq org-mobile-inbox-for-pull "~/win_d/SharedEnvironment/orgmode/flagged.org")
(setq org-mobile-directory "~/win_d/SharedEnvironment/orgmode/MobileOrg")
(setq org-agenda-files '("~/win_h/Projects/Spawar.org"
			 "~/win_h/Projects/ACNT.org"
			 "~/win_h/Projects/APU.org"))
(setq org-agenda-ndays 30)
(setq org-default-priority 68)

;; magit
(global-set-key (kbd "C-x g") 'magit-status)
(setq magit-last-seen-setup-instructions "1.4.0")

;; Load python-mode for scons files
(setq auto-mode-alist(cons '("SConstruct" . python-mode) auto-mode-alist))
(setq auto-mode-alist(cons '("SConscript" . python-mode) auto-mode-alist))

;; Global comment column
(setq-default comment-column 50) 		; Default comment column

;; Workgroups
;(workgroups-mode)
;(setq wg-emacs-exit-save-behavior nil)

;; which-function
(which-function-mode)

;; Default the bookmarks file
(setq bookmark-default-file "~/win_d/SharedEnvironment/emacs/Bookmarks.bmk")
(setq bmkp-last-as-first-bookmark-file nil)

;; icicles
(icicle-mode)

;; Customized version of the jump-bookmark-file function that defaults to asking if the
;; file should be switched rather than loaded.
(defun bmkp-jump-bookmark-file (bookmark &optional switchp batchp)
  "Override version by RWC
Jump to bookmark-file bookmark BOOKMARK, which loads the bookmark file.
Handler function for record returned by
`bmkp-make-bookmark-file-record'.
BOOKMARK is a bookmark name or a bookmark record.
Non-nil optional arg SWITCHP means overwrite current bookmark list.
Non-nil optional arg BATCHP is passed to `bookmark-load'."
  (let ((file        (bookmark-prop-get bookmark 'bookmark-file))
        (overwritep  (and (not switchp)  (y-or-n-p "SWITCH to new bookmark file, instead of just adding it? "))))
    (bookmark-load file overwritep batchp)) ; Treat load interactively, if no BATCHP.
  ;; This `throw' is only for the case where this handler is called from `bookmark--jump-via'.
  ;; It just tells `bookmark--jump-via' to skip the rest of what it does after calling the handler.
  (condition-case nil
      (throw 'bookmark--jump-via 'BOOKMARK-FILE-JUMP)
    (no-catch nil)))
