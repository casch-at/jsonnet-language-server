;;; lsp-jsonnet.el --- jsonnet-language-server support       -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'jsonnet-mode)
(require 'lsp-mode)

(defcustom lsp-jsonnet-server-command '("jsonnet-language-server")
  "Command to start Jsonnet language server."
  :risky t
  :group 'lsp-jsonnet
  :type '(repeat string))

;; Configure lsp-mode language identifiers.
(add-to-list 'lsp-language-id-configuration '(jsonnet-mode . "jsonnet"))

;; Register jsonnet-language-server with the LSP client.
(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection
                   (lambda ()
                     lsp-jsonnet-server-command))
  :activation-fn (lsp-activate-on "jsonnet")
  :initialized-fn (lambda (workspace)
                    (with-lsp-workspace workspace
                      (lsp--set-configuration
                       ;; TODO: jsonnet-language-server settings should use a prefix
                       (ht-get (lsp-configuration-section "jsonnet") "jsonnet"))))
  :server-id 'jsonnet))

;; Start the language server whenever jsonnet-mode is used.
(add-hook 'jsonnet-mode-hook #'lsp-deferred)

(provide 'lsp-jsonnet)
;;; lsp-jsonnet.el ends here
