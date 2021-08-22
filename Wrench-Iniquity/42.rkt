#lang racket
(begin (define (f x) (procedure-arity x))
       (define (g x) (f (lambda (y z) x)))
       (g 3))
