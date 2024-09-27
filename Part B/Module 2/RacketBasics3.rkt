#lang racket

; dynamic typing

(define xs1 (list 4 5 6))
(define ys (list (list 4  (list 5 0) 6 7 (list 8) 9 2 3 (list 0 1))))
(define zs (list #f "hi" 14))


(define (sum1 xs)
  (if (null? xs)
      0
      (if (number? (car xs))
          (+ (car xs) (sum1 (cdr xs)))
          (+ (sum1 (car xs)) (sum1 (cdr xs))))))


; assumes argument is list
(define (sum2 xs)
  (if (null? xs)
      0
      (if (number? (car xs))
          (+ (car xs) (sum2 (cdr xs)))
          (if (list? (car xs))
              (+ (sum2 (car xs)) (sum2 (cdr xs)))
              (sum2 (cdr xs))))))


; exercise - no assumption of argument
(define (sum3 xs)
  (if (not (list? xs))
      0
      (sum2 xs)))