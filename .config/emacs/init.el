;; Enable package manager early

;; Basic UI Config
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(setq make-backup-files nil)
(add-to-list 'default-frame-alist '(undecorated . t))

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)

;; Theme
(use-package tokyonight-themes
  :vc (:url "https://github.com/xuchengpeng/tokyonight-themes")
  :config
  (load-theme 'tokyonight-night :no-confirm))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-line-numbers 'visual)
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(@ all-the-icons-completion embark-consult evil-collection
       evil-mc-extras evil-multiedit go go-mode lua-mode magit
       marginalia orderless tokyonight-themes vertico vterm))
 '(package-vc-selected-packages
   '((tokyonight-themes :url
			"https://github.com/xuchengpeng/tokyonight-themes"))))
(custom-set-faces

 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Font
(set-frame-font "JetBrainsMonoNL NF-10")

;; Make M-p act like the original C-x prefix keymap
(define-key global-map (kbd "M-p") ctl-x-map)

;; Make M-m act like the original C-c prefix keymap
(define-key global-map (kbd "M-m") mode-specific-map)

 ;; Vim keybindings with Evil
 (use-package evil
   :ensure t
   :init
   (setq evil-want-integration t)
   (setq evil-want-keybinding nil)
   (setq evil-want-C-u-scroll t))
   ;; :config
   ;; (evil-mode 1))


 (use-package evil-collection
   :after evil
   :config
   (evil-collection-init))

;; Evil Numbers
(require 'cl-lib)
(use-package evil-numbers
  :ensure t)

(evil-define-key '(normal visual) 'global
  (kbd "C-a") 'evil-numbers/inc-at-pt
  (kbd "C-x") 'evil-numbers/dec-at-pt)

(evil-define-key '(normal visual) 'global
  (kbd "g C-a") 'evil-numbers/inc-at-pt-incremental
  (kbd "g C-x") 'evil-numbers/dec-at-pt-incremental)

;; C-c like Vim
(define-key evil-insert-state-map (kbd "C-c") 'evil-normal-state)
(define-key evil-visual-state-map (kbd "C-c") 'evil-normal-state)
(define-key evil-replace-state-map (kbd "C-c") 'evil-normal-state)

;; Garante que as funções de clipboard do sistema funcionem
(setq select-enable-clipboard nil)

;; Atalhos com CTRL + SHIFT
(global-set-key (kbd "C-S-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "C-S-v") 'clipboard-yank)


;; Magit - Git interface
(use-package magit
  :bind (("M-G" . magit-status))
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))
 
;; ===== EVIL-MC - MULTIPLE CURSORS =====
(use-package evil-mc
  :ensure t
  :after evil
  :config
  (global-evil-mc-mode 0) ; Enable multiple cursors globally
  ;; Core commands for creating cursors on matches
  (define-key evil-normal-state-map (kbd "C-.")
	      #'evil-mc-make-and-goto-next-match)
  (define-key evil-visual-state-map (kbd "C-.")
	      #'evil-mc-make-and-goto-next-match)
  (define-key evil-normal-state-map (kbd "C-,")
	      #'evil-mc-make-and-goto-prev-match)
  (define-key evil-visual-state-map (kbd "C-,")
	      #'evil-mc-make-and-goto-prev-match)
  ;; Create cursors for ALL matches in the buffer
  (define-key evil-visual-state-map (kbd "C-D")
	      #'evil-mc-make-all-cursors)
  ;; Navigation between existing cursors (optional)
  (define-key evil-mc-key-map (kbd "M-N") #'evil-mc-make-and-goto-next-cursor)
  (define-key evil-mc-key-map (kbd "M-P") #'evil-mc-make-and-goto-prev-cursor)
  (define-key evil-mc-key-map (kbd "C-n") #'evil-mc-skip-and-goto-next-match)
 (define-key evil-mc-key-map (kbd "C-p") #'evil-mc-skip-and-goto-prev-match)
    ;; Clear all cursors
 (define-key evil-mc-key-map (kbd "<escape>") #'evil-mc-undo-all-cursors))

;; FIXME: NixOs Shit
;; (use-package vterm
;;    :ensure t)
