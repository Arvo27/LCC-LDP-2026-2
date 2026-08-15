#lang racket

(struct circulo (radio) #:transparent)
(struct rectangulo (base altura) #:transparent)
(struct cuadrado (lado) #:transparent)
;Ejercicio 1 Definir dos figuras mas, triangulo y rombo
(struct triangulo (base altura) #:transparent)
(struct rombo (diagonal1 diagonal2) #:transparent)

;Ejercico 2 y 3 son pruebas

(define (area f)
  (match f
    [(circulo r) (* 3.1416 r r)]
    [(rectangulo b h) (* b h)]
    [(cuadrado l) (* l l)]
    ;Ejericio 4 agregar los dos casos nuevos
    [(triangulo b h) (/ (* b h) 2)]
    [(rombo d1 d2) (/ (* d1 d2) 2)]))

;Ejericio 5

(define (perimetro f)
    (match f
    [(circulo r) (* 2 3.1416 r)]
    [(rectangulo a b) (* 2 (+ a b))]
    [(cuadrado l) (* 4 l)]))

;Ejercicio 6

(define (tiene-lados-iguales? f)
    (match f
    [(cuadrado _) #t]
    [(rombo _ _) #t]
    [_ #f]))

;Ejercicio 7

#|
Da error al momento de llamar la funcion porque aunque la estructura esta definida, dentro del match no 
hay ninguno que se llame pentagono, por lo tanto da error.

|#




