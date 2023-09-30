#lang racket

;Provee cada una de las definiciones al archivo que lo requiera
(provide (all-defined-out))
(require "TDA_Chatbot_214985713_PaulRamirez.rkt")
(require "TDA_ChatHistory_214985713_PaulRamirez.rkt")
(require "TDA_User_214985713_PaulRamirez.rkt")

; TDA System
; especificación

; System(nombre InitialChatbotCodeLink chatbot*)
; construir system
; obtener nombre
; obtener chatbot inicial
; obtener lista de chatbots
; obtener lista chathistory
; obtener usuarios registrados
; obtener usuario logeado
; añadir chatbot
; añadir usuario
; login usuario
; logout usuario

; implementacion

; representacion 
; name (string) X InitialChatbotCodeLink (Int) X chatbot* (chatbot*) 

; Nombre de la funcion: system-remove-dup-envoltorio
; Dominio: lista de chatbots
; Recorrido: lista de chatbots
; Recursión: Cola
; Descripción: Esta funcion recibe una lista de chatbots y primero revisa si es que esta
;              vacia, si es que lo esta, retorna "result" el cual inicialmente es una lista
;              vacia, si no, revisa si el id del primer chatbot esta en otra lista que inicialmente
;              esta vacia para verificar unicidad. Luego si es que el id ya estaba, se hace
;              la llamada recursiva con el mismo result e id-list pero con la lista de chatbots
;              sin el primer elemento, luego si el id no estaba se agrega el chatbot a result y
;              su id a id-list en la llamada recursiva sin el primer elemento nuevamente.
(define system-remove-dup-envoltorio (lambda (chatbots)
                (define chatbot-remove-dup (lambda (result id-list chatbots)
                    (if (null? chatbots)
                        result                                
                        (if (member (chatbot-get-id (car chatbots)) id-list)
                            (chatbot-remove-dup result id-list (cdr chatbots))
                            (chatbot-remove-dup (append result (list (car chatbots)))
                                               (cons (chatbot-get-id (car chatbots)) id-list)
                                               (cdr chatbots))))))
                (chatbot-remove-dup (list) (list) chatbots)))

; Constructor:

; Nombre de la funcion: system
; Dominio: string X int X chatbot*
; Recorrido: system
; Recursión: Cola a traves de system-remove-dup-envoltorio
; Descripción: Esta Funcion recibe un string como nombre, un entero id y los enlista con los chatbots
; procesados con system-remove-dup-envoltorio para descartar duplicados y crea la lista de chathistory's
; con el fin de registrar cada interaccion de cada usuario con su usuario (una lista que al principio
; contiene dos listas, para que en una vacia se agregen los registros, y en la otra el usuario logeado
; que al principio es una lista vacia tambien.
(define system (lambda (nombre InitialChatbotCodeLink . chatbot)
                 (list nombre InitialChatbotCodeLink (system-remove-dup-envoltorio chatbot) (list (list) (list)))))

; Nombre de la funcion: check-dup-system
; Dominio: lista de chatbots X chatbot
; Recorrido: lista de chatbots
; Recursión: ninguna
; Descripción: Esta funcion revisa si es que el id del chatbot a agregar ya esta contenida
;              en la lista de id´s. Si es que el id ya esta, no se agrega nada y retorna la original, 
;              si no estaba, se agrega el chatbot a la lista y se retorna.
(define check-dup-system (lambda (chatbot-list chatbot)
                         (if (member (chatbot-get-id chatbot) (map chatbot-get-id chatbot-list))
                             chatbot-list
                             (append chatbot-list (list chatbot)))))

; Selectores:

; Nombre de la funcion: system-get-name
; Dominio: system
; Recorrido: string
; Recursión: ninguna
; Descripción: Esta funcion es sinonimo de caddr para obtener el primer elemento de system.
(define system-get-name car)


; Nombre de la funcion: system-get-initalchatbotid
; Dominio: system
; Recorrido: int
; Recursión: ninguna
; Descripción: Esta funcion es sinonimo de caddr para obtener el segundo elemento de system.
(define system-get-initalchatbotid cadr)


; Nombre de la funcion: system-get-chatbotlist
; Dominio: system
; Recorrido: lista de chatbot's
; Recursión: ninguna
; Descripción: Esta funcion es sinonimo de caddr para obtener el tercer elemento de system.
(define system-get-chatbotlist caddr)

; Nombre de la funcion: system-get-fourth
; Dominio: system
; Recorrido: lista de lista de chatHistory's y lista de user
; Recursión: ninguna
; Descripción: Esta funcion es sinonimo de cadddr para obtener el cuarto elemento system.
(define system-get-fourth (lambda (system)(cadddr system)))


; Nombre de la funcion: system-get-chatHistorylist
; Dominio: system
; Recorrido: lista de chatHistory's
; Recursión: ninguna
; Descripción: Esta funcion compone car con system-get-fourth para obtener
; la lista de chathistory's.
(define system-get-chatHistorylist (lambda (system)(car (system-get-fourth system))))

; Nombre de la funcion: system-get-userlist
; Dominio: system
; Recorrido: lista de user's
; Recursión: ninguna
; Descripción: Esta funcion compone systemchathistory list con map y caadr.
(define system-get-userlist (lambda (system)(map car (system-get-chatHistorylist system))))

; Nombre de la funcion: system-get-loggeduser
; Dominio: system
; Recorrido: lista con un string
; Recursión: ninguna
; Descripción: Esta funcion compone car con system-get-fourth para obtener el usuario logeado.
(define system-get-loggeduser (lambda (system) (cadr (system-get-fourth system))))

; Nombre de la funcion: system-add-chatbot
; Dominio: system X chatbot
; Recorrido: system
; Recursión: ninguna
; Descripción: Esta funcion crea un nuevo system con los 2 primeros elementos del system y la lista de
;              chatbots con el chatbot nuevo, la cual se procesa con la funcion "check-dup-system", para revisar
;              si efectivamente se agrega el chatbot o no (se verifican id duplicados).
(define system-add-chatbot (lambda (system chatbot)
                         (list (system-get-name system) (system-get-initalchatbotid system)
                               (check-dup-system (system-get-chatbotlist system) chatbot) (system-get-fourth system))))

(define system-add-user (lambda (system User)
                          (if (member (user User) (system-get-userlist system))
                              system
                              (list (system-get-name system) (system-get-initalchatbotid system)
                                      (system-get-chatbotlist system)
                                      (list (cons (chatHistory User) (system-get-chatHistorylist system)) (list))))))
                          