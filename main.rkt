#lang racket

; Nombre de la funcion: option
; Dominio: int X string X int X int X list
; Recorrido: option
; Recursión: ninguna
; Descripción: Esta funcion toma los parametros del dominio y los enlista junto con hacer
;              Append a esta misma con la lista de la cantidad indefinida de keywords con el 
;              fin de tener todos los argumentos en una sola lista y la retorna.

(define option (lambda (code message ChatbotCodeLink InitialFlowCodeLink . Keyword)
                 (append (list code message ChatbotCodeLink InitialFlowCodeLink) Keyword)))

; Nombre de la funcion: option-get-id
; Dominio: option
; Recorrido: int
; Recursión: ninguna
; Descripción: Esta funcion recibe un option y retorna el id de la misma con el uso de la
;              funcion car.

(define option-get-id (lambda (option) (car option)))

; Nombre de la funcion: option-remove-dup-envoltorio
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

(define option-remove-dup-envoltorio (lambda (option)
                        (define option-remove-dup (lambda (result id-list options)
                            (if (null? options)
                                result                                
                                (if (member (option-get-id (car options)) id-list)
                                    (option-remove-dup result id-list (cdr options))
                                    (option-remove-dup (append result (list (car options))) (cons (option-get-id (car options)) id-list) (cdr options))))))
                        (option-remove-dup (list) (list) option)))

; Nombre de la funcion: flow
; Dominio: int X string X list
; Recorrido: flow
; Recursión: ninguna
; Descripción: Esta funcion enlista los primeros 2 parametros y luego hace append con
;              la lista de opciones luego de componerse con la funcion "option-remove-dup-envoltorio"
;              con el fin de que solo se agreguen los option sin repetir id.

(define flow (lambda (id name-msg . Option)
               (append (list id name-msg) (option-remove-dup-envoltorio Option))))

(define flow-add-option (lambda (flow option) flow))
;funcion agregar opcion en proceso