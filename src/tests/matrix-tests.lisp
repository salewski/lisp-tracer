(in-package #:lisp-tracer-tests)

(deftest matrix-testing
  (testing "Constructing and inspecting a 4x4 matrix"
    (let ((matrix (create-matrix '(1 2 3 4
                                 5.5 6.5 7.5 8.5
                                 9 10 11 12
                                 13.5 14.5 15.5 16.6))))
      (ok (= (m matrix 0 0) 1))
      (ok (= (m matrix 0 3) 4))
      (ok (= (m matrix 1 0) 5.5))
      (ok (= (m matrix 1 2) 7.5))
      (ok (= (m matrix 2 2) 11))
      (ok (= (m matrix 3 0) 13.5))
      (ok (= (m matrix 3 2) 15.5)))))

(deftest matrix-equality
  (testing "Matrix equality with identical matrices"
    (let ((a (create-matrix '(1 2 3 4 5 6 7 8 9 8 7 6 5 4 3 2)))
          (b (create-matrix '(1 2 3 4 5 6 7 8 9 8 7 6 5 4 3 2))))
      (ok (equal? a b))))
  (testing "Matrix equality with different matrices"
    (let ((a (create-matrix '(1 2 3 4 5 6 7 8 9 8 7 6 5 4 3 2)))
          (b (create-matrix '(1 2 3 4 5 9 9 8 9 8 7 6 5 4 3 2))))
      (ng (equal? a b)))))

(deftest matrix-math
  (testing "Multiplying two matrices"
    (let ((a (create-matrix '(1 2 3 4 5 6 7 8 9 8 7 6 5 4 3 2)))
          (b (create-matrix '(-2 1 2 3 3 2 1 -1 4 3 6 5 1 2 7 8)))
          (a*b (create-matrix '(20 22 50 48 44 54 114 108 40 58 110 102 16 26 46 42))))
      (ok (equal? (mult a b) a*b))))
  (testing "Multiplying matrix by a tuple"
    (let ((a (create-matrix '(1 2 3 4 2 4 4 2 8 6 4 1 0 0 0 1)))
           (b (create-tuple 1 2 3 1)))
      (ok (equal? (mult a b) (create-tuple 18 24 33 1)))))
  (testing "Multiplying matrix by identity matrix"
    (let ((a (create-matrix '(0 1 2 4 1 2 4 8 2 4 8 16 4 8 16 32)))
          (id-matrix (identity-matrix)))
      (ok (equal? (mult a id-matrix) a)))))

(deftest transposing-matrix
  (testing "Transposing a matrix"
    (let ((a (create-matrix '(0 9 3 0 9 8 0 8 1 8 5 3 0 0 5 8)))
          (b (create-matrix '(0 9 1 0 9 8 8 0 3 0 5 5 0 8 3 8))))
      (ok (equal? (transpose a) b))))
  (testing "Transposing the identity matrix"
    (let ((a (transpose (identity-matrix))))
      (ok (equal? a (identity-matrix))))))

(deftest invert-matrix
  (testing "Calculating the inverse of a matrix"
    (let* ((a (create-matrix '(-5 2 6 -8 1 -5 1 8 7 7 -6 -7 1 -3 7 4)))
           (b (inverse a)))
      (ok (equal? (m b 3 2) (div -160 532)))
      (ok (equal? (m b 2 3) (div 105 532)))
      (ok (equal? b (create-matrix '(0.21805 0.45113 0.24060 -0.04511
                                     -0.80827 -1.45677 -0.44361 0.52068
                                     -0.07895 -0.22368 -0.05263 0.19737
                                     -0.52256 -0.81391 -0.30075 0.30639)))))))

(deftest calculating-iverses
  (testing "Calculating the inverse of another matrix"
    (let* ((a (create-matrix '(8 -5 9 2 7 5 6 1 -6 0 9 6 -3 0 -9 -4)))
           (inverted (inverse a))
           (result-matrix (create-matrix '(-0.15385 -0.15385 -0.28205 -0.53846
                                         -0.07692 0.12308 0.02564 0.03077
                                          0.35897 0.35897 0.43590 0.92308
                                         -0.69231 -0.69231 -0.76923 -1.92308))))
      (ok (equal? inverted result-matrix)))))

(deftest calculating-iverses-2
  (testing "Calculating the inverse of a third matrix"
    (let* ((a (create-matrix '(9 3 0 9 -5 -2 -6 -3 -4 9 6 4 -7 6 6 2)))
           (inverted (inverse a))
           (result-matrix (create-matrix '(-0.04074 -0.07778 0.14444 -0.22222
                                         -0.07778 0.03333 0.36667 -0.33333
                                         -0.02901 -0.14630 -0.10926 0.12963
                                         0.17778 0.06667 -0.26667 0.33333))))
      (ok (equal? inverted result-matrix)))))

(deftest multiplying-matrices-inversion
  (testing "Multiplying a product by its inverse"
    (let* ((a (create-matrix '(3 -9 7 3 3 -8 2 -9 -4 4 4 1 -6 5 -1 1)))
           (b (create-matrix '(8 2 2 2 3 -1 7 0 7 0 5 4 6 -2 0 5)))
           (c (mult a b)))
      (ok (equal? a (mult c (inverse b)))))))

(deftest translate-matrix
  (testing "Multiplying by a translation matrix"
    (let ((transform (translation 5 -3 2))
          (p (make-point -3 4 5)))
      (ok (equal? (mult transform p) (make-point 2 1 7)))))
  (testing "Multiplying by the inverse of a translation matrix"
    (let* ((transform (translation 5 -3 2))
           (inv (inverse transform))
           (p (make-point -3 4 5)))
      (ok (equal? (mult inv p) (make-point -8 7 3)))))
  (testing "Translation does not affect vectors"
    (let ((transform (translation 5 -3 2))
          (v (make-vec -3 4 5)))
      (ok (equal? (mult transform v) v)))))

(deftest scaling-matrix
  (testing "A scaling matrix applied to a point"
    (let ((transform (scaling 2 3 4))
          (p (make-point -4 6 8)))
      (ok (equal? (mult transform p) (make-point -8 18 32)))))
  (testing "A scaling matrix applied to a vector"
    (let ((transform (scaling 2 3 4))
          (v (make-vec -4 6 8)))
      (ok (equal? (mult transform v) (make-vec -8 18 32)))))
  (testing "Multiplying by the inverse of a scaling matrix"
    (let* ((transform (scaling 2 3 4))
           (inv (inverse transform))
           (v (make-vec -4 6 8)))
      (ok (equal? (mult inv v) (make-vec -2 2 2)))))
  (testing "Reflection is scaling by a negative value"
    (let ((transform (scaling -1 1 1))
          (p (make-point 2 3 4)))
      (ok (equal? (mult transform p) (make-point -2 3 4))))))

(deftest rotation-x-axis
  (testing "Rotating a point around the x axis"
    (let ((p (make-point 0 1 0))
          (half-quarter (rotation-x (div pi 4)))
          (full-quarter (rotation-x (div pi 2))))
      (ok (equal? (mult half-quarter p) (make-point 0
                                                    (div (sqrt 2) 2)
                                                    (div (sqrt 2) 2))))
      (ok (equal? (mult full-quarter p) (make-point 0 0 1)))))
  (testing "The inverse of an x-rotation rotates in the opposite direction"
    (let* ((p (make-point 0 1 0))
           (half-quarter (rotation-x (div pi 4)))
           (inv (inverse half-quarter)))
      (ok (equal? (mult inv p) (make-point 0
                                           (div (sqrt 2) 2)
                                           (- (div (sqrt 2) 2))))))))

(deftest rotation-y-axis
  (testing "Rotating a point around the y axis"
    (let ((p (make-point 0 0 1))
          (half-quarter (rotation-y (div pi 4)))
          (full-quarter (rotation-y (div pi 2))))
      (ok (equal? (mult half-quarter p) (make-point (div (sqrt 2) 2)
                                                    0
                                                    (div (sqrt 2) 2))))
      (ok (equal? (mult full-quarter p) (make-point 1 0 0))))))

(deftest rotation-z-axis
  (testing "Rotating a point around the z axis"
    (let ((p (make-point 0 1 0))
          (half-quarter (rotation-z (div pi 4)))
          (full-quarter (rotation-z (div pi 2))))
      (ok (equal? (mult half-quarter p) (make-point (- (div (sqrt 2) 2))
                                                    (div (sqrt 2) 2)
                                                    0)))
      (ok (equal? (mult full-quarter p) (make-point -1 0 0))))))

(deftest shearing
  (testing "A shearing transformation moves x in proportion to y"
    (let ((transform (shearing 1 0 0 0 0 0))
          (p (make-point 2 3 4)))
      (ok (equal? (mult transform p) (make-point 5 3 4)))))
  (testing "A shearing transformation moves x in proportion to z"
    (let ((transform (shearing 0 1 0 0 0 0))
          (p (make-point 2 3 4)))
      (ok (equal? (mult transform p) (make-point 6 3 4)))))
  (testing "A shearing transformation moves y in proportion to x"
    (let ((transform (shearing 0 0 1 0 0 0))
          (p (make-point 2 3 4)))
      (ok (equal? (mult transform p) (make-point 2 5 4)))))
  (testing "A shearing transformation moves y in proportion to z"
    (let ((transform (shearing 0 0 0 1 0 0))
          (p (make-point 2 3 4)))
      (ok (equal? (mult transform p) (make-point 2 7 4)))))
  (testing "A shearing transformation moves z in proportion to x"
    (let ((transform (shearing 0 0 0 0 1 0))
          (p (make-point 2 3 4)))
      (ok (equal? (mult transform p) (make-point 2 3 6)))))
  (testing "A shearing transformation moves z in proportion to y"
    (let ((transform (shearing 0 0 0 0 0 1))
          (p (make-point 2 3 4)))
      (ok (equal? (mult transform p) (make-point 2 3 7))))))

(deftest matrix-composing
  (testing "Individual transformations are applied in sequence"
    (let* ((p (make-point 1 0 1))
           (a (rotation-x (div pi 2)))
           (b (scaling 5 5 5))
           (c (translation 10 5 7))
           (p2 (mult a p))
           (p3 (mult b p2))
           (p4 (mult c p3)))
      (ok (equal? p4 (make-point 15 0 7)))))
  (testing "Chained transformations must be applied in reverse order"
    (let* ((p (make-point 1 0 1))
           (a (rotation-x (div pi 2)))
           (b (scaling 5 5 5))
           (c (translation 10 5 7))
           (transformed (reduce #'mult (list c b a p))))
      (ok (equal? transformed (make-point 15 0 7))))))
