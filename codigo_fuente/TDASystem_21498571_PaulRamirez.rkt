#lang racket

;Provee cada una de las definiciones al archivo que lo requiera
(provide (all-defined-out))
(require "TDAChatbot_21498571_PaulRamirez.rkt")
(require "TDAChatHistory_21498571_PaulRamirez.rkt")
(require "TDAUser_21498571_PaulRamirez.rkt")
(require "TDAFlow_21498571_PaulRamirez.rkt")
(require "TDAOption_21498571_PaulRamirez.rkt")

; TDA System
; especificación

; System(nombre InitialChatbotCodeLink chatbot*)
; system
; system-get-name
; system-get-initialchatbotid
; system-get-chabotlist
; system-get-fourth
; system-get-chatHistorylist
; system-get-userlist
; system-get-loggeduser
; system-get-actual
; system-add-chatbot
; system-add-user
; system-login
; system-logout

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
; que al principio es una lista vacia tambien, junto con una ultima que indica el chatbot y flow actual.
(define system (lambda (nombre InitialChatbotCodeLink . chatbot)
                 (list nombre InitialChatbotCodeLink (system-remove-dup-envoltorio chatbot) (list (list) (list)) (list))))

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
; Descripción: Esta funcion es sinonimo de car para obtener el primer elemento de system.
(define system-get-name car)


; Nombre de la funcion: system-get-initialchatbotid
; Dominio: system
; Recorrido: int
; Recursión: ninguna
; Descripción: Esta funcion es sinonimo de cadr para obtener el segundo elemento de system.
(define system-get-initialchatbotid cadr)

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
; Descripción: Esta funcion compone systemchathistory list con map y car.
(define system-get-userlist (lambda (system)(map car (system-get-chatHistorylist system))))

; Nombre de la funcion: system-get-loggeduser
; Dominio: system
; Recorrido: lista con un user
; Recursión: ninguna
; Descripción: Esta funcion compone cadr con system-get-fourth para obtener el usuario logeado.
(define system-get-loggeduser (lambda (system) (cadr (system-get-fourth system))))

; Nombre de la funcion: system-get-actual
; Dominio: system
; Recorrido: lista de 2 enteros y un string
; Recursión: ninguna
; Descripción: Esta funcion usa Last para obtener la ultima interaccion de talk.
(define system-get-actual (lambda (system) (last system)))

; Modificadores

; Nombre de la funcion: system-add-chatbot
; Dominio: system X chatbot
; Recorrido: system
; Recursión: ninguna
; Descripción: Esta funcion reconstruye el system, pero procesa la lista de
;              chatbots con el chatbot nuevo, la cual se procesa con la funcion "check-dup-system", para revisar
;              si efectivamente se agrega el chatbot o no (se verifican id duplicados).
(define system-add-chatbot (lambda (system chatbot)
                             (list (system-get-name system) (system-get-initialchatbotid system)
                                   (check-dup-system (system-get-chatbotlist system) chatbot)
                                   (system-get-fourth system) (system-get-actual system))))

; Nombre de la funcion: system-add-user
; Dominio: system X user
; Recorrido: system
; Recursión: ninguna
; Descripción: Esta funcion crea un nuevo system con los 3 primeros elementos del system con la lista
; de chattHistory's con el usuario nuevo si es que este ya no estaba, esto se verifica usando member
; con el usuario nuevo y la lista de usuarios obtenida con system-get-user-list, en el caso contrario
; (ya existia el nombre de usuario) se retorna el system original.
(define system-add-user (lambda (system User)
                          (if (member (user User) (system-get-userlist system))
                              system
                              (list (system-get-name system) (system-get-initialchatbotid system)
                                    (system-get-chatbotlist system)
                                    (list (cons (chatHistory User "") (system-get-chatHistorylist system)) (list))
                                    (system-get-actual system)))))

; Otros

; Nombre de la funcion: system-login
; Dominio: system X user
; Recorrido: system
; Recursión: ninguna
; Descripción: Esta funcion revisa si el usuario recibido se encuentra registrado en el system
; si lo esta y no hay ninguna sesion iniciada, este inicia sesion quedando su nombre guardado
; en el apartado de usuario logeado, caso contrario no se hace nada y se retorna el original.
(define system-login (lambda (system User)
                       (if (and (null? (system-get-loggeduser system)) (member User (system-get-userlist system)))
                           (list (system-get-name system) (system-get-initialchatbotid system)
                                 (system-get-chatbotlist system)
                                 (list (system-get-chatHistorylist system) (list (user User))) (system-get-actual system))
                           system)))

; Nombre de la funcion: system-logout
; Dominio: system
; Recorrido: system
; Recursión: ninguna
; Descripción: Esta funcion saca al usuario logeado del apartado de donde se guarda
; la actual sesion y se retorna el system con ese apartado vacio.
(define system-logout (lambda (system)
                        (list (system-get-name system) (system-get-initialchatbotid system)
                              (system-get-chatbotlist system)
                              (list (system-get-chatHistorylist system) (list)) (system-get-actual system))))