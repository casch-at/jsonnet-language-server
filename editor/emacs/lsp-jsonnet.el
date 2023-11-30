;;; lsp-jsonnet.el --- jsonnet-language-server support       -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'jsonnet-mode)
(require 'lsp-mode)


(defcustom lsp-jsonnet-executable "jsonnet-language-server"
  "jsonnet-language-server executable."
  :group 'lsp-jsonnet
  :type 'string
  :risky t)

;; TODO(cschwarzgruber):[doc] can be set via env too
(defcustom lsp-jsonnet-path '()
  "Additional library search path."
  :type '(repeat string)
  :group 'lsp-jsonnet)

;; Configure lsp-mode language identifiers.
(add-to-list 'lsp-language-id-configuration '(jsonnet-mode . "jsonnet"))

(lsp-register-custom-settings
 '(("jsonnet.path" lsp-jsonnet-path)))

;; Register jsonnet-language-server with the LSP client.
(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection
                   (lambda ()
                     (cons lsp-jsonnet-executable
                           (mapcar (lambda (path) (list "--jpath" path)) (lsp-configuration-section "jsonnet.path")))))
  :activation-fn (lsp-activate-on "jsonnet")
  :initialized-fn (lambda (workspace)
                    (with-lsp-workspace workspace
                      (lsp--set-configuration
                       (lsp-configuration-section "jsonnet"))))
  :server-id 'jsonnet))

;; Start the language server whenever jsonnet-mode is used.
(add-hook 'jsonnet-mode-hook #'lsp-deferred)

(provide 'lsp-jsonnet)
;;; lsp-jsonnet.el ends here
