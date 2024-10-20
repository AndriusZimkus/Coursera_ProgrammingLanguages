;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs but /is/ a MUPL value; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

;; Problem 1
;; a
(define (racketlist->mupllist rl)
  (if (null? rl)
      (aunit)
      (apair (car rl) (racketlist->mupllist (cdr rl)))))

;; b
(define (mupllist->racketlist ml)
  (if (aunit? ml)
      null
      (cons (apair-e1 ml) (mupllist->racketlist (apair-e2 ml)))))
        
  
;; Problem 2

;; lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  
  (let ([extend-env
         (lambda (old-env str val)
           (cons (cons str val) old-env))])
    
    (cond [(var? e) 
           (envlookup env (var-string e))]
          
          [(add? e) 
           (let ([v1 (eval-under-env (add-e1 e) env)]
                 [v2 (eval-under-env (add-e2 e) env)])
             (if (and (int? v1)
                      (int? v2))
                 (int (+ (int-num v1) 
                         (int-num v2)))
                 (error "MUPL addition applied to non-number")))]
          
          ;; CHANGE add more cases here
          
          [(int? e) e]
          
          [(ifgreater? e)
           (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
                 [v2 (eval-under-env (ifgreater-e2 e) env)])
             (if (and (int? v1)
                      (int? v2))
                 (if (> (int-num v1) (int-num v2))
                     (eval-under-env (ifgreater-e3 e) env)
                     (eval-under-env (ifgreater-e4 e) env))
                 (error "MUPL ifgreater applied to non-integer(s)")))]
          
          [(apair? e)
           (let ([e1 (eval-under-env (apair-e1 e) env)]
                 [e2 (eval-under-env (apair-e2 e) env)])
             (apair e1 e2))]
          
          [(fst? e)
           (let ([v (eval-under-env (fst-e e) env)])
             (if (apair? v)
                 (apair-e1 v)
                 (error "fst applied to a non-apair MUPL expression")))]
          
          [(snd? e)
           (let ([v (eval-under-env (snd-e e) env)])
             (if (apair? v)
                 (apair-e2 v)
                 (error (format "snd applied to a non-apair MUPL expression: ~v" v))))]
          
          [(aunit? e) e]
          
          [(isaunit? e)
           (let ([v (eval-under-env (isaunit-e e) env)])
             (if (aunit? v) (int 1) (int 0)))]
          
          [(mlet? e)
           (let ([s (mlet-var e)]
                 [e1 (mlet-e e)]
                 [e2 (mlet-body e)])
             (if (string? s)
                 (let* ([v1 (eval-under-env e1 env)]
                        [new-env (extend-env env s v1)]
                        [v2 (eval-under-env e2 new-env)])
                   v2)
                 (error "mlet applied to non-string value")))]
          
          [(fun? e)
           (let ([s1 (fun-nameopt e)]
                 [s2 (fun-formal  e)])
             (if (and (string? s2)
                      (or (string?  s1)
                          (boolean? s1)))
                 (closure env e)
                 (error (format "function applied to incorrect arguments: ~v and ~v" s1 s2))))]
          
          [(call? e)
           (let* ([e1 (call-funexp e)        ]  ; should be a closure expression
                  [e2 (call-actual e)        ]  ; should be the closure's argument expression
                  [c  (eval-under-env e1 env)]) ; evaluate e1 to a value with current environment
             (if (not (closure? c))             ; then check that it is a closure
                 (error (format "first expression of call is not a proper closure: ~v" e1))
                 (let* ([arg (eval-under-env e2 env  ) ] ; evaluate argument to a value using current environment
                        [c-env      (closure-env c    ) ] ; the closure's environment
                        [c-fun      (closure-fun c    ) ] ; the closure's function (name, parameter, body)
                        [f-nameopt  (fun-nameopt c-fun) ] ; function's name (or #f if anonymous)
                        [f-formal   (fun-formal c-fun ) ] ; function's parameter
                        [f-body     (fun-body c-fun   ) ] ; function's body
                        [c-env-ext1 (extend-env c-env f-formal arg)] ; bind the argument value to its name in the closure's env
                        [c-env-ext  (if f-nameopt                    ; bind the closure to the function name in its env
                                       (extend-env c-env-ext1 f-nameopt c)
                                       c-env-ext1)])                ; unless it is anonymous
                     (eval-under-env f-body c-env-ext))))] ; evaluate the function to a value using the closure's new environment

          [(closure? e) e]
          
          [#t (error (format "bad MUPL expression: ~v" e))])))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))

;; Problem 3

;; a
(define (ifaunit e1 e2 e3)
  (ifgreater (isaunit e1) (int 0) e2 e3))

;; b
(define (mlet* lstlst e2)
  (if (null? lstlst)
      e2
      (let* ([pr (car lstlst)]
            [s (car pr)]
            [e (cdr pr)]
            [nextlstlst (cdr lstlst)])
        (mlet s e (mlet* nextlstlst e2)))))

;; c
(define (ifeq e1 e2 e3 e4)
  (mlet* (list (cons "_x" e1) (cons "_y" e2))
         (ifgreater (var "_x") (var "_y")
                    e4
                    (ifgreater (var "_y") (var "_x")
                               e4
                               e3))))

;; Problem 4

(define mupl-map
  (fun "m-map" "fn"
       (fun #f "ls"
            (ifaunit (var "ls")
                     (aunit)
                     (apair
                      (call (var "fn") (fst (var "ls")))
                      (call (call (var "m-map") (var "fn")) (snd (var "ls"))))))))
  
(define mupl-mapAddN 
  (mlet "map" mupl-map
        (mlet "add" (fun #f "x" (fun #f "y" (add (var "x") (var "y"))))
              (fun #f "n"
                   (mlet "addN" (call (var "add") (var "n"))
                         (fun #f "ns"
                              (call (call (var "map") (var "addN")) (var "ns"))))))))
              
        
;; Challenge Problem

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e) "CHANGE")

;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env) "CHANGE")

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))

