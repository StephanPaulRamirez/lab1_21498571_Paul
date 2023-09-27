#lang racket

; Nombre de la funcion: option
; Dominio: int X string X int X int X list
; Recorrido: option
; Recursión: ninguna
; Descripción: Esta funcion toma los primeros parametros del dominio y los enlista
;              siendo estos el id, el mensaje, los id del flow y el chatbot, y 
;              la lista de la cantidad indefinida de keywords con el 
;              fin de tener todos los argumentos en una sola lista y la retorna.

(define option (lambda (code message ChatbotCodeLink InitialFlowCodeLink . Keyword)
                 (list code message ChatbotCodeLink InitialFlowCodeLink Keyword)))


; Nombre de la funcion: option-get-id
; Dominio: option
; Recorrido: int
; Recursión: ninguna
; Descripción: Esta funcion recibe un option y retorna el id de la misma con el uso de la
;              funcion car.

(define option-get-id (lambda (option) (car option)))


; Nombre de la funcion: flow-remove-dup-envoltorio
; Dominio: list
; Recorrido: list
; Recursión: Cola
; Descripción: Esta funcion recibe una lista de options y primero revisa si es que esta
;              vacia, si es que lo esta, retorna "result" el cual inicialmente es una lista
;              vacia, si no, revisa si el id del primer option esta en otra lista que inicialmente
;              esta vacia para verificar unicidad. Luego si es que el id ya estaba, se hace
;              la llamada recursiva con el mismo result e id-list pero con la lista de options
;              sin el primer elemento, luego si el id no estaba se agrega el option a result y
;              su id a id-list en la llamada recursiva sin el primer elemento nuevamente.

(define flow-remove-dup-envoltorio (lambda (options)
                (define option-remove-dup (lambda (result id-list options)
                    (if (null? options)
                        result                                
                        (if (member (option-get-id (car options)) id-list)
                            (option-remove-dup result id-list (cdr options))
                            (option-remove-dup (append result (list (car options)))
                                               (cons (option-get-id (car options)) id-list)
                                               (cdr options))))))
                (option-remove-dup (list) (list) options)))


; Nombre de la funcion: flow
; Dominio: int X string X list
; Recorrido: flow
; Recursión: ninguna
; Descripción: Esta funcion enlista los primeros 2 parametros (el id y el mensaje)
;              con la lista de opciones luego de componerse con la funcion "flow-remove-dup-envoltorio"
;              con el fin de que solo se agreguen los option sin repetir id.

(define flow (lambda (id name-msg . Option)
               (list id name-msg (flow-remove-dup-envoltorio Option))))


; Nombre de la funcion: check-dup-flow
; Dominio: list X option
; Recorrido: list
; Recursión: ninguna
; Descripción: Esta funcion revisa si es que el id de la opcion a agregar ya esta contenida
;              en la lista de opciones. Si es que el id ya esta, no se agrega nada y retorna la original, 
;              si no estaba, se agrega la opcion a la lista y se retorna.

(define check-dup-flow (lambda (option-list option)
                         (if (member (option-get-id option) (map option-get-id option-list))
                             option-list
                             (append option-list (list option)))))


; Nombre de la funcion: flow-get-id
; Dominio: flow
; Recorrido: int
; Recursión: ninguna
; Descripción: Esta funcion retorna el id de un flujo con el uso de car.

(define flow-get-id (lambda (flow) (car flow)))


; Nombre de la funcion: flow-get-msg
; Dominio: flow
; Recorrido: string
; Recursión: ninguna
; Descripción: Esta funcion retorna el mensaje de un flujo con el uso de cadr.

(define flow-get-msg (lambda (flow) (cadr flow)))


; Nombre de la funcion: flow-get-options
; Dominio: flow
; Recorrido: list
; Recursión: ninguna
; Descripción: Esta funcion retorna las opciones de un flujo con el uso de cddr.

(define flow-get-options (lambda (flow) (caddr flow)))


; Nombre de la funcion: flow-add-option
; Dominio: flow X option
; Recorrido: flow
; Recursión: ninguna
; Descripción: Esta funcion enlista los 2 primeros elementos del flujo con la lista de
;              opciones con la opcion nueva, la cual se procesa con la funcion "check-dup-flow", para revisar
;              si efectivamente se agrega la nueva opcion o no.

(define flow-add-option (lambda (flow option)
                         (list (flow-get-id flow) (flow-get-msg flow)
                               (check-dup-flow (flow-get-options flow) option))))


(define chatbot-remove-dup (lambda (result id-list flows)
                             (if (null? flows)
                                 result
                                 (if (member (flow-get-id (car flows)) id-list)
                                     (chatbot-remove-dup result id-list (cdr flows))
                                     (chatbot-remove-dup (append result (list (car flows)))
                                                         (cons (flow-get-id (car flows)) id-list)
                                                         (cdr flows))))))
                                                                     

(define chatbot (lambda (chatbotID name welcomeMessage startFlowId . flows)
                  (list chatbotID name welcomeMessage startFlowId
                        (chatbot-remove-dup (list) (list) flows))))

(define chatbot-get-id (lambda (chatbot)
                         (car chatbot)))

(define chatbot-get-name (lambda (chatbot)
                         (cadr chatbot)))

(define chatbot-get-msg (lambda (chatbot)
                         (caddr chatbot)))

(define chatbot-get-startFlowId (lambda (chatbot)
                         (cadddr chatbot)))

(define chatbot-get-flows (lambda (chatbot)
                            (car (cddddr chatbot))))
;cambiar car cddddr por un list ref
(define chatbot-add-flow (lambda (chatbot flow)
               (list (chatbot-get-id chatbot) (chatbot-get-name chatbot)
                     (chatbot-get-msg chatbot) (chatbot-get-startFlowId chatbot)
                     (chatbot-remove-dup (chatbot-get-flows chatbot)
                                         (map flow-get-id (chatbot-get-flows chatbot)) (list flow)))))