;;; .emacs -- Personal Emacs configuration
;;; Commentary:
;;; Code:

;; --- Package Management ---
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;; --- Basic Customizations ---
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq-default c-basic-offset 2)
(setq-default css-indent-offset 2)

;; Clean up whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; --- UTF-8 Settings ---
(setq utf-translate-cjk-mode nil)
(set-language-environment 'utf-8)
(setq locale-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-file-name-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(when (boundp 'buffer-file-coding-system)
  (setq buffer-file-coding-system 'utf-8))
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; --- Personal Keybindings ---
(global-set-key (kbd "M-j") 'backward-char)
(global-set-key (kbd "M-l") 'forward-char)

;; --- Org Mode ---
(global-set-key (kbd "C-c o") (lambda () (interactive) (find-file "~/Dropbox/org/notes.org")))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)

;; --- Magit (only load if installed) ---
(when (require 'magit nil 'noerror)
  (global-set-key (kbd "C-x g") 'magit-status))

;; --- Indentation Function ---
(defun my-setup-indent (n)
  (setq-local c-basic-offset n)
  (when (boundp 'coffee-tab-width) (setq-local coffee-tab-width n))
  (when (boundp 'javascript-indent-level) (setq-local javascript-indent-level n))
  (when (boundp 'js-indent-level) (setq-local js-indent-level n))
  (when (boundp 'js2-basic-offset) (setq-local js2-basic-offset n))
  (when (boundp 'web-mode-markup-indent-offset) (setq-local web-mode-markup-indent-offset n))
  (when (boundp 'web-mode-css-indent-offset) (setq-local web-mode-css-indent-offset n))
  (when (boundp 'web-mode-code-indent-offset) (setq-local web-mode-code-indent-offset n))
  (when (boundp 'css-indent-offset) (setq-local css-indent-offset n)))

(add-hook 'c-mode-common-hook (lambda () (my-setup-indent tab-width)))

;; --- Disable Desktop Save Mode (prevents y/n prompts) ---
(desktop-save-mode 0)

;; --- Custom Variables ---
(custom-set-variables
 '(package-selected-packages '())
 '(tab-stop-list (quote (2 4 6 8 10 12 14 16 18 20 22 24 26 28)))
 '(ediff-window-setup-function 'ediff-setup-windows-plain))

(custom-set-faces)

;;; .emacs ends here
