#lang racket

;Ejercicio 1
(struct verdadero-exp () #:transparent)
(struct falso-exp () #:transparent)
(struct y-exp (izq der) #:transparent)
(struct o-exp (izq der) #:transparent)
(struct no-exp (cuerpo) #:transparent)

;Ejercicio 2
#|
> (y-exp (verdadero-exp) (no-exp(falso-exp)))
(y-exp (verdadero-exp) (no-exp (falso-exp)))

> (o-exp (no-exp (verdadero-exp)) (y-exp (falso-exp) (verdadero-exp)))
(o-exp (no-exp (verdadero-exp)) (y-exp (falso-exp) (verdadero-exp)))
|#

;Ejercicio 3

#|
La opcion (a) no la genera porque tiene mas de un parametro al igual que la (b) tampoco lo genera pero porque
tiene menos parametros
|#

;Ejercicio 4

(struct avanza (num prog) #:transparent)
(struct gira-izq (prog) #:transparent)
(struct gira-der (prog) #:transparent)
(struct fin () #:transparent)

;Ejercicio 5

#|
> (avanza 3 (gira-izq (avanza 2 (fin))))
(avanza 3 (gira-izq (avanza 2 (fin))))
> (gira-der (gira-der (fin)))
(gira-der (gira-der (fin)))
|#

;Ejercicio 6

#|
hay 2 avanza y el struct que esta mas adentro es el de fin
|#

;Ejercicio 7

(struct aqui () #:transparent)
(struct norte (num ruta) #:transparent)
(struct este (num ruta) #:transparent)
(struct repite (num ruta ruta2) #:transparent)

;Ejercicio 8 Nota: hice el arbol en mi pizarron pero no entendi que hay que anotar lol

;Ejercicio 9

#|
arbol ::= hoja(Num)
    |     rama (ruta, ruta)
    |     etiq (name, sub)
|#