;; Use Emacs terminfo, not system terminfo
(setq system-uses-terminfo nil)

(require 'package)
;;(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;;                         ("marmalade" . "https://marmalade-repo.org/packages/")
;;                         ("melpa" . "http://melpa.org/packages/")))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq exec-path (cons (expand-file-name "~/.rvm/gems/ruby-2.1.5@sermo/bin") exec-path))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa"))
(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

(setq c-basic-offset 4)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(setq js-indent-level 2)
(setq scss-indent-level 2)
(setq require-final-newline t)

(require 'column-marker)
(require 'package)
(setq package-enable-at-startup nil)
(package-initialize)
(require 'ag)
(require 'ido)
(ido-mode t)
(setq column-number-mode t)
(setq undo-outer-limit 20000000)
(require 'helm-config)

(setq org-log-done 'time)

(require 'evernote-mode)
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
;; optional keyboard short-cut
(global-set-key "\C-xm" 'browse-url-at-point)
(setq w3m-use-cookies t)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'web-mode-indentation-params '("lineup-args" . nil))
(add-to-list 'web-mode-indentation-params '("lineup-calls" . nil))
(add-to-list 'web-mode-indentation-params '("lineup-concats" . nil))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-script-padding 2)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close 0)
  (js-set-offset 'arglist-intro '+)
  (js-set-offset 'arglist-close 0)
  (add-to-list 'web-mode-indentation-params '("lineup-args" . nil))
  (add-to-list 'web-mode-indentation-params '("lineup-calls" . nil))
  (add-to-list 'web-mode-indentation-params '("lineup-concats" . nil))
  )
(add-hook 'web-mode-hook 'my-web-mode-hook)

; (server-start)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evernote-developer-token
   "S=s10:U=11d8d5:E=15684551542:C=14f2ca3e658:P=1cd:A=en-devtoken:V=2:H=bcb930291dbf38a74ede0c66050c4552")
 '(evernote-password-cache t)
 '(evernote-username "rmorello"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
