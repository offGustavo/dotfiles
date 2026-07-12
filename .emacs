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
;; (add-to-list 'default-frame-alist '(undecorated . t))
;; (global-visual-line-mode 0)
(setq-default truncate-lines t)
(delete-selection-mode 1)

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
  ;; Function to get system color scheme from GNOME
  (defun my/get-system-color-scheme ()
    "Return 'dark or 'light based on GNOME's color-scheme setting."
    (let ((scheme (string-trim
                   (shell-command-to-string
                    "dconf read /org/gnome/desktop/interface/color-scheme"))))
      (cond
       ((string-match-p "dark" scheme) 'dark)
       ((string-match-p "light" scheme) 'light)
       (t 'dark)))) ; fallback to dark if unknown

  ;; Apply theme according to system preference
  (let ((system-scheme (my/get-system-color-scheme)))
    (pcase system-scheme
      ('dark (load-theme 'tokyonight-night :no-confirm))
      ('light (load-theme 'tokyonight-day :no-confirm)))))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("22d73dce2d6712154900097ac8f9146c51deea66a92a2406c8c3f341ee9eb30a"
     default))
 '(display-line-numbers 'visual)
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(## evil lua-mode magit meow meow-tree-sitter move-text
	multiple-cursors powershell tokyonight-themes))
 '(package-vc-selected-packages
   '((tokyonight-themes :url
			"https://github.com/xuchengpeng/tokyonight-themes"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Font
(set-frame-font "JetBrainsMonoNL NF-10")

;; Garante que as funções de clipboard do sistema funcionem
(setq select-enable-clipboard nil)

;; Interact with system clipboard
(global-set-key (kbd "C-S-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "C-S-v") 'clipboard-yank)

;; ;; Magit - Git interface
;; (use-package magit
;;   :ensure t
;;   :bind (("M-G" . magit-status))
;;   :config
;;   (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; (use-package evil
;;   :config
;;   (require 'evil))
;;   ;; (evil-mode))

;; (use-package exwm
;;   :config
;;   (require 'exwm)
;;   ;; Set the initial workspace number.
;;   (setq exwm-workspace-number 4)
;;   ;; Make class name the buffer name.
;;   (add-hook 'exwm-update-class-hook
;; 	    (lambda () (exwm-workspace-rename-buffer exwm-class-name)))
;;   ;; Global keybindings.
;;   (setq exwm-input-global-keys
;; 	`(([?\s-r] . exwm-reset) ;; s-r: Reset (to line-mode).
;;           ([?\s-w] . exwm-workspace-switch) ;; s-w: Switch workspace.
;;           ([?\s-&] . (lambda (cmd) ;; s-&: Launch application.
;;                        (interactive (list (read-shell-command "$ ")))
;;                        (start-process-shell-command cmd nil cmd)))
;;           ;; s-N: Switch to certain workspace.
;;           ,@(mapcar (lambda (i)
;;                       `(,(kbd (format "s-%d" i)) .
;; 			(lambda ()
;;                           (interactive)
;;                           (exwm-workspace-switch-create ,i))))
;;                     (number-sequence 0 9)))))
;; ;; NOTE: We active EXWM manually on the session file 
;; ;;   ;; Enable EXWM
;; ;;   (exwm-wm-mode))

;; NOTE: from rexim/tsoding
;; Multiple Cursors
(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-;") 'mc/edit-lines)
  (global-set-key (kbd "C-.")         'mc/mark-next-like-this)
  (global-set-key (kbd "C-,")         'mc/mark-previous-like-this)
  (global-set-key (kbd "C-x C-<")     'mc/mark-all-like-this)
  (global-set-key (kbd "M-n")        'mc/skip-to-next-like-this)
  (global-set-key (kbd "M-p")         'mc/skip-to-previous-like-this))

;; Move Text
(use-package move-text
  :ensure t
  :config
  (global-set-key (kbd "M-K") 'move-text-up)
  (global-set-key (kbd "M-J") 'move-text-down))

;; Compile
(global-set-key (kbd "M-C") 'compile)
(global-set-key (kbd "C-M-c") 'recompile)
