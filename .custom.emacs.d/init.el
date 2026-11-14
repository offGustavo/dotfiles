;;; init.el --- Vim-like Emacs config -*- lexical-binding: t; -*-


(setq gc-cons-threshold (* 50 1000 1000))
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 2 1000 1000))))

(setq use-package-always-ensure t)
(setq package-install-upgrade-built-in t)
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

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

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

(setq make-backup-files nil
      create-lockfiles nil
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(add-to-list 'default-frame-alist '(font . "JetBrainsMonoNL NF-12"))
(set-frame-font "JetBrainsMonoNL NF-12" nil t)

(setq-default indent-tabs-mode nil
              tab-width 4)

(setq scroll-margin 8
      scroll-conservatively 101
      scroll-preserve-screen-position t)

(setq display-line-numbers-type 0)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)

;; Code: no wrapping. Prose/Org: wrap at word boundaries.
(add-hook 'prog-mode-hook (lambda () (setq-local truncate-lines t)))
(add-hook 'text-mode-hook #'visual-line-mode)

(global-auto-revert-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(savehist-mode 1)

;; (fido-vertical-mode 1)

(which-key-mode 1)

(setq select-enable-clipboard nil)
(global-set-key (kbd "C-S-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "C-S-v") 'clipboard-yank)
;; TODO: add Cut
(global-set-key (kbd "C-S-x") 'clipboard-yank)

;; Compile
(global-set-key (kbd "M-C")   'compile)
(global-set-key (kbd "M-RET") 'recompile)


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



(use-package org
  :pin gnu
  :config
  (setq org-directory "~/Notes"
        org-agenda-files '("~/Notes")))

(use-package evil-org
  :after org
  :hook (org-mode . evil-org-mode )
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package evil
  :init
  ;; These MUST be set before Evil loads
  (setq evil-want-integration t
        evil-disable-insert-state-bindings t
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

  ;; ESC quits the minibuffer, like it does everywhere else in Vim
  (dolist (map (list minibuffer-local-map
                     minibuffer-local-ns-map
                     minibuffer-local-completion-map
                     minibuffer-local-must-match-map
                     minibuffer-local-isearch-map))
    (define-key map [escape] #'minibuffer-keyboard-quit))

  (evil-mode 1)

  ;; Evil binds C-. to `evil-repeat-pop' in normal state, which would
  ;; shadow multiple-cursors' C-. binding. Let the global binding through.
  (define-key evil-normal-state-map (kbd "C-.") nil)
  (define-key evil-normal-state-map (kbd "ESC") 'evil-ex-nohighlight))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode 1))

(use-package evil-goggles
  :ensure t
  :config
  (evil-goggles-mode)
  ;; optionally use diff-mode's faces; as a result, deleted text
  ;; will be highlighed with `diff-removed` face which is typically
  ;; some red color (as defined by the color theme)
  ;; other faces such as `diff-added` will be used for other actions
  (evil-goggles-use-diff-faces))

;; (use-package vertico
;;   :init
;;   (vertico-mode 1)
;;   :bind (:map vertico-map
;;               ("C-n" . vertico-next)
;;               ("C-p" . vertico-previous)))
;;
;; (use-package orderless
;;   :custom
;;   (completion-styles '(orderless basic))
;;   (completion-category-overrides '((file (styles basic partial-completion)))))
;;
;; (use-package marginalia
;;   :init
;;   (marginalia-mode 1))

;; ;; TODO(magit): fix magit config
;; (use-package magit)
;;   :commands (magit-status magit-dispatch magit-file-dispatch)
;;   :custom
;;   (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
;;   :config
;;   (global-set-key (kbd "M-G")     'magit-


;; TODO: add evil-mc
;; (use-package multiple-cursors
;;   :config
;;   (global-set-key (kbd "C-;")     'mc/edit-lines)
;;   (global-set-key (kbd "C-.")     'mc/mark-next-like-this)
;;   (global-set-key (kbd "C-,")     'mc/mark-previous-like-this)
;;   (global-set-key (kbd "C-x C-<") 'mc/mark-all-like-this)
;;   (global-set-key (kbd "M-n")     'mc/skip-to-next-like-this)
;;   (global-set-key (kbd "M-p")     'mc/skip-to-previous-like-this))

(use-package move-text
  :config
  (global-set-key (kbd "M-K") 'move-text-up)
  (global-set-key (kbd "M-J") 'move-text-down))
;; Visual mode: J / K move the selection (note: overrides Vim's J = join)
;; (with-eval-after-load 'evil
;;   (evil-define-key 'visual 'global
;;     (kbd "J") 'move-text-down
;;     (kbd "K") 'move-text-up)))


(use-package ghostel
  :vc (:url https://github.com/dakra/ghostel )
  :ensure t)

(use-package evil-ghostel
  :vc (:url "https://github.com/dakra/ghostel"
            :lisp-dir "extensions/evil-ghostel"
            :rev :newest)
  :after (ghostel evil)
  :hook (ghostel-mode . evil-ghostel-mode))

(use-package exwm
  ;; :if (and my/exwm-session (eq window-system 'x))
  :config
  (setq exwm-workspace-number 4)

  ;; Name buffers after the X window class / title
  (add-hook 'exwm-update-class-hook
            (lambda () (exwm-workspace-rename-buffer exwm-class-name)))
  (add-hook 'exwm-update-title-hook
            (lambda ()
              (exwm-workspace-rename-buffer
               
               (format "%s: %s" exwm-class-name
                       (truncate-string-to-width exwm-title 40 nil nil "…")))))

  ;; Keys that always go to Emacs, even from line-mode X windows
  (setq exwm-input-global-keys
        `(([?\s-r] . exwm-reset)             ; back to line-mode if stuck
          ([?\s-w] . exwm-workspace-switch)
          ([?\s-d] . my/exwm-launch)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

  ;; X windows should receive keys, not Evil's normal state
  (with-eval-after-load 'evil
    (evil-set-initial-state 'exwm-mode 'emacs)))
;; (exwm-enable))

(use-package exwm-evil
  :after exwm
  :vc (:url "https://github.com/LemonBreezes/exwm-evil")
  :config
  (add-hook 'exwm-manage-finish-hook #'enable-exwm-evil-mode)
  ;; ESC must reach Emacs so it can leave insert state. That means ESC no
  ;; longer reaches the app; use `my/exwm-send-escape' (g e in normal state).
  (add-to-list 'exwm-input-prefix-keys 'escape)
  ;; C-c is left to the app in insert state
  (define-key exwm-mode-map (kbd "C-c") nil)

  (defun my/exwm-send-escape ()
    "Send a real Escape key to the focused X window."
    (interactive)
    (exwm-evil-send-key 1 'escape))
  (evil-define-key 'normal exwm-mode-map (kbd "g e") #'my/exwm-send-escape))

;; (use-package comet-trail
;;   :vc (:url "https://git.andros.dev/andros/comet-trail.el"
;;        :rev :newest)
;;   :config
;;   (add-hook 'prog-mode-hook #'comet-trail-mode)
;;   (add-hook 'text-mode-hook #'comet-trail-mode))

;;   (add-hook 'text-mode-hook #'comet-trail-mode))
;;   (add-hook 'text-mode-hook #'comet-trail-mode))
;;   (add-hook 'text-mode-hook #'comet-trail-mode))
(use-package general
  :after evil
  :config
  (general-create-definer my/leader
    :states '(normal visual motion emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "M-SPC")
  (my/leader
    ;; "SPC" '(execute-extended-command :which-key "M-x")
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
