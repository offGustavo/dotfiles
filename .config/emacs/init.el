(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(setq make-backup-files nil)
;; (add-to-list 'default-frame-alist '(undecorated . t))
(global-display-line-numbers-mode)
(global-visual-line-mode)

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

;; Font
(set-frame-font "JetBrainsMonoNL NF-10")

;; ;; Vim keybindings with Evil
;; (use-package evil
;;   :ensure t
;;   :init
;;   (setq evil-want-C-u-scroll t)
;;   :config
;;   (evil-mode t))
  
;; ;; Magit - Git interface
(use-package magit)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(evil-collection evil-mc evil-numbers exwm-firefox-evil magit meow
		     tokyonight-themes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
