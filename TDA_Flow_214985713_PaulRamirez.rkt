#lang racket

;Provee cada una de las definiciones al archivo que lo requiera
(provide (all-defined-out))
;Incluimos TDAs implementados, funciones de utilidad y definiciones de prueba
(require "TDA_Option_214985713_PaulRamirez.rkt")

; TDA Flow
; especificación

; flow(id name-msg Option*)
; flow
; flow-get-id
; flow-get-msg
; flow-get-options
; flow-add-options

; implementacion

; representacion
; id (int) X name-msg (String)  X Option* (option*)  

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

; Constructor:

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
; Dominio: lista de opciones X option
; Recorrido: lista de opciones
; Recursión: ninguna
; Descripción: Esta funcion revisa si es que el id de la opcion a agregar ya esta contenida
;              en la lista de id. Si es que el id ya esta, no se agrega nada y retorna la original, 
;              si no estaba, se agrega la opcion a la lista y se retorna.
(define check-dup-flow (lambda (option-list option)
                         (if (member (option-get-id option) (map option-get-id option-list))
                             option-list
                             (append option-list (list option)))))
; Selectores:

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

; Modificador:

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