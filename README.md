# evaluacion-N-3
BBDD Relaciones y consultas PL/SQL

La problematica de este ejercicio es generar un modelo lógico y relacional para el sistema de evaluación de aprendizaje y desarrollo de competencias de Awakelab, el cual debe permitir que cada evaluación consistente en 1 o más preguntas con 1 o más alternativas (las cuales pueden tener más de 1 solución) sean mantenidas en una base de datos junto con los cursos, alumnos, programas y un registro de las soluciones a cada prueba de cada alumno.
Finalmente se solicita generar diversos scripts DML para ingresar datos a las BBDD creadas, asi como scripts DCL para consultar información de las BBDD creadas.

La solución consiste en generar el modelo lógico y relacional a través de oracle sql data modeler, a través del cual generar un DDL que pueda generar automaticamente las bases de datos y sus tablas respectivas en oracle sql developer, generar los scripts de carga de información, para luego consultar la información requerida.


![modelo relacional](https://github.com/mlilloblanco/evaluacion-N-3/blob/master/Relational_1.png)

Notas importantes:
Se debe ejecutar el DDL primero para generar las tablas utilizadas
1)Luego se debe ejecutar el script carga evaluaciones
2)Seguido por el script cursosAlumnos 
3)y finalmente el script registrorespustas
Se sigue este orden para no tener problemas con las restricciones impuestas por las llaves foraneas del modelo relacional
4) finalmente con el script preguntas se pueden ver las consultas necesarias para responder los ejercicios planteados en el problema

Supuestos:
1) se considero independiente el calculo del puntaje normalizado en el cual se utiliza el puntaje asociado a cada pregunta y se puede obtener porcentajes correctos, sin necesidad de tener una alternativa completamente mala.
2) Se considero independiente el calculo del puntaje no normalizado, obteniendo exactamente las respuestas buenas, restandole las malas divido 4 y no considerando las omitidas.
3) Se utilizaron tablas temporales para los 2 calculos anteriores, para poder registrar valores agrupados sin recurrir a la generacion completa de nuevas talas.
4) El curso diseño UX tiene solo 1 alumno asociado y ninguna prueba esta hecho a proposito para probar deficiencias
5) La evaluacion 3 y 4 no tienen cursos asociados estan hechas para probar deficiencias.
