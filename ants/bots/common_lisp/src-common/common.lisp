;;;; common.lisp

(in-package :ants-common)


;;; Functions

(defun current-date-time-string ()
  (multiple-value-bind (sec min hour day month year)
      (get-decoded-time)
    (format nil "~D-~2,'0D-~2,'0D ~2,'0D:~2,'0D:~2,'0D"
            year month day hour min sec)))


(defun errmsg (&rest args)
  (declare (ignore args))
  (error "You need to redefine ERRMSG in your own package."))


(defun host2str (host)
  (cond ((and (vectorp host) (= 4 (length host)))
         (format nil "~D.~D.~D.~D" (elt host 0) (elt host 1) (elt host 2)
                 (elt host 3)))
        (t host)))


(defun logmsg (&rest args)
  (declare (ignore args))
  (error "You need to redefine LOGMSG in your own package."))


(defun mkstr (&rest args)
  (with-output-to-string (s)
    (dolist (a args)
      (princ a s))))


(defun par-value (string)
  (parse-integer (subseq string (position #\space string) (length string))))


(defun print-game-map (game-map &optional (stream *debug-io*))
  (loop with dim = (array-dimensions game-map)
        for col from 0 below (second dim)
        initially (princ #\space stream)
                  (princ #\space stream)
        do (princ (mod col 10) stream)
        finally (terpri stream))
  (loop with dim = (array-dimensions game-map)
        for row from 0 below (first dim)
        do (princ (mod row 10) stream)
           (princ #\space stream)
           (loop for col from 0 below (second dim)
                 for val = (aref game-map row col)
                 do (cond ((= val 0) (princ #\. stream))
                          ((= val 1) (princ #\% stream))
                          ((= val 2) (princ #\* stream))
                          ((>= val 200) (princ (code-char (- val 135)) stream))
                          ((>= val 100) (princ (code-char (- val 3)) stream))
                          (t (princ #\? stream))))
           (terpri stream)))


(defun starts-with (sequence subsequence)
  (let ((sublen (length subsequence)))
    (when (and (> sublen 0)
               (<= sublen (length sequence)))
      (equal (subseq sequence 0 sublen) subsequence))))


(let ((time-units (/ 1.0 internal-time-units-per-second)))
  (defun wall-time (&key (offset 0))
    (+ (* (get-internal-real-time) time-units)
       offset)))
