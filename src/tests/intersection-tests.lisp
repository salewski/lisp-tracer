(in-package #:lisp-tracer-tests)

(deftest intersection-test
  (testing "An intersection encapsulates time and object"
    (let* ((s (make-sphere))
           (i (make-intersection 3.5 s)))
      (ok (equal? (tt i) 3.5))
      (ok (eq (object i) s)))))

(deftest aggregating-intersections
  (testing "Aggregating intersections"
    (let* ((s (make-sphere))
           (i1 (make-intersection 1 s))
           (i2 (make-intersection 2 s))
           (xs (intersections i1 i2)))
      (ok (equal? (length xs) 2))
      (ok (equal? (tt (first xs)) 1))
      (ok (equal? (tt (second xs)) 2)))))

(deftest hit-testing
  (testing "The hit, when all intersections have positive t"
    (let* ((s (make-sphere))
           (i1 (make-intersection 1 s))
           (i2 (make-intersection 2 s))
           (xs (intersections i2 i1))
           (i (hit xs)))
      (ok (eq i i1))))
  (testing "The hit, when some intersections have negative t"
    (let* ((s (make-sphere))
           (i1 (make-intersection -1 s))
           (i2 (make-intersection 2 s))
           (xs (intersections i2 i1))
           (i (hit xs)))
      (ok (eq i i2))))
  (testing "The hit, when all intersections have negative t"
    (let* ((s (make-sphere))
           (i1 (make-intersection -2 s))
           (i2 (make-intersection -1 s))
           (xs (intersections i2 i1))
           (i (hit xs)))
      (ok (null i))))
  (testing "The hit is always the lowest nonnegative intersection"
    (let* ((s (make-sphere))
           (i1 (make-intersection 5 s))
           (i2 (make-intersection 7 s))
           (i3 (make-intersection -3 s))
           (i4 (make-intersection 2 s))
           (xs (intersections i1 i2 i3 i4))
           (i (hit xs)))
      (ok (eq i i4)))))
