;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

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
;; (setq doom-theme 'compline)
(setq doom-theme 'doom-tokyo-night)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
 (setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Notes/Org/")

;; (custom-set-faces!
;;  '(markdown-header-delimiter-face :foreground "#565f89" :height 0.9) ;; darker gray
;;  '(markdown-header-face-1 :height 1.8 :foreground "#7aa2f7" :weight extra-bold :inherit markdown-header-face) ;; blue
;;  '(markdown-header-face-2 :height 1.4 :foreground "#9ece6a" :weight extra-bold :inherit markdown-header-face) ;; green
;;  '(markdown-header-face-3 :height 1.2 :foreground "#e0af68" :weight extra-bold :inherit markdown-header-face) ;; yellow
;;  '(markdown-header-face-4 :height 1.15 :foreground "#ff9e64" :weight bold :inherit markdown-header-face) ;; orange
;;  '(markdown-header-face-5 :height 1.1 :foreground "#bb9af7" :weight bold :inherit markdown-header-face) ;; purple
;;  '(markdown-header-face-6 :height 1.05 :foreground "#7dcfff" :weight semi-bold :inherit markdown-header-face)) ;; cyan


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
; (after! evil
  ;; (setq! evil-disable-insert-state-bindings t)

(setq doom-localleader-key "<backspace>")
  (map!
   ;;Windows
   :nv "C-w O" #'doom/window-enlargen
   :nv "C-w o" #'doom/window-maximize-buffer)

(map!
   :leader
   "w O" #'doom/window-enlargen
   "w o" #'doom/window-maximize-buffer)

(map!
   ;; Number increment/decrement
   :n "C-a" #'evil-numbers/inc-at-pt
   :v "C-a" #'evil-numbers/inc-at-pt
   :n "C-x" #'evil-numbers/dec-at-pt
   :v "C-x" #'evil-numbers/dec-at-pt)

(map!
   ;; Drag stuff
   :v "C-h" #'drag-stuff-left
   :v "C-j" #'drag-stuff-down
   :v "C-k" #'drag-stuff-up
   :v "C-l" #'drag-stuff-right)

(map!
   ;; Leader keys
   :leader
   "z" #'zoxide-travel)

(map!
   ;; Save buffer
   :n "C-s" #'save-buffer)
  ; )

;; (keymap! 
;;  :n
;;  ;; Edit lines (like mc/edit-lines)
;;  "C-S-c C-S-c" #'evil-mc-make-all-cursors

;;  ;; Mark next / previous occurrence
;;  "C->"         #'evil-mc-make-and-goto-next-match
;;  "C-<"         #'evil-mc-make-and-goto-prev-match
;;  "C-M-,"         #'evil-mc-make-and-goto-next-match
;;  "C-M-."         #'evil-mc-make-and-goto-prev-match

;;  ;; Mark all occurrences
;;  "C-S-d"     #'evil-mc-make-all-cursors
;;  "C-M-d"     #'evil-mc-make-all-cursors

;;  ;; Skip next / previous occurrence
;;  "C-?"        #'evil-mc-skip-and-goto-next-match
;;  "C-M-/"        #'evil-mc-skip-and-goto-next-match
;;  "C-:"         #'evil-mc-skip-and-goto-prev-match
;;  "C-M-;"         #'evil-mc-skip-and-goto-prev-match)

;; Send files to trash instead of fully deleting

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; ... your existing font, theme, and other settings ...

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

        ;; ([?\s-D] . (lambda (cmd) ;; s-&: Launch application.
        ;;              (interactive (list (read-shell-command "$ ")))
        ;;              (start-process-shell-command cmd nil cmd)))
        ;; (exwm-input-set-key (kbd "s-r") (lambda () (start-process "rofi" nil "rofi" "-show" "run")))
        ;; ([?\s-D]
        ;;  . (lambda ()
        ;;      ;; s-d: Launch application via rofi
        ;;      (interactive)
        ;;      (let ((cmd (string-trim
        ;;                  (shell-command-to-string
        ;;                   "rofi -show drun -run-shell-command '{cmd}'"))))
        ;;        (when (and cmd (not (string-empty-p cmd)))
        ;;          (start-process-shell-command cmd nil cmd)))))
        ;; s-N: Switch to certain workspace.
        ,@(mapcar (lambda (i)
                    `(,(kbd (format "s-%d" i)) .
                      (lambda ()
                        (interactive)
                        (exwm-workspace-switch-create ,i))))
                  (number-sequence 0 9))))

(defun exwm-change-screen-hook ()
  (let ((xrandr-output-regexp "\n\\([^ ]+\\) connected ")
        default-output)
    (with-temp-buffer
      (call-process "xrandr" nil t nil)
      (goto-char (point-min))
      (re-search-forward xrandr-output-regexp nil 'noerror)
      (setq default-output (match-string 1))
      (forward-line)
      (if (not (re-search-forward xrandr-output-regexp nil 'noerror))
          (call-process "xrandr" nil nil nil "--output" default-output "--auto")
        (call-process
         "xrandr" nil nil nil
         "--output" (match-string 1) "--primary" "--auto"
         "--output" default-output "--off")
        (setq exwm-randr-workspace-monitor-plist (list 0 (match-string 1)))))))

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

;; ;; This is the correct way to set EXWM-specific keys
;; (exwm-input-set-key (kbd "s-<escape>") #'my/exwm-super-esc)

;; Escape inside EXWM insert mode: send ESC to app
;; (evil-define-key 'insert exwm-evil-mode-map
;;   (kbd "<escape>")
;;   (lambda () (interactive)
;;     (exwm-input--fake-key 'escape)))

(evil-define-key 'normal exwm-evil-mode-map
  (kbd "<escape>")
  (lambda () (interactive)
    (exwm-input--fake-key 'escape)
    (exwm-evil-insert)))

(use-package! exwm-randr
  :after exwm
  :config
  (setq exwm-randr-workspace-monitor-plist
        '(0 "eDP-1"
          1 "HDMI-1-0"))

  (add-hook 'exwm-randr-screen-change-hook
            (lambda ()
              (start-process-shell-command
               "xrandr" nil
               "xrandr --output eDP-1 --mode 1920x1080 \
                       --output HDMI-1-0 --mode 1920x1080 --right-of eDP-1")))

  (exwm-randr-enable))
