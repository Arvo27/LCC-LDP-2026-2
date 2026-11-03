# proc-02-procedimientos

PROC: el lenguaje de `proc-01-inicio` con procedimientos. Un `proc` crea un procedimiento
de un parámetro, y `(e₁ e₂)` lo llama. El valor de un `proc` es una **clausura**: el
parámetro, el cuerpo y el entorno en que se creó. Al llamarlo, el cuerpo se evalúa en ese
entorno extendido con el parámetro, no en el entorno de la llamada.

```
let x = 200
in let f = proc (z) -(z, x)
   in let x = 100
      in let g = proc (z) -(z, x)
         in -((f 1), (g 1))
```

vale -100: `f` recuerda el `x` que valía 200 y `g` el que valía 100.

Los procedimientos no se comparan: `equal?` con un procedimiento es un error, igual que
`less?`. Llamar algo que no es procedimiento también:

```
==> (3 4)
val->proc: Esperaba un procedimiento pero me diste 3
```

## Instalación

Desde esta carpeta:

```
$ make install
```

Es `raco pkg install --auto --link` con el nombre de la carpeta como nombre del paquete.

Con eso cualquier archivo que empiece con `#lang proc` corre con este intérprete, en
DrRacket o desde la terminal:

```
#lang proc
let x = 5 in -(x, 1)
```

```
$ racket programa.rkt
4
```

En la ventana de interacciones de DrRacket queda disponible `run`, para probar otras
expresiones sin editar el archivo: `(run "zero?(0)")`.

Todas las versiones de PROC instalan el mismo `#lang proc`, así que solo una puede estar
instalada a la vez. Si hay otra instalada, `make install` falla con `packages conflict`.
Para cambiar de versión se quita la instalada con `make uninstall`, en su carpeta, y se
corre `make install` en la carpeta de la otra.

## Qué trae

| Archivo           | Qué hace                                                                   |
|-------------------|----------------------------------------------------------------------------|
| `lexer.rkt`       | Del texto a los tokens, cada uno con su posición en el texto               |
| `parser.rkt`      | De los tokens al árbol. La gramática completa va en la hoja de referencia  |
| `ast.rkt`         | Los `struct` del árbol                                                     |
| `desugar.rkt`     | Traduce el azúcar al núcleo                                                |
| `interp.rkt`      | `value-of` y `apply-procedure`                                             |
| `vals.rkt`        | La interfaz de los valores: `intval`, `boolval`, `listval`, `procval`      |
| `vals-impl.rkt`   | La implementación de los valores, `procval` incluido                       |
| `procs.rkt`       | La clausura: `closure`, con el parámetro, el cuerpo y el entorno           |
| `env.rkt`         | La interfaz del entorno                                                    |
| `env-impl-struct.rkt` | La implementación del entorno, con `struct`                            |
| `main.rkt`        | `run` y el REPL                                                            |
| `lang/reader.rkt` | El lector de `#lang proc`                                                  |
| `info.rkt`        | La descripción del paquete para `raco`                                     |
| `Makefile`        | `make install`, `make uninstall`, `make test` y `make run`                 |
| `tests/`          | Las pruebas                                                                |

## Errores con ubicación

Los errores de lexer y de parser dicen la fuente, la línea y la columna, y DrRacket subraya
el lugar en el archivo:

```
programa.rkt:4:3: parse: no esperaba `in` después de `=`
```

El mensaje muestra el texto tal como se escribió y el token anterior. La línea cuenta
desde 1 y la columna desde 0, como en Racket. Con `run` y `parse` la fuente
es `string`, o la que se les pase como segundo argumento, y en el REPL es `repl`. Los errores
de `value-of` todavía no dicen dónde ocurrieron.

## Cómo se corre

Desde esta carpeta:

```
$ make test                        356 tests passed
$ make run                         el REPL
```

Son `raco test --make tests` y `racket -y main.rkt`. La opción de compilar hace que, después
de modificar un archivo, se recompile todo lo que depende de él antes de correr.

## Interfaz e implementación

Los valores y el entorno están separados igual: una interfaz con los contratos (`vals.rkt`,
`env.rkt`) y una implementación sin ellos (`vals-impl.rkt`, `env-impl-struct.rkt`). El resto
del intérprete solo importa las interfaces. La única excepción es `env.rkt`, que toma
`denval?` de `vals-impl.rkt`. Un `procval` guarda una clausura, la clausura guarda un
entorno y el entorno guarda valores. Si las interfaces se importaran entre sí, los `require`
formarían un ciclo, y Racket no lo admite. Así quedan:

```
vals.rkt   → vals-impl.rkt, procs.rkt
procs.rkt  → ast.rkt, env.rkt
env.rkt    → vals-impl.rkt, env-impl-struct.rkt
```

## El REPL

Una expresión puede ocupar varias líneas. Mientras esté incompleta, el REPL pide la
siguiente con `...`:

```
==> let x = 5
... in -(x, 1)
4
```

Los valores se muestran en pantalla con la sintaxis del lenguaje: `4`, `true`, `list(1, 2)`. Un
procedimiento se muestra solo con su parámetro, `<proc (x)>`. Una línea
vacía a la mitad de una expresión se ignora. Ctrl-C cancela la expresión que se
está escribiendo y vuelve al prompt. Una línea vacía en el prompt `==>`, o el fin de la
entrada, terminan el REPL.
