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

(define (racketlist->mupllist xs)
  (if (null? xs)
      (aunit)
      (apair (car xs) (racketlist->mupllist (cdr xs)))))

(define ( mupllist->racketlist mupl-list)
  (if (aunit? mupl-list)
      null
      (cons (apair-e1 mupl-list) (mupllist->racketlist (apair-e2 mupl-list)))))

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
        ;; CHANGE add more cases here
        [(int? e) e]
        [(ifgreater? e)
         (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
               [v2 (eval-under-env (ifgreater-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (if (> (int-num v1) 
                      (int-num v2))
                   (eval-under-env (ifgreater-e3 e) env)
                   (eval-under-env (ifgreater-e4 e) env))
               (error "MUPL ifgreater applied to non-number")))]
                   
        [(fun? e) (closure env e)]
        [(call? e)
         (let ([v1 (eval-under-env (call-funexp e) env)]
               [v2 (eval-under-env (call-actual e) env)])
           (if (not (closure? v1))
               (error "MUPL call applied to non closure")
               (let*(
                     [cfunc (closure-fun v1)]
                     [cfunc-body (fun-body cfunc)]
                     [cfunc-nameopt (fun-nameopt cfunc)]
                     [cfunc-formal (fun-formal cfunc)]
                     [new-env (list (cons cfunc-formal v2)      ; map 2nd argument name to v2
                                    (if cfunc-nameopt           ; map 1st arg function name to closure v1
                                        (cons cfunc-nameopt v1)
                                        null
                                        ))])
                 (eval-under-env cfunc-body new-env))))]
        [(mlet? e)
         (eval-under-env (mlet-body e) (cons (cons (mlet-var e) (mlet-e e)) env))]
        [(apair? e)
         (let ([v1 (eval-under-env (apair-e1 e) env)]
               [v2 (eval-under-env (apair-e2 e) env)])
           (apair v1 v2))] 
        [(fst? e)
         (let ([v (eval-under-env (fst-e e) env)])
           (if (apair? v)
               (apair-e1 v)
               (error "MUPL fst applied to non pair")))]
        [(snd? e)
         (let ([v (eval-under-env (snd-e e) env)])
           (if (apair? v)
               (apair-e2 v)
               (error "MUPL snd applied to non pair")))]
        [(aunit? e) e]
        [(isaunit? e)
         (let ([v (eval-under-env (isaunit-e e) env)])
           (if (aunit? v)
               (int 1)
               (int 0)))]
        [(closure? e) e]
        [#t (error (format "bad MUPL expression: ~v" e))]))


;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))

;; Problem 3

(define (ifaunit e1 e2 e3)
  (if (aunit? e1) e2 e3))

(define (mlet* lstlst e2)
  (letrec (
           [helper (lambda (local-lst-lst env)               
                     (if (null? local-lst-lst)
                         (eval-under-env e2 env)
                         (helper (cdr local-lst-lst)
                                 (cons
                                  (cons (car (car local-lst-lst)) (eval-under-env (cdr (car local-lst-lst)) env))
                                  env))))])
    (helper lstlst null)))

(define (ifeq e1 e2 e3 e4)
  (mlet*
   (list (cons "_x" e1)
         (cons "_y" e2))
   (ifgreater (var "_x") (var "_y") e4 (ifgreater (var "_y") (var "_x") e4 e3))))

;; Problem 4

(define mupl-map
  (fun "mupl-map-helper"
       "mupl-function"
       (fun "mupl-map-applier" "mupl-list"
            (let ([mupl-function (var "mupl-function")]
                  [mupl-list-local (var "mupl-list")])
              (if (aunit? mupl-list-local)
                  mupl-list-local
                  (apair (call mupl-function (fst mupl-list-local)) (call (var "mupl-map-applier") (snd mupl-list-local))))) 
            ))
       )
 
;(let (
;     [cfunc-body (fun-body mupl-function)]
;    [cfunc-nameopt (fun-nameopt mupl-function)]
;   [cfunc-formal (fun-formal mupl-function)]
;  )
;(fun cfunc-nameopt cfunc-formal
;
;        (if (aunit? mupl-list)
;           mupl-list
;          (apair (call mupl-function (fst mupl-list)) (mupl-map (snd mupl-list)))))))

(define x (call mupl-map (fun #f "x" (add (var "x") (int 7)))))
(define y (call x (apair (int 1) (aunit))))

(define mupl-mapAddN 
  (mlet "map" mupl-map
        "CHANGE (notice map is now in MUPL scope)"))

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
