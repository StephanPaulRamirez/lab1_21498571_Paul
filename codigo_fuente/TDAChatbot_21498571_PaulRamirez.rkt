#lang racket

;Provee cada una de las definiciones al archivo que lo requiera
(provide (all-defined-out))
;Incluimos TDAs implementados, funciones de utilidad y definiciones de prueba
(require "TDAFlow_21498571_PaulRamirez.rkt")

; TDA Chatbot
; especificación

; chatbot(chatbotID name welcomeMessage startFlowId flows*)
; chatbot
; chatbot-get-id
; chatbot-get-name
; chatbot-get-msg
; chatbot-get-startFlowId
; chatbot-get-flows
; chatbot-add-flow

; implementacion

; representacion
; chatbotID (int) X name (String) X welcomeMessage (String) X startFlowId(int)  X  flows* (flow*)

; Nombre de la funcion: chatbot-remove-dup
; Dominio: lista vacia X lista vacia X lista de flows
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
; Constructor:

; Nombre de la funcion: chatbot
; Dominio: int X string X string X int X flows* 
; Recorrido: chatbot
; Recursión: Cola a traves de chatbot-remove-dup
; Descripción: Esta Funcion recibe los parametros y los enlista pero los flows los enlista luego
; de procesarlos en la funcion chatbot-remove-dup para eliminar id duplicados (usando de parametro
; 2 listas vacias y los flows).
(define chatbot (lambda (chatbotID name welcomeMessage startFlowId . flows)
                  (list chatbotID name welcomeMessage startFlowId
                        (chatbot-remove-dup (list) (list) flows))))

; Selectores;

; Nombre de la funcion: chatbot-get-id
; Dominio: chatbot
; Recorrido: int
; Recursión: ninguna
; Descripción: Esta Funcion es sinonimo de car  para obtener el primer elemento de chatbot.
(define chatbot-get-id car)


; Nombre de la funcion: chatbot-get-name
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

; Modificador:

; Nombre de la funcion: chatbot-add-flow
; Dominio: chatbot X flow
; Recorrido: chatbot
; Recursión: Cola a traves de la funcion chatbot-remove-dup
; Descripción: Esta Funcion recibe un chatbot y un flow y crea un chatbot nuevo utilizando los mismos
; elementos pero a la lista de flows se le agrega el nuevo flow usando la funcion chatbot-remove-dup.
(define chatbot-add-flow (lambda (chatbot flow)
               (list (chatbot-get-id chatbot) (chatbot-get-name chatbot)
                     (chatbot-get-msg chatbot) (chatbot-get-startFlowId chatbot)
                     (chatbot-remove-dup (chatbot-get-flows chatbot)
                                         (map flow-get-id (chatbot-get-flows chatbot)) (list flow)))))