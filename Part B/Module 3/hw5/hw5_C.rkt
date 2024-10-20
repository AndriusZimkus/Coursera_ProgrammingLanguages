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

(define (racketlist->mupllist lst)
  (foldr (lambda (elem tail) (apair elem tail)) (aunit) lst))

(define (mupllist->racketlist mlst)
  (letrec ([mupl-foldr (lambda (f init mlst)
                         (if (aunit? mlst)
                             init
                             (f (apair-e1 mlst) (mupl-foldr f init (apair-e2 mlst)))))])
    (mupl-foldr (lambda (elem tail) (cons elem tail)) (list) mlst)))


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
        [(int? e) e]
        [(closure? e) e]
        [(aunit? e) e]
        [(fun? e)
         (closure env e)]
        [(ifgreater? e)
         (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
               [v2 (eval-under-env (ifgreater-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (eval-under-env ((if (> (int-num v1) (int-num v2)) ifgreater-e3 ifgreater-e4) e) env) 
               (error "MUPL if-greater-than applied to non-number")))]
        [(mlet? e)
         (letrec ([bound-value (eval-under-env (mlet-e e) env)]
                  [new-env (cons (cons (mlet-var e) bound-value) env)])
           (eval-under-env (mlet-body e) new-env))]
        [(call? e)
         (let ([clos (eval-under-env (call-funexp e) env)])
           (if (closure? clos)
               (letrec ([param (eval-under-env (call-actual e) env)]
                        [f-env (closure-env clos)]
                        [f (closure-fun clos)]
                        [f-name (fun-nameopt f)]
                        [env-maybe-with-fname (if (string? f-name) (cons (cons f-name clos) f-env) f-env)]
                        [evaluation-env (cons (cons (fun-formal f) param) env-maybe-with-fname)])
                 (eval-under-env (fun-body f) evaluation-env))
               (error "MUPL call applied to non-closure")))]
        [(apair? e)
         (apair (eval-under-env (apair-e1 e) env) (eval-under-env (apair-e2 e) env))]
        [(fst? e)
         (let ([pair (eval-under-env (fst-e e) env)])
           (if (apair? pair)
               (apair-e1 pair)
               (error "MUPL fst applied to non-pair")))]
        [(snd? e)
         (let ([pair (eval-under-env (snd-e e) env)])
           (if (apair? pair)
               (apair-e2 pair)
               (error "MUPL snd applied to non-pair")))]       
        [(isaunit? e)
         (let ([maybe-unit (eval-under-env (isaunit-e e) env)])
           (int (if (aunit? maybe-unit) 1 0)))]
        [#t (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))

;; Problem 3

(define (ifaunit e1 e2 e3)
  (ifgreater (isaunit e1) (int 0) e2 e3))

(define (mlet* lstlst e2)
  (if (null? lstlst)
      e2
      (letrec ([current-binding (car lstlst)]
               [later-bindings (cdr lstlst)]
               [binding-var (car current-binding)]
               [binding-val (cdr current-binding)])
        (mlet binding-var binding-val (mlet* later-bindings e2)))))

(define (ifeq e1 e2 e3 e4)
  (let ([x (var "_x")]
        [y (var "_y")])
    (mlet* (list (cons "_x" e1) (cons "_y" e2))
           (ifgreater x y e4 (ifgreater y x e4 e3)))))

;; Problem 4

(define mupl-map
  (let ([fn (var "fn")]
        [l (var "lst")])
    (fun #f "fn"
         (fun "mupl-inner" "lst"
              (ifeq (isaunit l) (int 1)
                    (aunit)
                    (apair (call fn (fst l)) (call (var "mupl-inner") (snd l))))))))

(define mupl-mapAddN 
  (mlet "map" mupl-map
        (fun #f "i"
             (fun #f "l"
                  (call (call (var "map")
                              (fun #f "e" (add (var "e") (var "i"))))
                        (var "l"))))))

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
