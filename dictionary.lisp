(defpackage #:dictionary
  (:use :common-lisp :digikar-utilities)
  (:export :in-dict-p
	   :add-to-dict
	   :clean-dict
	   :write-dict))

(in-package :dictionary)

(defvar *english*
  (with-open-file (f "~/quicklisp/local-projects/dictionary/english.dict")
		  (read f)))

(defun in-dict-p (word &optional (dict *english*))
  "Returns true, if word exists in dict."
  (cond ((nilp dict) nil)
	((= 0 (length word)) 
	 (if (member nil (cdr dict)) t nil))
	(t
	 (let ((sub-dict 
		(find-if (lambda (sub-dict)
			   (and sub-dict 
				(equal (first sub-dict) (get-val word 0))))
			 (cdr dict))))
	   (in-dict-p (subseq word 1) sub-dict)))))

(defun add-to-dict (word &optional (dict *english*))
  "Returns the modified dictionary. The modification is non-persistent.
Dictionary exists in the form of tries, implemented using lists.
NOTE: Begin an empty dict using '(0)."
  (cond ((and (nilp dict) (= 0 (length word))) '())
	((nilp dict)
	 (cons (get-val word 0)
	       (list (add-to-dict (subseq word 1) nil))))
	((= 0 (length word))
	 (cons (first dict)
	       (if (member '() (cdr dict))
		   (cdr dict)
		 (cons '() (cdr dict)))))
	(t
	 (let* ((not-inserted t)
		(rest-dict
		 (mapcar (lambda (sub-dict)
			   (if (and sub-dict
				    (equal (first sub-dict)
					   (get-val word 0))) 
			       (progn
				 (setq not-inserted nil)
				 (add-to-dict (subseq word 1) sub-dict))
			     sub-dict))
			 (cdr dict))))
	   (cons (first dict)
		 (if not-inserted 
		     (cons (add-to-dict word nil) rest-dict)
		   rest-dict))))))

(defun clean-dict (input-file output-file)
  "Keeps words starting with lowercase letters only."
  (with-open-file
   (f input-file :direction :input)
   (with-open-file
    (out output-file
	 :direction :output
	 :if-does-not-exist :create
	 :if-exists :supersede)
    (loop for line = (ignore-errors (read-line f t))
	  while line
	  if (lower-case-p (get-val line 0))
	  do 
	  (format out line)
	  (terpri out)))))

(defun write-dict (input-file output-file &optional (verbose t))
  (with-open-file
   (f input-file :direction :input)
   (with-open-file
    (out output-file :direction :output
	 :if-exists :supersede
	 :if-does-not-exist :create)
    (let ((dict '(0))
	  (line-no 0))
      (loop for line = (ignore-errors (read-line f t))
	    while line do
	    (setq dict (add-to-dict line dict))
	    (incf line-no)
	    (if (and verbose (= 0 (rem line-no 10000)))
		(format t "Currently on line ~d...~%" line-no)))
      (format out (write-to-string dict))))))

;;(clean-file "english.txt" "english-cleaned.txt")
;;(write-dict "english-cleaned.txt" "english.dict")


