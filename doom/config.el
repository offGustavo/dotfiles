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
;; (setq doom-theme 'doom-one)
;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
  (setq doom-theme '(doom-tokyo-night   . doom-nord-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Notes/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
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

;;; Disable Evil Mode in MiniBuffer ---------------------------------------------------------------
;; NOTE: Disable Evil Mode in MiniBuffer
;; REF: https://github.com/doomemacs/core/issues/7780
;; evil-toggle-key (C-z) enables evil in the minibuffer.
;;
;; Alternatives:
;;   1. Always enable evil in the minibuffer
;;          (setopt evil-want-minibuffer t)
;;      This is annoying because we have to press ESC (or "fd") twice to abort:
;;      once to switch to normal state and once to quit the minibuffer.
;;   2. Like 1 but also default to emacs state in the minibuffer.
;;          (setopt evil-want-minibuffer t)
;;          (add-to-list 'evil-emacs-state-modes 'minibuffer-mode)
;;          ;; also in inactive mode for performance to avoid constant switching
;;          (add-to-list 'evil-emacs-state-modes 'minibuffer-inactive-mode)
;;      Then we only need to press ESC once to quit. But this is annoying due to
;;      issues with the cursor color:
;;         - The cursor will have a "warning" color in the minibuffer which is
;;           not elegant.
;;         - Actually, the color isn't even consistent due to a bug in evil, see
;;           my PR https://github.com/emacs-evil/evil/pull/2008.
;;         - When switching from the minibuffer to the main buffer, the cursor
;;           can sometimes stay in warning color for a short time, which is
;;           distracting.
(setopt evil-collection-setup-minibuffer t)
(after! evil
  ;; Ensure evil is initially off in the minibuffer
  (add-hook! 'minibuffer-setup-hook
             ;; PERF skip some lisp when this is already disabled. overkill?
             (when evil-local-mode
               (evil-local-mode -1)))
  ;; Sacrifice the current C-z binding (undo or helm-select-action).
  (undefine-key! :keymaps +default-minibuffer-maps evil-toggle-key)
  ;; evil-normal-state will enable evil in the buffer automatically
  (define-key! :keymaps +default-minibuffer-maps evil-toggle-key #'evil-normal-state)
  ;; TODO Should 'evil-ex-completion-map be added to +default-minibuffer-maps if
  ;;      evil is enabled? See also the C-s binding in config/default module.
  (define-key! :keymaps 'evil-ex-completion-map evil-toggle-key #'evil-normal-state))

;; NOTE: Remove Vertico C-k and C-j in Vertico
(after! vertico
  (map! :map vertico-map "C-k" nil)
  (map! :map vertico-map "C-j" nil))

;; NOTE: Remove Vertico C-K And C-J In Compile Mode
(after! compile
  (map! :map compilation-mode-map
        :n "C-k" nil
        :n "C-k" nil))

;;; System clipboard (explicit) ---------------------------------------------------------------
(setq select-enable-clipboard nil)
(global-set-key (kbd "C-S-c") #'clipboard-kill-ring-save)
(global-set-key (kbd "C-S-x") #'clipboard-kill-region)
(global-set-key (kbd "C-S-v") #'clipboard-yank)

;;; Compile ---------------------------------------------------------------
(global-set-key (kbd "M-C")   #'compile)
(global-set-key (kbd "M-RET") #'recompile)

;;; Zoxide ---------------------------------------------------------------
(map!
 :leader
 :n
 :desc "Zoxide"
 "z z"
 #'zoxide-travel)

;;; FZF ---------------------------------------------------------------
(map!
 :n
 :desc "FZF Files"
 "M-o"
 #'fzf)

(map!
 :n
 :desc "FZF Live Grep"
 "M-s"
 #'fzf-grep)

(map!
 :n
 :desc "FZF Buffers"
 "M-b"
 #'fzf-switch-buffer)

;;; EXWM ---------------------------------------------------------------

;; ;; Only act as the window manager when the session asks for it (EXWM=1),
;; ;; so Emacs still starts normally inside any other X/Wayland session.
;; (defvar +exwm-active-p (and (eq window-system 'x) (getenv "EXWM"))
;;   "Non-nil when this Emacs should run as the X window manager.")

;; (when +exwm-active-p
(require 'exwm)

(setq exwm-workspace-number 4
      exwm-layout-show-all-buffers t)

;; Readable buffer names: "Class: title"
(defun +exwm-rename-buffer-h ()
  (exwm-workspace-rename-buffer
   (format "%s: %s" exwm-class-name
           (truncate-string-to-width (or exwm-title "") 40 nil nil "…"))))
(add-hook 'exwm-update-class-hook #'+exwm-rename-buffer-h)
(add-hook 'exwm-update-title-hook #'+exwm-rename-buffer-h)

;; Evil keys in any X application
(use-package! exwm-evil
  :hook (exwm-manage-finish . exwm-evil-mode))

;; Vim keys + link hints in Firefox/Chrome (needs the Link Hints extension)
(use-package! exwm-firefox-evil
  :hook (exwm-manage-finish . exwm-firefox-evil-mode))

;; ;; Focus follows mouse
;; (use-package! exwm-mff
;;   :config (exwm-mff-mode 1))


;; ;; Edit any input field in Emacs with C-c '
;; (use-package! exwm-edit
;;   :config
;;   (defvar +exwm-edit-default-major-mode 'org-mode
;;     "Major mode used when no language can be detected.")
;;   (defvar +exwm-edit-language-modes
;;     '((python . python-mode) (javascript . js-mode) (c . c-mode)
;;       (bash . sh-mode) (emacslisp . emacs-lisp-mode) (html . html-mode)
;;       (css . css-mode) (java . java-mode))
;;     "Map `language-detection' results to major modes.")
;;   (defun +exwm-edit-pick-mode-h ()
;;     (let* ((lang (ignore-errors (language-detection-buffer)))
;;            (mode (or (alist-get lang +exwm-edit-language-modes)
;;                      +exwm-edit-default-major-mode)))
;;       (funcall mode)))
;;   (add-hook 'exwm-edit-compose-hook #'+exwm-edit-pick-mode-h))
;; (map! "C-c '" #'exwm-edit--compose)

;; ;; App launcher and a nested vanilla Emacs
;; (use-package! app-launcher :commands app-launcher-run-app)
;; (defun +exwm/nested-vanilla-emacs ()
;;   (interactive)
;;   (start-process "nested-emacs" nil "emacs" "-Q"))
;; (map! :leader
;;       :desc "Launch application"     "$"   #'app-launcher-run-app
;;       :desc "Nested vanilla Emacs"   "o N" #'+exwm/nested-vanilla-emacs)


(defun +exwm/rofi ()
  "Launch rofi's application launcher."
  (interactive)
  (start-process "rofi" nil "rofi" "-show" "drun"))

;; i3-style global keys (vim-style hjkl; change to taste)
(windmove-mode +1)
(map! "s-j" #'windmove-left
      "s-k" #'windmove-down
      "s-i" #'windmove-up
      "s-l" #'windmove-right
      "s-J" #'windmove-swap-states-left
      "s-K" #'windmove-swap-states-down
      "s-I" #'windmove-swap-states-up
      "s-L" #'windmove-swap-states-right
      "s-h" #'split-window-right
      "s-v" #'split-window-below
      "s-q" #'delete-window
      "s-d" #'+exwm/rofi)

(when (modulep! :ui workspaces)
  (map! "s-1" #'+workspace/switch-to-0
        "s-2" #'+workspace/switch-to-1
        "s-3" #'+workspace/switch-to-2
        "s-4" #'+workspace/switch-to-3
        "s-5" #'+workspace/switch-to-4
        "s-6" #'+workspace/switch-to-5
        "s-7" #'+workspace/switch-to-6
        "s-8" #'+workspace/switch-to-7
        "s-9" #'+workspace/switch-to-8
        "s-0" #'+workspace/switch-to-final))

(when (modulep! :ui workspaces)
  (add-hook 'exwm-manage-finish-hook
            (defun +exwm-add-to-workspace-h ()
              (persp-add-buffer (current-buffer)))))

;; Let EXWM windows pass these keys to Emacs instead of the application
(dolist (key '(?\s-h ?\s-j ?\s-k ?\s-l ?\s-H ?\s-J ?\s-K ?\s-L
               ?\s-v ?\s-s ?\s-Q ?\s-d
               ?\s-0 ?\s-1 ?\s-2 ?\s-3 ?\s-4 ?\s-5 ?\s-6 ?\s-7 ?\s-8 ?\s-9))
  (cl-pushnew key exwm-input-prefix-keys))

;; ;; Start EXWM (`exwm-wm-mode' on exwm >= 0.30, `exwm-enable' before)
;; (if (fboundp 'exwm-wm-mode) (exwm-wm-mode 1) (exwm-enable))
