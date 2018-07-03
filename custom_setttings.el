;;===========
;; 基本
;;===========
;; パッケージ
(setq package-user-dir "~/.emacs.d/elisp/elpa/")
(defvar package-archives
      '(("gnu"   . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org"   . "http://orgmode.org/elpa/")))
(package-initialize)

;; 環境を日本語、UTF-8にする
(set-locale-environment nil)
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(defvar default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; テーマ
(load-theme 'manoj-dark t)

;; スタートアップメッセージを表示させない
(setq inhibit-startup-message t)

;; バックアップファイルを作成させない
(setq make-backup-files nil)

;; 終了時にオートセーブファイルを削除する
(setq delete-auto-save-files t)

;; スクロールは１行ごとに
(setq scroll-conservatively 1)

;; タブにスペースを使用する
(setq-default tab-width 4 indent-tabs-mode nil)

;; "yes or no" の選択を "y or n" にする
(fset 'yes-or-no-p 'y-or-n-p)

;; メニューバーの非表示
(menu-bar-mode 0)

;; カーソル行をハイライトする
;; 現在行をハイライト
(global-hl-line-mode t)

;; 対応する括弧を光らせる
(show-paren-mode t)

;; ウィンドウ内に収まらないときだけ、カッコ内も光らせる
(defvar show-paren-style 'mixed)
;;(set-face-background 'show-paren-match-face "grey")
;;(set-face-foreground 'show-paren-match-face "black")

;; 行数を表示する
(require 'linum)
(global-linum-mode 1)
(setq linum-delay t)
(defadvice linum-schedule (around my-linum-schedule () activate)
    (run-with-idle-timer 0.2 nil #'linum-update-current))
(setq linum-format "%4d ")

;; ssh
(defvar tramp-default-method "sshx")

;; imenu 関数名自動
(defvar imenu-auto-rescan t)

;; バッファリスト便利化
(ido-mode 1)
(ido-everywhere 1)

;;ウィンドウ移動
;; C-x o の補助
(global-set-key (kbd "C-c b") 'windmove-left)
(global-set-key (kbd "C-c f") 'windmove-right)
(global-set-key (kbd "C-c p") 'windmove-up)
(global-set-key (kbd "C-c n") 'windmove-down)

;; diredでrでエディタブルに
(add-hook 'dired-load-hook (lambda ()
                  (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)))

;; diredを二つ開いているときにsrcとdstに
(defvar dired-dwim-target t)

;;===========
;; プログラム
;;===========
;; Auto complete
;; M-x package-install auto-complete
(require 'auto-complete-config)
(ac-config-default)

;; flycheck
;; M-x package-install flycheck
;; apy-cygでgcc-coreとgcc-g++をインストールした
(require 'flycheck)
(global-flycheck-mode)
(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++11")))
(define-key global-map (kbd "\C-cn") 'flycheck-next-error)
(define-key global-map (kbd "\C-cp") 'flycheck-previous-error)
(define-key global-map (kbd "\C-cd") 'flycheck-list-errors)
(defmacro flycheck-define-clike-checker (name command modes)
  `(flycheck-define-checker ,(intern (format "%s" name))
     ,(format "A %s checker using %s" name (car command))
     :command (,@command source-inplace)
     :error-patterns
     ((warning line-start (file-name) ":" line ":" column ": 警告:" (message) line-end)
      (error line-start (file-name) ":" line ":" column ": エラー:" (message) line-end))
     :modes ',modes))
(flycheck-define-clike-checker c-gcc-ja
                   ("gcc" "-fsyntax-only" "-Wall" "-Wextra")
                   c-mode)
(add-to-list 'flycheck-checkers 'c-gcc-ja)
(flycheck-define-clike-checker c++-g++-ja
                   ("g++" "-fsyntax-only" "-Wall" "-Wextra" "-std=c++11")
                   c++-mode)
(add-to-list 'flycheck-checkers 'c++-g++-ja)

;;===========
;; Python
;;===========
;; Python-mode
;; M-x package-list-packages python-mode
(require 'python-mode)
(setq auto-mode-alist (cons '("\\.py\\'" . python-mode) auto-mode-alist))

;;===========
;; 自作関数
;;===========
;; 日付挿入 C-cd
(defun insert-current-time-day()
  (interactive)
  (insert (format-time-string "%Y%m%d" (current-time))))
(define-key global-map "\C-cd" `insert-current-time-day)

;; 時刻挿入 C-ch
(defun insert-current-time-hour()
  (interactive)
  (insert (format-time-string "%H:%M" (current-time))))
(define-key global-map "\C-ch" `insert-current-time-hour)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (flycheck tabbar sr-speedbar python-mode py-autopep8 nlinum jedi flymake-python-pyflakes exec-path-from-shell))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
