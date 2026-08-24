#lang racket 

(struct num-exp (n) #:transparent)
(struct add-exp (izq der) #:transparent)
(struct mult-exp (izq der) #:transparent)
(struct max-exp (izq der) #:transparent)
(struct neg-exp (exp) #:transparent)



(define (calc e)
(match e
    [(num-exp n) n]
    [(add-exp izq der) (+ (calc izq) (calc der))]
    [(mult-exp izq der) (* (calc izq) (calc der))]
    [(neg-exp exp) (- (calc exp))]
    [(max-exp izq der) (max (calc izq) (calc der))]))


;Ejercicio 3

(define (cuantos-nodos e)
(match e
    [(num-exp _) 1]
    [(add-exp izq der) (+ 1 (cuantos-nodos izq) (cuantos-nodos der))]
    [(mult-exp izq der) (+ 1 (cuantos-nodos izq) (cuantos-nodos der))]
    [(max-exp izq der) (+ 1 (cuantos-nodos izq) (cuantos-nodos der))]
    [(neg-exp exp) (+ 1 (cuantos-nodos exp))]))

;Ejercicio 4

(define (profundidad e)
(match e
    [(num-exp _) 1]
    [(add-exp izq der) (+ 1 (max (profundidad izq) (profundidad der)))]
    [(mult-exp izq der) (+ 1 (max (profundidad izq) (profundidad der)))]
    [(neg-exp exp) (+ 1 (profundidad exp))]
    [(max-exp izq der) (+ 1 (max (profundidad izq) (profundidad der)))]))

;Ejercicio 5

(define (a-texto e)
(match e
    [(num-exp n) (number->string n)]
    [(add-exp izq der) (string-append "add(" (a-texto izq) ", " (a-texto der) ")")]
    [(mult-exp izq der) (string-append "mult(" (a-texto izq) ", " (a-texto der) ")")]
    [(neg-exp exp) (string-append "neg(" (a-texto exp) ")")]
    [(max-exp izq der) (string-append "max(" (a-texto izq) ", " (a-texto der) ")")]))