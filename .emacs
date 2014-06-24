(require 'package)
(add-to-list 'package-archives
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(package-initialize)
(add-to-list 'load-path "/Users/rmorello/.emacs.d/")
(add-to-list 'load-path "/Users/rmorello/.emacs.d/vendor/")
(add-to-list 'load-path "/Users/rmorello/.emacs.d/git-emacs/")
(add-to-list 'load-path "/Users/rmorello/.emacs.d/markdown-mode/")
(require 'minitest)
(require 'git-emacs)
(require 'git-blame)
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(load "/Users/rmorello/.emacs.d/emacs-xkcd.el")
(global-set-key (kbd "M-/") 'hippie-expand)
(set-default 'cursor-type 'box)
; make carriage returns blue and tabs green
(custom-set-faces
 '(my-carriage-return-face ((((class color)) (:background "blue"))) t)
 '(my-tab-face ((((class color)) (:background "green"))) t)
 )
; add custom font locks to all buffers and all files
(add-hook
 'font-lock-mode-hook
 (function
  (lambda ()
    (setq
     font-lock-keywords
     (append
      font-lock-keywords
      '(
        ("\r" (0 'my-carriage-return-face t))
        ("\t" (0 'my-tab-face t))
        ))))))

; make characters after column 80 purple
; (setq whitespace-style
;   (quote (face trailing tab-mark lines-tail)))
; (add-hook 'find-file-hook 'whitespace-mode)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

; transform literal tabs into a right-pointing triangle
(setq
 whitespace-display-mappings ;http://ergoemacs.org/emacs/whitespace-mode.html
 '(
   (tab-mark 9 [9654 9] [92 9])
   ;others substitutions...
   ))
