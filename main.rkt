#lang racket

; Nombre de la funcion: option
; Dominio: int X string X int X int X strings*
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
; Descripción: Esta funcion es sinonimo de car para obtener el primer elemento de option.
(define option-get-id car)


; Nombre de la funcion: flow-remove-dup-envoltorio
; Dominio: lista de opciones
; Recorrido: lista de opciones
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
; Dominio: int X string X options*
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
; Descripción: Esta funcion es sinonimo de caddr para obtener el primer elemento de flow.
(define flow-get-id car)


; Nombre de la funcion: flow-get-msg
; Dominio: flow
; Recorrido: string
; Recursión: ninguna
; Descripción: Esta funcion es sinonimo de caddr para obtener el segundo elemento de flow.
(define flow-get-msg cadr)


; Nombre de la funcion: flow-get-options
; Dominio: flow
; Recorrido: lista de opciones
; Recursión: ninguna
; Descripción: Esta funcion es sinonimo de caddr para obtener el tercer elemento de flow.
(define flow-get-options caddr)


; Nombre de la funcion: flow-add-option
; Dominio: flow X option
; Recorrido: flow
; Recursión: De Cola a traves de check-dup-flow
; Descripción: Esta funcion crea un nuevo flow con los 2 primeros elementos del flujo y la lista de
;              opciones con la opcion nueva, la cual se procesa con la funcion "check-dup-flow", para revisar
;              si efectivamente se agrega la nueva opcion o no (se verifican id duplicados).
(define flow-add-option (lambda (flow option)
                         (list (flow-get-id flow) (flow-get-msg flow)
                               (check-dup-flow (flow-get-options flow) option))))

; Nombre de la funcion: chatbot-remove-dup
; Dominio: list X list X lista de flows
; Recorrido: lista de flows
; Recursión: Cola 
; Descripción: Esta Funcion recibe las listas y revisa si hay flujos por agregar a result
; si no hay retorna result, si aun hay, se hace una llamada recursiva con los mismos parametros
; pero la la lista de flows sin su primer elemento si es que el id de este ya estaba en id-list
; caso contrario se hace el llamado con el flow agregado a result y su id a id-list
; junto con tambien eliminar este de flows.
(define chatbot-remove-dup (lambda (result id-list flows)
                             (if (null? flows)
                                 result
                                 (if (member (flow-get-id (car flows)) id-list)
                                     (chatbot-remove-dup result id-list (cdr flows))
                                     (chatbot-remove-dup (append result (list (car flows)))
                                                         (cons (flow-get-id (car flows)) id-list)
                                                         (cdr flows))))))


; Nombre de la funcion: chatbot
; Dominio: int X string X string X int X flows* 
; Recorrido: chatbot
; Recursión: Cola a traves de chatbot-remove-dup
; Descripción: Esta Funcion recibe los parammetros y los enlista pero los flows los enlista luego
; de procesarlos en la funcion chatbot-remove-dup para eliminar id duplicados (usando de parametro
; 2 listas vacias y los flows).
(define chatbot (lambda (chatbotID name welcomeMessage startFlowId . flows)
                  (list chatbotID name welcomeMessage startFlowId
                        (chatbot-remove-dup (list) (list) flows))))


; Nombre de la funcion: chatbot-get-id
; Dominio: chatbot
; Recorrido: int
; Recursión: ninguna
; Descripción: Esta Funcion es sinonimo de car  para obtener el primer elemento de chatbot.
(define chatbot-get-id car)


; Nombre de la funcion: chatbot-get-msg
; Dominio: chatbot
; Recorrido: string
; Recursión: ninguna
; Descripción: Esta Funcion es sinonimo de cadr para obtener el segundo elemento de chatbot.
(define chatbot-get-name cadr)


; Nombre de la funcion: chatbot-get-msg
; Dominio: chatbot
; Recorrido: string
; Recursión: ninguna
; Descripción: Esta Funcion es sinonimo de caddr para obtener el tercer elemento de chatbot.
(define chatbot-get-msg caddr)


; Nombre de la funcion: chatbot-get-startFlowId
; Dominio: chatbot
; Recorrido: int
; Recursión: ninguna
; Descripción: Esta Funcion es sinonimo de cadddr para obtener el cuarto elemento de chatbot.
(define chatbot-get-startFlowId cadddr)


; Nombre de la funcion: chatbot-get-flows
; Dominio: chatbot
; Recorrido: lista de flows
; Recursión: ninguna
; Descripción: Esta Funcion recibe un chatbot y le aplica un (car(cddddr()) con el fin de obtener
; el quinto elemento.
(define chatbot-get-flows (lambda (chatbot) (car(cddddr chatbot))))


; Nombre de la funcion: chatbot-add-flow
; Dominio: chatbot X flow
; Recorrido: chatbot
; Recursión: Cola a traves de la funcion chatbot-remove-dup
; Descripción: Esta Funcion recibe un chatbot y un flow y crea un chatbot nuevo utilizando los mismos
;elementos pero a la lista de flows se le agrega el nuevo flow usando la funcion chatbot-remove-dup.
(define chatbot-add-flow (lambda (chatbot flow)
               (list (chatbot-get-id chatbot) (chatbot-get-name chatbot)
                     (chatbot-get-msg chatbot) (chatbot-get-startFlowId chatbot)
                     (chatbot-remove-dup (chatbot-get-flows chatbot)
                                         (map flow-get-id (chatbot-get-flows chatbot)) (list flow)))))
