#lang racket

;Provee cada una de las definiciones al archivo que lo requiera
(provide (all-defined-out))

; TDA User
; especificación

; user(nombre)
; User

; implementacion

; representacion
; string

; Constructor:

; Nombre de la funcion: User
; Dominio: string
; Recorrido: user
; Recursión: ninguna
; Descripción: Esta Funcion recibe un string como nombre y devuelve un user.
(define user (lambda (nombre) nombre))
