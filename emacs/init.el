;; Standard emacs configuration
;;
;; Assumes
;;
;; '(package-selected-packages
;;   (quote
;;    (zoom-window neotree fish-mode htmlize counsel-projectile projectile all-the-icons counsel yaml-mode swiper org markdown-mode+ magit jedi elpy dired-sort-menu+ dired+ csv-mode bookmark+ auctex flycheck))))

(cond
      ;; Windows Specific Stuff

      ((eq system-type 'windows-nt)
       (message "windows-nt Initialization")
       )

      ;; Mac Specific Stuff

      ((eq system-type 'darwin)
       (message "MacOS Initialization")
       
       (setq ns-alternate-modifier (quote super))
       (setq ns-command-modifier (quote meta))

       (setq TeX-view-program-list
	     (quote
	      (("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b"))))

       (setq rwc-paths '("/usr/local/opt/coreutils/libexec/gnubin"
                         "/Library/TeX/texbin"
                         "/usr/local/bin"))
       
       )

      ;; Linux Specific Stuff

      ((eq system-type 'gnu/linux)
       (message "Linux Initialization")

       (setq TeX-view-program-list '(("Evince" "evince --page-index=%(outpage) %o")))
       (setq TeX-view-program-selection '((output-pdf "Evince")))

       (setq ispell-program-name '"aspell")
       (setq lpr-switches (quote ("-PPDF")))

       )
)

;; Initialization for all systems
;; For the path and exec-path it is assumed that emacs will be launched from a
;; 'command line' app of some sort so rwc-paths will only need to contain any
;; additional directories not in the bash login path

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(setenv "PATH" (mapconcat 'identity (append rwc-paths (split-string (getenv "PATH") ":") ) ":"))
(setq exec-path (append rwc-paths exec-path))

(setq user-full-name "Ralph W. Crosby")
(setq user-mail-address "ralphcrosby@gmail.com")

(server-start)

;; startup options

(setq column-number-mode t)		    ; show column numbers
(setq inhibit-startup-screen t)	    ; don't show startup screen
(global-hl-line-mode 1)			    ; highlight current line
(setq-default truncate-lines t)	    ; truncate lines by default
(tool-bar-mode -1)                  ; don't show the scrollbar
(show-paren-mode t)		            ; highlight matching parenthesis
(desktop-save-mode t)	            ; save desktop on exit
(setq debug-on-error nil)           ; Don't automatically open debugger

(put 'dired-find-alternate-file 'disabled nil)

;; Default faces

(set-face-attribute 'default t
                    :background "#faf1c2")

(set-face-attribute 'font-lock-comment-face t
                    :slant 'italic
                    :foreground '"Firebrick")

(set-face-attribute 'region nil
                    :background "#666"
                    :foreground "#ffffff")

;; Clean up some keys

;; Crummy buffer list...
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

; Reset start and end of line
(global-set-key (kbd "<home>") 'move-beginning-of-line)
(global-set-key (kbd "<end>") 'move-end-of-line)

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

(setq dired-listing-switches "-alG --group-directories-first --time-style=long-iso")

;; Eliminate training lines in c and python modes on save
;; When C++ was included it appeared to delete training in all modes.
;(add-hook 'c++-mode-hook (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))
;(add-hook 'python-mode-hook '(lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

(setq tags-revert-without-query 1)

;; Ruler and line numbers
(add-hook 'find-file-hook (lambda () (ruler-mode 1)))

(global-linum-mode 1)

(add-hook 'org-mode-hook (lambda () (linum-mode 0)))
(add-hook 'dired-mode-hook (lambda () (linum-mode 0)))

(set-face-attribute 'linum nil :height 90)

;; which-function
(which-function-mode)

; Snippets
(setq yas-snippet-dirs '("~/SharedEnvironment/emacs/snippets"))
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

(setq org-todo-keyword-faces
      '(("WORKING" . "slateblue3") ("TODO" . "red") ("DONE" . "dark green"))
)

(setq org-priority-faces '((?A . (:foreground "white" :background "red"))
                           (?B . (:foreground "white" :background "DarkGoldenrod3"))
                           (?C . (:foreground "white" :background "cyan4"))))

(setq org-agenda-ndays 30)
(setq org-default-priority 68)

(setq org-latex-classes
   (quote
    (("beamer" "\\documentclass[presentation]{beamer}"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("article" "\\documentclass[11pt]{article}"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
     ("report" "\\documentclass[11pt]{report}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("book" "\\documentclass[11pt]{book}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("OrgNotes" "\\documentclass[11pt]{OrgNotes}"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
      ("\\section{%s}" . "\\section*{%s}")))))

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

;; Markdown mode
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Python environment

(when (require 'elpy nil 'no-error)
  (elpy-enable)
  (setq elpy-rpc-backend "jedi")
  (define-key elpy-mode-map (kbd "<M-left>") nil)
  (define-key elpy-mode-map (kbd "<M-right>") nil)
  (define-key elpy-mode-map (kbd "<M-up>") nil)
  (define-key elpy-mode-map (kbd "<M-down>") nil)

  (setq python-shell-interpreter "jupyter"
        python-shell-interpreter-args "console --simple-prompt"
        python-shell-prompt-detect-failure-warning nil)
  (add-to-list 'python-shell-completion-native-disabled-interpreters
               "jupyter")
  
)

(setq python-shell-interpreter "ipython")
(setq python-shell-interpreter-args "-i --simple-prompt")

(pyvenv-activate rwc-default-pyvenv)

(defun my-delete-trailing-whitespace-hook ()
  "Add hook to delete trailing whitespace before save"
    (add-hook 'before-save-hook 'delete-trailing-whitespace nil 'local))

(add-hook 'python-mode-hook #'my-delete-trailing-whitespace-hook)

; (setq tramp-use-ssh-controlmaster-options nil)

;; Ivy/Counsel

(ivy-mode 1)

(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")

(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)

;; Neotree

(require 'all-the-icons)

(global-set-key  (kbd "M-<f8>") 'neotree-toggle)

;(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(setq neo-theme (if (display-graphic-p) 'arrow))
(setq neo-window-fixed-size nil)

;; Projectile

(projectile-mode)
(setq projectile-completion-system 'ivy)
(setq projectile-switch-project-action 'neotree-projectile-action)
(setq neo-vc-integration '(face char))
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; Defaults for specific file types

(add-hook 'text-mode-hook #'visual-line-mode)

;; Zoom window

(global-set-key (kbd "C-c z") 'zoom-window-zoom)

