#lang racket

(require "TDASystem_21498571_PaulRamirez.rkt")
(require "TDAChatHistory_21498571_PaulRamirez.rkt")
(require "TDAUser_21498571_PaulRamirez.rkt")
(require "TDAChatbot_21498571_PaulRamirez.rkt")
(require "TDAFlow_21498571_PaulRamirez.rkt")
(require "TDAOption_21498571_PaulRamirez.rkt")
(require "main_21498571_PaulRamirez.rkt")

;Mis ejemplos para cada Requerimiento funcional

;ejemplos option
(define option11 (option 1 "1) Adoptar" 1 0 "adoptar" )) ; se crean options con distintos links
(define option12 (option 2 "2) Estudiar" 2 0 "estudiar"))
(define option1 (option 1 "1) perro" 1 1 "perro" "can" "perrito")) ;se crean con mas de una keyword
(define option2 (option 2 "2) gato" 1 2 "gato" "felino" "gatito" "michi"))
(define option4 (option 1 "1) calculo" 0 0 "calculo")) ;se crean options que mandan al inicio de la conversacion
(define option5 (option 2 "2) algebra" 0 0 "algebra"))
(define option6 (option 3 "3) fisica" 0 0 "fisica"))
(define option7 (option 1 "1) grande" 0 0 "grande"))
(define option8 (option 2 "2) chico" 0 0 "chico"))
(define option9 (option 1 "1) corto" 0 0 "corto" ))
(define option10 (option 2 "2) largo" 0 0 "largo"))

;ejemplos flow
(define flow4 (flow 0 "¿Que te gustaria hacer?")) ;se crea flow sin options
(define flow0 (flow 0 "¿Que te gustaria adoptar?" option1 option2)) ;flow con 2 options
(define flow2 (flow 0 "¿Que ramo quieres estudiar?" option4 option4 option4 option5 option6)) ;se deja la primera instancia si hay id repetido de options en un flow
(define flow3 (flow 1 "¿Que tamaño?" option7))
(define flow5 (flow 2 "¿Que tan largo el pelo?" option9 option10))
;ejemplos flow-add-option
(define flow6 (flow-add-option flow3 option8)) ;se agregan options nuevos
(define flow7 (flow-add-option flow4 option11))
(define flow8 (flow-add-option flow7 option12))
(define flow9 (flow-add-option flow8 option12)) ;no se agrega nada por id repetido
;ejemplos chatbot
(define chatbot0 (chatbot 0 "inicial" "Bienvenido" 0)) ;chatbot sin flows
(define chatbot1 (chatbot 1 "Adoptar" "¿que quieres adoptar?" 0 flow0 flow6)) ;chatbot con 2 flows
(define chatbot2 (chatbot 2 "Estudiar" "¿que quieres estudiar?" 0 flow2 flow2 flow2)) ;deja la primera instancia si hay id repetido del flow en el chatbot
;ejemplos chatbot-add-flow
(define chatbot3 (chatbot-add-flow chatbot0 flow8)) ;se añade un flow
(define chatbot4 (chatbot-add-flow chatbot1 flow5))
(define chatbot5 (chatbot-add-flow chatbot1 flow5)) ;no hace nada porque esta repetido el id del flow
;ejemplos system
(define system1 (system "chatbots ejemplo" 0)) ;system sin chatbots
(define system2 (system "chatbots ejemplo" 0 chatbot3))
(define system3 (system "chatbots ejemplo" 0 chatbot3 chatbot3 chatbot3)) ;se deja la primera instancia si hay chatbots con id repetido en un system
;ejemplos system-add-chatbot
(define system4 (system-add-chatbot system3 chatbot1)) ;se agrega un chatbot
(define system5 (system-add-chatbot system4 chatbot0)) ;id repetido no agrega el chatbot
(define system6 (system-add-chatbot system5 chatbot2)) ;agrega el segundo chatbot
;ejemplos system-add-user
(define system7 (system-add-user system6 "usuario0")) ;agrega el usuario 
(define system8 (system-add-user system7 "usuario0")) ;no agrega nada porque ya esta registrado
(define system9 (system-add-user system8 "usuario1")) 
;ejemplos system-login
(define system10 (system-login system9 "usuario8")) ;no inicia porque no esta registrado
(define system11 (system-login system10 "usuario0")) ;inicia sesion
(define system12 (system-login system11 "usuario1")) ;no hace nada porque hay sesion abierta
;ejemplso system-logout
(define system13 (system-logout system12)) ;hace logout del usuario 0
(define system14 (system-logout system10)) ;no hace nada, no hay usuarios logeados
(define system15 (system-logout system11)) 
;ejemplos system-talk-rec
(define system16 (system-talk-rec system15 "hola")) ;no hace nada, no hay usuario logeado
(define system17 (system-talk-rec system12 "hola")) ;inicia historial del usuario 0
(define system18 (system-talk-rec system17 "1")) ;se linkea al chatbot 1 flow 0
(define system19 (system-talk-rec system18 "1")) ;se linkea al chatbot 1 flow 1
;Ejemplos enunciado

;Ejemplo de un sistema de chatbots basado en el esquema del enunciado general
;Chabot0
(define op1 (option  1 "1) Viajar" 1 1 "viajar" "turistear" "conocer"))
(define op2 (option  2 "2) Estudiar" 2 1 "estudiar" "aprender" "perfeccionarme"))
(define f10 (flow 1 "Flujo Principal Chatbot 1\nBienvenido\n¿Qué te gustaría hacer?" op1 op2 op2 op2 op2 op1)) ;solo añade una ocurrencia de op2   y op1
(define f11 (flow-add-option f10 op1)) ;se intenta añadir opción duplicada            
(define cb0 (chatbot 0 "Inicial" "Bienvenido\n¿Qué te gustaría hacer?" 1 f10 f10 f10 f10))  ;solo añade una ocurrencia de f10
;Chatbot1
(define op3 (option 1 "1) New York, USA" 1 2 "USA" "Estados Unidos" "New York"))
(define op4 (option 2 "2) París, Francia" 1 1 "Paris" "Eiffel"))
(define op5 (option 3 "3) Torres del Paine, Chile" 1 1 "Chile" "Torres" "Paine" "Torres Paine" "Torres del Paine"))
(define op6 (option 4 "4) Volver" 0 1 "Regresar" "Salir" "Volver"))
;Opciones segundo flujo Chatbot1
(define op7 (option 1 "1) Central Park" 1 2 "Central" "Park" "Central Park"))
(define op8 (option 2 "2) Museos" 1 2 "Museo"))
(define op9 (option 3 "3) Ningún otro atractivo" 1 3 "Museo"))
(define op10 (option 4 "4) Cambiar destino" 1 1 "Cambiar" "Volver" "Salir")) 
(define op11 (option 1 "1) Solo" 1 3 "Solo")) 
(define op12 (option 2 "2) En pareja" 1 3 "Pareja"))
(define op13 (option 3 "3) En familia" 1 3 "Familia"))
(define op14 (option 4 "4) Agregar más atractivos" 1 2 "Volver" "Atractivos"))
(define op15 (option 5 "5) En realidad quiero otro destino" 1 1 "Cambiar destino"))
(define f20 (flow 1 "Flujo 1 Chatbot1\n¿Dónde te Gustaría ir?" op3 op4 op5 op6))
(define f21 (flow 2 "Flujo 2 Chatbot1\n¿Qué atractivos te gustaría visitar?" op7 op8 op9 op10))
(define f22 (flow 3 "Flujo 3 Chatbot1\n¿Vas solo o acompañado?" op11 op12 op13 op14 op15))
(define cb1 (chatbot 1 "Agencia Viajes"  "Bienvenido\n¿Dónde quieres viajar?" 1 f20 f21 f22))
;Chatbot2
(define op16 (option 1 "1) Carrera Técnica" 2 1 "Técnica"))
(define op17 (option 2 "2) Postgrado" 2 1 "Doctorado" "Magister" "Postgrado"))
(define op18 (option 3 "3) Volver" 0 1 "Volver" "Salir" "Regresar"))

(define f30 (flow 1 "Flujo 1 Chatbot2\n¿Qué te gustaría estudiar?" op16 op17 op18))
(define cb2 (chatbot 2 "Orientador Académico"  "Bienvenido\n¿Qué te gustaría estudiar?" 1 f30))
;Sistema
(define s0 (system "Chatbots Paradigmas" 0 cb0 cb0 cb0 cb1 cb2))
(define s1 (system-add-chatbot s0 cb0)) ;igual a s0
(define s2 (system-add-user s1 "user1"))
(define s3 (system-add-user s2 "user2"))
(define s4 (system-add-user s3 "user2"))
(define s5 (system-add-user s4 "user3"))
(define s6 (system-login s5 "user8"))
(define s7 (system-login s6 "user1"))
(define s8 (system-login s7 "user2"))
(define s9 (system-logout s8))
(define s10 (system-login s9 "user2"))
;las siguientes interacciones deben funcionar de igual manera con system-talk-rec  o system-talk-norec 
(define s11 (system-talk-rec s10 "hola"))
(define s12 (system-talk-rec s11 "1"))
(define s13 (system-talk-rec s12 "1"))
(define s14 (system-talk-rec s13 "Museo"))
(define s15 (system-talk-rec s14 "1"))
(define s16 (system-talk-rec s15 "3"))
(define s17 (system-talk-rec s16 "5"))
