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
(setq doom-theme 'doom-tokyo-night)
;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


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
