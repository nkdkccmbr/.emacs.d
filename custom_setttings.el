;;===========
;; 基本
;;===========
;; パッケージ
;; 初回はM-x package-refresh-contents
(setq package-user-dir "~/.emacs.d/elisp/elpa/")
(package-initialize)
(setq package-archives
      '(("gnu"   . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org"   . "http://orgmode.org/elpa/")))

;; UTF-8環境
(set-locale-environment nil)
(prefer-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-default 'buffer-file-coding-system 'utf-8-with-signature)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-language-environment "Japanese")

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

;; C-[の無効化
;; M-xまで潰れてしまう．
;; (global-set-key (kbd "\C-[") nil)

;; ssh
(defvar tramp-default-method "sshx")

;; imenu 関数名自動
(defvar imenu-auto-rescan t)

;; バッファリスト便利化
(ido-mode 1)
(ido-everywhere 1)

;; ウィンドウ移動
;; C-x o の補助
;; (global-set-key (kbd "C-c <left>")  'windmove-left)
;; (global-set-key (kbd "C-c <down>")  'windmove-down)
;; (global-set-key (kbd "C-c <up>")    'windmove-up)
;; (global-set-key (kbd "C-c <right>") 'windmove-right)

;; diredでrでエディタブルに
(add-hook 'dired-load-hook (lambda ()
                  (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)))

;; diredを二つ開いているときにsrcとdstに
(defvar dired-dwim-target t)

;; バックスペースキーをC-hに割り当て
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))

;; ========
;; org-mode
;; ========
;; http://emacs.rubikitch.com/sd1502-org-mode/
;; (global-set-key (kbd "C-c c") 'org-capture)
;; (global-set-key (kbd "C-c a") 'org-agenda)
;; ;; org-captureで2種類のメモを扱うようにする
;; (setq org-capture-templates
;;       '(("t" "New TODO" entry
;;          (file+headline "~/dropbox/org/todo.org" "予定")
;;          "* TODO %?\n\n")
;;         ("m" "Memo" entry
;;          (file+headline "~/dropbox/org/memo.org" "メモ")
;;          "* %U%?\n%i\n%a")))
;; ;; org-agendaでaを押したら予定表とTODOリストを表示
;; (setq org-agenda-custom-commands
;;       '(("a" "Agenda and TODO"
;;          ((agenda "")
;;           (alltodo "")))))
;; ;; org-agendaで扱うファイルは複数可だが、
;; ;; TODO・予定用のファイルのみ指定
;; (setq org-agenda-files '("~/dropbox/org/todo.org"))
;; ;; TODOリストに日付つきTODOを表示しない
;; (setq org-agenda-todo-ignore-with-date t)
;; ;; 今日から予定を表示させる
;; (setq org-agenda-start-on-weekday nil)

;;===========
;; プログラム
;;===========
;; 各モードの拡張子を指定する
(add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))
(add-to-list 'auto-mode-alist '("\\.pyx\\'". python-mode))

;; M-x compile を F7に設定
(global-set-key [f7] 'compile)

;; Auto complete
;; M-x package-install auto-complete
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'text-mode)
(ac-set-trigger-key "TAB") ;;TABで候補の表示
(setq ac-use-menu-map t) ;; C-n, C-p 
(setq ac-use-fuzzy t) ;; 曖昧

;; flycheck
;; M-x package-install flycheck
;; apy-cygでgcc-coreとgcc-g++をインストールした
(require 'flycheck)
(global-flycheck-mode)
(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++11")))

(define-key global-map (kbd "C-c n") 'flycheck-next-error)
(define-key global-map (kbd "C-c p") 'flycheck-previous-error)
(define-key global-map (kbd "C-c d") 'flycheck-list-errors)
;; 日本語環境でのみ
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
 '(package-selected-packages (quote (flycheck auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
