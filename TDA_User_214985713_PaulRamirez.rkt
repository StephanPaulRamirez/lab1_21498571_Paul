#lang racket

;Provee cada una de las definiciones al archivo que lo requiera
(provide (all-defined-out))

; TDA User
; especificación

; user(nombre)
; construir usuario

; implementacion

; representacion
; string

; Constructor:

; Nombre de la funcion: User
; Dominio: string
; Recorrido: user
; Recursión: ninguna
; Descripción: Esta Funcion recibe un string como nombre y lo enlista.
(define user (lambda (nombre) nombre))

