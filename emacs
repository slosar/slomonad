(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)


(defun up-one () (interactive) (scroll-up 1))
(defun down-one () (interactive) (scroll-down 1))
(global-set-key [S-mouse-4] 'down-one)
(global-set-key [S-mouse-5] 'up-one)

(defun up-a-lot () (interactive) (scroll-up))
(defun down-a-lot () (interactive) (scroll-down))
(global-set-key [C-mouse-4] 'down-a-lot)
(global-set-key [C-mouse-5] 'up-a-lot)

(global-set-key [button4] 'scroll-down)
(global-set-key [button5] 'scroll-up)
(global-set-key [help] 'next-error)

(global-set-key [(C-return)] 'indent-region)
(global-set-key [(C-M-return)] 'comment-region)
(global-set-key [(C =)] 'eshell)
(global-set-key [(M p)] 'point-to-register)
(global-set-key [(M o)] 'jump-to-register)
(global-set-key [(M v)] 'todo-show)
(global-set-key (kbd "C-\\") 'set-mark-command)

(global-set-key (kbd "C-'") 'flyspell-auto-correct-word)
(global-set-key (kbd "C-e") 'move-end-of-line)

(global-set-key (kbd "C-z") 'battery)

(global-set-key [(control F)] 'find-file)

(global-set-key [(M g)] 'goto-line)

(global-set-key [(pause)] 'next-error)
(global-set-key [(Scroll_Lock)] 'compile)

;;; Cycle buffers
;;(global-set-key (kbd "M-[") 'previous-buffer)
;;(global-set-key (kbd "M-]") 'next-buffer)

(set-cursor-color "orange")


;;; git

(setq load-path (cons (expand-file-name "/usr/share/doc/git-core/contrib/emacs") load-path))
 (require 'vc-git)
 (when (featurep 'vc-git) (add-to-list 'vc-handled-backends 'git))
 (require 'git)
 (autoload 'git-blame-mode "git-blame"
           "Minor mode for incremental blame for Git." t)


;;; Under CVS control

(require 'cl)

;;;--- First the basic configuration which run on all computers


;; Prevent Emacs from extending file when pressing down arrow at end of buffer.
(setq next-line-add-newlines nil)


;; This + other files are under cvs -- get rid of annoying questions
(setq vc-follow-symlinks t)


;; Don't need the help mode!

;(global-set-key "\C-h" 'delete-backward-char) 
;(global-set-key "\M-C-h" 'delete-backward-word)
;(global-set-key "\C-xh" 'help-command) ;; overrides mark-whole-buffer




     (progn

       
       ;; Include local info files
       (setq Info-directory-list '("/usr/info" "/usr/share/info" "~/emacs/info" "~/s/info"))
      
      
       (require 'info)
       (setq Info-default-directory-list 
 	    (cons "~/emacs/info/texi" Info-default-directory-list))
      
 					; Turn on topic mode by default
       (add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
      
       ;; turn off excessive prompts
       (setq gnus-prompt-before-saving t)
      

       ;;; Setup C++ mode
       (add-hook 'c++-mode-hook 'turn-on-font-lock )

 ;;; Setup C mode
       (add-hook 'c-mode-hook 'turn-on-font-lock )

 ;;; Setup fortran mode
       (add-hook 'fortran-mode-hook 'turn-on-font-lock )
       (add-hook 'f90-mode-hook 'turn-on-font-lock )


;;  Setup Makefile mode
       (add-hook 'makefile-mode-hook 'turn-on-font-lock )

 ;;; Dired mode setup
       (add-hook 'dired-mode-hook 'turn-on-font-lock )

 ;;; Setup message mode
       (add-hook 'message-mode-hook 'auto-fill-mode)
       (add-hook 'message-mode-hook 'flyspell-mode)
       (custom-set-variables
        '(visible-bell t))
      
       (custom-set-faces)
      
      
 ;;; Set up PSGLM
      
       (autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
       (autoload 'xml-mode "psgml" "Major mode to edit XML files." t)
      
       (add-hook 'xml-mode-hook 'flyspell-mode)
       (add-hook 'xml-mode-hook 'auto-fill-mode)
      
       (add-hook 'sgml-mode-hook 'flyspell-mode)
       (add-hook 'sgml-mode-hook 'auto-fill-mode)
      
 ;;; setup xsl mode
      
       ;; XSL mode
       (autoload 'xsl-mode "xslide" "Major mode for XSL stylesheets." t)
      
       ;; Turn on font lock when in XSL mode
       (add-hook 'xsl-mode-hook
 		'turn-on-font-lock)
      
       (setq auto-mode-alist
 	    (append
 	     (list
 	      '("\\.fo" . xsl-mode)
 	      '("\\.xsl" . xsl-mode))
 	     auto-mode-alist))
      
      
       ;; Set up bibtex
       (setq bibtex-user-optional-fields 
 	    (list  '( "objects" "astronomical sources described in the paper")
 		   '( "comments" "General comments about the paper")))
      
            
       (load-library "python")
       ;; Set up python mode
       ;(autoload 'python-mode "python-mode" "Python editing mode." t)
       ;(add-hook 'python-mode-hook 'turn-on-font-lock )


       ;(setq auto-mode-alist
 	;    (cons '("\\.py$" . python-mode) auto-mode-alist))
       ;(setq interpreter-mode-alist
 	;   (cons '("python" . python-mode)
 		; interpreter-mode-alist))
      
      ;; set up printer
       (setq lpr-switches '(""))

(custom-set-variables
  ;; custom-set-variables was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 '(appt-message-warning-time 12 t)
 '(blink-cursor nil)
 '(blink-matching-paren-on-screen nil)
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "Slovenian")
 '(default-input-method "latin-2-postfix")
 '(delete-selection-mode nil nil (delsel))
 '(dired-copy-preserve-time t t)
 '(display-time-day-and-date nil)
 '(display-time-mode t nil (time))
 '(indicate-empty-lines t)
 '(keyboard-coding-system (quote iso-8859-2))
 '(menu-bar-mode nil)
 '(minibuffer-message-timeout 2 t)
 '(mouse-sel-cycle-clicks nil)
 '(mouse-sel-default-bindings (quote interprogram-cut-paste))
 '(mouse-sel-leave-point-near-mouse nil)
 '(mouse-wheel-mode t nil (mwheel))
 '(mouse-yank-at-point t)
 '(reftex-use-itimer-in-xemacs nil t)
 '(rmail-summary-scroll-between-messages t t)
 '(scroll-bar-mode nil)
 '(scroll-step 1)
 '(show-paren-mode t nil (paren))
 '(tool-bar-mode nil nil (tool-bar))
 '(track-mouse nil t)
 '(transient-mark-mode t)
 '(truncate-lines t)
 '(visible-bell t)
 '(woman-use-own-frame nil)))

;;(add-hook 'html-mode-hook 'turn-on-font-lock )
(put 'upcase-region 'disabled nil)

;(load-file "/opt/intel/idb/9.0/bin/idb.el")

(put 'downcase-region 'disabled nil)
(load "preview-latex.el" nil t t)
(require 'tex-site)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
;; Set up xdvi
(setq tex-dvi-view-command "evince")
(setq ispell-dictionary "american")
;; Setup latex mode 
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;;; these need to be disabled for some bizarres reason
;;; as something else switches them on.
;(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
;(add-hook 'LaTeX-mode-hook 'flyspell-mode)
;(add-hook 'LaTeX-mode-hook 'turn-on-font-lock )
;(put 'LaTeX-hide-environment 'disabled nil)
					;(setq LaTeX-command-style '(("" "%(PDF)%(latex) -file-line-error %S%(PDFout)")))
(setq LaTeX-command-style '(("" "pdflatex -file-line-error %S%(PDFout)")))

;; Setup text mode
(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'text-mode-hook 'flyspell-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-selection
   (quote
    (((output-dvi style-pstricks)
      "Evince")
     (output-dvi "Evince")
     (output-pdf "Evince")
     (output-html "Evince"))))
 '(appt-message-warning-time 12 t)
 '(blink-cursor-mode nil)
 '(blink-matching-paren-on-screen nil)
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "Slovenian")
 '(default-input-method "latin-2-postfix")
 '(delete-selection-mode nil nil (delsel))
 '(dired-copy-preserve-time t)
 '(display-time-day-and-date nil)
 '(display-time-mode t nil (time))
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(keyboard-coding-system (quote iso-8859-2))
 '(menu-bar-mode nil)
 '(minibuffer-message-timeout 2 t)
 '(mouse-sel-cycle-clicks nil)
 '(mouse-sel-default-bindings (quote interprogram-cut-paste))
 '(mouse-sel-leave-point-near-mouse nil)
 '(mouse-wheel-mode t nil (mwheel))
 '(mouse-yank-at-point t)
 '(package-selected-packages (quote (ein markdown-mode)))
 '(reftex-use-itimer-in-xemacs nil t)
 '(rmail-summary-scroll-between-messages t t)
 '(scroll-bar-mode nil)
 '(scroll-step 1)
 '(show-paren-mode t nil (paren))
 '(tool-bar-mode nil nil (tool-bar))
 '(track-mouse nil t)
 '(transient-mark-mode t)
 '(truncate-lines f)
 '(visible-bell t)
 '(woman-use-own-frame nil))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "#000000" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal))))
 '(border ((t nil)))
 '(font-latex-bold-face ((t (:foreground "violet" :weight bold))))
 '(font-latex-italic-face ((t (:foreground "orange" :slant italic))))
 '(fringe ((((class color) (background dark)) nil)))
 '(header-line ((((class color grayscale) (background dark)) (:inherit mode-line))))
 '(mode-line ((((type x w32 mac) (class color)) (:background "gray" :foreground "black"))))
 '(widget-documentation-face ((((class color) (background dark)) (:foreground "yellow"))) t))


;;;;;;;;;;;;;;;;;;;;
;; set up unicode
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)


;(setq TeX-engine 'pdflatex)
(setq TeX-PDF-mode t)


;;; vipers
;(add-to-list 'load-path "~/.emacs.d/evil")
;    (require 'evil)
;    (evil-mode 1)

;;; evil remaps C-e to evil-scroll-line-down - undo that
;(define-key evil-insert-state-map "\C-e" 'end-of-line)

;; (setq load-path (cons "/home/anze/local/share/emacs/site-lisp/mew" load-path))

;; ;(add-to-list 'load-path "/home/anze/local/share/emacs/site-lisp")
;; ;(require 'rainbow-delimiters)

;; (autoload 'mew "mew" nil t)
;; (autoload 'mew-send "mew" nil t)

;; ;; Optional setup (Read Mail menu):
;; (setq read-mail-command 'mew)

;; ;; Optional setup (e.g. C-xm for sending a message):
;; (autoload 'mew-user-agent-compose "mew" nil t)
;; (if (boundp 'mail-user-agent)
;;     (setq mail-user-agent 'mew-user-agent))
;; (if (fboundp 'define-mail-user-agent)
;;     (define-mail-user-agent
;;       'mew-user-agent
;;       'mew-user-agent-compose
;;       'mew-draft-send-message
;;       'mew-draft-kill
;;       'mew-send-hook))

;; (set-language-environment "Latin-1")
;; (set-input-method "latin-1-prefix") ;; or "latin-1-postfix"
;; (setq mew-name "Anže Slosar") ;; (user-full-name)
;; (setq mew-user "anze") ;; (user-login-name)
;; (setq mew-mail-domain "bnl.gov")
;; (setq mew-smtp-server "rcf.rhic.bnl.gov")  ;; if not localhost
;; (setq mew-proto "%")
;; (setq mew-imap-user "anze")  ;; (user-login-name)
;; (setq mew-imap-ssl 1)
;; (setq mew-ssl-verify-level 0)
;; (setq mew-imap-server "rcf.rhic.bnl.gov")    ;; if not localhost


(autoload 'zap-up-to-char "misc"
    "Kill up to, but not including ARGth occurrence of CHAR.
  
  \(fn arg char)"
    'interactive)
(global-set-key "\M-z" 'zap-up-to-char)

(setq reftex-section-levels '(("part" . 0)
                  ("chapter" . 1)
                  ("section" . 2)
                  ("subsection" . 3)
                  ("subsubsection" . 4)
                  ("paragraph" . 5)
                  ("subparagraph" . 6)
                  ("frametitle" . 7)
                  ("addchap" . -1)
                  ("addsec" . -2)))
(add-to-list 'load-path
              "~/.emacs.d/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

(require 'eshell)
(require 'em-smart)

(setq eshell-cmpl-cycle-completions nil
      eshell-save-history-on-exit t
      eshell-cmpl-dir-ignore "\\`\\(\\.\\.?\\|CVS\\|\\.svn\\|\\.git\\)/\\'")


(add-hook 'eshell-mode-hook
   '(lambda nil
      (add-to-list 'eshell-visual-commands "emacsclient")
     (add-to-list 'eshell-visual-commands "ssh")
     (add-to-list 'eshell-visual-commands "tail")
     (add-to-list 'eshell-command-completions-alist
                  '("gunzip" "gz\\'"))
     (add-to-list 'eshell-command-completions-alist
                  '("tar" "\\(\\.tar|\\.tgz\\|\\.tar\\.gz\\)\\'"))
     (add-to-list 'eshell-output-filter-functions 'eshell-handle-ansi-color)
     (setenv "SVN_EDITOR" "emacsclient"))
 )

 (defvar visual-wrap-column 80)

(defun set-visual-wrap-column (new-wrap-column &optional buffer)
      "Force visual line wrap at NEW-WRAP-COLUMN in BUFFER (defaults
    to current buffer) by setting the right-hand margin on every
    window that displays BUFFER.  A value of NIL or 0 for
    NEW-WRAP-COLUMN disables this behavior."
      (interactive (list (read-number "New visual wrap column, 0 to disable: " (or visual-wrap-column fill-column 0))))
      (if (and (numberp new-wrap-column)
               (zerop new-wrap-column))
        (setq new-wrap-column nil))
      (with-current-buffer (or buffer (current-buffer))
        (visual-line-mode t)
        (set (make-local-variable 'visual-wrap-column) new-wrap-column)
        (add-hook 'window-configuration-change-hook 'update-visual-wrap-column nil t)
        (let ((windows (get-buffer-window-list)))
          (while windows
            (when (window-live-p (car windows))
              (with-selected-window (car windows)
                (update-visual-wrap-column)))
            (setq windows (cdr windows))))))
(defun update-visual-wrap-column ()
      (if (not visual-wrap-column)
        (set-window-margins nil nil)
        (let* ((current-margins (window-margins))
               (right-margin (or (cdr current-margins) 0))
               (current-width (window-width))
               (current-available (+ current-width right-margin)))
          (if (<= current-available visual-wrap-column)
            (set-window-margins nil (car current-margins))
            (set-window-margins nil (car current-margins)
                                (- current-available visual-wrap-column))))))

(setq visual-line-fringe-indicators '(space right-curly-arrow))

;;;;;;;;;;;;;;;;;

(setq mail-user-agent 'message-user-agent)

(setq user-mail-address "anze@bnl.gov"
        user-full-name "Anže Slosar")

(setq send-mail-function 'smtpmail-send-it)
(setq message-send-mail-function 'smtpmail-send-it)
(setq smtpmail-smtp-server "localhost")
(setq smtpmail-smtp-service 2525)

;; use the default input method in message mode
(add-hook 'message-mode-hook 'toggle-input-method)
;; report problems with the smtp server
(setq smtpmail-debug-info t)
;; add Cc and Bcc headers to the message buffer
(setq message-default-mail-headers "Cc: \nBcc: anze@bnl.gov\n")
;; postponed message is put in the following draft file
(setq message-auto-save-directory "~/Mail/drafts")


(setq frame-title-format "%b")

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)


(setq TeX-engine 'xetex)
