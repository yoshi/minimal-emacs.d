;;; pre-early-init.el --- Pre Early Init -*- no-byte-compile: t; lexical-binding: t; -*-

;;(setq debug-on-error t)

(setq minimal-emacs-gc-cons-threshold (* 64 1024 1024))

(setq minimal-emacs-user-directory "~/.config/emacs/")

(setq user-emacs-directory (expand-file-name "var/" minimal-emacs-user-directory))

(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))

(setq minimal-emacs-ui-features '(context-menu menu-bar tooltips))

(setq enable-dir-local-variables nil)
