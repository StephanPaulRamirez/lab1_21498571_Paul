#lang racket

;Provee cada una de las definiciones al archivo que lo requiera
(provide (all-defined-out))

; TDA Option
; especificación

; option(code message ChatbotCodeLink InitialFlowCodeLink Keyword*)
; option
; option-get-id
; option-get-chatbotcodelink
; option-get-initialflowcodelink
; option-get-keywords
; option-get-message

; implementacion

; representacion
; code (Int)  X message (String)  X ChatbotCodeLink (Int) X InitialFlowCodeLink (Int) X Keyword* (string*)

; Constructor:

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

; Selectores:

; Nombre de la funcion: option-get-id
; Dominio: option
; Recorrido: int
; Recursión: ninguna
; Descripción: Esta funcion es sinonimo de car para obtener el primer elemento de option.
(define option-get-id car)

; Nombre de la funcion: option-get-msg
; Dominio: option
; Recorrido: string
; Recursión: ninguna
; Descripción: Esta funcion es sinonimo de cadr para obtener el segundo elemento de option.
(define option-get-msg cadr)

; Nombre de la funcion: option-get-chatbotcodelink
; Dominio: option
; Recorrido: int
; Recursión: ninguna
; Descripción: Esta funcion es sinonimo de caddr para obtener el tercer elemento de option.
(define option-get-chatbotcodelink caddr)

; Nombre de la funcion: option-get-initialflowcodelink
; Dominio: option
; Recorrido: int
; Recursión: ninguna
; Descripción: Esta funcion es sinonimo de cadddr para obtener el cuarto elemento de option.
(define option-get-initialflowcodelink cadddr)

; Nombre de la funcion: option-get-keywords
; Dominio: option
; Recorrido: lista de strings
; Recursión: ninguna
; Descripción: Esta funcion es sinonimo de last para obtener las keywords.
(define option-get-keywords last)

; Otros:

; Nombre de la funcion: system-search-option
; Dominio: lista de opciones X string
; Recorrido: option
; Recursión: Cola
; Descripción: Esta funcion recibe una lista de opciones y busca un option en este, a partir de una keyword.
(define system-search-option (lambda (listaoptions keyword)
                               (if (or (equal? (string->number keyword) (option-get-id (car listaoptions))) (member keyword (map string-downcase (option-get-keywords (car listaoptions)))))
                                   (car listaoptions)
                                   (system-search-option (cdr listaoptions) keyword))))