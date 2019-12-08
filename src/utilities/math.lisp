(in-package #:lisp-tracer-utilities)

(defparameter *epsilon* 0.00001)

(defun eq? (a b)
  (< (abs (- a b)) *epsilon*))

(defgeneric add (term1 term2)
  (:documentation "Adding datastructures together")
  (:method ((x number) (y number))
    (+ x y))
  (:method ((x list) (y list))
    (map 'list #'+ x y)))

(defgeneric sub (term1 term2)
  (:documentation "Subtracting datastructures")
  (:method ((x number) (y number))
    (- x y))
  (:method ((x list) (y list))
    (map 'list #'- x y)))

(defgeneric mult (term1 term2)
  (:documentation "Multiplying datastructures with scalar")
  (:method ((x number) (y number))
    (* x y))
  (:method ((x list) (y number))
    (map 'list (lambda (element)
                 (* element y))
         x)))

(defgeneric div (term1 term2)
  (:documentation "Multiplying datastructures with scalar")
  (:method ((x number) (y number))
    (/ x y))
  (:method ((x list) (y number))
    (map 'list (lambda (element)
                 (float (/ element y)))
         x)))

(defgeneric equal? (a b)
  (:documentation "Checking for unsafe equality")
  (:method ((a number) (b number))
    (eq? a b))
  (:method ((a list) (b list))
    (every (lambda (x y) (eq? x y))
           a
           b)))

(defgeneric neg (tuple)
  (:documentation "Negates provided value")
  (:method ((x number))
    (- x))
  (:method ((x list) )
    (map 'list #'- x)))

(defun magnitude (vec)
  (->> vec
       (map 'list (lambda (x) (* x x)))
       (reduce '+ )
       (sqrt)))

(defun normalize (vec)
  (tuple (div (x vec) (magnitude vec))
         (div (y vec) (magnitude vec))
         (div (z vec) (magnitude vec))
         (div (w vec) (magnitude vec))))

(defun dot (a b)
  (->> (map 'list #'list a b)
       (map 'list #'(lambda (x) (reduce #'* x)))
       (reduce #'+)))

(defun cross (a b)
  (vec (- (* (y a) (z b))
          (* (z a) (y b)))
       (- (* (z a) (x b))
          (* (x a) (z b)))
       (- (* (x a) (y b))
          (* (y a) (x b)))))
