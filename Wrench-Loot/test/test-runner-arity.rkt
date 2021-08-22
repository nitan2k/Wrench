#lang racket
(provide test-runner test-runner-io)
(require rackunit)

(define (test-runner run)
  ;; Iniquity tests
  (check-equal? (run
                 '(begin (define (f x) x)
                         (procedure-arity f)))
                1)
  (check-equal? (run
                 '(begin (define (tri x)
                           (if (zero? x)
                               0
                               (+ x (tri (sub1 x)))))
                         (tri (procedure-arity tri))))
                1)
  ;; Loot tests
  (check-equal? (run
                 '(begin (define (f x y z) x)
                         (define (g x) (procedure-arity f))
                         (g 42)))
                3)

  (check-equal? (run
                 '(begin (define (f x) (procedure-arity x))
                         (define (g x) (f (lambda (y z) x)))
                         (g 3)))
                2)
  
  (check-equal? (run
                 '(begin (define (f x) x)
                         (f 42 14)))
                'err)

  (check-equal? (run
                 '(begin (define (f x y) x)
                         (f 42)))
                'err)
  )


(define (test-runner-io run)
  ;; Iniquity examples
  (check-equal? (run '(begin
                        (define (choose f g n) (procedure-arity (if (zero? (- n 100)) f g)))
                        (choose (lambda (x) x) (lambda (x y) y) (read-byte)))
                     "a")
                (cons 2 ""))

  (check-equal? (run '(begin
                        (define (choose f g n) (procedure-arity (if (zero? (- n 100)) f g)))
                        (choose (lambda (x) x) (lambda (x y) y) (read-byte)))
                     "d")
                (cons 1 ""))
  )
