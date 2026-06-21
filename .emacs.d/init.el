;;; -*- lexical-binding: t; -*-

;;; General setup
(setq user-full-name "Matt Higgins"
      user-mail-address "matt@matthiggins.d")

;; Perf
(setq gc-cons-threshold 50000000)
(setq large-file-warning-threshold 100000000)
(setq exec-path-from-shell-arguments nil)

;; Appearance
(setq inhibit-startup-message t
      initial-scratch-message ""
      cursor-type 'bar)
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;;; Package manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)
(unless package-archive-contents
  (package-refresh-contents))
(eval-when-compile
  (require 'use-package))


;;; Custom
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

;;; Appearance
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)

(global-hl-line-mode +1)
(line-number-mode +1)
(global-display-line-numbers-mode 1)
(column-number-mode t)
(size-indication-mode t)

(global-auto-revert-mode t)
(setq visible-bell t)
(fido-vertical-mode 1)

(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

(use-package gruber-darker-theme
  :ensure t
  :config
  (load-theme 'gruber-darker t))

(set-face-attribute 'default nil :family "Iosevka" :height 140)

(setq-default tab-width 4
              indent-tabs-mode nil)
(add-hook 'before-save-hook 'whitespace-cleanup)


;;; Editor Packages
(use-package diminish
  :ensure t)

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode 1)
    (show-paren-mode t)))

(use-package go-mode
  :hook (go-mode . my/go-mode-setup)
  :init
  (defun my/go-mode-setup ()
    (eglot-ensure)
    (add-hook 'before-save-hook #'eglot-format-buffer -10 t)
    (add-hook 'before-save-hook #'my/go-organize-imports -10 t))
  (defun my/go-organize-imports ()
    (when (eglot-managed-p)
      (ignore-errors
        (eglot-code-action-organize-imports (point-min) (point-max))))))

(add-to-list 'display-buffer-alist
             '("\\*compilation\\*"
               (display-buffer-reuse-window
                display-buffer-in-side-window)
               (side . bottom)
               (window-height . 0.25)))

(add-hook 'compilation-mode-hook #'goto-address-mode)
(setq compilation-always-kill t)
;; Put backups in one place instead of next to files
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups" user-emacs-directory))))

;; Same for auto-save files
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t)))

;; Make sure that auto-save dir exists, or auto-save silently fails
(make-directory (expand-file-name "auto-save/" user-emacs-directory) t)

(setq create-lockfiles nil)

;; HTTP Formatting
(use-package apheleia
  :ensure t
  :config
  ;; prettier for HTML is in the defaults, but being explicit doesn't hurt
  (setf (alist-get 'html-mode apheleia-mode-alist) 'prettier-html)
  (setf (alist-get 'mhtml-mode apheleia-mode-alist) 'prettier-html)
  (apheleia-global-mode +1))

;; C Config
(add-hook 'c-mode-hook #'eglot-ensure)
(add-hook 'c-ts-mode-hook #'eglot-ensure)
