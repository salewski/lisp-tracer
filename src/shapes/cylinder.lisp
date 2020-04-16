(in-package #:lisp-tracer)

(defstruct (cylinder (:include shape))
  (closed nil :type t)
  (minimum sb-ext:double-float-negative-infinity :type double-float)
  (maximum sb-ext:double-float-positive-infinity :type double-float))

;;; TODO: Below macros are for readablilty of code. Find out
;;; how to make these nested accessors more general
(defmacro ray-direction-x ()
  `(tuple-x (ray-direction ray)))

(defmacro ray-direction-y ()
  `(tuple-y (ray-direction ray)))

(defmacro ray-direction-z ()
  `(tuple-z (ray-direction ray)))

(defmacro ray-origin-x ()
  `(tuple-x (ray-origin ray)))

(defmacro ray-origin-y ()
  `(tuple-y (ray-origin ray)))

(defmacro ray-origin-z ()
  `(tuple-z (ray-origin ray)))

(defmacro add-intersection? (t-val)
  `(let ((y (+ (ray-origin-y) (* ,t-val (ray-direction-y)))))
     (if (< (cylinder-minimum cylinder) y (cylinder-maximum cylinder))
         (setf xs (append xs (list (make-intersection :tt ,t-val :object cylinder)))))))

(declaim (inline check-cap))
(defun check-cap (ray tt)
  (let ((x (+ (ray-origin-x) (* tt (ray-direction-x))))
        (z (+ (ray-origin-z) (* tt (ray-direction-z)))))
    (<= (+ (expt x 2) (expt z 2)) 1.0)))

(defmacro add-caps-intersection? (min-or-max)
  `(let ((tt (/ (- ,min-or-max (ray-origin-y))
                (ray-direction-y))))
     (if (check-cap ray tt)
         (setf xs
               (append xs (list (make-intersection :tt tt :object cylinder)))))))

(defmacro add-caps-intersections? ()
  `(unless (or (not (cylinder-closed cylinder)) (equal? (ray-direction-y) 0.0))
     (add-caps-intersection? (cylinder-minimum cylinder))
     (add-caps-intersection? (cylinder-maximum cylinder))))

(defmethod local-intersect ((cylinder cylinder) (ray ray) &aux xs)
  (let* ((a (+ (expt (ray-direction-x) 2)
               (expt (ray-direction-z) 2))))
    (if (equal? a 0.0)
        ;;; This case handles whenever ray doesn't intersect sides.
        (add-caps-intersections?)
        (let* ((b (+ (* 2.0 (ray-origin-x) (ray-direction-x))
                     (* 2.0 (ray-origin-z) (ray-direction-z))))
               (c (- (+ (expt (ray-origin-x) 2) (expt (ray-origin-z) 2)) 1.0))
               (discriminant (- (expt b 2) (* 4.0 a c))))
          (unless (< discriminant 0)
            (let* ((-b (- b))
                   (sqrt-discriminant (sqrt discriminant))
                   (2a (* 2.0 a))
                   (t0 (/ (- -b sqrt-discriminant) 2a))
                   (t1 (/ (+ -b sqrt-discriminant) 2a)))
              (if (> t0 t1) (rotatef t0 t1))
              (add-intersection? t0)
              (add-intersection? t1)
              (add-caps-intersections?)
              xs))))))

(defmethod local-normal-at ((cylinder cylinder) (point tuple))
  (let ((distance (+ (expt (tuple-x point) 2) (expt (tuple-z point) 2))))
    (cond ((and (< distance 1.0)
                (>= (tuple-y point) (- (cylinder-maximum cylinder) epsilon)))
           (make-vec :x 0.0 :y 1.0 :z 0.0))
          ((and (< distance 1.0)
                (<= (tuple-y point) (+ (cylinder-minimum cylinder) epsilon)))
           (make-vec :x 0.0 :y -1.0 :z 0.0))
          (t (make-vec :x (tuple-x point) :y 0.0 :z (tuple-z point))))))
