;;; 一些个人常用的Emacs配置
;;; 参考https://huadeyu.tech/tools/emacs-setup-notes.html#orgf474189
;;; Code:

(require 'package)
(setq package-enable-at-startup nil)
;; 使用清华镜像
(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize)
;; 配置use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)
;; 编码相关
(prefer-coding-system 'utf-8)
(setenv "LANG" "en_US.UTF-8")
(setenv "LC_ALL" "en_US.UTF-8")
(setenv "LC_CTYPE" "en_US.UTF-8")
;; 界面布局
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

;;
(display-time-mode 1)
(column-number-mode 1)
(global-hl-line-mode t)
(show-paren-mode nil)
(display-battery-mode 1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(global-auto-revert-mode t)
(global-hl-line-mode 1)

(fset 'yes-or-no-p 'y-or-n-p)
(toggle-frame-fullscreen)

;;
(setq tab-width 4
      inhibit-splash-screen t
      initial-scratch-message nil
      sentence-end-double-space nil
      make-backup-files nil
      indent-tabs-mode nil
      make-backup-files nil
      auto-save-default nil)
;; 近期文件
(savehist-mode 1)
(setq savehist-file "~/.emacs.d/.savehist")
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))
;; mac 配置
(cond ((string-equal system-type "darwin")
       (progn
         ;; modify option and command key
         (setq mac-command-modifier 'control)
         (setq mac-option-modifier 'meta)

         ;; batter copy and paste support for mac os x
         (defun copy-from-osx ()
           (shell-command-to-string "pbpaste"))
         (defun paste-to-osx (text &optional push)
           (let ((process-connection-type nil))
             (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
               (process-send-string proc text)
               (process-send-eof proc))))
         (setq interprogram-cut-function 'paste-to-osx)
         (setq interprogram-paste-function 'copy-from-osx))))
;; fonts
(set-face-attribute 'default nil
                    :family "Source Code Pro for Powerline"
                    :height 140
                    :weight 'medium
                    :width 'medium)

(if (display-graphic-p)
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
                        charset (font-spec :family "Microsoft Yahei"
                                           :size 14))))
;; 加载其他用户配置
(setq custom-file "~/.emacs.d/.custom.el")
(load custom-file t)
;; 主题配置
(use-package 'solarized-theme)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/pkg/themes"))
(require 'color-theme-solarized)
(color-theme-solarized)

;;
(use-package doom-modeline
             :ensure t
             :hook (after-init . doom-modeline-mode))
;; auto-complete
(use-package auto-compile
             :init (setq load-prefer-newer t)
             :config
             (progn
               (auto-compile-on-load-mode)
               (auto-compile-on-save-mode)))
;; undo tree
(use-package undo-tree
             :config
             (progn
               (global-undo-tree-mode)
               (setq undo-tree-visualizer-timestamps t)
               (setq undo-tree-visualizer-diff t)
               ))
;; which key
(use-package which-key
             :config
             (progn
               (which-key-mode)
               (which-key-setup-side-window-bottom)))

;; linum
(use-package linum
             :init
             (progn
               (global-display-line-numbers-mode t)
               (setq display-line-numbers "%4d \u2502")
               ))

;; auto pair
(use-package autopair
             :config (autopair-global-mode))

;; neotree
(use-package all-the-icons)
(use-package neotree
             :config
             (progn
               (setq neo-smart-open t)
               (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
               (setq neo-window-fixed-size nil)
               (setq-default neo-show-hidden-files t)))
;; git
(use-package magit
             :config
             (progn
               (global-set-key (kbd "C-x g") 'magit-status)
               ))

(use-package git-gutter+
             :ensure t
             :config
             (progn
               (global-git-gutter+-mode)))
;; helm
(use-package helm-swoop)
(use-package helm-gtags)
(use-package helm
             :diminish helm-mode
             :init
             (progn
               ;; (require 'helm-config)
               (setq helm-candidate-number-limit 100)
               ;; From https://gist.github.com/antifuchs/9238468
               (setq helm-idle-delay 0.0 ; update fast sources immediately (doesn't).
                     helm-input-idle-delay 0.01  ; this actually updates things
                                        ; reeeelatively quickly.
                     helm-yas-display-key-on-candidate t
                     helm-quick-update t
                     helm-M-x-requires-pattern nil
                     helm-ff-skip-boring-files t)
               (helm-mode))
             :config
             (progn
               )
             :bind  (("C-i" . helm-swoop)
                     ("C-x C-f" . helm-find-files)
                     ("C-x b" . helm-buffers-list)
                     ("M-y" . helm-show-kill-ring)
                     ("M-x" . helm-M-x)))
;; yasnippet
(use-package yasnippet
             :diminish yas-minor-mode
             :init (yas-global-mode)
             :config
             (progn
               (yas-global-mode)
               (add-hook 'hippie-expand-try-functions-list 'yas-hippie-try-expand)
               (setq yas-key-syntaxes '("w_" "w_." "^ "))
               ;; (setq yas-installed-snippets-dir "~/elisp/yasnippet-snippets")
               (setq yas-expand-only-for-last-commands nil)
               (yas-global-mode 1)
               (bind-key "\t" 'hippie-expand yas-minor-mode-map)
               (add-to-list 'yas-prompt-functions 'shk-yas/helm-prompt)))


(dolist (command '(yank yank-pop))
  (eval
   `(defadvice ,command (after indent-region activate)
      (and (not current-prefix-arg)
           (member major-mode
                   '(emacs-lisp-mode
                     lisp-mode
                     python-mode
                     c-mode
                     c++-mode
                     java-mode
                     latex-mode
                     js-mode
                     plain-tex-mode))
           (let ((mark-even-if-inactive transient-mark-mode))
             (indent-region (region-beginning) (region-end) nil))))))

(defun shk-yas/helm-prompt (prompt choices &optional display-fn)
  "Use helm to select a snippet. Put this into `yas-prompt-functions.'"
  (interactive)
  (setq display-fn (or display-fn 'identity))
  (if (require 'helm-config)
      (let (tmpsource cands result rmap)
        (setq cands (mapcar (lambda (x) (funcall display-fn x)) choices))
        (setq rmap (mapcar (lambda (x) (cons (funcall display-fn x) x)) choices))
        (setq tmpsource
              (list
               (cons 'name prompt)
               (cons 'candidates cands)
               '(action . (("Expand" . (lambda (selection) selection))))
               ))
        (setq result (helm-other-buffer '(tmpsource) "*helm-select-yasnippet"))
        (if (null result)
            (signal 'quit "user quit!")
          (cdr (assoc result rmap))))
    nil))
;; fix me mode
(add-to-list 'load-path (expand-file-name "~/.emacs.d/pkg/vendors"))
(require 'fixme-mode)
(defvar my-highlight-words
  '("FIXME" "TODO" "BUG"))
;; Ensure that the variable exists.
(defvar wcheck-language-data nil)
(push '("FIXME"
        (program . (lambda (strings)
                     (let (found)
                       (dolist (word my-highlight-words found)
                         (when (member word strings)
                           (push word found))))))
        (face . highlight)
        (read-or-skip-faces
         (nil)))
      wcheck-language-data)
(fixme-mode 1)
;; dash
(use-package helm-dash
             :config
             (progn
               (setq helm-dash-browser-func 'eww)
               (setq helm-dash-docsets-path (expand-file-name "~/.emacs.d/docsets"))

               (helm-dash-activate-docset "Go")
               (helm-dash-activate-docset "Python 3")
               (helm-dash-activate-docset "CMake")
               (helm-dash-activate-docset "Bash")
               (helm-dash-activate-docset "Django")
               (helm-dash-activate-docset "Redis")
               (helm-dash-activate-docset "Emacs Lisp")
               ))
;; markdown
(use-package markdown-mode
             :ensure t
             :bind (("C-c p" . livedown-preview)
                    ("C-c k" . livedown-kill))
             :commands (markdown-mode gfm-mode)
             :mode (("README\\.md\\'" . gfm-mode)
                    ("\\.md\\'" . markdown-mode)
                    ("\\.markdown\\'" . markdown-mode))
             :init (setq markdown-command "multimarkdown"))
