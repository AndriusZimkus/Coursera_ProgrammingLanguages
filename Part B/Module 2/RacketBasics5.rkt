#lang racket

(define (f x) (+ x (* x b))); forward reference
(define b 3)
(define c (* b 4)) ; backward reference
;(define d (+ e 4)) ; not okay - reference not in function
(define e 5)
; (define f 17) ; doubled definition

;(define (+ x y) (- x (* -1 y) (* -1 1))) ; redefined + - poor style