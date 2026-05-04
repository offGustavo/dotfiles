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
(global-visual-line-mode 1)
(setq make-backup-files nil)
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
 '(package-selected-packages '(exwm exwm-firefox-evil move-text multiple-cursors))
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

;; Atalhos com CTRL + SHIFT
(global-set-key (kbd "C-S-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "C-S-v") 'clipboard-yank)

;; Magit - Git interface
(use-package magit
  :bind (("M-G" . magit-status))
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

 (use-package evil
   :config
   (require 'evil))
   ;; (evil-mode))

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

;;; multiple cursors
(use-package multiple-cursors
  :config
  (global-set-key (kbd "C-;") 'mc/edit-lines)
  (global-set-key (kbd "C-.")         'mc/mark-next-like-this)
  (global-set-key (kbd "C-,")         'mc/mark-previous-like-this)
  (global-set-key (kbd "C-x C-<")     'mc/mark-all-like-this)
  (global-set-key (kbd "C-<")        'mc/skip-to-next-like-this)
  (global-set-key (kbd "C->")         'mc/skip-to-previous-like-this))

;;; Move Text
(use-package move-text
  :config
  (global-set-key (kbd "M-p") 'move-text-up)
  (global-set-key (kbd "M-n") 'move-text-down))
;; Compile

(global-set-key (kbd "M-C") 'compile)
(global-set-key (kbd "C-M-c") 'recompile)

(defun mark-whole-line ()
  "Select current line. If repeated, expand selection to next line.
Like Ctrl+L in VS Code."
  (interactive)
  (if (and (eq last-command 'mark-line-expand)
           (region-active-p))
      ;; Expand region downward by one line
      (let ((end (region-end)))
        (goto-char end)
        (when (not (eobp))
          (forward-line 1)
          (if (> (point) (point-max))
              (goto-char (point-max))))
        ;; Keep region active
        (activate-mark))
    ;; First press: select current line (including newline)
    (deactivate-mark)
    (beginning-of-line)
    (set-mark-command nil)               ; set mark at bol
    (if (eobp)
        (goto-char (point-max))          ; last line, no newline
      (forward-line 1))                  ; go to start of next line
    (activate-mark))
  (setq this-command 'mark-line-expand))

(global-set-key (kbd "M-L") 'mark-whole-line)

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))

;; (require 'meow)
;; (meow-setup)
;; (meow-global-mode 1)
