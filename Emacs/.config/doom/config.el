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

(setq doom-font (font-spec :family "JetBrainsMonoNL NF" :size 16 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "JetBrainsMonoNL NF" :size 16)
      doom-symbol-font (font-spec :family "JetBrainsMonoNL NF")
      doom-big-font (font-spec :family "JetBrainsMonoNL NF" :size 24))

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

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Notes")


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
;; Here are some additional functions/macros that will help youj configure Doom.
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


(put 'scroll-left 'disabled nil)

;; C-a/C-x vim
(define-key evil-normal-state-map (kbd "C-a") 'evil-numbers/inc-at-pt)
(define-key evil-visual-state-map (kbd "C-a") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-x") 'evil-numbers/dec-at-pt)
(define-key evil-visual-state-map (kbd "C-x") 'evil-numbers/dec-at-pt)

;; Move selected lines up and down
(define-key evil-visual-state-map (kbd "K") 'drag-stuff-up)
(define-key evil-visual-state-map (kbd "J") 'drag-stuff-down)

;; C-c
;; In Insert Mode
(define-key evil-insert-state-map (kbd "C-c") 'evil-normal-state)
;; In Visual Mode
(define-key evil-visual-state-map (kbd "C-c") 'evil-normal-state)

;; Save Buffer
(define-key evil-normal-state-map (kbd "C-s") 'save-buffer)

;; (define-key evil-normal-state-map (kbd "gz") 'zoxide-travel)
(map! :leader "z" 'zoxide-travel)

;; ;; You can use this hydra menu that have all the commands
;; (map! :leader "o h h" 'harpoon-quick-menu-hydra)
;; (map! :leader "o h t" 'harpoon-toggle-quick-menu)
;; (map! :leader "h a" 'harpoon-add-file)

;; ;; And the vanilla commands
;; (map! :leader "o h c" 'harpoon-clear)
;; (map! :leader "h e" 'harpoon-toggle-file)

;; (map! :leader "1" 'harpoon-go-to-1)
;; (map! :leader "2" 'harpoon-go-to-2)
;; (map! :leader "3" 'harpoon-go-to-3)
;; (map! :leader "4" 'harpoon-go-to-4)
;; (map! :leader "5" 'harpoon-go-to-5)
;; (map! :leader "6" 'harpoon-go-to-6)
;; (map! :leader "7" 'harpoon-go-to-7)
;; (map! :leader "8" 'harpoon-go-to-8)
;; (map! :leader "9" 'harpoon-go-to-9)


(custom-set-faces!
 '(markdown-header-delimiter-face :foreground "#565f89" :height 0.9) ;; darker gray
 '(markdown-header-face-1 :height 1.8 :foreground "#7aa2f7" :weight extra-bold :inherit markdown-header-face) ;; blue
 '(markdown-header-face-2 :height 1.4 :foreground "#9ece6a" :weight extra-bold :inherit markdown-header-face) ;; green
 '(markdown-header-face-3 :height 1.2 :foreground "#e0af68" :weight extra-bold :inherit markdown-header-face) ;; yellow
 '(markdown-header-face-4 :height 1.15 :foreground "#ff9e64" :weight bold :inherit markdown-header-face) ;; orange
 '(markdown-header-face-5 :height 1.1 :foreground "#bb9af7" :weight bold :inherit markdown-header-face) ;; purple
 '(markdown-header-face-6 :height 1.05 :foreground "#7dcfff" :weight semi-bold :inherit markdown-header-face)) ;; cyan

;; (custom-set-faces!
;; '(markdown-header-delimiter-face :foreground "#616161" :height 0.9)
;; '(markdown-header-face-1 :height 1.8 :foreground "#A3BE8C" :weight extra-bold :inherit markdown-header-face)
;; '(markdown-header-face-2 :height 1.4 :foreground "#EBCB8B" :weight extra-bold :inherit markdown-header-face)
;; '(markdown-header-face-3 :height 1.2 :foreground "#D08770" :weight extra-bold :inherit markdown-header-face)
;; '(markdown-header-face-4 :height 1.15 :foreground "#BF616A" :weight bold :inherit markdown-header-face)
;; '(markdown-header-face-5 :height 1.1 :foreground "#b48ead" :weight bold :inherit markdown-header-face)
;; '(markdown-header-face-6 :height 1.05 :foreground "#5e81ac" :weight semi-bold :inherit markdown-header-face))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(warning-suppress-types
   '((use-package) (use-package) (defvaralias) (lexical-binding))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; ;; Surround
;; (use-package evil-surround
;;   :ensure t
;;   :config
;;   (global-evil-surround-mode 1))


;; (use-package! multi-vterm
;;   :config
;;   ;; Bind a key to create new vterm buffers easily
;;   ;; (define-key evil-normal-state-map (kbd "M-/") 'multi-vterm)
;;   ;; (define-key vterm-mode-map (kbd "C-c C-t") 'multi-vterm)
;;   )

;; ;; Mult Vterm
;; ;; (map! :nvi "M-p P" #'multi-v
;; (map! :nvi "M-m c" #'multi-vterm-dedicated-open)
;; (map! :nvi "M-n" #'multi-vterm)
;; (map! :nvi "M-m x" #'multi-vterm-dedicated-close)
;; (map! :nvi "M-m p" #'multi-vterm-prev)
;; (map! :nvi "M-m n" #'multi-vterm-next)
;; (map! :nvi "M-m ," #'multi-vterm-rename-buffer)
;; (map! :nvi "M-m s" #'multi-vterm-dedicated-select)
;; (map! :nvi "M-m d" #'multi-vterm-dedicated-toggle)
;; (map! :nvi "M-/" #'multi-vterm-dedicated-toggle)

;; [My Literate Doom Emacs Configuration ·](https://joshblais.com/posts/my-literate-doom-emacs-config/)
;; remove top frame bar in emacs
;; (add-to-list 'default-frame-alist '(undecorated . t))

;; Blink cursor
;; (blink-cursor-mode 1)

;; Send files to trash instead of fully deleting
(setq delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files/")
;; Save automatically
(setq auto-save-default t)

;; Disable breadcrumb
(add-hook 'lsp-mode-hook (lambda () (lsp-headerline-breadcrumb-mode -1)))
