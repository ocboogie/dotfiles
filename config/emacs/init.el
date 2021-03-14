;; Straight bootstrap
(setq straight-use-package-by-default t)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; General config
(setq inhibit-startup-message t)
(setq custom-file (concat user-emacs-directory "/custom.el"))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10) 

(menu-bar-mode -1)

(linum-mode 1)

(set-face-attribute 'default nil :font "monospace" :height 120)

;; https://gist.github.com/yorickvP/6132f237fbc289a45c808d8d75e0e1fb
(setq wl-copy-process nil)
(defun wl-copy (text)
  (setq wl-copy-process (make-process :name "wl-copy"
                                      :buffer nil
                                      :command '("wl-copy" "-f" "-n")
                                      :connection-type 'pipe))
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process))
(defun wl-paste ()
  (if (and wl-copy-process (process-live-p wl-copy-process))
      nil ; should return nil if we're the current paste owner
      (shell-command-to-string "wl-paste -n | tr -d \r")))
(setq interprogram-cut-function 'wl-copy)
(setq interprogram-paste-function 'wl-paste)

;; https://stackoverflow.com/a/2708042
(add-hook 'comint-exec-hook 
  (lambda () (set-process-query-on-exit-flag (get-buffer-process (current-buffer)) nil)))


;; Packages
(straight-use-package 'use-package)

(use-package which-key
  :config
  (which-key-mode 1))

(use-package general)

(use-package ivy
  :config
  (ivy-mode 1))

(use-package counsel)

(use-package swiper)

(use-package projectile
  :config
  (projectile-mode +1)
  (setq projectile-project-search-path '"~/Projects")
  (setq projectile-completion-system 'ivy)
  (setq projectile-indexing-method 'alien))

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package treemacs)

(use-package treemacs-evil
  :after (treemacs evil))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package all-the-icons)

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
    doom-themes-enable-italic t) 
  (doom-themes-visual-bell-config)
  (doom-themes-treemacs-config)
  (load-theme 'doom-dracula t))

(use-package doom-modeline
  :config
  (doom-modeline-mode 1))

(use-package rustic
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)

  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm
  (setq-local buffer-save-without-query t))

(use-package lsp-mode
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))


(use-package ace-window
  :config
  (setq aw-keys '(?a ?r ?s ?t ?d ?h ?n ?e ?i ?o))) ;; colemak baby

;; Keybinds
(general-create-definer my-leader-def 
  :states '(normal motion)
  :keymaps 'override
  :prefix "SPC")

(my-leader-def "SPC" 'projectile-find-file)
(my-leader-def "f" 'find-file)
(my-leader-def "TAB" 'treemacs)
(my-leader-def "p" 'projectile-command-map)
(my-leader-def "t" 'counsel-switch-buffer)
(my-leader-def "o" 'ace-window)
(my-leader-def "v" 'split-window-vertically)
(my-leader-def "h" 'split-window-horizontally)
(my-leader-def "x" 'delete-window)
