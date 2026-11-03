#lang racket

(require "ast.rkt"
         "env.rkt")

(provide
 (contract-out
  [struct closure ([x symbol?]
                  [body expression?]
                  [⍴ env?])]))

(struct closure (x body ⍴))