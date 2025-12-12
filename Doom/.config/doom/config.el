;l;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
(setq doom-font (font-spec :family "JetBrainsMonoNL NF" :size 16 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "JetBrainsMonoNL NF" :size 16)
      doom-symbol-font (font-spec :family "JetBrainsMonoNL NF")
      doom-big-font (font-spec :family "JetBrainsMonoNL NF" :size 24))
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'compline)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
 (setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/Notes/Org/")

(custom-set-faces!
 '(markdown-header-delimiter-face :foreground "#565f89" :height 0.9) ;; darker gray
 '(markdown-header-face-1 :height 1.8 :foreground "#7aa2f7" :weight extra-bold :inherit markdown-header-face) ;; blue
 '(markdown-header-face-2 :height 1.4 :foreground "#9ece6a" :weight extra-bold :inherit markdown-header-face) ;; green
 '(markdown-header-face-3 :height 1.2 :foreground "#e0af68" :weight extra-bold :inherit markdown-header-face) ;; yellow
 '(markdown-header-face-4 :height 1.15 :foreground "#ff9e64" :weight bold :inherit markdown-header-face) ;; orange
 '(markdown-header-face-5 :height 1.1 :foreground "#bb9af7" :weight bold :inherit markdown-header-face) ;; purple
 '(markdown-header-face-6 :height 1.05 :foreground "#7dcfff" :weight semi-bold :inherit markdown-header-face)) ;; cyan


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(after! evil
(setq! evil-disable-insert-state-bindings t)
;;Windows
(map!
 :nv "C-w O" #'doom/window-enlargen
 :nv "C-w o" #'doom/window-maximize-buffer
 :leader
 "w O" #'doom/window-enlargen
 "w o" #'doom/window-maximize-buffer)

;; Number increment/decrement
  (map!
   :n "C-a" #'evil-numbers/inc-at-pt
   :v "C-a" #'evil-numbers/inc-at-pt
   :n "C-x" #'evil-numbers/dec-at-pt
   :v "C-x" #'evil-numbers/dec-at-pt)

;; Drag stuff
  (map!
   :v "C-h" #'drag-stuff-left
   :v "C-j" #'drag-stuff-down
   :v "C-k" #'drag-stuff-up
   :v "C-l" #'drag-stuff-right)

;; Leader keys
(map!
 :leader
 "z" #'zoxide-travel)

;; Save buffer
(map!
 :n "C-s" #'save-buffer))


;; Send files to trash instead of fully deleting
(setq delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files/")
;; Save automatically
(setq auto-save-default t)

;; Disable breadcrumb
(add-hook 'lsp-mode-hook (lambda () (lsp-headerline-breadcrumb-mode -1)))

(require 'exwm)
;; Set the initial workspace number.
(setq exwm-workspace-number 4)
;; Make class name the buffer name.
(add-hook 'exwm-update-class-hook
  (lambda () (exwm-workspace-rename-buffer exwm-class-name)))
;; Global keybindings.
(setq exwm-input-global-keys
      `(([?\s-r] . exwm-reset) ;; s-r: Reset (to line-mode).
        ([?\s-w] . exwm-workspace-switch) ;; s-w: Switch workspace.
        ([?\s-&] . (lambda (cmd) ;; s-&: Launch application.
                     (interactive (list (read-shell-command "$ ")))
                     (start-process-shell-command cmd nil cmd)))
        ([?\s-d] . (lambda (cmd) ;; s-&: Launch application.
                     (interactive (list (read-shell-command "$ ")))
                     (start-process-shell-command cmd nil cmd)))
        ([?\s-/] . (lambda (cmd) ;; s-&: Launch application.
                     (interactive 
                     (start-process-shell-command "rofi-drun" nil "rofi -show drun"))))
        ;; s-N: Switch to certain workspace.
        ,@(mapcar (lambda (i)
                    `(,(kbd (format "s-%d" i)) .
                      (lambda ()
                        (interactive)
                        (exwm-workspace-switch-create ,i))))
                  (number-sequence 0 9))))

;; ;; Enable EXWM
;; (exwm-wm-mode)

(use-package! exwm-evil
  :after exwm
  :config
  (add-hook 'exwm-manage-finish-hook #'enable-exwm-evil-mode)
  (cl-pushnew 'escape exwm-input-prefix-keys)

  ;; If you want to force enable exwm-evil-mode in any buffer, use:
  ;; (exwm-evil-enable-unconditionally)

  ;; We will disable `C-c' in insert state.
  (define-key exwm-mode-map (kbd "C-c") nil)

  (map! :map exwm-mode-map
        :localleader
        (:prefix ("d" . "debug")
         :desc "Clear debug buffer" "l" #'xcb-debug:clear
         :desc "Insert mark into the debug buffer" "m" #'xcb-debug:mark
         :desc "Enable debug logging" "t" #'exwm-debug)
        :desc "Toggle fullscreen" "f" #'exwm-layout-toggle-fullscreen
        :desc "Hide floating window" "h" #'exwm-floating-hide
        :desc "Send next key" "q" #'exwm-input-send-next-key
        :desc "Toggle floating" "SPC" #'exwm-floating-toggle-floating
        :desc "Send escape" "e" (cmd! (exwm-evil-send-key 1 'escape))
        :desc "Toggle modeline" "m" #'exwm-layout-toggle-mode-line))

;; Super+Escape → return to evil-normal-state in EXWM
(defun my/exwm-super-esc ()
  (interactive)
  (exwm-evil-normal-state))

(exwm-input-set-key (kbd "s-<escape>") #'my/exwm-super-esc)

;; Escape inside EXWM insert mode: send ESC to app
(evil-define-key 'insert exwm-evil-mode-map
  (kbd "<escape>")
  (lambda () (interactive)
    (exwm-input--fake-key 'escape)))

;; ;; i3-like keybindings for EXWM
;; (windmove-mode +1)
;; (when (featurep! :private exwm)
;;   (map! "s-j" #'windmove-left
;;         "s-k" #'windmove-down
;;         "s-l" #'windmove-up
;;         "s-;" #'windmove-right
;;         "s-J" #'windmove-swap-states-left
;;         "s-K" #'windmove-swap-states-down
;;         "s-L" #'windmove-swap-states-up
;;         "s-Q" #'delete-window
;;         "s-:" #'windmove-swap-states-right
;;         "s-v" #'split-window-right
;;         "s-h" #'split-window-below
;;         (:when (featurep! :ui workspaces)
;;          "s-1" #'+workspace/switch-to-0
;;          "s-2" #'+workspace/switch-to-1
;;          "s-3" #'+workspace/switch-to-2
;;          "s-4" #'+workspace/switch-to-3
;;          "s-5" #'+workspace/switch-to-4
;;          "s-6" #'+workspace/switch-to-5
;;          "s-7" #'+workspace/switch-to-6
;;          "s-8" #'+workspace/switch-to-7
;;          "s-9" #'+workspace/switch-to-8
;;          "s-0" #'+workspace/switch-to-final
;;          (:when (featurep! :term vterm)
;;           "s-<return>" (defun +run-or-raise-vterm ()
;;                          (interactive)
;;                          (+workspace-switch "Vterm" t)
;;                          (let ((display-buffer-alist))
;;                            (vterm most-positive-fixnum)))))
;;         "s-d" #'app-launcher-run-app
;;         "s-'" #'exwm-edit--compose)
;;   (after! exwm
;;     (dolist (key '(?\s-h ?\s-j ?\s-k ?\s-l ?\s-H ?\s-J ?\s-K ?\s-L ?\s-0 ?\s-1
;;                          ?\s-2 ?\s-3 ?\s-4 ?\s-5 ?\s-6 ?\s-7 ?\s-8 ?\s-9 ?\s-d
;;                          ?\s-\; ?\s-v ?\s-' ?\C-\[ ?\s-Q))
;;       (cl-pushnew key exwm-input-prefix-keys))))
