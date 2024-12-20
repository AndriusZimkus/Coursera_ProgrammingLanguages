#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

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

;9
(define (vector-assoc v vec)
  (letrec ([va-helper (lambda (x)
                        (if (>= x (vector-length vec))
                            #f                                                    ;passed through whole vector
                            (let ([current-value (vector-ref vec x)])             ;extract current value
                              (cond
                                [(not (pair? current-value)) (va-helper (+ x 1))] ;if not a pair - skip element
                                [(equal? (car current-value) v) current-value]
                                [else (va-helper (+ x 1))])
                              )))])
    (va-helper 0)))

;10
(define (cached-assoc xs n)
  (letrec ([cache-vector (make-vector n #f)]
           [cache-index 0])
    (lambda (v)    
      (let ([cached-value (vector-assoc v cache-vector)])
        (if cached-value
            cached-value                                                  ;cached value found
            (begin (let([current-value (assoc v xs)])
                     (vector-set! cache-vector cache-index current-value) ;update cache
                     (set! cache-index (if (= cache-index (- n 1))        ;update index
                                           0
                                           (+ cache-index 1)))
                     current-value
                     )) ;begin          
            )) ;let                 
      ) ;lambda
    ) ;letrec
  )

;11
(define-syntax while-less
  (syntax-rules (do)
    [(while-less e1 do e2)
     ( letrec(
              [e1-value e1]
              [f (lambda ()
                   (let ([e2-value e2])
                   (if (or (not (number? e2-value)) (>= e2-value e1-value))                               
                               #t
                               (f)
                               )))]
              )
        (f)) ;letrec
     ]))