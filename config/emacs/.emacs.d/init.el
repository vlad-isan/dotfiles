;; Without this, emacs doesn't follow symlinks to true file path - for security reasons
(setq vc-follow-symlinks t)

(require 'org)

(org-babel-load-file (expand-file-name "config.org" user-emacs-directory))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("f5661fd54b1e60a4ae373850447efc4158c23b1c7c9d65aa1295a606278da0f8" "0340489fa0ccbfa05661bc5c8c19ee0ff95ab1d727e4cc28089b282d30df8fc8" "88267200889975d801f6c667128301af0bc183f3450c4b86138bfb23e8a78fb1" "c171012778b7cf795ac215b91e1ecab8e3946738d03095397a790ed41e0a3386" "17bd04719213ed7482ce37d8207f3618f55a81babe56484851ea5951ced383ef" "0af489efe6c0d33b6e9b02c6690eb66ab12998e2649ea85ab7cfedfb39dd4ac9" "046a2b81d13afddae309930ef85d458c4f5d278a69448e5a5261a5c78598e012" "7b8f5bbdc7c316ee62f271acf6bcd0e0b8a272fdffe908f8c920b0ba34871d98" default))
 '(package-selected-packages '(gruvbox-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
