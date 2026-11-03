# tarea2

El punto de partida de la tarea 2 de la unidad 2. Tres carpetas, cada una con el código de
`proc-02-procedimientos` y las pruebas de una parte de la tarea, ya escritas:

| Carpeta | Parte de la tarea | `make test` al terminar |
|---------|-------------------|-------------------------|
| `proc-varios-nucleo/` | 1.1, varios parámetros en el núcleo | `378 tests passed` |
| `proc-varios-azucar/` | 1.2, varios parámetros como azúcar | `373 tests passed` |
| `proc-dyn/` | 2.2, vinculación dinámica, `#lang proc-dyn` | `363 tests passed` |

Las pruebas no pasan tal como se entregan: esperan lo que la tarea pide implementar. En
`proc-varios-azucar` ni siquiera corren hasta que escribas los `struct` `proc*-exp` y
`call*-exp`. Lo que hay que modificar en cada una, y en qué archivo, lo dice la hoja de la
tarea.

Cada carpeta es un paquete de Racket con su `Makefile`: `make test` corre las pruebas y
`make run` abre el REPL. `proc-varios-nucleo` y `proc-varios-azucar` dan `#lang proc`, así
que solo una puede estar instalada a la vez. `proc-dyn` da `#lang proc-dyn`, porque cambia la
semántica del lenguaje.
