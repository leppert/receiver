;;; receiver.el --- a quick and easy tunnel to listen to the outside world
;;
;; Public domain.

;;; Commentary:
;;
;; Requires beame-insta-ssl to be install.

;;; Code:
;;

(require 'json)
(require 'elnode)

(defgroup receiver nil
  "A quick and easy tunnel to listen to the outside world"
  :group 'tools)

(defcustom receiver-port 8010
  "The port number at which to listen."
  :group 'receiver
  :type 'integer)

(defcustom receiver-tunnel-command "beame-insta-ssl tunnel %p http"
  "The command to use to start the tunnel, where %p is replaced by the port."
  :group 'receiver
  :type 'string)

(defcustom receiver-tunnel-buffer-name "receiver"
  "Name for tunnel process buffer."
  :group 'receiver
  :type 'string)

(defcustom receiver-request-buffer-name "*HTTP Request*"
  "Name for request buffer."
  :group 'receiver
  :type 'string)

(defcustom receiver-response-code 200
  "The HTTP code to send in response."
  :group 'receiver
  :type 'integer)

(defcustom receiver-response-content-type "text/plain"
  "The content-type header to send in response."
  :group 'receiver
  :type 'string)

(defcustom receiver-response-body ""
  "The body to send in response."
  :group 'receiver
  :type 'string)

(defun receiver--handler (httpcon)
  "The elnode response handler.  HTTPCON: the elnode request map."
  (let* ((params (elnode-http-params httpcon))
         (json (car (car params))))
    (get-buffer-create receiver-request-buffer-name)
    (with-current-buffer receiver-request-buffer-name
      (save-excursion
        (erase-buffer)
        (princ json (current-buffer))
        (ignore-errors (json-pretty-print-buffer))
        (js-mode))))
  (elnode-http-start httpcon receiver-response-code '("Content-type" . receiver-response-content-type))
  (elnode-http-return httpcon receiver-response-body))

(defun receiver--start-tunnel ()
  "Start the tunnel connection."
  (start-process-shell-command receiver-tunnel-buffer-name
                               receiver-tunnel-buffer-name
                               (format-spec receiver-tunnel-command (format-spec-make ?p receiver-port))))

(defun receiver--kill-tunnel ()
  "Kill the tunnel connection."
  (ignore-errors (kill-process receiver-tunnel-buffer-name))
  (kill-buffer receiver-tunnel-buffer-name))

(defun receiver-listen ()
  "Start listening."
  (interactive)
  (elnode-start 'receiver--handler :port receiver-port)
  (receiver--start-tunnel)
  (message "receiver is listening on port %s" receiver-port))

(defun receiver-hangup ()
  "Stop listening."
  (interactive)
  (receiver--kill-tunnel)
  (elnode-stop receiver-port)
  (message "receiver hung up on port %s" receiver-port))

(provide 'receiver)

;;; receiver.el ends here
