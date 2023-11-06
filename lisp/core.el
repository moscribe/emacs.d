;;; core.el -- my functions & macros

;;; Commentary:

;;; Code:
(defvar env/deny
  '(;; Unix/shell state that shouldn't be persisted
    "^HOME$" "^\\(OLD\\)?PWD$" "^SHLVL$" "^PS1$" "^R?PROMPT$" "^TERM\\(CAP\\)?$"
    "^USER$" "^INSIDE_EMACS$"
    ;; X server, Wayland, or services' env  that shouldn't be persisted
    "^DISPLAY$" "^WAYLAND_DISPLAY" "^DBUS_SESSION_BUS_ADDRESS$" "^XAUTHORITY$"
    ;; Windows+WSL envvars that shouldn't be persisted
    "^WSL_INTEROP$"
    ;; XDG variables that are best not persisted.
    "^XDG_CURRENT_DESKTOP$" "^XDG_RUNTIME_DIR$"
    "^XDG_\\(VTNR\\|SEAT\\|SESSION_\\(TYPE\\|CLASS\\)\\)"
    ;; Socket envvars, like I3SOCK, GREETD_SOCK, SEATD_SOCK, SWAYSOCK, etc.
    "SOCK$"
    ;; ssh and gpg variables that could quickly become stale if persisted.
    "^SSH_\\(AUTH_SOCK\\|AGENT_PID\\)$" "^\\(SSH\\|GPG\\)_TTY$"
    "^GPG_AGENT_INFO$"
    ;; Internal Doom envvars
    "^DEBUG$" "^INSECURE$" "^__"))

(defun open-init-file()
  "Find and open the init.el."
  (interactive)
  (find-file (concat user-emacs-directory "init.el")))

(defun load-init-file()
  "Load init.el."
  (interactive)
  (load-file (concat user-emacs-directory "init.el")))

(defun open-userconfig-file()
  "Open userconfig."
  (interactive)
  (find-file configs/userconfig-file))

(defun gc-minibuffer-setup ()
  (setq gc-cons-threshold (* better-gc-cons-threshold 2)))

(defun gc-minibuffer-exit ()
  (garbage-collect)
  (setq gc-cons-threshold better-gc-cons-threshold))

(defun core/garbage-collect-h ()
  (if (boundp 'after-focus-change-function)
      (add-function :after after-focus-change-function
                    (lambda ()
                      (unless (frame-focus-state)
                        (garbage-collect))))
    (add-hook 'after-focus-change-function 'garbage-collect))

  (add-hook 'minibuffer-setup-hook #'gc-minibuffer-setup)
  (add-hook 'minibuffer-exit-hook #'gc-minibuffer-exit))

(defun core/elpa-package-dir ()
  "Generate the elpa package directory."
  (file-name-as-directory
   (if (not configs/elpa-subdirectory)
       configs/elpa-pack-dir
     (let ((subdir (format "%d%s%d"
                           emacs-major-version
                           version-separator
                           emacs-minor-version)))
       (expand-file-name subdir configs/elpa-pack-dir)))))

(defvar core/profiler nil)
;;;autoload
(defun core/toggle-profiler ()
  "Toggle the Emacs profiler"
  (interactive)
  (if (not core/profiler)
      (profiler-start 'cpu+mem)
    (profiler-report)
    (profiler-stop))
  (setq core/profiler (not core/profiler)))

(defun core/create-if-not-found ()
  "Create file if not found"
  (unless (file-remote-p buffer-file-name)
    (let ((parent-dir (file-name-directory buffer-file-name)))
      (and (not (file-directory-p parent-dir))
           (y-or-n-p (format "Directory `%s' does not exist! Create it? "
                             parent-dir))
           (make-directory parent-dir)))))

(defmacro core/file-exists-p (files &optional directory)
  "Return non-nil if the FILES in DIRECTORY all exist."
  `(let ((p))))

(defun core/genreate-env-file ()
  "Generate enviroment file"
  (interactive)
  (let ((env-file configs/env-file))
    (with-temp-file env-file
      (setq-local coding-system-for-write 'utf-8-unix)
      (goto-char (point-min))
      (insert
       ";; -*- mode: lisp-interaction; coding: utf-8-unix; -*-\n"
       ";; ---------------------------------------------------------------------------\n"
       ";; This file was auto-generated by emacs. It contains a list of environment\n"
       ";; variables scraped from your default shell.\n"
       ";;\n"
       ";; DO NOT EDIT THIS FILE!\n"
       ";;\n")
      (insert "(")
      (dolist (env (get 'process-environment 'initial-value))
        (insert (prin1-to-string env) "\n "))
      (insert ")"))
    t))

(provide 'core)
;;; core-libs.el ends here
