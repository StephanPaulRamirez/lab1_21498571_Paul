#lang racket


(define option (lambda (code message ChatbotCodeLink InitialFlowCodeLink . Keyword)
                 (append (list code message ChatbotCodeLink InitialFlowCodeLink) Keyword)))

(define option-get-id (lambda (option) (car option)))

(define option-remove-dup-envoltorio (lambda (option)
                        (define option-remove-dup (lambda (result id-list options)
                            (if (null? options)
                                result                                
                                (if (member (option-get-id (car options)) id-list)
                                    (option-remove-dup result id-list (cdr options))
                                    (option-remove-dup (append result (list (car options))) (cons (option-get-id (car options)) id-list) (cdr options))))))
                        (option-remove-dup (list) (list) option)))

(define flow (lambda (id name-msg . Option)
               (append (list id name-msg) (option-remove-dup-envoltorio Option))))

(define flow-add-option (lambda (flow option)
                          