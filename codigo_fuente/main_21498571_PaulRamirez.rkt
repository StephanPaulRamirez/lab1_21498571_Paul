#lang racket


;Provee cada una de las definiciones al archivo que lo requiera
(provide (all-defined-out))

(require "TDASystem_21498571_PaulRamirez.rkt")
(require "TDAChatHistory_21498571_PaulRamirez.rkt")
(require "TDAUser_21498571_PaulRamirez.rkt")
(require "TDAChatbot_21498571_PaulRamirez.rkt")
(require "TDAFlow_21498571_PaulRamirez.rkt")
(require "TDAOption_21498571_PaulRamirez.rkt")

; Archivo principal donde se definen las funciones necesarias
; para hacer funcionar a system-talk-rec

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

; Nombre de la funcion: system-search-flow
; Dominio: chatbot X int
; Recorrido: flow
; Recursión: Cola
; Descripción: Esta funcion recibe un chatbot y busca un flow en este, a partir del id entregado.
(define system-search-flow (lambda (chatbot id)
                             (define system-buscar-flow-id (lambda (listaflow id)
                                                             (if (= (flow-get-id (car listaflow)) id)
                                                                 (car listaflow)
                                                                 (system-buscar-flow-id (cdr listaflow) id))))
                             (system-buscar-flow-id (chatbot-get-flows chatbot) id)))

; Nombre de la funcion: system-search-option
; Dominio: lista de opciones X string
; Recorrido: option
; Recursión: Cola
; Descripción: Esta funcion recibe una lista de opciones y busca un option en este, a partir de una keyword.
(define system-search-option (lambda (listaoptions keyword)
                               (if (or (equal? (string->number keyword) (option-get-id (car listaoptions))) (member keyword (map string-downcase (option-get-keywords (car listaoptions)))))
                                   (car listaoptions)
                                   (system-search-option (cdr listaoptions) keyword))))

; Nombre de la funcion: system-search-coord
; Dominio: system X sring
; Recorrido: option
; Recursión: ninguna
; Descripción: Esta funcion recibe un system y busca un option en este, a partir de una keyword, dependiendo de la ultima interaccion
; para saber cual es el chatbot y flujo actual de la conversacion.
(define system-search-coord (lambda (system message)
                              (system-search-option (flow-get-options (system-search-flow (system-search-chatbot system (car (system-get-actual system)))
                                                                                          (cadr (system-get-actual system))))
                                                    message)))

; Nombre de la funcion: system-get-options-msg
; Dominio: flow
; Recorrido: string
; Recursión: Cola
; Descripción: Esta funcion recibe un flow y retorna a traves de una recursion que hace append
; de los message de cada option el mensaje formateado
(define system-get-options-msg (lambda (flow)
                                 (define get-msg (lambda (result optionlist)
                                                   (if (null? optionlist)
                                                       result
                                                       (get-msg (string-append result "\n" (option-get-msg (car optionlist))) (cdr optionlist)))))
                                 (get-msg "\n" (flow-get-options flow))))

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

; Nombre de la funcion: system-registerappendstring
; Dominio: system X string
; Recorrido: string
; Recursión: Cola a traves de las funciones search
; Descripción: Esta funcion un system y el mensaje recibido y retorna la respuesta del
; chatbot en base a las coordenadas de la opcion elegida, haciendo append de los mensajes
; del nuevo chatbot, flow y las opciones, de manera formateada para display
(define system-registerappendstring (lambda (system message)
                                      (if (equal? (chatHistory-get-register (search-user (system-get-chatHistorylist system) (system-get-loggeduser system))) "")
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
; Nombre de la funcion: system-update-history
; Dominio: system X string
; Recorrido: lista de la Lista de chatHistory's, con el usuario logeado
; Recursión: Cola a traves de search user y system-registerappendstring que contiene varias funciones search recursivas
; Descripción: Esta funcion recibe un system y un mensaje y dependiendo si es el primer mensaje o no,
; reconstruye el registro de los chatHistory y el usuario logeado agregando los ultimos 2 mensajes
; el del usuario y la respuesta del chatbot al chatHistory de este ultimo.
(define system-update-history (lambda (system message)
                                (define notuser (lambda (chathistory)
                                                  (not (equal? (first (system-get-loggeduser system)) (first chathistory)))))
                                (if (equal? (chatHistory-get-register (search-user (system-get-chatHistorylist system) (system-get-loggeduser system))) "")
                                    (cons (cons (chatHistory (first (system-get-loggeduser system)) (string-append (chatHistory-get-register (search-user (system-get-chatHistorylist system) (system-get-loggeduser system)))
                                                                                                                   (system-registerappendstring system message)
                                                                                                                   )
                                                             ) (filter notuser (system-get-chatHistorylist system))) (list (system-get-loggeduser system)))
                                    (cons (cons (chatHistory (first (system-get-loggeduser system)) (string-append (chatHistory-get-register (search-user (system-get-chatHistorylist system) (system-get-loggeduser system)))
                                                                                                                   (system-registerappendstring system message))
                                                             )
                                                (filter notuser (system-get-chatHistorylist system))) (list (system-get-loggeduser system))))))
                                                   

; Nombre de la funcion: system-talk-rec
; Dominio: system X string
; Recorrido: system
; Recursión: Cola a traves de las funciones search y system-update-history que tambien las contiene
; Descripción: Esta funcion recibe un system y un mensaje, y primero revisa si existe un usuario
; logeado, si no hay no hace nada, si hay revisa si es que es el primer mensaje o no,
; y dependiendo de esto reconstruye el system actualizando el actual chatbot/flow.
(define system-talk-rec(lambda (system message)
                         (if (null? (system-get-loggeduser system))
                             system
                             (if (equal? (chatHistory-get-register (search-user (system-get-chatHistorylist system) (system-get-loggeduser system))) "")
                                 (list (system-get-name system) (system-get-initialchatbotid system)
                                       (system-get-chatbotlist system)
                                       (system-update-history system message)
                                       (list (system-get-initialchatbotid system)
                                             (chatbot-get-startFlowId (system-search-chatbot system (system-get-initialchatbotid system))) message))
                                 (list (system-get-name system) (system-get-initialchatbotid system)
                                       (system-get-chatbotlist system)
                                       (system-update-history system message)
                                       (list (option-get-chatbotcodelink (system-search-coord system (string-downcase message)))
                                             (option-get-initialflowcodelink (system-search-coord system (string-downcase message)))
                                             message))))))