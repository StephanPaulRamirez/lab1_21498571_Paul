# lab1_214985713_StephanPaul

El uso casi nulo de Let en el laboratorio es debido a la ignorancia de la existencia de la funcion y a que tampoco sabia
que se podia usar, lo cual dificulta la legibilidad del codigo pero por otro lado el uso del paradigma funcional
es mas puro. Tambien los commit consecutivos de borrar archivos, fue para eliminar los archivos de respaldo.bak, junto que 
se cambio el nombre de los archivos por que incluian el digito verificador del RUT.

Observacion: debido a que la unica forma de reinicar una conversacion es iniciando sesion y hablar con un usuario nuevo
en la implementacion, si es que se hace logout y luego login con otro usuario que no es su primera vez hablando,
este tiene que responder de acuerdo a la ultima interaccion del usuario anterior o el programa se cae. Por otro lado
en vez de crear un option que contenga solo keywords en minuscula o mayuscula, la funcion talk-rec se ocupa de comparar
con string-downcase.