#lang racket


;Provee cada una de las definiciones al archivo que lo requiera
(provide (all-defined-out))

(require "TDASystem_21498571_PaulRamirez.rkt")
(require "TDAChatHistory_21498571_PaulRamirez.rkt")
(require "TDAUser_21498571_PaulRamirez.rkt")
(require "TDAChatbot_21498571_PaulRamirez.rkt")
(require "TDAFlow_21498571_PaulRamirez.rkt")
(require "TDAOption_21498571_PaulRamirez.rkt")

; Archivo principal                                         

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