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
; system-search-chatbot
; system-search-coord
; system-add-chatbot
; system-add-user
; system-login
; system-logout
; system-registerappendstring
; system-update-history

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

; Nombre de la funcion: system-search-chatbot
; Dominio: system X int
; Recorrido: chatbot
; Recursión: Cola
; Descripción: Esta funcion recibe un system y busca un chatbot en este, a partir del id entregado.
(define system-search-chatbot (lambda (system id)
                                (define system-buscar-chatbot-id (lambda (listachatbot id)
                                                                   (if (= (chatbot-get-id (car listachatbot)) id)
                                                                       (car listachatbot)
                                                                       (system-buscar-chatbot-id (cdr listachatbot) id))))
                                (system-buscar-chatbot-id (system-get-chatbotlist system) id)))

; Nombre de la funcion: system-search-coord
; Dominio: system X string
; Recorrido: option
; Recursión: Cola a traves de los search
; Descripción: Esta funcion recibe un system y busca un option en este, a partir de una keyword, dependiendo de la ultima interaccion
; para saber cual es el chatbot y flujo actual de la conversacion.
(define system-search-coord (lambda (system message)
                              (system-search-option (flow-get-options (system-search-flow (system-search-chatbot system (car (system-get-actual system)))
                                                                                          (cadr (system-get-actual system))))
                                                    message)))

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
; la actual sesion y se retorna el system con ese apartado vacio, junto con reiniciar la
; interaccion actual.
(define system-logout (lambda (system)
                        (list (system-get-name system) (system-get-initialchatbotid system)
                              (system-get-chatbotlist system)
                              (list (system-get-chatHistorylist system) (list)) (list))))

; Nombre de la funcion: system-registerappendstring
; Dominio: system X string
; Recorrido: string
; Recursión: Cola a traves de las funciones search
; Descripción: Esta funcion recibe un system y el mensaje, y retorna la respuesta del
; chatbot en base a las coordenadas de la opcion elegida, haciendo append de los mensajes
; del nuevo chatbot, flow y las opciones, de manera formateada para display
(define system-registerappendstring (lambda (system message)
                                      (if (null? (system-get-actual system))
                                          (string-append "\n" (number->string (current-seconds)) " - " (first (system-get-loggeduser system)) ": " message "\n"
                                                         (number->string (current-seconds)) " - " (chatbot-get-name (system-search-chatbot  system (system-get-initialchatbotid system)))
                                                         ": " (flow-get-msg (system-search-flow (system-search-chatbot system (system-get-initialchatbotid system))
                                                                                                (chatbot-get-startFlowId (system-search-chatbot system (system-get-initialchatbotid system)))))
                                                         (system-get-options-msg (system-search-flow (system-search-chatbot system (system-get-initialchatbotid system))
                                                                                                     (chatbot-get-startFlowId (system-search-chatbot system (system-get-initialchatbotid system))))) "\n")
                                          (let ([opt (system-search-coord system (string-downcase message))]) (string-append "\n" (number->string (current-seconds)) " - " (first (system-get-loggeduser system)) ": " message "\n"
                                                                                                                            (number->string (current-seconds)) " - " (chatbot-get-name (system-search-chatbot system (option-get-chatbotcodelink opt)))
                                                                                                                            ": " (flow-get-msg (system-search-flow (system-search-chatbot system (option-get-chatbotcodelink opt))
                                                                                                                                                                   (option-get-initialflowcodelink opt)))
                                                                                                                            (system-get-options-msg (system-search-flow (system-search-chatbot system (option-get-chatbotcodelink opt))
                                                                                                                                                                        (option-get-initialflowcodelink opt))) "\n")))))

; Nombre de la funcion: search-user
; Dominio: lista de chatHistory's X user
; Recorrido: chatHistory
; Recursión: Cola
; Descripción: Esta funcion recibe un la lista de chatHistory's y retorna el chatHistory
; que coincide con el usuario recibido a traves de un member y una recursion descartando los que
; no lo contienen.
(define search-user (lambda (listachatHistory user)
                      (if (member (chatHistory-get-user (car listachatHistory)) user)
                          (car listachatHistory)
                          (search-user (cdr listachatHistory) user))))

; Nombre de la funcion: system-update-history
; Dominio: system X string
; Recorrido: lista de la Lista de chatHistory's y lista de user
; Recursión: Cola a traves de search user y system-registerappendstring que contiene varias funciones search recursivas
; Descripción: Esta funcion recibe un system y un mensaje y dependiendo si es el primer mensaje o no,
; reconstruye el registro de los chatHistory y el usuario logeado agregando los ultimos 2 mensajes
; el del usuario y la respuesta del chatbot al chatHistory de este ultimo.
(define system-update-history (lambda (system message)
                                (define notuser (lambda (chathistory)
                                                  (not (equal? (first (system-get-loggeduser system)) (first chathistory)))))
                                (if (null? (system-get-actual system))
                                    (cons (cons (chatHistory (first (system-get-loggeduser system)) (string-append (chatHistory-get-register (search-user (system-get-chatHistorylist system) (system-get-loggeduser system)))
                                                                                                                   (system-registerappendstring system message)
                                                                                                                   )
                                                             ) (filter notuser (system-get-chatHistorylist system))) (list (system-get-loggeduser system)))
                                    (cons (cons (chatHistory (first (system-get-loggeduser system)) (string-append (chatHistory-get-register (search-user (system-get-chatHistorylist system) (system-get-loggeduser system)))
                                                                                                                   (system-registerappendstring system message))
                                                             )
                                                (filter notuser (system-get-chatHistorylist system))) (list (system-get-loggeduser system))))))
