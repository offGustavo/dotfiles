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
(setq doom-theme 'compline)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
 (setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

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
        (map! 
          ;; C-a/C-x increment/decrement numbers
          :n "C-a" #'evil-numbers/inc-at-pt
          :v "C-a" #'evil-numbers/inc-at-pt
          :v "C-x" #'evil-numbers/dec-at-pt
          :n "C-x" #'evil-numbers/dec-at-pt

          :v "C-j" #'drag-stuff-down
          :v "C-k" #'drag-stuff-up

          ;; Leader key: z → zoxide
          :leader "z" #'zoxide-travel

          ;; Save buffer
          :n "C-s" #'save-buffer)


;; Send files to trash instead of fully deleting
(setq delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files/")
;; Save automatically
(setq auto-save-default t)

;; Disable breadcrumb
(add-hook 'lsp-mode-hook (lambda () (lsp-headerline-breadcrumb-mode -1)))
