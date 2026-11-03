# proc-01-inicio

El lenguaje con el que empieza la unidad 2. Es el LET con el que cerró la unidad 1:
todas las extensiones trabajadas en clase (aritmética, booleanos, `+` y `*`, listas) y los
siete constructos de la tarea 1 resueltos (`not`, `and`, `or`, `xor`, `cond`, `list`,
`unpack`). Todavía no tiene procedimientos. Es el punto de partida sobre el que se
construye PROC.

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

## De aquí a PROC

PROC agrega procedimientos al lenguaje: un `proc` crea uno, y una llamada lo aplica a un
argumento. Las dos producciones y sus reglas son las siguientes.

```
Expression ::= proc (Identifier) Expression        (proc-exp x e)
Expression ::= (Expression Expression)             (call-exp e₁ e₂)
```

```
  ──────────────────────────────────────────────────    [proc]
  (value-of (proc-exp x e) ρ) = (procval (closure x e ρ))

  (value-of e₁ ρ) = (procval (closure x e ρ′))
  (value-of e₂ ρ) = v₂
  (value-of e [x=v₂]ρ′) = v
  ──────────────────────────────────────────────────    [call]
  (value-of (call-exp e₁ e₂) ρ) = v
```

Los dos constructos son del núcleo. Esta carpeta compila y pasa sus pruebas tal como está,
y cada paso de la lista agrega algo sin romper lo anterior. Conviene correr `make test`
después de cada uno.

1. **`lexer.rkt`.** El token `PROC`, para la palabra `proc`. Va en `define-empty-tokens`,
   en una regla del lexer escrita antes de `identifier`, en `token-names` y en
   `empty-token-texts`, que da su texto para los mensajes de error.
2. **`ast.rkt`.** Los `struct` `proc-exp`, con campos `x` y `e1`, y `call-exp`, con campos
   `e1` y `e2`. Cada uno va en el `contract-out`, en la definición y en `expression?`.
3. **`parser.rkt`.** Las dos producciones. La llamada empieza con `(` y ninguna otra
   producción empieza así, así que no hay conflicto con la gramática actual.
4. **`desugar.rkt`.** Las dos cláusulas del núcleo, que reconstruyen el constructo con sus
   partes traducidas.
5. **`procs.rkt`, archivo nuevo.** El `struct` `closure`, con campos `x`, `body` y `ρ`, y su
   contrato: un símbolo, una expresión y un entorno. Importa `ast.rkt` y `env.rkt`.
6. **`vals-impl.rkt`.** El `struct` `procval`, con un campo `p`, y su caso en `expval?`.
7. **`vals.rkt`.** Importa `procs.rkt`. El contrato de `procval` (en `p` va una clausura),
   el selector `val->proc`, con un error como el de `val->int`, y el caso de `procval` en
   `expval->string`, que escribe `<proc (x)>`, solo con el parámetro.
8. **`interp.rkt`.** Importa `procs.rkt`. Las cláusulas de `proc-exp` y `call-exp`, y
   `apply-procedure`, que recibe la clausura y el argumento y evalúa el cuerpo en el entorno
   de la clausura extendido con el parámetro. `equal?` deja de usar el `equal?` de Racket:
   dos procedimientos no se comparan, y es un error, igual que en `less?`.
9. **Pruebas.** Cada archivo de `tests/` gana las suyas: el token en `lexer-tests.rkt`, las
   producciones en `parser-tests.rkt`, las dos cláusulas en `desugar-tests.rkt`, el valor y
   su selector en `vals-tests.rkt`, las reglas en `interp-tests.rkt`, y los programas
   completos en `main-tests.rkt`.

Los pasos 5 a 7 explican por qué los valores están separados en interfaz e implementación:
un procedimiento es un valor, guarda un entorno, y el entorno guarda valores. Ver
"Interfaz e implementación", más abajo.

Con todo hecho, estos programas valen 55, 55 y -100:

```
let f = proc (x) -(x, 11)
in (f (f 77))

(proc (f) (f (f 77))
 proc (x) -(x, 11))

let x = 200
in let f = proc (z) -(z, x)
   in let x = 100
      in let g = proc (z) -(z, x)
         in -((f 1), (g 1))
```

La versión resuelta es `proc-02-procedimientos`.

## Qué trae

| Archivo           | Qué hace                                                                   |
|-------------------|----------------------------------------------------------------------------|
| `lexer.rkt`       | Del texto a los tokens, cada uno con su posición en el texto               |
| `parser.rkt`      | De los tokens al árbol. La gramática completa va en la hoja de referencia  |
| `ast.rkt`         | Los `struct` del árbol                                                     |
| `desugar.rkt`     | Traduce el azúcar al núcleo                                                |
| `interp.rkt`      | `value-of`                                                                 |
| `vals.rkt`        | La interfaz de los valores expresados: `intval`, `boolval`, `listval`      |
| `vals-impl.rkt`   | La implementación de los valores                                           |
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
$ make test                        318 tests passed
$ make run                         el REPL
```

Son `raco test --make tests` y `racket -y main.rkt`. La opción de compilar hace que, después
de modificar un archivo, se recompile todo lo que depende de él antes de correr.

## Interfaz e implementación

Los valores y el entorno están separados igual: una interfaz con los contratos (`vals.rkt`,
`env.rkt`) y una implementación sin ellos (`vals-impl.rkt`, `env-impl-struct.rkt`). El resto
del intérprete solo importa las interfaces. La única excepción es `env.rkt`, que toma
`denval?` de `vals-impl.rkt`: cuando el lenguaje tenga procedimientos, un valor guardará un
entorno y un entorno guardará valores, y si las dos interfaces se importaran entre sí los
`require` formarían un ciclo.

## El REPL

Una expresión puede ocupar varias líneas. Mientras esté incompleta, el REPL pide la
siguiente con `...`:

```
==> let x = 5
... in -(x, 1)
4
```

Los valores se escriben en la sintaxis del lenguaje: `4`, `true`, `list(1, 2)`. Una línea
vacía a la mitad de una expresión se ignora. Ctrl-C cancela la expresión que se
está escribiendo y vuelve al prompt. Una línea vacía en el prompt `==>`, o el fin de la
entrada, terminan el REPL.
