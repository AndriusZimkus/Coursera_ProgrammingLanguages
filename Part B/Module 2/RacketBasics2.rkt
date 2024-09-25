#lang racket

; head function - car
; tail function - cdr

; sum all the numbers in a list
(define (sum xs)
  (if (null? xs)
      0
      (+ (car xs) (sum (cdr xs)))))

; append
(define (my-append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (my-append (cdr xs) ys))))

; map
(define (my-map f xs)
  (if (null? xs)
      null
      (cons (f (car xs))
            (my-map f (cdr xs)))))

(define (add-one-to-list xs)
  (my-map (lambda (x) (+ x 1))
          xs))

(define foo (add-one-to-list (list 1 2 3)))