;;; init.el --- Mac Emacs configuration  -*- lexical-binding: t; -*-
;;; Commentary:
;; Loads the shared ~/dotfiles/.emacs (also used on the Linux hosts), then
;; adds a few Mac-side settings on top. Edit shared settings there, not here.
;;; Code:

;; --- Customize writes here instead of into this file ---
(setq custom-file (locate-user-emacs-file "custom.el"))

;; --- Shared config (loaded first so the settings below win) ---
(load (expand-file-name "~/dotfiles/.emacs") 'noerror)

;; --- Packages: MELPA over https (the shared file adds it over http) ---
(require 'package)
(setf (alist-get "melpa" package-archives nil nil #'equal)
      "https://melpa.org/packages/")

;; --- Files and history ---
(setq backup-directory-alist `(("." . ,(locate-user-emacs-file "backups"))))
(save-place-mode 1)         ; reopen files at the last cursor position
(savehist-mode 1)           ; remember minibuffer history
(recentf-mode 1)            ; M-x recentf-open for recently opened files
(global-auto-revert-mode 1) ; reload files changed on disk

;; Reopen last session's files in the GUI only; terminal Emacs starts fresh.
(when (display-graphic-p)
  (desktop-save-mode 1))

;; --- GUI: use the login shell's PATH so Emacs.app finds git ---
(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns))
  :config (exec-path-from-shell-initialize))

;; --- GUI colors: built-in Modus themes, following macOS light/dark mode ---
;; ns-system-appearance* come from Emacs Plus. Terminal Emacs keeps the
;; terminal's own colors. M-x modus-themes-toggle switches by hand.
(when (display-graphic-p)
  (defun my/apply-theme (appearance)
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme (if (eq appearance 'dark) 'modus-vivendi 'modus-operandi) t))
  (if (boundp 'ns-system-appearance-change-functions)
      (progn
        (add-hook 'ns-system-appearance-change-functions #'my/apply-theme)
        (my/apply-theme ns-system-appearance))
    (my/apply-theme 'light)))

;; --- Magit ---
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; --- Rex: M-x rexel for a shell in a Rex session, M-x rexel-attach to pick
;; a running one. Each Rex terminal becomes a Ghostel buffer. Rexel is not on
;; MELPA yet, so it comes from its repository.
(use-package ghostel :ensure t)
(use-package websocket :ensure t)
(use-package rexel
  :vc (:url "https://github.com/dakra/rexel"))

;; --- Org ---
(setq org-directory "~/org")
(setq org-default-notes-file (expand-file-name "inbox.org" org-directory))
(setq org-agenda-files (list org-directory))
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c l") #'org-store-link)

;; --- Calendar: mark holidays in M-x calendar ---
(setq calendar-mark-holidays-flag t)

(load custom-file 'noerror)

;;; init.el ends here
