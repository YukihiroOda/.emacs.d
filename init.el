;;; init.el --- This is  my init.el
;;; Commentary:
;; This is my init.el.

;;; Code:
;; this enables this running method
;; emacs -q -l ~/.debug.emacs.d/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file)
				)
	   )
	  )
    )
  )

;;leaf settings ---------------
(eval-and-compile
  (customize-set-variable
   'package-archives '(
		       ("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
		       ("melpa-stable" . "https://stable.melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")
		       )
   )
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf)
    )

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)
    )
  )

;; leaf-convert and leaf-tree ----------------
(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom (
	     (imenu-list-size . 30)
             (imenu-list-position . 'left)
	     )
    )
  )

;; macrostep ----------------
(leaf macrostep
  :ensure t
  :bind (
	 ("C-c e" . macrostep-expand)
	 )
  )

;; custom-set-variables ------------------
(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `(
	    (custom-file . ,(locate-user-emacs-file "custom.el")
			 )
	    )
  )
(leaf custom-set-variables
  :custom (
	   (eww-search-prefix . "https://www.google.com/search?q=-sejuku+-wa3.i-3-i.info+")
	   (inhibit-startup-screen . t)
	   (js-indent-level . 2)
	   (make-backup-files)
	   (tool-bar-mode)
	   (fill-column . 100)
	   )
  )

;; autorevert --------------
(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom (
	   (auto-revert-interval . 1)
	   )
  :global-minor-mode global-auto-revert-mode
  )

;; cc-mode
(leaf cc-mode
  :doc "major mode for editing C and similar languages"
  :tag "builtin"
  :defvar (c-basic-offset)
  :bind (c-mode-base-map
         ("C-c c" . compile)
	 )
  :mode-hook
  (c-mode-hook . (
		  (c-set-style "gnu")
                  (setq c-basic-offset 2)
		  (setq c-tab-always-indent t)
		  )
	       )
  (c++-mode-hook . (
		    (c-set-style "gnu")
                    (setq c-basic-offset 2)
		    (setq c-tab-always-indent t)
		    )
		 )
  )

;; kill-ring
(leaf simple
  :doc "basic editing commands for Emacs"
  :tag "builtin" "internal"
  :custom (
	   (kill-ring-max . 100)
           (kill-read-only-ok . t)
           (kill-whole-line . t)
           (eval-expression-print-length . nil)
           (eval-expression-print-level . nil)
	   )
  )

;; ivy
(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom (
	   (ivy-initial-inputs-alist . nil)
           (ivy-use-selectable-prompt . t)
	   )
  :global-minor-mode t
  :config
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.0"
    :tag "matching" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :bind (
	   ("C-s" . swiper)
	   )
    )

  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "swiper-0.13.0"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :blackout t
    :bind (
	   ("C-S-s" . counsel-imenu)
           ("C-x C-r" . counsel-recentf)
	   )
    :custom `(
	      (counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)
					       )
	      )
    :global-minor-mode t)
  (leaf counsel-gtags
    :emacs>= 24.5
    :ensure t
    :bind (
	   ("M-t" . counsel-gtags-find-definition)
	   ("M-r" . counsel-gtags-find-reference)
	   ("M-s" . counsel-gtags-find-symbol)
	   ("M-," . counsel-gtags-go-backword)
	   )
    )
  )

(mapc

    (lambda (hook)
   (add-hook hook
	     (lambda nil
	       (counsel-gtags-mode 1)
	       )
	     )
   )
 '( ;; counsel-gtags-mode
   c-mode-hook c++-mode-hook
	       )
 )

(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :custom ((prescient-aggressive-file-save . t))
  :global-minor-mode prescient-persist-mode)
  
(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom (
	   (ivy-prescient-retain-classic-highlighting . t)
	   )
  :global-minor-mode t)

;; Which-key
(leaf which-key
  :ensure which-key
  :commands which-key-mode
  :global-minor-mode which-key-mode
  )

;; Free-key
(leaf free-keys
  :ensure free-keys
  )

;; volatile-highlights ----------------
(leaf volatile-highlights
  :ensure volatile-highlights
  :config
  (volatile-highlights-mode t)
  )

;; highlight-indent-guide ----------------
(leaf highlight-indent-guides
  :ensure t
  :blackout t
  :hook (
	 (
	  (prog-mode-hook yaml-mode-hook) . highlight-indent-guides-mode
	  )
	 )
  :custom (
           (highlight-indent-guides-method . 'character)
           (highlight-indent-guides-auto-enabled . t)
           (highlight-indent-guides-responsive . t)
           (highlight-indent-guides-character . ?|)
	   )
  )

;; rainbow-delimiters
(leaf rainbow-delimiters
  :ensure t
  :hook
  (
   (prog-mode-hook       . rainbow-delimiters-mode)
   )
  )

;; whitespace
(leaf whitespace
  :ensure t
  :commands whitespace-mode
  :bind ("C-c W" . whitespace-cleanup)
  :custom (
	   (whitespace-style . '(face
                                trailing
                                tabs
                                spaces
                                empty
                                space-mark
                                tab-mark)
			     )
           (whitespace-display-mappings . '(
					    (space-mark ?　 [?□])
                                            (tab-mark ?	 [?» ?	] [?\ ?	])
					    )
					)
           (whitespace-space-regexp . "\(　+\)")
           (whitespace-global-modes .
	     '(emacs-lisp-mode shell-script-mode sh-mode python-mode yatex-mode cc-mode)
				    )
           (global-whitespace-mode . t)
	   )

  :config
  (set-face-attribute 'whitespace-trailing nil
                      :background "Black"
                      :foreground "DeepPink"
                      :underline t)
  (set-face-attribute 'whitespace-tab nil
                      :background "Black"
                      :foreground "LightSkyBlue"
                      :underline t)
  (set-face-attribute 'whitespace-space nil
                      :background "Black"
                      :foreground "GreenYellow"
                      :weight 'bold)
    (set-face-attribute 'whitespace-empty nil
                      :background "Black")
  )

;; py-isort
(leaf py-isort :ensure t)

;;elscreen -----------------------
(leaf elscreen
  :ensure t
  :bind (
	 ("<f9>" . elscreen-toggle)
	 )
  :config
  (setq elscreen-prefix-key (kbd "C-<f9>")
	)
  )
(elscreen-start)


;; Settings for magit -------------------
(leaf magit
  :ensure magit
  :setq (
	 (magit-completing-read-function quote ivy-completing-read)
	 )
  :bind (
	 ("C-x g" . magit-status)
	 )
  )

;; To use git-gutter -----------------
(leaf git-gutter
  ;; :when (require 'git-gutter nil t)
  :ensure git-gutter
  :global-minor-mode  global-git-gutter-mode
  )

;; company -------------------------------
(leaf company
  :doc "Modular text completion framework"
  :req "emacs-24.3"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :url "http://company-mode.github.io/"
  :emacs>= 24.3
  :ensure t
  :blackout t
  :leaf-defer nil
  :bind (
	 (company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . company-complete-selection)
	  )
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
	  )
	 )
  :custom (
	   (company-idle-delay . 0)
           (company-minimum-prefix-length . 1)
           (company-transformers . '(company-sort-by-occurrence)
				 )
	   )
  :global-minor-mode global-company-mode
  )

(leaf company-c-headers
  :doc "Company mode backend for C/C++ header files"
  :req "emacs-24.1" "company-0.8"
  :tag "company" "development" "emacs>=24.1"
  :added "2020-03-25"
  :emacs>= 24.1
  :ensure t
  :after company
  :defvar company-backends
  :config
  (add-to-list 'company-backends 'company-c-headers)
  )


(leaf yasnippet
  :ensure t
  :blackout yas-minor-mode
  :custom ((yas-indent-line . 'fixed)
	   (yas-global-mode . t)
	   )
  :bind (
	 (yas-keymap
	  ("<tab>" . nil)
	  )            ; conflict with company
	 (yas-minor-mode-map
	  ("C-c y i" . yas-insert-snippet)
	  ("C-c y n" . yas-new-snippet)
	  ("C-c y v" . yas-visit-snippet-file)
	  ("C-c y l" . yas-describe-tables)
	  ("C-c y g" . yas-reload-all)))
  :config
  (leaf yasnippet-snippets :ensure t)
  (leaf yatemplate
    :ensure t
    :config
    (yatemplate-fill-alist)
    )
  (defvar company-mode/enable-yas t
    "Enable yasnippet for all backends.")
  (defun company-mode/backend-with-yas (backend)
    (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)
					       )
	    )
	backend
      (append (if (consp backend) backend (list backend)
		  )
	      '(:with company-yasnippet)
	      )
      )
    )
  (defun set-yas-as-company-backend ()
    (setq company-backends
	  (mapcar #'company-mode/backend-with-yas company-backends)
	  )
    )
  :hook
  (
   (company-mode-hook . set-yas-as-company-backend)
   )
  )



;; git-complete -------------------
(leaf git-complete
  :el-get zk-phi/git-complete
  :bind (
	 ("C-c C-c" . nil)
	 ("C-z" . git-complete)
	 )
  :setq (
	 (git-complete-enable-autopair . t)
	 )
  )

;; dumb-jump ------------------------
(leaf dumb-jump
  :ensure t
  :setq (
	 (dumb-jump-selector . 'ivy)
	 )
  :global-minor-mode dumb-jump-mode)

;; smart-jump ---------------------
(leaf smart-jump
 :ensure t
 :config
 (smart-jump-setup-default-registers)
 :bind (
	("s-g" . smart-jump-go)
	("s-b" . smart-jump-back)
	("s-?" . smart-jump-references)
	)
 )

;; elpy
(leaf elpy
  :ensure t
  :init (elpy-enable)
  :config
  (remove-hook 'elpy-modules 'elpy-module-highlight-indentation) ;; インデントハイライトの無効化
  (remove-hook 'elpy-modules 'elpy-module-flymake) ;; flymakeの無効化
  :custom
  (elpy-rpc-python-command . "python3") ;; https://mako-note.com/elpy-rpc-python-version/の問題を回避するための設定
  (flycheck-python-flake8-executable . "flake8")
  :bind (elpy-mode-map
         ("C-c C-r f" . elpy-format-code)
	 )
  :hook (
	 (elpy-mode-hook . flycheck-mode)
	 )
  )

(leaf virtualenvwrapper
  :ensure t
  :hook (
	 (python-mode-hook . virtualenvwrapper-activate)
	 )
  )
(leaf auto-virtualenvwrapper
  :ensure t
  :hook (
	 (python-mode-hook . auto-virtualenvwrapper-activate)
	 )
  )
;; YaTeX-mode ---------------------
(leaf yatex
  :ensure t
  :commands yatex-mode
  :mode "\\.tex$" "\\.ltx$" "\\.sty$"
  :mode-hook
  ;; yatex-mode-hook
  (yatex-mode-hook . (
		      (outline-minor-mode t)
		      (setq LaTeX-outline-regexp (concat "[ t]*"
							 (regexp-quote "")
							 "(appendix|documentstyle|part|chapter|" "section|subsection|subsubsection|" "paragraph|subparagraph)" "*?[ t]*[[{]")
			    )
		      (make-local-variable 'outline-regexp)
	      )
		   )
  :config
  (when (eq system-type 'gnu/linux)
    (setq dvi2-command "evince")
    )
  (when (or (eq system-type 'windows-nt) (eq system-type 'cygwin))
    (setq tex-pdfview-command "rundll32 shell32,ShellExec_RunDLL SumatraPDF -reuse-instance")
    )
  )
;; Default の tex-command を latexmk に
(setq tex-command "latexmk -c -gg -lualatex")
;; Default を utf-8 に
(setq YaTeX-kanji-code 4)
;; YaTeX キーバインドを C-c ? から C-c C-? に変更
(setq YaTeX-inhibit-prefix-letter t)
;; \section の背景の色を変更．(YaTeX-hilit-sectioning-face . '(light 時の forecolor/backcolor dark 時の forecolor/backcolor))
(setq YaTeX-hilit-sectioning-face '(black/cyan black/DeepSkyBlue))

(leaf yahtml
  ;;; YaHTML-mode
  :commands yahtml-mode
  :mode "\\.html$"
 )

;;; BibTeX-mode ---------------------------------------
(leaf BibTeX
  :setq (
	 (bibtex-user-optional-fields quote
				      (
				       ("annote" "Personal annotation (ignored)")
				       ("yomi" "Yomigana")
				       ("location" "where it is (ignored)")
				       ("memo" "Memorundum (ignored)")
				       )
				      )
	 )
  )

;; Settings for SATySFi ----------------
(leaf satysfi
  :el-get gfngfn/satysfi.el
  :commands satysfi-mode satysfi-command
  :mode "\\.saty$" "\\.satyh$"
  :setq (
	 ;; set the command for typesetting (default: "satysfi -b")
	 (satysfi-command . "satysfi")
	 )
  )


;; Settings for rust
(setq exec-path (cons (expand-file-name "~/bin") exec-path))
(setq exec-path (cons (expand-file-name "~/.cargo/bin") exec-path))

(leaf rust-mode
  :ensure t
  :commands rust-mode
  :mode "\\.rs$"
  )

(leaf cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode)
  )

(leaf lsp-mode
  :ensure t
  :hook (rust-mode . lsp)
  :bind ("C-c h" . lsp-describe-thing-at-point)
  :custom (lsp-rust-server 'rust-analyzer)
  )

(leaf lsp-ui
  :ensure t
  )

;; Settings for Coq ----------
(leaf proof-general
  :ensure t
  :commands coq-mode
  :mode "\\.v$"
  )

;;; flyspell-mode -------------
(leaf flyspell-mode
  :setq (
	 (ispell-list-command . "--list")
	 )
  :preface
  (mapc
   (lambda (hook)
   (add-hook hook 'flyspell-prog-mode)
   )
   '( ;; flyspell-mode for comments
     c-mode-common-hook emacs-lisp-mode-hook sh-mode-hook
			)
 )
  (mapc
   (lambda (hook)
     (add-hook hook
	     (lambda nil
	       (flyspell-mode 1)
	       )
	     )
     )
   '( ;; flyspell-mode  
     yatex-mode-hook bibtex-mode-hook git-commit-setup-hook git-commit-turn-on-flyspell
     org-mode-hook satysfi-mode-hook
     )
   )
  )
(leaf flyspell-correct-ivy
  :ensure t
  :bind (
	 ("<f6>" . flyspell-correct-at-point)
	 )
  )


;; flycheck---------------------------------------
(leaf flycheck
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
  :tag "minor-mode" "tools" "languages" "convenience" "emacs>=24.3"
  :url "http://www.flycheck.org"
  :emacs>= 24.3
  :ensure t
  :bind (
	 ("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error)
	 )
  :global-minor-mode global-flycheck-mode
  :config
  (leaf flycheck-grammarly :ensure t)
  )

;; evil-mode ----------------------------
(leaf evil
  :ensure t
  :bind (
	 ("C-M-?" . evil-mode)
	 )
  :config
  (leaf evil-surround
    :ensure t
    :hook (evil-mode-hook)
    :config
    (global-evil-surround-mode)
    (push '(?$ . ("$" . "$")) evil-surround-pairs-alist)
    )
  )

;; surround --------------------------
(leaf surround
  ;; :preface (el-get-bundle ganmacs/emacs-surround)
  :el-get ganmacs/emacs-surround
  :bind (
	 ("<f12>" . emacs-surround)
	 )
  :config
  (push ("$" . ("$" . "$")) emacs-surround-alist)
  )

;; Settings for Media Wiki
(leaf mediawiki
  :ensure t
  :mode "\\.mediawiki$" "\\.mw$"
  :bind (
	 (mediawiki-mode-map
	  ("C-x C-s" . save-buffer)
	  ("C-x <f12>" . mediawiki-save)
	  ("C-z" . mediawiki-insert-itemize )
	  ("C-\\" . toggle-input-method)
	  )
	 )
  :setq (
	 (browse-url-browser-function quote browse-url-generic)
	 )
  :config
  (setq mediawiki-mode-hook (lambda nil
			      (turn-off-auto-fill)
			      )
	)
  )
(when (file-exists-p "~/.emacs.d/secret")
(load "~/.emacs.d/secret/mediawikisettings.el")
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(leaf Language)
;;Language settings -------------
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)

(leaf my-keybind)
;; Change window previous
(global-set-key
 (kbd "C-x p")
 (lambda nil
   (interactive)
   (other-window -1)
   )
 )
(global-set-key
 (kbd "C-x m")
 'nil
 )
(global-set-key
 (kbd "C-x m")
 'compile
 )
(global-set-key
 (kbd "C-z")
 'nil)

(leaf settings-for-windows)
;; Settings to use only in Windows system.
(when (or (eq system-type 'windows-nt) (eq system-type 'cygwin))
  ;; To use Powershell.
  (leaf powershell
    :ensure t
    :commands powershell
    )
  ;; To use coq
  (setq coq-prog-name "C:/Program Files (x86)/Coq/bin/coqtop.exe")
  ;; To use utf-8 in Windows
  (unless (cl-member 'cp65001 coding-system-list)
    (define-coding-system-alias 'cp65001 'utf-8))
  ;; To use wsl
  (setq shell-file-name (executable-find "bash"))
  (setq grep-use-null-device nil)
  ;; To use aspell
  (setq-default ispell-program-name "~/.emacs.d/aspell.cmd")
  (with-eval-after-load "ispell"
  (add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))
  ;; フォント
  (set-face-attribute 'default nil :family "Yu Gothic" :height 125)
  )

(leaf settings-for-linux)
;; Settings to use only in Linux system.
(when (eq system-type 'gnu/linux)
  ;; 半角英字設定
  (set-face-attribute 'default nil :family "SourceHanSansHW" :height 120)
  ;; 全角かな設定
  (set-fontset-font (frame-parameter nil 'font)
                    'japanese-jisx0208
                    (font-spec :family "SourceHanSansHW" :size 17)
		    )
  ;; To use aspell
  (setq-default ispell-program-name "aspell")
  (with-eval-after-load "ispell"
    (add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")
		 )
    )
  ;; mozc
  (leaf mozc
    :require mozc
    :setq (
	   (default-input-method . "japanese-mozc")
	   (mozc-leim-title . "あ")
	   (mozc-candidate-style . 'echo-area)
	   )
    :config
    (add-hook 'input-method-activate-hook
	      (lambda nil
		(set-cursor-color "red")
		)
	      )
    (add-hook 'input-method-inactivate-hook
	      (lambda nil
		(set-cursor-color "black")
		)
	      )
    )
  )

;; Screen display control
(set-face-background 'mode-line-inactive "gray60")  

(leaf  global-hl-line-mode
  :config (set-face-background 'hl-line "lavender")
  :global-minor-mode global-hl-line-mode
  )

(leaf show-paren-mode
  :setq (
	 (show-paren-style quote mixed)
	 )
  :config (set-face-attribute 'show-paren-match nil :background "medium spring green")
  :global-minor-mode   show-paren-mode
  )

(leaf transient-mark-mode
  :config  (set-face-background 'region "Orange")
  :global-minor-mode transient-mark-mode
  )

;; Default screen size
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; I HATE BEEP
(setq visible-bell t)

(provide 'init)
;;; init.el ends here
