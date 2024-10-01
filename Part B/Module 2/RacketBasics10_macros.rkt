#lang racket

; Macro expansion = syntax rewriting

;; a cosmetic macro -- adds then, else
(define-syntax my-if
  (syntax-rules (then else)
    [(my-if e1 then e2 else e3)
     (if e1 e2 e3)]))

; (my-if foo then bar else baz) -> (if foo bar baz)

(my-if #t then (+ 3 4) else 72)

;; a macro to replace an expression with another one

(define-syntax comment-out
  (syntax-rules () ; no additional keywords
    [(comment-out ignore instead) instead]))

; (comment-out (car null) (+ 3 4)) -> (+ 3 4)

(comment-out (car null) (+ 3 4))

(define-syntax my-delay
  (syntax-rules ()
    [(my-delay e)
     (mcons #f (lambda() e))]))

; macro hygiene - local variables in macros get new unique names
; macros - lexical scope
; uses environment where macros are defined not where they are used
 

