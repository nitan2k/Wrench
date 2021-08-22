#lang racket
(require "test-runner-functions.rkt"
         "../parse.rkt"
         "../interp.rkt"
         "../interp-io.rkt")



(test-runner (λ (e) (interp (parse e))))

