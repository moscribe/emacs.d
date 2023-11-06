;;; configs.el -- configurations for my Emacs
;;
;;; Commentary:
;;
;;; Code:
(defvar config/full-name "Liu Miao")
(defvar config/email-address "liumiaogemini@foxmail.com")

(defconst *sys/win32*
  (eq system-type 'windows-nt))

(defconst *sys/linux*
  (eq system-type 'gnu/linux))

(defconst *sys/mac*
  (eq system-type 'darwin))

(defvar configs/default-font '("Consolas"
                               :size 10
                               :weight normal
                               :width normal))

(defvar configs/unicode-font '("Noto Sans Mono CJK SC"))

(defvar configs/cache-directory
  (expand-file-name ".cache/" user-emacs-directory))

(defvar configs/userconfig-file
  (expand-file-name "userconfig" configs/cache-directory))

(defvar configs/custom-file
  (expand-file-name "custom.el" configs/cache-directory))

(defvar configs/recentf-save-file
  (expand-file-name "recentf" configs/cache-directory))

(defvar configs/save-place-file
  (expand-file-name "places" configs/cache-directory))

(defvar configs/backup-directory-alist
  (expand-file-name "backup/" configs/cache-directory))

(defvar configs/project-list-file
  (expand-file-name "projects" configs/cache-directory))

(defvar configs/auto-save-list-prefix
  (expand-file-name "auto-save-list/.saves-" configs/cache-directory))

(defvar configs/layouts-directory
  (expand-file-name "layouts/" configs/cache-directory))

(defvar configs/quelpa-dir
  (expand-file-name "quelpa/" configs/cache-directory))

(defvar configs/notes-dir "~/org/"
  "User defined notes directory.")

(defvar configs/org-roam-dir configs/notes-dir
  "User defined org roam directory.")

(defvar configs/org-roam-db-location
  (expand-file-name "org-roam.db" configs/cache-directory))

(defvar configs/notes-extensions '("org" "md" "markdown"))

(defvar configs/rime-data-dir
  (expand-file-name "rime/" configs/cache-directory))

(defvar configs/elpa-pack-dir
  (expand-file-name "elpa" user-emacs-directory )
  "Packages install by package-initilize.")

(defvar configs/elpa-subdirectory 'emacs-version)

(defvar default-package-mirror '(("melpa" . "https://melpa.org/packages/")
                                 ("gnu" . "https://elpa.gnu.org/packages/")))

(defvar emacs-china-package-mirror '(("gnu"   . "http://mirrors.ustc.edu.cn/elpa/gnu/")
                                     ("melpa" . "http://mirrors.ustc.edu.cn/elpa/melpa/")
                                     ("nongnu"   . "http://mirrors.ustc.edu.cn/elpa/nongnu/")))

(defvar emacs-tuna-package-mirror '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                                    ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                                    ("nongnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")))

(defvar configs/package-mirror default-package-mirror)

(defvar configs/org-journal-type 'daily)

(defvar configs/theme 'doom-one)

(defvar configs/profile-eln-caches-dir (expand-file-name "eln-caches" configs/cache-directory))

(defvar configs/env-file
  (expand-file-name "env" configs/cache-directory))

(defvar configs/transient-history-file
  (expand-file-name "transient/history.el" configs/cache-directory))

(provide 'configs)
;;; configs.el ends here
