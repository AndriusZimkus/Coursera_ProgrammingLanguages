#lang racket

(define pr (cons 1 (cons #t "hi"))) ; not a list
(define lst (cons 1 (cons #t (cons "hi" null))))

; car ; #1 in ML
; cdr ; #2 in ML
; caddr - (car (cdr (cdr x))))

(list? pr)
(list? null)
(pair? pr)
(and (list? lst) (pair? pr))

; lst - proper list
; pr - is a pair, improper list

; cons cells are immutable

(define x (cons 14 null))
(define y x)
(set! x (cons 42 null))

; mcons - mutable
(define z x)
(define mpr (mcons 1 (mcons #t "hi")))
(mcar mpr)
(mcdr mpr)

(define mpr2 mpr)
mpr2
(set-mcdr! mpr 47)
mpr2