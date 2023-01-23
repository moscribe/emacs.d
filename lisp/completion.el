;;; completion.el --- Completion configs -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2020 Liu Miao
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;; vertico + orderless + consult
;;; corfu for completion
;;
;;; Code:
(defvar completion/search-map (make-sparse-keymap)
  (let ((map (make-sparse-keymap)))
    (keybinds/define-key map
                         "i" 'imenu
                         "s" 'consult-line)
    map)
  "Searching in Emacs")

(defvar ripgrep-p
  (executable-find "rg"))

(defvar grep-p
  (executable-find "grep"))

(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package vertico
  :ensure t
  :bind (:map vertico-map
              ("DEL" . vertico-directory-delete-char))
  :init
  (vertico-mode)
  (setq vertico-resize nil
        vertico-cycle t)
  :config
  (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)
  (add-hook 'minibuffer-setup-hook #'vertico-repeat-save))

(use-package consult
  :ensure t
  :defer t
  :after (vertico)
  :bind (([remap apropos]                       . consult-apropos)
         ([remap bookmark-jump]                 . consult-bookmark)
         ([remap evil-show-marks]               . consult-mark)
         ([remap evil-show-registers]           . consult-register)
         ;;([remap evil-show-jumps]             . consult-xref)
         ([remap goto-line]                     . consult-goto-line)
         ([remap imenu]                         . consult-imenu)
         ([remap locate]                        . consult-locate)
         ([remap load-theme]                    . consult-theme)
         ([remap man]                           . consult-man)
         ([remap recentf-open-files]            . consult-recent-file)
         ([remap switch-to-buffer]              . consult-buffer)
         ([remap switch-to-buffer-other-window] . consult-buffer-other-window)
         ([remap switch-to-buffer-other-frame]  . consult-buffer-other-frame)
         ([remap projectile-switch-to-buffer]   . consult-project-buffer)
         ([remap yank-pop]                      . consult-yank-pop))
  :preface
  (advice-add #'multi-occur :override #'consult-multi-occur)
  :config
  (setq consult-line-numbers-widen t
        consult-async-min-input 2
        consult-async-refresh-delay 0.15
        consult-async-input-throttle 0.2
        consult-async-input-debounce 0.1)
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file
   consult--source-recent-file consult--source-project-recent-file))

(use-package consult-xref
  :defer t
  :after xref
  :init
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

(defun completion/search--dir (&optional dir initial)
  "Search directory.

DIR for the search directory.
INITIAL for the initial input."
  (require 'consult)
  (let ()
    (cond (ripgrep-p
           (consult-ripgrep dir initial))
          (grep-p
           (consult-grep dir initial))
          (t (user-error "Couldn't find ripgrep or grep in PATH")))))

(defun completion/search-project ()
  "Search current project."
  (interactive)
  (completion/search--dir nil nil))
(define-key completion/search-map (kbd "p") #'completion/search-project)

(defun completion/search-project-at ()
  "Search current project at point."
  (interactive)
  (completion/search--dir nil (thing-at-point 'symbol)))
(define-key completion/search-map (kbd "P") #'completion/search-project-at)

(defun completion/search-current-dir ()
  "Search current directory."
  (interactive)
  (completion/search--dir default-directory nil))
(define-key completion/search-map (kbd "d") #'completion/search-current-dir)

(defun completion/search-current-dir-at ()
  "Search current directory at point."
  (interactive)
  (completion/search--dir default-directory (thing-at-point 'symbol)))
(define-key completion/search-map (kbd "D") #'completion/search-current-dir-at)

(use-package corfu
  :ensure t
  ;; Optional customizations
  :custom
    (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
    (corfu-auto t)                 ;; Enable auto completion
    (corfu-separator ?\s)          ;; Orderless field separator
    ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
    ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
    ;; (corfu-preview-current nil)    ;; Disable current candidate preview
    ;; (corfu-preselect-first nil)    ;; Disable candidate preselection
    ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
    (corfu-echo-documentation nil) ;; Disable documentation in the echo area
    (corfu-scroll-margin 5)        ;; Use scroll margin

    ;; Enable Corfu only for certain modes.
    ;; :hook ((prog-mode . corfu-mode)
    ;;        (shell-mode . corfu-mode)
    ;;        (eshell-mode . corfu-mode))

    ;; Recommended: Enable Corfu globally.
    ;; This is recommended since Dabbrev can be used globally (M-/).
    ;; See also `corfu-excluded-modes'.
    :init
    (global-corfu-mode))

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode)
  :init
  (marginalia-mode))

(provide 'completion)
;;; completion.el ends here
