#lang racket

(struct num-exp (n) #:transparent)
(struct id-exp (id) #:transparent)
(struct add-exp (izq der) #:transparent)
(struct mul-exp (izq der) #:transparent)
(struct with-exp (nombre exp cuerpo) #:transparent)


(define (asocs-vacias)'())
(define (extender asocs nombre valor)
(cons (cons nombre valor) asocs))
(define (buscar nombre asocs)
(cdr (assoc nombre asocs)))


(define (calc e asocs)
  (match e
    [(num-exp n) n]
    [(id-exp id) (buscar id asocs)]
    [(add-exp izq der) (+ (calc izq asocs) (calc der asocs))]
    [(mul-exp izq der) (* (calc izq asocs) (calc der asocs))]
    [(with-exp nombre exp cuerpo)
     (calc cuerpo (extender asocs nombre (calc exp asocs)))]))

#|
primera corrida 
> (calc (add-exp (num-exp 3) (mul-exp (num-exp 2) (num-exp 4))) (asocs-vacias))

11

Segunda corrida

> (calc (with-exp 'y 
                (add-exp (num-exp 3) (num-exp 4)) 
                (mul-exp (id-exp 'y) (id-exp 'y))) 
      (asocs-vacias))

49

Tercera corrida

> (calc (with-exp 'x 
                (add-exp (num-exp 2) (num-exp 3)) 
                (with-exp 'y 
                          (mul-exp (id-exp 'x) (num-exp 2)) 
                          (add-exp (id-exp 'x) (id-exp 'y)))) 
      (asocs-vacias))

15

Ya me dio flojera la cuarta mucho escribir por dios ... Kill the parentheses pls

Actualizacion dia siguiente: ya me di cuenta que son para que me verifique yo, no quiero volver 
a ser una decepción para usted :(

Cuarta corrida 

> (calc (with-exp 'a 
                (num-exp 5) 
                (mul-exp (with-exp 'b 
                                   (add-exp (id-exp 'a) (num-exp 1)) 
                                   (id-exp 'b)) 
                         (id-exp 'a))) 
      (asocs-vacias))
30
> (calc (me quiero tirar del puente de la unison))

|#


;Seccion 3 trazado

#|
Trazado de: with x = add(2, 3) in with y = mul(x, 2) in add(x, y)

Abreviaturas:
  N2 = (num-exp 2)
  N3 = (num-exp 3)
  AddX = (add-exp N2 N3)
  MulY = (mul-exp (id-exp x) N2)
  AddXY = (add-exp (id-exp x) (id-exp y))
  WithY = (with-exp y MulY AddXY)

  (calc (with-exp x AddX WithY) sigma0)
= (calc WithY extend(sigma0, x, (calc AddX sigma0)))                                       [with]
= (calc WithY extend(sigma0, x, (calc N2 sigma0) + (calc N3 sigma0)))                      [add]
= (calc WithY extend(sigma0, x, 2 + 3))                                                    [num]
= (calc WithY sigma1)                                    con sigma1 = extend(sigma0, x, 5)
= (calc AddXY extend(sigma1, y, (calc MulY sigma1)))                                       [with]
= (calc AddXY extend(sigma1, y, (calc (id-exp x) sigma1) * (calc N2 sigma1)))              [mul]
= (calc AddXY extend(sigma1, y, lookup(x, sigma1) * (calc N2 sigma1)))                     [id]
= (calc AddXY extend(sigma1, y, lookup(x, sigma1) * 2))                                    [num]
= (calc AddXY extend(sigma1, y, 5 * 2))
= (calc AddXY sigma2)                                    con sigma2 = extend(sigma1, y, 10)
= (calc (id-exp x) sigma2) + (calc (id-exp y) sigma2)                                      [add]
= lookup(x, sigma2) + lookup(y, sigma2)                                                    [id]
= 5 + 10
= 15
|#
