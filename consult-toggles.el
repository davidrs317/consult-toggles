;; consult-toggles --- interface to toggle consult variables -*- lexical-binding: t; -*-

;; Author: David Sullivan <devel@sullatrix.us>
;; URL: https://github.com/davidrs317
;; Created: January 23, 2026
;; Keywords: consult, toggle
;; Package-Requires: ((emacs "29.1") (consult "3.2"))
;; Version 0.1

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation (FSF), either version 3 of the License,
;; or (at the option of the reader) any later version.

;; This program is distributefd in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;; A copy of the GNU General Public License should have been received
;; along with this program. If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package adds a quick way to toggle the `consult-project-function'
;; variable. This will allow for more methods to configure functions like
;; `consult-grep' and `consult-ripgrep' which rely on `consult-project-function'
;; to determine what to set their default directory to. This could be expanded
;; further to add toggle-ability to other consult variables as well.

;;; Code:

(require 'consult) ;; consult-project-function

(defgroup consult-toggle nil
  "Add additional toggle-ability to `consult'."
  :group 'consult
  :prefix "consult-toggle-")

(defcustom consult-toggle-project-function-list '(#'consult--default-project-function)
  "List of functions that `consult-project-function' can be set to."
  :type `(repeat function))

(defun consult-toggle-add-project-function (fn)
  "Add FN to the toggle list.
If called interactively, function will prompt for user input."
  (interactive
   (let* ((add-fn (intern (read-string "Project Function to add: "))))
	 (list add-fn)))
  (if (functionp fn)
	  (push fn consult-toggle-project-function-list)
	(message "cannot add %s to list as it is not a function" fn)))

(defun consult-toggle-remove-project-function (fn)
  "Remove FN from the toggle list.
If called interactively, function will prompt for user input."
  (interactive
   (let ((rem-fn (intern (completing-read "Project Function to remove: "
								  consult-toggle-project-function-list))))
	 (list rem-fn)))
  (cond ((eq fn #'consult--default-project-function)
		 (message "do not remove default project function"))
		((<= (length consult-toggle-project-function-list) 1)
		 (message "project function list should contain at least one element"))
		(t (setq consult-toggle-project-function-list (delq fn consult-toggle-project-function-list)))))

(defun consult-toggle-project-function ()
  "Toggle consult project function to function provided in `completing-read' list."
  (interactive
   (let ((fn (completing-read "Project Function: "
							  consult-toggle-project-function-list)))
	 (setq consult-project-function fn))))
(provide 'consult-toggles)

;;; consult-toggles.el ends here
