#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

;1
(define (sequence low high stride)
  (if (> low high)
      null
      (cons low (sequence (+ low stride) high stride))))


;2
(define (string-append-map xs suffix)
  (map (lambda (x) (string-append x suffix)) xs))

;3
(define (list-nth-mod xs n)
  (cond
    [(< n 0) (error "list-nth-mod: negative number")]
    [(null? xs) (error "list-nth-mod: empty list")]
    [else (car (list-tail xs (remainder n (length xs))))]
    ))

;4
(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (let([pr (s)])
        (cons (car pr) (stream-for-n-steps (cdr pr) (- n 1))))))


;5
(define funny-number-stream
  (letrec ([f (lambda (x)
                (cons (if (= (remainder x 5) 0)
                          (* -1 x)
                          x)
                      (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))

;6
(define dan-then-dog
  (letrec ([f (lambda (x)
                (cons (if x "dan.jpg" "dog.jpg")
                      (lambda () (f (not x)))))])
    (lambda () (f #t))))

;7
(define (stream-add-zero s)
  (letrec ([pr (s)])
    (lambda () (cons (cons 0 (car pr))
                     (stream-add-zero (cdr pr))))))

;8
(define (cycle-lists xs ys)
  (letrec ([f (lambda (x)
                (cons (cons (list-nth-mod xs x) (list-nth-mod ys x))
                      (lambda () (f (+ x 1)))))])
    (lambda () (f 0))))
