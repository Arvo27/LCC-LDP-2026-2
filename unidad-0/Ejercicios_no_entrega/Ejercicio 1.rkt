;Ejercicio 1

#lang racket

(define (cuenta-atras n)
    (if (= n 0)
        '()
        (cons n (cuenta-atras (- n 1)))))

;Ejercicio 2

(define (suma-hasta n)
    (if (= n 0)
        0
        (+ n (suma-hasta (- n 1)))))

;Ejericio 3

(define (potencia n p)
    (if (= p 0)
        1
        (* n (potencia n (- p 1)))))

;Ejercicio 4

(define (longitud lst)
    (if (null? lst)
        0
        (+ 1 (longitud (cdr lst)))))

;Ejercicio 5

(define (concatenar lst1 lst2)
    (if (null? lst1)
        lst2
        (cons (car lst1) (concatenar (cdr lst1) lst2))))

;Ejericio 6

(define (cuadrado x)
    (* x x))

(define (doble x)
    (* x 2))

(define (mapeo f lst)
    (if (null? lst)
        '()
        (cons (f (car lst)) (mapeo f (cdr lst)))))

;Ejercicio 7

(define (positivo? n)
    (> n 0))

(define (filtrar f lst)
    (if (null? lst)
        '()
        (cons (f (car lst)) (filtrar f (cdr lst)))))

;Ejercicio 8

(define (invierte lst1)
    (if (null? lst1)
    '()
    (concatenar (invierte (cdr lst1)) (list (car lst1)))))

;Ejercicio 9

(define (suma-lista lst)
    (if (null? lst)
    0
    (+ (car lst) (suma-lista (cdr lst)))))
 
;Ejercicio 10
 #|
 (suma-lista (mapea cuadrado (cuenta-atras 3)))

 cuentra-atras 3 = '(3 2 1)
 mapea cuadrado '(3 2 1) = '(9 4 1)
 suma-lista '(9 4 1) = 14

 El resultado que retorna es 14
 |#