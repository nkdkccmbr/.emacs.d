 ;; カスタマイズ用のファイルを設定

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

 (setq custom-file "./custom_setttings.el")
 
 ;; カスタマイズ用ファイルをロード
 (load custom-file t)