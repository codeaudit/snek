#!/usr/bin/sbcl --script

(load "../src/load")

(setf *print-pretty* t)
(setf *random-state* (make-random-state t))

; note that this does not use the snek structure.


(defun main (size fn)
  (let ((rad 0.07d0)
        (rep 5)
        (box-rep 10)
        (left 150)
        (right 850)
        (plt (plot:make size)))

    (let ((ddd (math:make-perspective-transform
                 (rnd:in-box 500 500 :xy (vec:vec -500d0 500d0))
                 (rnd:in-box 500 500 :xy (vec:vec 1500d0 500d0))
                 (rnd:in-box 500 500 :xy (vec:vec 500d0 1500d0)))))
      (loop for x in (math:linspace rep left right) do
        (loop for y in (math:linspace rep left right) do
          (let ((points (funcall ddd
                          (vec:vec x y) rad rad (half rad) (half rad))))
            (let ((top (subseq points 0 5))
                  (bottom (subseq points 5 10)))
              (loop for s in (math:linspace box-rep 0.0 1.0) do
                (plot:path plt
                   (loop for a in top
                     for b in bottom
                     collect (math:on-line s a b)))))))))

      (plot:save plt fn)))


(time (main 1000 (second (cmd-args))))

