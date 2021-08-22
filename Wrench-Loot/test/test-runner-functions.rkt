#lang racket
(provide test-runner test-runner-io)
(require rackunit)

(define (test-runner run)
  ; Iniquity tests
  (check-equal? (run
                 '(begin (define (f x) x)
                         (f 5)))
                5)
  
  (check-equal? (run
                 '(begin (define (f x y) y)
                         (f 5 6)))
                6)
  (check-equal? (run
                 '(begin (define (tri x)
                           (if (zero? x)
                               0
                               (+ x (tri (sub1 x)))))
                         (tri 9)))
                45)
  
  ;; Loot tests
  (check-equal? (run
                 '(begin (define (f x) x)
                         (f 42)))
                42)

  (check-equal? (run
                 '(begin (define (f x) x)
                         (define (g x) x)
                         ((car (cons f (cons g '()))) 42)))
                42)

  (check-equal? (run
                 '(begin (define (f x)
                           (if (zero? x) 0 (f (sub1 x))))
                         (f 42)))
                0)
  (check-equal? (run
                 '(begin (define (f x)
                           (if (zero? x) 0 (f (sub1 x))))
                         (f 42)))
                0)

  ;; MonkeWrench tests
  (check-equal? (run
                 '(begin (define (tri x)
                           (if (zero? x)
                               0
                               (+ x (tri (: x (sub1 x))))))
                         (tri 9)))
                45)

  (check-equal? (run
                 '(begin (define (f x) x)
                         (f (: x 5))))
                5)
  (check-equal? (run
                 '(begin (define (f y) y)
                         (f (: y 5))))
                5)

  (check-equal? (run
                 '(begin (define (f x y) y)
                         (f  (: y 6) (: x 5))))
                6)
  (check-equal? (run
                 '(begin (define (f x y) x)
                         (f  (: y 6) (: x 5))))
                5)
(check-equal? (run
                 '(begin (define (f x) (x))
                         (define (g x) (f (lambda (y z) x)))
                         (g 3)))
                3)
  )

(define (test-runner-io run)
  ;; Iniquity examples
  (check-equal? (run '(begin (define (print-alphabet i)
                               (if (zero? i)
                                   (void)
                                   (begin (write-byte (- 123 i))
                                          (print-alphabet (sub1 i)))))
                             (print-alphabet 26))
                     "")
                (cons (void) "abcdefghijklmnopqrstuvwxyz"))

  (check-equal? (run
                 '(begin (define (f x) x)
                         (f 5))
                 "")
                (cons 5 ""))

  

  

  ;;Loot examples
  (check-equal?
   (run
    '(begin (define (f x)
              (if (zero? (- x (+ 97 26)))
                  (void)
                  (begin
                    (write-byte x)
                    (g (add1 x)))))
            (define (g x)
              (if (zero? (- x (+ 97 26)))
                  (void)
                  (begin
                    (write-byte x)
                    (f (add1 x)))))
            (f 97))
    "")
   (cons (void) "abcdefghijklmnopqrstuvwxyz"))

  )
