;;; init.el --- Vim-like Emacs config -*- lexical-binding: t; -*-

;;; ------------------------------------------------------------
;;; Startup performance
;;; ------------------------------------------------------------
(setq gc-cons-threshold (* 50 1000 1000))
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 2 1000 1000))))

;;; ------------------------------------------------------------
;;; Package manager
;;; ------------------------------------------------------------
(require 'package)
(setq package-archives '(("melpa"  . "https://melpa.org/packages/")
                         ("gnu"    . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;; Keep Custom's generated code out of this file
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

;;; ------------------------------------------------------------
;;; Basic UI
;;; ------------------------------------------------------------
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(show-paren-mode 1)
(blink-cursor-mode 0)
(column-number-mode 1)
;; (add-to-list 'default-frame-alist '(undecorated . t))

(setq inhibit-startup-message t
      initial-scratch-message ""
      ring-bell-function #'ignore
      use-short-answers t)

;; Files: no backups, no lockfiles, auto-saves go to the temp dir
(setq make-backup-files nil
      create-lockfiles nil
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; Font (applies to every new frame too)
(add-to-list 'default-frame-alist '(font . "JetBrainsMonoNL NF-12"))
(set-frame-font "JetBrainsMonoNL NF-12" nil t)

;;; ------------------------------------------------------------
;;; Editing defaults (Vim-ish)
;;; ------------------------------------------------------------
(setq-default indent-tabs-mode nil
              tab-width 4)

;; Keep context around the cursor, like `set scrolloff=8`
(setq scroll-margin 8
      scroll-conservatively 101
      scroll-preserve-screen-position t)

;; Relative line numbers, like `set relativenumber`
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)

;; Code: no wrapping. Prose/Org: wrap at word boundaries.
(add-hook 'prog-mode-hook (lambda () (setq-local truncate-lines t)))
(add-hook 'text-mode-hook #'visual-line-mode)

(global-auto-revert-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(savehist-mode 1)
(electric-pair-mode 1)

;; Separate system clipboard from the kill ring (like Vim's "+ register)
;;   "+y / "+p in Evil, or C-S-c / C-S-v anywhere
(setq select-enable-clipboard nil)
(global-set-key (kbd "C-S-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "C-S-v") 'clipboard-yank)

;; ESC quits the minibuffer, like it does everywhere else in Vim
(dolist (map (list minibuffer-local-map
                   minibuffer-local-ns-map
                   minibuffer-local-completion-map
                   minibuffer-local-must-match-map
                   minibuffer-local-isearch-map))
  (define-key map [escape] #'minibuffer-keyboard-quit))

;;; ------------------------------------------------------------
;;; Theme (follows the OS dark/light setting)
;;; ------------------------------------------------------------
(use-package tokyonight-themes
  :vc (:url "https://github.com/xuchengpeng/tokyonight-themes")
  :config
  (defun my/get-system-color-scheme ()
    "Return `dark' or `light' based on the OS color-scheme setting."
    (cond
     ;; Linux (GNOME via dconf)
     ((and (eq system-type 'gnu/linux) (executable-find "dconf"))
      (let ((scheme (string-trim
                     (shell-command-to-string
                      "dconf read /org/gnome/desktop/interface/color-scheme"))))
        (if (string-match-p "light" scheme) 'light 'dark)))
     ;; Windows (registry: AppsUseLightTheme)
     ((eq system-type 'windows-nt)
      (let ((value (string-trim
                    (shell-command-to-string
                     "powershell -NoProfile -Command \"(Get-ItemProperty -Path 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize' -Name AppsUseLightTheme).AppsUseLightTheme\""))))
        (if (string= value "0") 'dark 'light)))
     (t 'dark)))

  (pcase (my/get-system-color-scheme)
    ('dark  (load-theme 'tokyonight-night :no-confirm))
    ('light (load-theme 'tokyonight-day   :no-confirm))))

;;; ------------------------------------------------------------
;;; Evil (Vim emulation)
;;; ------------------------------------------------------------
(use-package evil
  :init
  ;; These MUST be set before Evil loads
  (setq evil-want-integration t
        evil-want-keybinding nil          ; evil-collection handles other modes
        evil-want-C-u-scroll t            ; C-u scrolls up like Vim
        evil-want-C-i-jump nil            ; keep TAB working in terminal/Org
        evil-want-Y-yank-to-eol t         ; Y = y$
        evil-want-fine-undo t
        evil-undo-system 'undo-redo       ; u / C-r
        evil-respect-visual-line-mode t   ; j/k move by screen line when wrapped
        evil-split-window-below t
        evil-vsplit-window-right t
        evil-search-module 'evil-search   ; / ? n N with :s-style regexps
        evil-ex-search-highlight-all t
        evil-shift-width 4)
  :config
  (evil-mode 1))

;; Evil keybindings for Magit, Dired, help buffers, Vertico, etc.
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; ys / cs / ds for surrounding pairs
(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

;; gc / gcc to comment
(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode 1))

;; ;;; ------------------------------------------------------------
;; ;;; Completion: Vertico + Orderless + Marginalia
;; ;;; ------------------------------------------------------------
;; (use-package vertico
;;   :init
;;   (vertico-mode 1)
;;   :bind (:map vertico-map
;;               ("C-j" . vertico-next)
;;               ("C-k" . vertico-previous)))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode 1))

;;; ------------------------------------------------------------
;;; Magit
;;; ------------------------------------------------------------
(use-package magit
  :commands (magit-status magit-dispatch magit-file-dispatch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;;; ------------------------------------------------------------
;;; Editing helpers
;;; ------------------------------------------------------------
;; note: from rexim/tsoding
(use-package multiple-cursors
  :config
  (global-set-key (kbd "C-;")     'mc/edit-lines)
  (global-set-key (kbd "C-.")     'mc/mark-next-like-this)
  (global-set-key (kbd "C-,")     'mc/mark-previous-like-this)
  (global-set-key (kbd "C-x C-<") 'mc/mark-all-like-this)
  (global-set-key (kbd "M-n")     'mc/skip-to-next-like-this)
  (global-set-key (kbd "M-p")     'mc/skip-to-previous-like-this))

(use-package move-text
  :config
  (global-set-key (kbd "M-K") 'move-text-up)
  (global-set-key (kbd "M-J") 'move-text-down)
  ;; Visual mode: J / K move the selection (note: overrides Vim's J = join)
  (with-eval-after-load 'evil
    (evil-define-key 'visual 'global
      (kbd "J") 'move-text-down
      (kbd "K") 'move-text-up)))

;;; ------------------------------------------------------------
;;; Org
;;; ------------------------------------------------------------
(use-package org
  :pin gnu
  :config
  (setq org-directory "~/org"
        org-agenda-files '("~/org")))

(use-package evil-org
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;;; ------------------------------------------------------------
;;; Compile
;;; ------------------------------------------------------------
(global-set-key (kbd "M-C")   'compile)
(global-set-key (kbd "C-M-c") 'recompile)

;;; ------------------------------------------------------------
;;; Leader key (SPC) — which-key is built in since Emacs 30
;;; ------------------------------------------------------------
(if (fboundp 'which-key-mode)
    (which-key-mode 1)
  (use-package which-key :config (which-key-mode 1)))

(use-package general
  :after evil
  :config
  (general-create-definer my/leader
    :states '(normal visual motion emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "M-SPC")

  (my/leader
    "SPC" '(execute-extended-command :which-key "M-x")

    ;; files
    "f"  '(:ignore t :which-key "file")
    "ff" '(find-file :which-key "find file")
    "fr" '(recentf-open :which-key "recent files")
    "fs" '(save-buffer :which-key "save")
    "fe" `(,(lambda () (interactive) (find-file user-init-file))
           :which-key "edit init.el")

    ;; buffers
    "b"  '(:ignore t :which-key "buffer")
    "bb" '(switch-to-buffer :which-key "switch")
    "bd" '(kill-current-buffer :which-key "kill")
    "bn" '(next-buffer :which-key "next")
    "bp" '(previous-buffer :which-key "previous")

    ;; windows (C-w also works natively through Evil)
    "w"  '(:ignore t :which-key "window")
    "ws" '(evil-window-split :which-key "split below")
    "wv" '(evil-window-vsplit :which-key "split right")
    "wd" '(evil-window-delete :which-key "delete")
    "wo" '(delete-other-windows :which-key "only this")

    ;; git
    "g"  '(:ignore t :which-key "git")
    "gg" '(magit-status :which-key "status")
    "gl" '(magit-log-current :which-key "log")
    "gb" '(magit-blame :which-key "blame")
    "gf" '(magit-file-dispatch :which-key "file actions")

    ;; code
    "c"  '(:ignore t :which-key "compile")
    "cc" '(compile :which-key "compile")
    "cr" '(recompile :which-key "recompile")

    ;; org
    "o"  '(:ignore t :which-key "org")
    "oa" '(org-agenda :which-key "agenda")
    "oc" '(org-capture :which-key "capture")

    ;; help
    "h"  '(:ignore t :which-key "help")
    "hf" '(describe-function :which-key "function")
    "hv" '(describe-variable :which-key "variable")
    "hk" '(describe-key :which-key "key")))

;;; init.el ends here
