#lang racket

#|
   TAREA 1. Extender el lenguaje LET

   Nombre: Angel Ricardo Vazquez Ortiz

   Aquí va la prosa de las secciones 1, 2 y 4 de cada constructo, en el
   orden del enunciado. Solo aparecen las secciones que te toca escribir: las
   demás vienen dadas en el enunciado. La sección 3 es el código: tus struct
   en ast.rkt y tus cláusulas en interp.rkt y en desugar.rkt, en los lugares
   marcados.

   not
   ---
   4. Contraste
      Expresión                      Traza              REPL
   ----------------------------   --------------        --------------------------
   not(zero?(0))                  #f [zero?-v] [not-v]  (boolval #f)
   not(false)                     #t [zero?-f] [not-f]  (boolval #t)
   not(5)                         error                 error de val->bool

   Coinciden: Sí. En el caso de not(5), la especificación se atasca osea no produce ningún valor
   porque no existe una regla donde la premisa evalúe a un número,
   lo cual la implementación modela correctamente arrojando un error.



   and
   ---
   4. Contraste                               
      Expresión                      Traza                                                              REPL
   ----------------------------   --------------                                            --------------------------
   and(true, false)               #f[and] [zero?-v] [if-v] [zero?-f]                              (boolval #f)
   and(false, car(emptylist))     #f [and] [zero?-f] [if-f] [zero?-f] (e2 no se evalúa)           (boolval #f)
   and(true, 5)                   (intval 5)   [and] [zero?-v] [if-v] [const]                     (intval 5)

   Coinciden: Sí. Como and se traduce a un if (azúcar sintáctica), devuelve el valor de e2 directamente
   sin validar su tipo, a diferencia del comportamiento estricto de or.

   or
   --
   1. Propuesta informal
   or(e1, e2) checa si al menos una de las dos expresiones es verdadera.
   Primero se evalúa e1, y e1 tiene que valer un booleano. Si e1 vale #t, el
   resultado es #t y e2 ni siquiera se evalúa. Solo si e1 vale #f se evalúa
   e2, y entonces e2 también tiene que valer un booleano, que es el
   resultado. Por eso or(true, 5) da #t (el 5 nunca se evalúa), pero
   or(false, 5) es un error.

   2. Especificación formal
   Expression ::= or(Expression, Expression)      (or-exp e1 e2)

   (value-of e1 ρ) = #t
   ---------------------------------- [or-v]
   (value-of (or-exp e1 e2) ρ) = #t

   (value-of e1 ρ) = #f     (value-of e2 ρ) = v     v ∈ { #t, #f }
   ------------------------------------------------------------ [or-f]
   (value-of (or-exp e1 e2) ρ) = v

   Caso de borde: si e1 no vale #t ni #f, o si e1 vale #f y e2 no vale un
   booleano, ninguna regla aplica y el resultado es un error.

   4. Contraste
      Expresión                      Traza                                    REPL
   ----------------------------   --------------                            --------------------------
   or(false, true)                #t[zero?-f] [zero?-v] [or-f]             (boolval #t)
   or(true, car(emptylist))       #t [zero?-v] [or-v]  (e2 no se evalúa)   (boolval #t)
   or(false, 5)                   error                                    error de val->bool

   Coinciden: Sí. La especificación se detiene en el caso de or(false, 5) porque el 5 no cumple la
   premisa de ser booleano, y la implementación modela exactamente esa restricción lanzando el error.


   xor
   ---
   1. Propuesta informal
   xor(e1, e2) da verdadero solo cuando exactamente una de las dos
   expresiones es verdadera. Por ejemplo, xor(true, true) da #f porque ambas
   lo son. Es azúcar: se traduce a un if, así que e2 se evalúa exactamente
   una vez, sin importar el valor de e1, porque el programa termina en alguna
   de las dos ramas. Una consecuencia: como solo se le exige booleano a e1,
   xor(false, 5) da 5 (el valor de e2 sale tal cual), mientras que
   xor(true, 5) es un error, porque not(5) no tiene sentido.

   2. Especificación formal
   Expression ::= xor(Expression, Expression)      (xor-exp e1 e2)

   xor(e1, e2)  ⇝  if e1 then not(e2) else e2      [xor]

   4. Contraste
      Expresión                      Traza                                             REPL
   ----------------------------   --------------                                    --------------------------
   xor(true, true)                #f [xor] [zero?-v] [if-v] [zero?-v] [not-v]              (boolval #f)
   xor(true, false)               #t [xor] [zero?-v] [if-v] [zero?-f] [not-f]              (boolval #t)
   xor(false, 5)                  (intval 5)    [xor] [zero?-f] [if-f] [const]             (intval 5)
           
   Coinciden: Sí. Al traducirse a if, si e1 es falso, la expresión devuelve e2 directamente
   sin pasar por not ni validar su tipo, por lo que ambas arrojan el valor exacto.


   cond
   ----
   2. Especificación formal: solo la regla de cond end
      cond end  ⇝  car(emptylist)        [cond-vacío]
      Hacerlo por error sale mejor porque los errores se ven de inmediato aunque el mensaje de error habla de car, no de cond.

   4. Contraste
      Expresión                                                            Traza                                                                                              REPL
   ----------------------------                                        --------------                                                                             --------------------------
      let x = 3 in cond zero?(x) ==> 100 zero?(-(x,3)) ==> 200 end     (intval 200)  [let] [cond] [var] [zero?-f] [if-f] [cond] [diff] [zero?-v] [if-v] [const]   (intval 200)
   cond true ==> 1 true ==> car(emptylist) end                         (intval 1)    [cond] [zero?-v] [if-v] [const]                                              (intval 1)
   cond end                                                            error                                                                                            error de car

   Coinciden: Sí. Al encontrar la primera prueba verdadera, devuelve su valor y omite el resto.
   El caso vacío se traduce a car(emptylist), y pues este provoca el error esperado en ambas
   partes al no tener un valor de retorno válido.



   list
   ----
   4. Contraste
      Expresión                      Traza                                                                                     REPL
   ----------------------------   --------------                                                                             --------------------------
   list()  [borde]                ⟨⟩  [list-vacía] [emptylist]                                                               (listval '())
   list(1, true)                  1 :: #t :: ⟨⟩ [list] [list] [list-vacía] [cons] [const] [zero?-v]                          (listval (list (intval 1) (boolval #t)))
   list(list(1), list())          (1 :: ⟨⟩) :: ⟨⟩ :: ⟨⟩ [list] [list] [const] [list-vacía] [list] [list-vacía] [list-vacía]  (listval (list (listval (list (intval 1))) (listval '())))

   Coinciden: Sí. Ambas agrupan los elementos en el mismo orden y llegan al mismo resultado.
   La única diferencia es visual es la especificación usa símbolos matemáticos y la implementación devuelve el texto en Racket.


   unpack
   ------
   2. Especificación formal
      Expression ::=  unpack Identifier* = Expression in Expression  (unpack-exp xs e1 e2)

      Reglas de inferencia:

     (value-of e1 ρ) = v1 :: v2 :: ... :: vn :: ⟨⟩ [xs = x1 ... xn]
     ------------------------------------------------------   [unpack-v]
     (value-of (unpack-exp xs e1 e2) ρ) = (value-of e2 [x1=v1][x2=v2]...[xn=vn]ρ) 

     (value-of e1 ρ) = v1 :: v2 :: ... :: vm :: ⟨⟩  [xs = x1 ... xn]  [m ≠ n]
     ------------------------------------------------------   [unpack-f]
     (value-of (unpack-exp xs e1 e2) ρ) = error
   

   4. Contraste
      Expresión                                            Traza                                                   REPL
   ----------------------------                        --------------                                           --------------------------
   let u = 7 in unpack x y = list(u, 3) in -(x, y)     (intval 4) [let] [list] [cons] [unpack-v] [diff] [var]    (intval 4)
   unpack = list() in 5                                (intval 5) [list-vacía] [unpack-v] con n = 0; [const]     (intval 5)
   unpack x y = list(1, 2, 3) in x                     error                                                     error: hubo 2 nombres y 3 elementos
     
   Coinciden: Sí. Ambas exigen que haya exactamente la misma cantidad de nombres y elementos.
   Si ambos lados están vacíos, evalúan el cuerpo directo, si las cantidades difieren, interrumpen la ejecución y marcan el error.

|#

(require "ast.rkt"
         "env.rkt"
         "vals.rkt")

(provide
 (contract-out
  [value-of (-> expression? env?
                expval?)]))

;; Intérprete del lenguaje LET
(define (value-of e ρ)
  (match e
    [(const-exp n)    (intval n)]
    [(var-exp x)      (apply-env ρ x)]
    [(diff-exp e1 e2)
     (define v1 (value-of e1 ρ))
     (define v2 (value-of e2 ρ))
     (intval (- (val->int v1)
                (val->int v2)))]
    [(zero?-exp e1)
     (define v1 (value-of e1 ρ))
     (boolval (zero? (val->int v1)))]
    [(if-exp e1 e2 e3)
     (define v1 (value-of e1 ρ))
     (if (val->bool v1)
         (value-of e2 ρ)
         (value-of e3 ρ))]
    [(let-exp x e1 e2)
     (define v1 (value-of e1 ρ))
     (define ρ* (extend-env x v1 ρ))
     (value-of e2 ρ*)]

    ;; La aritmética que va en el núcleo: minus, mul y quotient
    [(minus-exp e1)
     (define v1 (value-of e1 ρ))
     (intval (- (val->int v1)))]
    [(mul-exp e1 e2)
     (define v1 (value-of e1 ρ))
     (define v2 (value-of e2 ρ))
     (intval (* (val->int v1)
                (val->int v2)))]
    [(quotient-exp e1 e2)
     (define v1 (value-of e1 ρ))
     (define v2 (value-of e2 ρ))
     (intval (quotient (val->int v1)
                       (val->int v2)))]

    ;; Los booleanos que van en el núcleo: equal? y less?
    [(equal?-exp e1 e2)
     (define v1 (value-of e1 ρ))
     (define v2 (value-of e2 ρ))
     (boolval (equal? v1 v2))]
    [(less?-exp e1 e2)
     (define v1 (value-of e1 ρ))
     (define v2 (value-of e2 ρ))
     (boolval (val<? v1 v2))]

    ;; Las listas
    [(emptylist-exp)
     (listval '())]
    [(cons-exp e1 e2)
     (define v1 (value-of e1 ρ))
     (define v2 (value-of e2 ρ))
     (listval (cons v1 (val->list v2)))]
    [(car-exp e1)
     (define v1 (value-of e1 ρ))
     (car (val->list v1))]
    [(cdr-exp e1)
     (define v1 (value-of e1 ρ))
     (listval (cdr (val->list v1)))]
    [(null?-exp e1)
     (define v1 (value-of e1 ρ))
     (boolval (null? (val->list v1)))]

    ;; --- AQUÍ van  tus cláusulas del núcleo: not-exp y unpack-exp ---
    [(not-exp e1)
     (define v1 (value-of e1 ρ))
     (boolval (not (val->bool v1)))]

    [(unpack-exp xs e1 e2)
     (define v1 (value-of e1 ρ))
     (define vs (val->list v1))
     (if (= (length xs) (length vs))
         (value-of e2 (extend-env-varios xs vs ρ))
         (error 'unpack "hubo ~a nombres y ~a elementos" (length xs) (length vs)))]

    ;; La tarea, lo que viene hecho en el núcleo: or
    [(or-exp e1 e2)
     (define v1 (value-of e1 ρ))
     (if (val->bool v1)
         (boolval #t)
         (boolval (val->bool (value-of e2 ρ))))]))

;; Si una cláusula necesita una función auxiliar, va aquí abajo, con nombre
;; propio, y no escondida dentro de la cláusula.

;; --- AQUÍ van tus auxiliares, cada una con nombre propio ---
(define (extend-env-varios xs vs ρ)
  (cond
    [(null? xs) ρ]
    [else (extend-env (car xs) (car vs)
                      (extend-env-varios (cdr xs) (cdr vs) ρ))]))

;; El orden de los valores expresados: false es menor que todo lo demás,
;; true es mayor que todo lo demás, y entre números es el < de siempre.
;; Es estricto: ningún valor es menor que sí mismo.
(define (val<? v1 v2)
  (match (list v1 v2)
    [(list (boolval #f) (boolval #f)) #f]
    [(list (boolval #f) _)            #t]
    [(list (boolval #t) _)            #f]
    [(list _            (boolval #f)) #f]
    [(list _            (boolval #t)) #t]
    [(list (intval n1)  (intval n2))  (< n1 n2)]))
