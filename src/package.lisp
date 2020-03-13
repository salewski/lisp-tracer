(defpackage #:lisp-tracer
  (:use #:cl
        #:iterate
        #:arrows)
  (:export
   #:add
   #:ambient
   #:black
   #:blue
   #:canvas
   #:canvas-to-ppm
   #:cofactor
   #:color
   #:cross
   #:determinant
   #:diffuse
   #:direction
   #:div
   #:dot
   #:epsilon
   #:equal?
   #:green
   #:height
   #:hit
   #:identity-matrix
   #:intensity
   #:intersect
   #:intersection
   #:intersections
   #:inverse
   #:invertible?
   #:lighting
   #:m
   #:magnitude
   #:make-canvas
   #:make-color
   #:make-intersection
   #:make-material
   #:make-matrix
   #:create-matrix
   #:matrix-grid
   #:make-point
   #:make-ray
   #:make-sphere
   #:create-tuple
   #:make-vec
   #:mapcolor
   #:mapnumber
   #:maptuple
   #:material
   #:material-color
   #:matrix
   #:minor
   #:mult
   #:neg
   #:normal-at
   #:normalize
   #:object
   #:origin
   #:pixel-at
   #:point
   #:point-light
   #:point?
   #:pos
   #:posit
   #:ray
   #:red
   #:reflect
   #:rotation-x
   #:rotation-y
   #:rotation-z
   #:scaling
   #:set-transform
   #:shearing
   #:shininess
   #:specular
   #:sphere
   #:sphere-material
   #:sub
   #:submatrix
   #:to-pixel
   #:transform
   #:transform-matrix
   #:transform-object
   #:translation
   #:transpose
   #:tt
   #:tuple
   #:tuple-to-list
   #:vec
   #:vec?
   #:width
   #:write-pixel
   #:tuple-x
   #:tuple-y
   #:tuple-z
   #:tuple-w
   #:zerovec))
