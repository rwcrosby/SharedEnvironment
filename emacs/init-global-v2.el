;
; Linux Specific Stuff
;

(setq TeX-view-program-list '(("Evince" "evince --page-index=%(outpage) %o")))
(setq TeX-view-program-selection '((output-pdf "Evince")))

(setq ispell-program-name '"aspell")
(setq lpr-switches (quote ("-PPDF")))

(setq rwc-paths '( "/home/crosbyr/.local/bin" ))

;
; Initialization for all systems
;

(setenv "PATH" (mapconcat 'identity (append rwc-paths (split-string (getenv "PATH") ":") ) ":"))
(setq exec-path (append rwc-paths exec-path))

(setq user-full-name "Ralph W. Crosby")
(setq user-mail-address "ralph.crosby@navy.mil")

(setq package-archives (quote (("gnu" . "https://elpa.gnu.org/packages/")
                               ("melpa" . "https://melpa.milkbox.net/packages/")
                               ("elpy" . "http://jorgenschaefer.github.io/packages/"))))

(server-start)

; startup options
(setq column-number-mode t)		; show column numbers
(setq inhibit-startup-screen t)	; don't show startup screen
(global-hl-line-mode 1)			; highlight current line
(setq-default truncate-lines t)	; truncate lines by default
(tool-bar-mode -1)	            ; don't show the scrollbar
(show-paren-mode t)		        ; highlight matching parenthesis
(desktop-save-mode t)	        ; save desktop on exit
(setq debug-on-error nil)       ; Don't automatically open debugger

(put 'dired-find-alternate-file 'disabled nil)

; Default faces
(set-face-attribute 'default t
		    :background "#faf1c2")

(set-face-attribute 'font-lock-comment-face t
		    :slant 'italic
		    :foreground '"Firebrick")

; Clean up some keys
; Crummy buffer list...
(global-unset-key (kbd "C-x C-b"))

; Run a function in an alternate directory
(defun in-directory ()
  "Reads a directory name (using ido), then runs execute-extended-command with default-directory in the given directory."
  (interactive)
  (let ((default-directory
          (ido-read-directory-name "In directory: "
                                   nil nil t)))
    (call-interactively 'execute-extended-command)))

(global-set-key (kbd "M-X") 'in-directory)

; Force .h and .cl files to be in c++ mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cl\\'" . c++-mode))

; Expanded printer support
(require 'printing)
(pr-update-menus)

; Delete all but one space, moved due to os/x finder
(global-set-key (kbd "s-SPC") 'just-one-space)

; Window movement with cmd-up/down
(global-set-key (kbd "s-<left>") 'windmove-left)
(global-set-key (kbd "s-<right>") 'windmove-right)
(global-set-key (kbd "s-<up>") 'windmove-up)
(global-set-key (kbd "s-<down>") 'windmove-down)

; Configuration for tex file handling
(add-hook 'LaTeX-mode-hook 'turn-on-visual-line-mode) ; visual-line-mode for text files
(add-hook 'LaTeX-mode-hook 'flyspell-mode 1)	      ; on the fly spell checking
(add-hook 'LaTeX-mode-hook 'outline-minor-mode 1)     ; outlining for text files
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)           ; with AUCTeX LaTeX mode
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode); For viewers
(setq TeX-PDF-mode t)				      ; PDF output for tex files
(setq ispell-program-name "aspell")

; Next/Prev Error
(global-set-key (kbd "<f5>") 'previous-error)
(global-set-key (kbd "<f6>") 'next-error)

; List top level definitions
(require 'derived)
(require 'generic-dl)
(global-set-key (kbd "<f7>") 'dl-popup)

; Better buffer list command
(setq bs-default-configuration "all")
(setq bs-default-sort-name "by mode")
(require 'bs)
(global-set-key (kbd "<f8>") 'bs-show)

; Compile/Recompile
(global-set-key (kbd "<f9>") 'recompile)
(global-set-key (kbd "C-<f9>") 'compile)

; Close all buffers
(global-set-key (kbd "C-<f10>") 'desktop-clear)

; CUA editing mode
(cua-mode t)

; save file position
(require 'saveplace)
(setq-default save-place t)

; Code formatting options
(setq c-default-style (quote ((java-mode . "java") (awk-mode . "awk") (other . "stroustrup"))))
(setq-default comment-column 50)
(setq cperl-comment-column 50)
(setq cperl-indent-level 4)

;; Tabs handling
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; Keep these from opening new windows
(setq same-window-regexps  '("compilation"
                             "magit:"
                             "gud"
                             "Agenda"
                             "Bookmark List"
                             )
      )

; Setup single line scrolling
(global-set-key (kbd "M-<up>") (lambda () (interactive) (scroll-down 1)))
(global-set-key (kbd "M-<down>") (lambda () (interactive) (scroll-up 1)))

; Ansi colors in the shell
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

; Replace frame title
(setq frame-title-format '((buffer-file-name "%f" (dired-directory dired-directory "%b"))))

; Setup slick edit like behavior for copy and cut
; with this C-w, M-w are sensitive to the position on the line
(defadvice kill-ring-save (before slick-copy activate compile)
   "When called interactively with no active region, copy a single line instead."
   (interactive
     (if mark-active (list (region-beginning) (region-end))
       (message "Copied line")
       (list (line-beginning-position)
             (line-beginning-position 2)))))

(defadvice kill-region (before slick-cut activate compile)
   "When called interactively with no active region, kill a single line instead."
   (interactive
     (if mark-active (list (region-beginning) (region-end))
       (list (line-beginning-position)
             (line-beginning-position 2)))))

; ido mode
;(require 'ido)
;(ido-mode t)

;(setq ido-enable-flex-matching t)
;(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)

; Desktop save/restore
;(autoload 'dta-hook-up "desktopaid_rwc.el" "Desktop Aid" t)
;(dta-hook-up)
;(setq dta-cfg-dir "~/.emacs.d/")
;(setq dta-default-auto nil)
;(setq dta-default-cfg "desktopaid.conf")
;(global-set-key [f11] 'dta-load-session)

;(recentf-mode t)

;; (add-hook 'after-init-hook (lambda () (load "init-packages")))

(setq dired-listing-switches "-alG --group-directories-first --time-style=long-iso")

;; Eliminate training lines in c and python modes on save
(add-hook 'c++-mode-hook (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))
(add-hook 'python-mode-hook '(lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

(setq tags-revert-without-query 1)

;; Ruler and line numbers
(add-hook 'find-file-hook (lambda () (ruler-mode 1)))
(global-linum-mode 1)

;; which-function
(which-function-mode)

;; Package initialization *****************************************************************

(package-initialize)

;; icicles
(setq icicle-Completions-text-scale-decrease 0.0)
(setq icicle-candidate-width-factor 120)
(setq icicle-completions-format (quote vertical))
(setq icicle-file-sort (quote icicle-dirs-first-p))
(setq icicle-inter-candidates-min-spaces 5)

; Snippets
(setq yas-snippet-dirs '("~/win_c/SharedEnvironment/emacs/snippets"))
(yas-global-mode 1)

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
(setq org-directory "~/win_c/SharedEnvironment/orgmode")
(setq org-mobile-inbox-for-pull "~/win_c/SharedEnvironment/orgmode/flagged.org")
(setq org-mobile-directory "~/win_c/SharedEnvironment/orgmode/MobileOrg")
(setq org-agenda-files '("~/win_c/Projects/Spawar.org"
			 "~/win_c/Projects/ACNT.org"
			 "~/win_c/Projects/APU.org"))
(setq org-agenda-ndays 30)
(setq org-default-priority 68)

;; magit
(global-set-key (kbd "C-x g") 'magit-status)
(setq magit-last-seen-setup-instructions "1.4.0")

;; dired+
(setq diredp-hide-details-initially-flag nil)

;; Default the bookmarks file
(setq bookmark-default-file "~/win_d/SharedEnvironment/emacs/Bookmarks.bmk")
(setq bmkp-last-as-first-bookmark-file nil)

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

;; icicles
(icicle-mode)
