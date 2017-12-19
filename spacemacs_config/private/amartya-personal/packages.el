;;; packages.el --- amartya-personal layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Amartya Bose <amartya@bose>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `amartya-personal-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `amartya-personal/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `amartya-personal/pre-init-PACKAGE' and/or
;;   `amartya-personal/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst amartya-personal-packages
  '(org org-ref unicode-fonts magithub)
  "The list of Lisp packages required by the amartya-personal layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")


(defun define-latex-classes ()
  (with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes
                 '("revtex"
                   "\\documentclass{revtex4-1}"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
    (add-to-list 'org-latex-classes
                 '("achemso"
                   "\\documentclass{achemso}"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))))

(defun my/org-ref-open-pdf-at-point ()
  "Open the pdf for bibtex key under point if it exists."
  (interactive)
  (let* ((results (org-ref-get-bibtex-key-and-file))
         (key (car results))
         (pdf-file (car (bibtex-completion-find-pdf key))))
    (if (file-exists-p pdf-file)
        (funcall bibtex-completion-pdf-open-function pdf-file)
      (message "No PDF found for %s" key))))

(defun setup-org-latex ()
  (require 'org)
  (require 'ox-latex)
  (require 'ox-beamer)
  (spacemacs/set-leader-keys-for-major-mode 'org-mode "ep" 'org-preview-latex-fragment)
  (add-to-list 'org-latex-default-packages-alist '("titletoc" "hyperref" "geometry" "amsmath" "amssym" "amsthm" "minted"))
  (setq org-latex-listings 'minted)
  (setq org-src-fontify-natively t)
  ;;(setq org-latex-pdf-process (list "latexmk -pdflatex='pdflatex -shell-escape -interaction nonstopmode' -f -pdf %f"))
  ;;(setq org-latex-pdf-process (list "latexmk -pdflatex='xelatex -shell-escape -interaction nonstopmode' -f -pdf %f"))
  (setq org-latex-compiler "xelatex")
  (setq org-latex-prefer-user-labels t)
  (setq org-latex-hyperref-template
        (concat "\\hypersetup {\n"
                "pdfauthor={%a},\n"
                "pdftitle={%t},\n"
                "pdfkeywords={%k},\n"
                "pdflang={%L},\n"
                "colorlinks,\n"
                "urlcolor=blue,\n"
                "linkcolor=blue\n"
                "}"))
  (define-latex-classes)
  (add-to-list 'org-beamer-environments-extra '("onlyenv" "O" "\\begin{onlyenv}%a" "\\end{onlyenv}"))
  )

(defun setup-org-planner ()
  (require 'org)
  (global-set-key (kbd "C-c c") 'org-capture)
  (setq org-agenda-files '("~/Dropbox/Org-mode"))
  (setq org-todo-keywords
        '((sequence "TODO" "IN-PROGRESS" "WAITING" "|" "DONE" "CANCELLED")))
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/Dropbox/Org-mode/Tasks.org" "Tasks")
           "* TODO %?\n  %i\n  %a")
          ("j" "Journal" entry (file+datetree "~/Dropbox/Org-mode/journal.org")
           "* %?\nEntered on %U\n  %i\n  %a")))
  )

(defun toggle-org-latex-export-on-save ()
  (interactive)
  (if (eq major-mode 'org-mode)
      (if (memq 'org-latex-export-to-pdf after-save-hook)
          (progn
            (remove-hook 'after-save-hook 'org-latex-export-to-pdf t)
            (message "Disabled org latex export on save for current buffer..."))
        (progn
          (add-hook 'after-save-hook 'org-latex-export-to-pdf nil t)
          (message "Enabled org latex export on save for current buffer...")))
    (message "Not in an org-mode buffer")))

(defun amartya-personal/post-init-org ()
  (use-package org
    :config
    (progn
      (add-to-list 'org-modules 'org-habits)
      (require 'org-habit)
      (add-hook 'org-mode-hook 'org-display-inline-images)
      (add-hook 'org-mode-hook 'spacemacs/toggle-truncate-lines-on)
      (add-hook 'org-mode-hook 'spacemacs/toggle-visual-line-navigation-on)
      (setq org-export-coding-system 'utf-8)
      (setup-org-planner)
      (setup-org-latex)
      )
    ))

(defun amartya-personal/post-init-org-ref ()
  (use-package org-ref
    :config
    (progn
      (setq org-ref-default-bibliography "/home/amartya/Documents/MendeleyDesktop/library.bib")
      (setq org-ref-pdf-directory "/home/amartya/Documents/MendeleyDesktop/")
      (setq org-ref-open-pdf-function 'org-ref-get-mendeley-filename)
      )))

(defun my/init-fonts (&optional frame)
  (when (display-graphic-p frame)
    (select-frame frame)
    (unicode-fonts-setup)
    (remove-hook 'after-make-frame-functions 'my/init-fonts)))

(defun amartya-personal/init-unicode-fonts ()
  (use-package unicode-fonts
    :ensure t
    :config
    (progn
      (add-hook 'after-init-hook
                (lambda ()
                  (if initial-window-system
                      (my/init-fonts)
                    (add-hook 'after-make-frame-functions 'my/init-fonts)))))))

(defun amartya-personal/init-magithub ()
  (use-package magithub
    :after magit
    :config (magithub-feature-autoinject t)))

;;; packages.el ends here
