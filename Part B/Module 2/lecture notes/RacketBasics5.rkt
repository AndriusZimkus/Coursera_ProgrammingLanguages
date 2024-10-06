#lang racket

(define (f x) (+ x (* x b))); forward reference
(define b 3)
(define c (* b 4)) ; backward reference
;(define d (+ e 4)) ; not okay - reference not in function
(define e 5)
; (define f 17) ; doubled definition

;(define (+ x y) (- x (* -1 y) (* -1 1))) ; redefined + - poor style


; assignment statements - set!
(define b2 3)
(define f2 (lambda (x) (* 1 (+ x b2))))
(define c2 (+ b2 4)) ; 7
(set! b2 5)
(define z2 (f2 4))   ; 9
(define w2 c2)       ; 7

; A general principle:
; If something you need not to change might change
; make a local copy of it.

(define b3 3)
(define f3
  (let ([b3 b3])
    (lambda (x) (* 1 (+ x b3)))))
(set! b3 4)

; Defense against mutation:
; 1. Do not allow mutation
; 2. Mutable top-level bindings a highly dubious idea