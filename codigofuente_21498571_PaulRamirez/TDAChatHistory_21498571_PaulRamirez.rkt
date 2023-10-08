#lang racket

;Provee cada una de las definiciones al archivo que lo requiera
(provide (all-defined-out))
;Incluimos TDAs implementados, funciones de utilidad y definiciones de prueba
(require "TDAUser_21498571_PaulRamirez.rkt")

; TDA ChatHistory
; especificación

; chatHistory(user)
; chatHistory
; chatHistory-get-user
; chatHistory-get-register

; implementacion

; representacion 
; user

; Constructor:

; Nombre de la funcion: chatHistory
; Dominio: user X string
; Recorrido: chatHistory
; Recursión: ninguna
; Descripción: Esta Funcion recibe un usuario y un string y los enlista.
(define chatHistory (lambda (user string) (list user string)))

; Selectores:

; Nombre de la funcion: chatHistory-get-user
; Dominio: chatHistory
; Recorrido: user
; Recursión: ninguna
; Descripción: Esta Funcion es sinonimo de car para obtener el primer elemento de un chathistory.
(define chatHistory-get-user car)

; Nombre de la funcion: chatHistory-get-register
; Dominio: chatHistory
; Recorrido: string
; Recursión: ninguna
; Descripción: Esta Funcion es sinonimo de cadr para obtener el segundo elemento de un chathistory.
(define chatHistory-get-register cadr)



