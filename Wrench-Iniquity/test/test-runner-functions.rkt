#lang racket
(provide test-runner test-runner-io)
(require rackunit)

(define (test-runner run)
  ;; Iniquity tests
  (check-equal? (run
                 '(begin (define (f x) x)
                         (f 5)))
                5)
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
                  '(begin (define (f x) (procedure-arity x))
                          (define (g x) (lambda (y z) x))
                          ((g 3) 2 4)))
                3)


      (check-equal? (run
                 '(begin (define (tri x)
                           (if (zero? x)
                               0
                               (+ x (tri (sub1 x)))))
                         (tri 9)))
                42)

  ;; MonkeWrench tests

     (check-equal? (run
                  '(begin (define (f y x) x)
                          (f  (: y 11) (: x 42))))
                42)

     (check-equal? (run
                  '(begin (define (f y x) y)
                          (f  (: y (+ 3 4)) (: x 42))))
                7)

      (check-equal? (run
                 '(begin (define (tri x)
                           (if (zero? x)
                               0
                               (+ x 1)))
                         (tri 9)))
                10)

 ; Named recursion unstable
;    (check-equal? (run
;                 '(begin (define (tri x)
;                           (if (zero? x)
;                               0
;                               (tri  (: x (add1 x)))))
;                         (tri 9)))
;                45)
  

 )


(define (test-runner-io run)

    (check-equal? (run '(begin (define (f y x) x)
                          (f  (: y 11) (: x 42)))
                     "")
                (cons 42 ""))

  
 
  
  ;; Iniquity examples
  (check-equal? (run '(begin (define (print-alphabet i)
                               (if (zero? i)
                                   (void)
                                   (begin (write-byte (- 123 i))
                                          (print-alphabet (sub1 i)))))
                             (print-alphabet 26))
                     "")
                (cons (void) "abcdefghijklmnopqrstuvwxyz"))

  ;; Loot examples
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
