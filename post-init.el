;;; post-init.el --- Post Init -*- no-byte-compile: t; lexical-binding: t; -*-

(use-package emacs
  :custom

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion function.
  ;; Try `cape-dict' as an alternative.
  (text-mode-ispell-word-completion nil)

  ;; Hide commands in M-x which do not apply to the current mode.  Corfu
  ;; commands are hidden, since they are not used via M-x. This setting is
  ;; useful beyond Corfu.
  (read-extended-command-predicate #'command-completion-default-include-p))

;; Environment Variable Synchronization (Essential for macOS users)
(use-package exec-path-from-shell
  :if (and (or (display-graphic-p) (daemonp))
           (eq system-type 'darwin)) ; macOS only
  :demand t
  :functions exec-path-from-shell-initialize
  :config
  (dolist (var '("TMPDIR"
                 "SSH_AUTH_SOCK" "SSH_AGENT_PID"
                 "GPG_AGENT_INFO"
                 ;; "FZF_DEFAULT_COMMAND" "FZF_DEFAULT_OPTS" ; fzf
                 ;; "VIRTUAL_ENV" ; Python
                 ;; "GOPATH" "GOROOT" "GOBIN" ; Go
                 ;; "CARGO_HOME" "RUSTUP_HOME" ; Rust
                 ;; "NVM_DIR" "NODE_PATH" ; Node/JS
                 "LANG" "LC_CTYPE"))
    (add-to-list 'exec-path-from-shell-variables var))
  ;; Initialize
  (exec-path-from-shell-initialize))

;;
;; Recent Things
;;
(use-package markdown-ts-mode
  :ensure nil
  :mode ("\\.md\\'" "\\.mdx\\'" "\\.markdown\\'")
  :config
  (require 'markdown-ts-mode-x))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Package Management
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Auto upgrade Emacs packages
;;
;; This automates the process of updating installed packages
(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-hide-results t)
  (auto-package-update-delete-old-versions t)
  ;; (auto-package-update-prompt-before-update t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "10:00"))

;; Allow Emacs to upgrade built-in packages, such as Org mode
(setq package-install-upgrade-built-in t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Buffer Management
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Track changes in the window configuration, allowing undoing actions such as
;; closing windows.
(setq winner-boring-buffers '("*Completions*"
                              "*Minibuf-0*"
                              "*Minibuf-1*"
                              "*Minibuf-2*"
                              "*Minibuf-3*"
                              "*Minibuf-4*"
                              "*Compile-Log*"
                              "*inferior-lisp*"
                              "*Fuzzy Completions*"
                              "*Apropos*"
                              "*Help*"
                              "*cvs*"
                              "*Buffer List*"
                              "*Ibuffer*"
                              "*esh command on file*"))
(add-hook 'after-init-hook #'winner-mode)

(use-package uniquify
  :ensure nil
  :custom
  (uniquify-buffer-name-style 'reverse)
  (uniquify-separator "•")
  (uniquify-after-kill-buffer-p t))

(use-package golden-ratio
  :disabled
  :hook (after-init . golden-ratio-mode)
  :custom
  (golden-ratio-exclude-modes '(occur-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; UI
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'super))

(when (display-graphic-p)
  ;;(pixel-scroll-precision-mode 1)
  ;;(fringe-mode 8)
  (blink-cursor-mode t)
  (toggle-scroll-bar 'right)
  (toggle-horizontal-scroll-bar t)
  (setq mouse-yank-at-point t)
  (setq mouse-wheel-mode t)
  (setq indicate-buffer-boundaries 'left))

;; Changing the default theme
(let ((inhibit-redisplay t))
  ;; Disable all active themes
  (mapc #'disable-theme custom-enabled-themes)
  ;; Load the built-in theme
  (load-theme 'starlit t))

;; Changing the Default Font
(set-face-attribute 'default nil
                    :family "SF Mono"
                    :width 'medium
                    :height 130
                    :weight 'normal)

;; Window dividers separate windows visually. Window dividers are bars that can
;; be dragged with the mouse, thus allowing you to easily resize adjacent
;; windows.
(add-hook 'after-init-hook #'window-divider-mode)

;; Enables visual indication of minibuffer recursion depth after initialization.
(add-hook 'after-init-hook #'minibuffer-depth-indicate-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Modeline Management
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Display the current line and column numbers in the mode line
(setopt line-number-mode t)
(setopt column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))

;; Display the time in the modeline
;;(add-hook 'after-init-hook #'display-time-mode)

(use-package minions
  :commands minions-mode
  :custom
  (mode-line-modes-delimiters nil)
  (minions-mode-line-lighter " …" nil)
  :config
  (force-mode-line-update t)
  :hook (after-init . minions-mode))

;; (use-package moody
;;   :ensure t
;;   :config
;;   ;; (setq-default mode-line-format
;;   ;;               '(""
;;   ;;                 mode-line-front-space
;;   ;;                 mode-line-client
;;   ;;                 mode-line-frame-identification
;;   ;;                 mode-line-buffer-identification
;;   ;;                 " "
;;   ;;                 mode-line-position
;;   ;;                 (vc-mode vc-mode)
;;   ;;                 (multiple-cursors-mode mc/mode-line)
;;   ;;                 mode-line-modes
;;   ;;                 mode-line-end-spaces))
;;   (moody-replace-mode-line-front-space)
;;   (moody-replace-mode-line-buffer-identification)
;;   ;;(moody-replace-vc-mode)
;;   (set-face-attribute 'mode-line-active nil :box 'unspecified)
;;   (set-face-attribute 'mode-line-inactive nil :box 'unspecified))

(use-package nyan-mode
  :commands nyan-mode
  :hook (after-init . nyan-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Parenthesis
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paren match highlighting
(add-hook 'after-init-hook #'show-paren-mode)

;; Which other customizations can be interesting to add?
;;
;;; Enable automatic insertion and management of matching pairs of characters
;;; (e.g., (), {}, "") globally using `electric-pair-mode'.
;; (use-package elec-pair
;;   :ensure nil
;;   :commands (electric-pair-mode
;;              electric-pair-local-mode
;;              electric-pair-delete-pair)
;;   :hook (after-init . electric-pair-mode))


;; Prevent parenthesis imbalance
;; (use-package paredit
;;   :commands paredit-mode
;;   :hook
;;   (emacs-lisp-mode . paredit-mode)
;;   :config
;;   (define-key paredit-mode-map (kbd "RET") nil))

;; smartparens
;; https://github.com/Fuco1/smartparens
;; https://ebzzry.com/en/emacs-pairs/
(use-package smartparens
  :commands smartparens-mode
  :hook (prog-mode)
  :config
  (require 'smartparens-config))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Time and Date
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq display-time-day-and-date t
 	  display-time-24hr-format t
 	  display-time-use-mail-icon t
      display-time-format "%Y-%m-%dT%H:%M%z" ; ISO 8601
      display-time-default-load-average nil
 	  display-time-interval 10)

;;; time things
(defun insert-timestamp ()
  (interactive)
  (insert (format-time-string display-time-format (current-time))))

(define-key global-map (kbd "C-x y t") 'insert-timestamp)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Filesystem
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constrain vertical cursor movement to lines within the buffer
(setq dired-movement-style 'bounded-files)

;; dired: Group directories first
(with-eval-after-load 'dired
  (let ((args "--group-directories-first -ahlv --time-style=long-iso"))
    (when (or (eq system-type 'darwin) (eq system-type 'berkeley-unix))
      (if-let* ((gls (executable-find "gls")))
          (setq insert-directory-program gls)
        (setq args nil)))
    (when args
      (setq dired-listing-switches args))))

;; Configure Emacs to ask for confirmation before exiting
;;(setq confirm-kill-emacs 'y-or-n-p)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Backups
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Enabled backups save your changes to a file intermittently
(setq make-backup-files t)
(setq vc-make-backup-files t)
(setq kept-old-versions 10)
(setq kept-new-versions 10)


;; When tooltip-mode is enabled, certain UI elements (e.g., help text,
;; mouse-hover hints) will appear as native system tooltips (pop-up windows),
;; rather than as echo area messages. This is useful in graphical Emacs sessions
;; where tooltips can appear near the cursor.
(setq tooltip-hide-delay 20)    ; Time in seconds before a tooltip disappears (default: 10)
(setq tooltip-delay 0.4)        ; Delay before showing a tooltip after mouse hover (default: 0.7)
(setq tooltip-short-delay 0.08) ; Delay before showing a short tooltip (Default: 0.1)
(tooltip-mode 1)

;; In Emacs, customization variables modified via the UI (e.g., M-x customize)
;; are typically stored in a separate file, commonly named 'custom.el'. To
;; ensure these settings are loaded during Emacs initialization, it is necessary
;; to explicitly load this file if it exists.
(load custom-file 'noerror 'no-message)

;;
;; File Management & History: recentf, savehist, saveplace, and auto-revert?
;;

;; Recentf is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.
(use-package recentf
  :ensure nil
  :commands (recentf-mode recentf-cleanup)
  :hook
  (after-init . recentf-mode)

  :init
  (setq recentf-auto-cleanup (if (daemonp) 300 'never))
  (setq recentf-exclude
        (list "\\.tar$" "\\.tbz2$" "\\.tbz$" "\\.tgz$" "\\.bz2$"
              "\\.bz$" "\\.gz$" "\\.gzip$" "\\.xz$" "\\.zip$"
              "\\.7z$" "\\.rar$"
              "COMMIT_EDITMSG\\'"
              "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
              "-autoloads\\.el$" "autoload\\.el$"))

  :config
  ;; A cleanup depth of -90 ensures that `recentf-cleanup' runs before
  ;; `recentf-save-list', allowing stale entries to be removed before the list
  ;; is saved by `recentf-save-list', which is automatically added to
  ;; `kill-emacs-hook' by `recentf-mode'.
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90))

;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
(use-package savehist
  :ensure nil
  :commands (savehist-mode savehist-save)
  :hook
  (after-init . savehist-mode)
  :init
  (setq history-length 300)
  (setq savehist-autosave-interval 600))

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(use-package saveplace
  :ensure nil
  :commands (save-place-mode save-place-local-mode)
  :hook
  (after-init . save-place-mode)
  :init
  (setq save-place-limit 400))

;; Emacs server
(use-package server
  :ensure nil
  :if (not (daemonp))
  :commands (server-running-p
             server-start)
  :hook (after-init . my-server-start)
  :preface
  (defun my-server-start ()
    "Start the Emacs server if no server process is currently active."
    (unless (server-running-p)
      (server-start))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Spell check
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package jinx
  :custom
  (jinx-languages "en_US" t)
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
		 ("C-M-$" . jinx-languages)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Completion
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; corfu
;; https://github.com/minad/corfu
(use-package corfu
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match 'insert) ;; Configure handling of exact matches
  (corfu-auto t)

  ;; Enable Corfu
  :config
  (global-corfu-mode)
  (corfu-popupinfo-mode))

;; cape
;; https://github.com/minad/cape
(use-package cape
  :after corfu
  :commands (cape-dabbrev cape-file cape-elisp-block)
  :bind ("C-c p" . cape-prefix-map)
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

;; vertico
;; https://github.com/minad/vertico
(use-package vertico
  ;; (Note: It is recommended to also enable the savehist package.)
  :custom
  (vertico-scroll-margin 0) ;; Different scroll margin
  (vertico-count 20) ;; Show more candidates
  (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :config
  (vertico-mode))

;; orderless
;; https://github.com/minad/orderless
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; https://github.com/minad/marginalia
(use-package marginalia
  :commands (marginalia-mode marginalia-cycle)
  :hook (after-init . marginalia-mode)
  :custom
  (marginalia-max-relative-age 0))

(use-package embark
  :commands (embark-act
             embark-dwim
             embark-export
             embark-collect
             embark-bindings
             embark-prefix-help-command)
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package consult
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x t b" . consult-buffer-other-tab)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))

  ;; Enable automatic preview at point in the *Completions* buffer.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  :init
  ;; Optionally configure the register formatting. This improves the register
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Aggressive asynchronous that yield instantaneous results. (suitable for
  ;; high-performance systems.) Note: Minad, the author of Consult, does not
  ;; recommend aggressive values.
  ;; Read: https://github.com/minad/consult/discussions/951
  ;;
  ;; However, the author of minimal-emacs.d uses these parameters to achieve
  ;; immediate feedback from Consult.
  ;; (setq consult-async-input-debounce 0.02
  ;;       consult-async-input-throttle 0.05
  ;;       consult-async-refresh-delay 0.02)

  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<"))

;; Enhancing undo/redo
;;
;; The undo-fu package is a lightweight wrapper around Emacs' built-in undo
;; system, providing more convenient undo/redo functionality.
(use-package undo-fu
  :commands (undo-fu-only-undo
             undo-fu-only-redo
             undo-fu-only-redo-all
             undo-fu-disable-checkpoint)
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

;; The undo-fu-session package complements undo-fu by enabling the saving
;; and restoration of undo history across Emacs sessions, even after restarting.
(use-package undo-fu-session
  :commands undo-fu-session-global-mode
  :hook (after-init . undo-fu-session-global-mode))

;; The easysession Emacs package is a session manager for Emacs that can persist
;; and restore file editing buffers, indirect buffers/clones, Dired buffers,
;; windows/splits, the built-in tab-bar (including tabs, their buffers, and
;; windows), and Emacs frames. It offers a convenient and effortless way to
;; manage Emacs editing sessions and utilizes built-in Emacs functions to
;; persist and restore frames.
(use-package easysession
  :commands (easysession-switch-to
             easysession-save-as
             easysession-save-mode
             easysession-load-including-geometry)

  :custom
  ;; (easysession-mode-line-misc-info t)  ; Display the session in the modeline
  (easysession-save-interval (* 10 60))  ; Save every 10 minutes

  :init
  ;; Key mappings
  (global-set-key (kbd "C-c ss") #'easysession-save)
  (global-set-key (kbd "C-c sl") #'easysession-switch-to)
  (global-set-key (kbd "C-c sL") #'easysession-switch-to-and-restore-geometry)
  (global-set-key (kbd "C-c sr") #'easysession-rename)
  (global-set-key (kbd "C-c sR") #'easysession-reset)
  (global-set-key (kbd "C-c sd") #'easysession-delete)

  (if (fboundp 'easysession-setup)
      ;; The `easysession-setup' function adds hooks:
      ;; - To enable automatic session loading during `emacs-startup-hook', or
      ;;   `server-after-make-frame-hook' when running in daemon mode.
      ;; - To automatically save the session at regular intervals, and when
      ;;   Emacs exits.
      (easysession-setup)
    ;; Legacy
    ;; The depth 102 and 103 have been added to to `add-hook' to ensure that the
    ;; session is loaded after all other packages. (Using 103/102 is
    ;; particularly useful for those using minimal-emacs.d, where some
    ;; optimizations restore `file-name-handler-alist` at depth 101 during
    ;; `emacs-startup-hook`.)
    (add-hook 'emacs-startup-hook #'easysession-load-including-geometry 102)
    (add-hook 'emacs-startup-hook #'easysession-save-mode 103)))






;; Configuring markdown-mode (e.g., README.md syntax)
;;
;; The markdown-mode package provides a major mode for Emacs for syntax
;; highlighting, editing commands, and preview support for Markdown documents.
;; It supports core Markdown syntax as well as extensions like GitHub Flavored
;; Markdown (GFM).
;; (use-package markdown-mode
;;   :commands (gfm-mode
;;              gfm-view-mode
;;              markdown-mode
;;              markdown-view-mode)
;;   :mode (("\\.markdown\\'" . markdown-mode)
;;          ("\\.md\\'" . markdown-mode)
;;          ("README\\.md\\'" . gfm-mode))
;;   :bind
;;   (:map markdown-mode-map
;;         ("C-c C-e" . markdown-do)))

;; Automatically generate a table of contents when editing Markdown files
;; (use-package markdown-toc
;;   :commands (markdown-toc-generate-toc
;;              markdown-toc-generate-or-refresh-toc
;;              markdown-toc-delete-toc
;;              markdown-toc--toc-already-present-p)
;;   :custom
;;   (markdown-toc-header-toc-title "**Table of Contents**"))

;; Kirigami: A unified interface for opening and closing folds
(use-package kirigami
  :custom
  (kirigami-show-context-menu t)
  :config
  (kirigami-global-mode 1)
  :commands (kirigami-open-fold
             kirigami-open-fold-rec
             kirigami-close-fold
             kirigami-toggle-fold
             kirigami-open-folds
             kirigami-close-folds-except-current
             kirigami-close-folds)

  :bind
  (("C-c z o" . kirigami-open-fold)          ; Open fold at point
   ("C-c z O" . kirigami-open-fold-rec)      ; Open fold recursively
   ("C-c z r" . kirigami-open-folds)         ; Open all folds
   ("C-c z c" . kirigami-close-fold)         ; Close fold at point
   ("C-c z m" . kirigami-close-folds)        ; Close all folds
   ("C-c z <tab>" . kirigami-toggle-fold)))  ; Toggle fold at point

;; outline-minor-mode and hs-minor-mode
;;
;; The built-in outline-minor-mode provides structured code folding in modes
;; such as Emacs Lisp and Python, allowing users to collapse and expand sections
;; based on headings or indentation levels. This feature enhances navigation and
;; improves the management of large files with hierarchical structures.
(use-package outline
  :ensure nil
  :commands outline-minor-mode
  :hook
  ((emacs-lisp-mode . outline-minor-mode)
   ;; Use " ▼" instead of the default ellipsis "..." for folded text to make
   ;; folds more visually distinctive and readable.
   (outline-minor-mode
    .
    (lambda()
      (let* ((display-table (or buffer-display-table (make-display-table)))
             (face-offset (* (face-id 'shadow) (ash 1 22)))
             (value (vconcat (mapcar (lambda (c) (+ face-offset c)) " ▼"))))
        (set-display-table-slot display-table 'selective-display value)
        (setq buffer-display-table display-table))))))

;; outline-indent-minor-mode: Folding based on indentation levels
;;
;; The outline-indent Emacs package provides a minor mode that enables code
;; folding based on indentation levels.
;;
;; In addition to code folding, *outline-indent* allows:
;; - Moving indented blocks up and down
;; - Indenting/unindenting to adjust indentation levels
;; - Inserting a new line with the same indentation level as the current line
;; - Move backward/forward to the indentation level of the current line
;; - and other features.
(use-package outline-indent
  :commands outline-indent-minor-mode

  :custom
  (outline-indent-ellipsis " ▼")

  :init
  ;; The minor mode can also be automatically activated for a certain modes.
  (add-hook 'python-mode-hook #'outline-indent-minor-mode)
  (add-hook 'python-ts-mode-hook #'outline-indent-minor-mode)

  (add-hook 'yaml-mode-hook #'outline-indent-minor-mode)
  (add-hook 'yaml-ts-mode-hook #'outline-indent-minor-mode))

;; treesit-fold
;;
;; Intelligent code folding by leveraging the structural understanding of the
;; built-in tree-sitter parser. Unlike traditional folding methods that rely on
;; regular expressions or indentation, treesit-fold uses the actual syntax tree
;; of the code to accurately identify foldable regions such as functions,
;; classes, comments, and documentation strings. This allows for faster and more
;; precise folding behavior that respects the grammar of the programming
;; language, ensuring that fold boundaries are always syntactically correct even
;; in complex or nested code structures.
(use-package treesit-fold
  :commands (treesit-fold-close
             treesit-fold-close-all
             treesit-fold-open
             treesit-fold-toggle
             treesit-fold-open-all
             treesit-fold-mode
             global-treesit-fold-mode
             treesit-fold-open-recursively
             treesit-fold-line-comment-mode)

  :custom
  (treesit-fold-line-count-show t)
  (treesit-fold-line-count-format " ▼")

  :config
  (set-face-attribute 'treesit-fold-replacement-face nil
                      :foreground "#808080"
                      :box nil
                      :weight 'bold))

;; Set the maximum level of syntax highlighting for Tree-sitter modes
(setq treesit-font-lock-level 4)

;; Asynchronous code formatting without cursor disruption
;;
;; Apheleia is an Emacs package designed to run code formatters (e.g., Shfmt,
;; Black and Prettier) asynchronously without disrupting the cursor position.
(use-package apheleia
  :commands (apheleia-mode
             apheleia-global-mode)
  :hook ((prog-mode . apheleia-mode)))

;; Context-aware 'go to definition' functionality for 50+ programming languages
(use-package dumb-jump
  :commands dumb-jump-xref-activate
  :init
  ;; Register `dumb-jump' as an xref backend so it integrates with
  ;; `xref-find-definitions'. A priority of 90 ensures it is used only when no
  ;; more specific backend is available.
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate 90)

  (setq dumb-jump-aggressive nil)
  ;; (setq dumb-jump-quiet t)

  ;; Number of seconds a rg/grep/find command can take before being warned to
  ;; use ag and config.
  (setq dumb-jump-max-find-time 3)

  ;; Use `completing-read' so that selection of jump targets integrates with the
  ;; active completion framework (e.g., Vertico, Ivy, Helm, Icomplete),
  ;; providing a consistent minibuffer-based interface whenever multiple
  ;; definitions are found.
  (setq dumb-jump-selector 'completing-read)

  ;; If ripgrep is available, force `dumb-jump' to use it because it is
  ;; significantly faster and more accurate than the default searchers (grep,
  ;; ag, etc.).
  (when (executable-find "rg")
    (setq dumb-jump-force-searcher 'rg)
    (setq dumb-jump-prefer-searcher 'rg)))

;; Efficient template expansion with snippets
;;
;; The official collection of snippets for yasnippet.
(use-package yasnippet-snippets
  :after yasnippet)

;; YASnippet is a template system designed that enhances text editing by
;; enabling users to define and use snippets. When a user types a short
;; abbreviation, YASnippet automatically expands it into a full template, which
;; can include placeholders, fields, and dynamic content.
(use-package yasnippet
  :commands (yas-minor-mode
             yas-global-mode)

  :hook
  (after-init . yas-global-mode)

  :custom
  (yas-also-auto-indent-first-line t)  ; Indent first line of snippet
  (yas-also-indent-empty-lines t)
  (yas-snippet-revival nil)  ; Setting this to t causes issues with undo
  (yas-wrap-around-region nil) ; Do not wrap region when expanding snippets
  ;; (yas-triggers-in-field nil)  ; Disable nested snippet expansion
  ;; (yas-indent-line 'fixed) ; Do not auto-indent snippet content
  ;; (yas-prompt-functions '(yas-no-prompt))  ; No prompt for snippet choices

  :init
  ;; Suppress verbose messages
  (setq yas-verbosity 0))


;; Automatic removal of trailing whitespace on save
;;
;; The stripspace Emacs package provides stripspace-local-mode, a minor mode
;; that automatically removes trailing whitespace and blank lines at the end of
;; the buffer when saving.
(use-package stripspace
  :commands stripspace-local-mode

  ;; Enable for prog-mode-hook, text-mode-hook, conf-mode-hook
  :hook ((prog-mode . stripspace-local-mode)
         (text-mode . stripspace-local-mode)
         (conf-mode . stripspace-local-mode))

  :custom
  ;; The `stripspace-only-if-initially-clean' option:
  ;; - nil to always delete trailing whitespace.
  ;; - Non-nil to only delete whitespace when the buffer is clean initially.
  ;; (The initial cleanliness check is performed when `stripspace-local-mode'
  ;; is enabled.)
  (stripspace-only-if-initially-clean nil)

  ;; Enabling `stripspace-restore-column' preserves the cursor's column position
  ;; even after stripping spaces. This is useful in scenarios where you add
  ;; extra spaces and then save the file. Although the spaces are removed in the
  ;; saved file, the cursor remains in the same position, ensuring a consistent
  ;; editing experience without affecting cursor placement.
  (stripspace-restore-column t))

;; Highlighting uncommitted changes in the buffer margin (e.g., Git changes)
(use-package diff-hl
  :commands (diff-hl-mode
             global-diff-hl-mode)
  :hook (prog-mode . diff-hl-mode)
  :init
  (setq diff-hl-flydiff-delay 0.4)  ; Faster
  (setq diff-hl-show-staged-changes nil)  ; Realtime feedback
  (setq diff-hl-update-async t)  ; Do not block Emacs
  (setq diff-hl-global-modes '(not pdf-view-mode image-mode)))

(add-hook 'dired-mode-hook 'diff-hl-dired-mode)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

;; Configuring org-mode
(use-package org
  :commands (org-mode org-version)
  :mode
  ("\\.org\\'" . org-mode)
  :custom
  ;;(org-hide-leading-stars t)
  (org-startup-indented t)
  ;;(org-adapt-indentation nil)
  ;;(org-src-content-indentation 0)
  ;; (org-fontify-done-headline t)
  ;; (org-fontify-todo-headline t)
  ;; (org-fontify-whole-heading-line t)
  ;; (org-fontify-quote-and-verse-blocks t)
  ;;(org-startup-truncated t)
  )

(use-package ob-lilypond
  :ensure nil
  :custom
  (org-babel-lilypond-commands '("lilypond" "" ""))
  :config
  ;; fix the bloody case of the lilypond package reference.

  (setf (cdr (assoc "lilypond" org-src-lang-modes)) 'lilypond)
  )


;; Ugh, trying to figure out the best way to alter alists
;;
;; (add-to-list 'org-src-lang-modes '("lilypond" . LilyPond))
;; (message "before: %s\n" org-src-lang-modes)
;; (delete '("lilypond" . LilyPond) org-src-lang-modes)
;; (message "after: %s\n" org-src-lang-modes)
;; (add-to-list 'org-src-lang-modes '("lilypond" . lilypond))
;; (message "more after: %s\n" org-src-lang-modes)
;; (message "result: %s\n" (assoc "lilypond" org-src-lang-modes))

(use-package lilypond-mode
  :ensure nil
  :mode
  (("\\.ly\\'" . lilypond-mode)
   ("\\.ily\\'" . lilypond-mode))
  :init
  (turn-on-font-lock))

;; (use-package org-appear
;;   :commands org-appear-mode
;;   :hook (org-mode . org-appear-mode))

;; org-modern
;; https://github.com/minad/org-modern
;; (use-package org-modern
;;   :commands (org-modern-mode global-org-modern-mode)
;;   :hook (org-mode . org-modern-mode))

;; Configuring LSP Servers with Eglot (built-in)
;;
;; Set up the Language Server Protocol (LSP) servers using Eglot.
(use-package eglot
  :ensure nil
  :commands (eglot-ensure
             eglot-rename
             eglot-format-buffer))

;; Treemacs, a tree layout file explorer (Sidebar file explorer)
;;
;; A file and project explorer for Emacs that displays a structured tree
;; layout, similar to file browsers in modern IDEs. It functions as a sidebar
;; in the left window, providing a persistent view of files, projects, and
;; other elements.
;; (use-package treemacs
;;   :commands (treemacs
;;              treemacs-select-window
;;              treemacs-delete-other-windows
;;              treemacs-select-directory
;;              treemacs-bookmark
;;              treemacs-find-file
;;              treemacs-find-tag)
;;
;;   :bind
;;   (:map global-map
;;         ("M-0"       . treemacs-select-window)
;;         ("C-x t 1"   . treemacs-delete-other-windows)
;;         ("C-x t t"   . treemacs)
;;         ("C-x t d"   . treemacs-select-directory)
;;         ("C-x t B"   . treemacs-bookmark)
;;         ("C-x t C-t" . treemacs-find-file)
;;         ("C-x t M-t" . treemacs-find-tag))
;;
;;   :init
;;   (with-eval-after-load 'winum
;;     (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
;;
;;   :config
;;   (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
;;         treemacs-deferred-git-apply-delay        0.5
;;         treemacs-directory-name-transformer      #'identity
;;         treemacs-display-in-side-window          t
;;         treemacs-eldoc-display                   'simple
;;         treemacs-file-event-delay                2000
;;         treemacs-file-extension-regex            treemacs-last-period-regex-value
;;         treemacs-file-follow-delay               0.2
;;         treemacs-file-name-transformer           #'identity
;;         treemacs-follow-after-init               t
;;         treemacs-expand-after-init               t
;;         treemacs-find-workspace-method           'find-for-file-or-pick-first
;;         treemacs-git-command-pipe                ""
;;         treemacs-goto-tag-strategy               'refetch-index
;;         treemacs-header-scroll-indicators        '(nil . "^^^^^^")
;;         treemacs-hide-dot-git-directory          t
;;         treemacs-indentation                     2
;;         treemacs-indentation-string              " "
;;         treemacs-is-never-other-window           nil
;;         treemacs-max-git-entries                 5000
;;         treemacs-missing-project-action          'ask
;;         treemacs-move-files-by-mouse-dragging    t
;;         treemacs-move-forward-on-expand          nil
;;         treemacs-no-png-images                   nil
;;         treemacs-no-delete-other-windows         t
;;         treemacs-project-follow-cleanup          nil
;;         treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
;;         treemacs-position                        'left
;;         treemacs-read-string-input               'from-child-frame
;;         treemacs-recenter-distance               0.1
;;         treemacs-recenter-after-file-follow      nil
;;         treemacs-recenter-after-tag-follow       nil
;;         treemacs-recenter-after-project-jump     'always
;;         treemacs-recenter-after-project-expand   'on-distance
;;         treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
;;         treemacs-project-follow-into-home        nil
;;         treemacs-show-cursor                     nil
;;         treemacs-show-hidden-files               t
;;         treemacs-silent-filewatch                nil
;;         treemacs-silent-refresh                  nil
;;         treemacs-sorting                         'alphabetic-asc
;;         treemacs-select-when-already-in-treemacs 'move-back
;;         treemacs-space-between-root-nodes        t
;;         treemacs-tag-follow-cleanup              t
;;         treemacs-tag-follow-delay                1.5
;;         treemacs-text-scale                      nil
;;         treemacs-user-mode-line-format           nil
;;         treemacs-user-header-line-format         nil
;;         treemacs-wide-toggle-width               70
;;         treemacs-width                           35
;;         treemacs-width-increment                 1
;;         treemacs-width-is-initially-locked       t
;;         treemacs-workspace-switch-cleanup        nil)
;;
;;   ;; The default width and height of the icons is 22 pixels. If you are
;;   ;; using a Hi-DPI display, uncomment this to double the icon size.
;;   ;; (treemacs-resize-icons 44)
;;
;;   (treemacs-follow-mode t)
;;   (treemacs-filewatch-mode t)
;;   (treemacs-fringe-indicator-mode 'always)
;;
;;   ;;(when treemacs-python-executable
;;   ;;  (treemacs-git-commit-diff-mode t))
;;
;;   (pcase (cons (not (null (executable-find "git")))
;;                (not (null treemacs-python-executable)))
;;     (`(t . t)
;;      (treemacs-git-mode 'deferred))
;;     (`(t . _)
;;      (treemacs-git-mode 'simple)))
;;
;;   (treemacs-hide-gitignored-files-mode nil))

;;(use-package treemacs-icons-dired
;;  :hook (dired-mode . treemacs-icons-dired-enable-once))

;;(use-package treemacs-tab-bar  ; treemacs-tab-bar if you use tab-bar-mode
;;  :after (treemacs)
;;  :config (treemacs-set-scope-type 'Tabs))

;;(treemacs-start-on-boot)

;; A better Emacs *help* buffer
;;
;; Helpful is an alternative to the built-in Emacs help that provides much more
;; contextual information.
(use-package helpful
  :commands (helpful-callable
             helpful-variable
             helpful-key
             helpful-command
             helpful-at-point
             helpful-function)
  :bind
  ([remap describe-command] . helpful-command)
  ([remap describe-function] . helpful-callable)
  ([remap describe-key] . helpful-key)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . helpful-variable)
  :custom
  (helpful-max-buffers 7))

;; Efficient jumps
(use-package avy
  :commands (avy-goto-char
             avy-goto-char-2
             avy-next)
  :init
  (global-set-key (kbd "C-'") 'avy-goto-char-2))

;; Renaming and deleting files
(use-package bufferfile
  :commands (bufferfile-copy
             bufferfile-rename
             bufferfile-delete)
  :custom
  ;; If non-nil, display messages during file renaming operations
  (bufferfile-verbose nil)

  ;; If non-nil, enable using version control (VC) when available
  (bufferfile-use-vc nil)

  ;; Specifies the action taken after deleting a file and killing its buffer.
  (bufferfile-delete-switch-to 'parent-directory))

;; Enhancing the Elisp development experience
;;
;; Enables automatic indentation of code while typing
(use-package aggressive-indent
  :commands aggressive-indent-mode
  :hook
  (emacs-lisp-mode . aggressive-indent-mode))

;; Highlights function and variable definitions in Emacs Lisp mode
(use-package highlight-defined
  :commands highlight-defined-mode
  :hook
  (emacs-lisp-mode . highlight-defined-mode))

;; Provides functions to find references to functions, macros, variables,
;; special forms, and symbols in Emacs Lisp
(use-package elisp-refs
  :commands (elisp-refs-function
             elisp-refs-macro
             elisp-refs-variable
             elisp-refs-special
             elisp-refs-symbol))

;; Offline Dictionary
(use-package quick-sdcv
  :custom
  (quick-sdcv-unique-buffers t)
  (quick-sdcv-dictionary-prefix-symbol "►")
  (quick-sdcv-ellipsis " ▼"))

;; Persisting and Restoring Text Scale
(use-package persist-text-scale
  :commands (persist-text-scale-mode
             persist-text-scale-restore)

  :hook (after-init . persist-text-scale-mode)

  :custom
  (text-scale-mode-step 1.07))

;; A Faster Terminal Emulator
;;
;; `vterm' is an Emacs terminal emulator that provides a fully interactive shell
;; experience within Emacs, supporting features such as color, cursor movement,
;; and advanced terminal capabilities. Unlike standard Emacs terminal modes,
;; `vterm' utilizes the libvterm C library for high-performance emulation. This
;; ensures accurate terminal behavior when running shell programs, text-based
;; applications, and REPLs.
(use-package vterm
  :if (bound-and-true-p module-file-suffix)
  :commands (vterm
             vterm-send-string
             vterm-send-return
             vterm-send-key
             vterm-module-compile)

  :preface
  (when noninteractive
    ;; vterm unnecessarily triggers compilation of vterm-module.so upon loading.
    ;; This prevents that during byte-compilation (`use-package' eagerly loads
    ;; packages when compiling).
    (advice-add #'vterm-module-compile :override #'ignore))

  (defun my-vterm--setup ()
    ;; Hide the mode-line
    (setq mode-line-format nil)

    ;; Inhibit early horizontal scrolling
    (setq-local hscroll-margin 0)

    ;; Suppress prompts for terminating active processes when closing vterm
    (setq-local confirm-kill-processes nil))

  :init
  (add-hook 'vterm-mode-hook #'my-vterm--setup)

  (setq vterm-timer-delay 0.05)  ; Faster vterm
  (setq vterm-kill-buffer-on-exit t)
  (setq vterm-max-scrollback 5000))

(use-package which-key
  :commands which-key-mode
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 1.5)
  (which-key-idle-secondary-delay 0.25)
  (which-key-add-column-padding 1)
  (which-key-max-description-length 40))

(use-package magit
  :bind (("C-x g" . magit)
         ("C-x C-g" . magit-status)))

;; File types
;;
;; https://github.com/magit/git-modes
(use-package git-modes
  :commands (gitattributes-mode
             gitconfig-mode
             gitignore-mode)
  :mode (("/\\.gitignore\\'" . gitignore-mode)
         ("/info/exclude\\'" . gitignore-mode)
         ("/git/ignore\\'" . gitignore-mode)
         ("/.gitignore_global\\'" . gitignore-mode)  ; jc-dotfiles

         ("/\\.gitconfig\\'" . gitconfig-mode)
         ("/\\.git/config\\'" . gitconfig-mode)
         ("/modules/.*/config\\'" . gitconfig-mode)
         ("/git/config\\'" . gitconfig-mode)
         ("/\\.gitmodules\\'" . gitconfig-mode)
         ("/etc/gitconfig\\'" . gitconfig-mode)

         ("/\\.gitattributes\\'" . gitattributes-mode)
         ("/info/attributes\\'" . gitattributes-mode)
         ("/git/attributes\\'" . gitattributes-mode)))

;; Configure built-in sgml-mode to automatically enable
;; `sgml-electric-tag-pair-mode' in `html-mode' and `mhtml-mode', providing
;; automatic insertion of matching closing tags.
(use-package sgml-mode
  :ensure nil
  :commands (sgml-mode sgml-electric-tag-pair-mode)
  :hook ((html-mode mhtml-mode) . sgml-electric-tag-pair-mode))

;; Support for YAML files.
;;
;; NOTE: Prefer the tree-sitter-based yaml-ts-mode over yaml-mode when
;; available, as it provides more accurate syntax parsing and enhanced editing
;; features.
(use-package yaml-ts-mode
  :commands yaml-ts-mode
  :mode (("\\.yaml\\'" . yaml-ts-mode)
         ("\\.yml\\'" . yaml-ts-mode)))

;; Support for Gnuplot files
(use-package gnuplot
  :commands gnuplot-mode
  :mode ("\\.gp\\'" . gnuplot-mode))

;; CSV file support with automatic column alignment. This configuration enables
;; csv-align-mode whenever a CSV file is opened, improving readability by
;; keeping columns visually aligned according to a configurable maximum width
;; and a set of recognized field separators.
(use-package csv-mode
  :commands (csv-mode
             csv-align-mode
             csv-guess-set-separator)
  :mode ("\\.csv\\'" . csv-mode)
  :hook ((csv-mode . csv-align-mode)
         (csv-mode . csv-guess-set-separator))
  :custom
  (csv-align-max-width 100)
  (csv-separators '("," ";" " " "|" "\t")))

;; Support for Go
;;
;; NOTE: Prefer the tree-sitter-based go-ts-mode over go-mode
;; when available, as it provides more accurate syntax parsing and enhanced
;; editing features.
(use-package go-ts-mode
  :commands go-ts-mode
  :mode ("\\.go\\'" . go-ts-mode))

;; Support for Haskell
(use-package haskell-mode
  :commands haskell-mode
  :mode ("\\.hs\\'" . haskell-mode))

(use-package zig-ts-mode
  :commands zig-ts-mode
  :mode ("\\.zig\\'" . zig-ts-mode))

(use-package vertico-posframe
  :custom
  (vertico-posframe-parameters
   '((left-fringe . 8)
     (right-fringe . 8))))

;; dashboard
;; https://github.com/emacs-dashboard/dashboard
;; (use-package dashboard
;;   :config
;;   (dashboard-setup-startup-hook))
