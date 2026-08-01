
;; Enable package manager early

;; Basic UI Config
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(show-paren-mode 1)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(setq make-backup-files nil)
;; (add-to-list 'default-frame-alist '(undecorated . t))
(global-visual-line-mode 1)

(setq-default truncate-lines t)
(delete-selection-mode 1)
(blink-cursor-mode 0)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")("gnu-devel" . "https://elpa.gnu.org/devel/")
                         ("nongnu-devel" . "https://elpa.nongnu.org/nongnu-devel/")))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;; Theme
(use-package tokyonight-themes
  :vc (:url "https://github.com/xuchengpeng/tokyonight-themes")
  :config
  ;; Function to get system color scheme (Linux/GNOME or Windows)
  (defun my/get-system-color-scheme ()
    "Return 'dark or 'light based on the OS's color-scheme setting."
    (cond
     ;; Linux (GNOME via dconf)
     ((eq system-type 'gnu/linux)
      (let ((scheme (string-trim
                     (shell-command-to-string
                      "dconf read /org/gnome/desktop/interface/color-scheme"))))
        (cond
         ((string-match-p "dark" scheme) 'dark)
         ((string-match-p "light" scheme) 'light)
         (t 'dark))))
     ;; Windows (registry: AppsUseLightTheme)
     ((eq system-type 'windows-nt)
      (let ((value (string-trim
                    (shell-command-to-string
                     "powershell -NoProfile -Command \"(Get-ItemProperty -Path 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize' -Name AppsUseLightTheme).AppsUseLightTheme\""))))
        (if (string= value "0") 'dark 'light)))
     ;; Fallback for anything else
     (t 'dark)))
  ;; Apply theme according to system preference
  (let ((system-scheme (my/get-system-color-scheme)))
    (pcase system-scheme
      ('dark (load-theme 'tokyonight-night :no-confirm))
      ('light (load-theme 'tokyonight-day :no-confirm)))))

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(custom-safe-themes
;;    '("c11d5bd3fca620924c8593fd03947041bcf8d6fe9118d0139442fb63d9d74445"
;;      "ee3cc4f443355601df81966e86770c8726c95b9cc48ec33464bab93dda09795b"
;;      "x22d73dce2d6712154900097ac8f9146c51deea66a92a2406c8c3f341ee9eb30a"
;;     )
;;  ;; '(display-line-numbers 'visual)
;;  '(inhibit-startup-screen t)
;;  '(package-selected-packages
;;    '(## evil lua-mode magit markdown-mode meow meow-tree-sitter move-text
;; 	multiple-cursors powershell tokyonight-themes))
;;  '(package-vc-selected-packages
;;    '((tokyonight-themes :url
;; 			"https://github.com/xuchengpeng/tokyonight-themes"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Font
(set-frame-font "JetBrainsMonoNL NF-12")

;; Disable System Wide Clipboard
(setq select-enable-clipboard nil)
;; Interact With System Clipboard
(global-set-key (kbd "C-S-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "C-S-v") 'clipboard-yank)




;; ;; note: from rexim/tsoding
;; ;; multiple cursors
;; (use-package multiple-cursors
;;   :ensure t
;;   :config
;;   (global-set-key (kbd "C-;") 'mc/edit-lines)
;;   (global-set-key (kbd "C-.")         'mc/mark-next-like-this)
;;   (global-set-key (kbd "C-,")         'mc/mark-previous-like-this)
;;   (global-set-key (kbd "C-x C-<")     'mc/mark-all-like-this)
;;   (global-set-key (kbd "M-n")        'mc/skip-to-next-like-this)
;;   (global-set-key (kbd "M-p")         'mc/skip-to-previous-like-this))

;; ;; Move Text
;; (use-package move-text
;;   :ensure t
;;   :config
;;   (global-set-key (kbd "M-K") 'move-text-up)
;;   (global-set-key (kbd "M-J") 'move-text-down))

;; Compile
(global-set-key (kbd "M-C") 'compile)
(global-set-key (kbd "C-M-c") 'recompile)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("96aa24cb6fb4b38a754726ae70f631cff06cb12892e2878eb441f1a35023722f"
     default)))
