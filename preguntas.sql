--1) cantidad de evaluaciones por curso
SELECT cursos.nombrecurso, COUNT(cursostest.id_test) AS evaluaciones
FROM cursos INNER JOIN cursostest
ON cursos.id_curso = cursostest.id_curso
GROUP BY cursos.nombrecurso;

--2) cursos sin evaluacion
SELECT cursos.nombrecurso, COUNT(cursostest.id_test) AS evaluaciones
FROM cursos LEFT JOIN cursostest
ON cursos.id_curso = cursostest.id_curso
WHERE cursostest.id_curso IS NULL
GROUP BY cursos.nombrecurso;

--3)determinar las evaluacion con deficiencias
--primero se buscan las evaluaciones sin preguntas
SELECT test.nombretest, COUNT(preguntas.id_pregunta) AS CantidadPreguntas
FROM test LEFT JOIN preguntas
ON test.id_test = preguntas.id_test
WHERE preguntas.id_pregunta IS NULL
GROUP BY test.nombretest;

--luego se buscan las evaluaciones con preguntas con 2 o menos alternativas
SELECT test.nombretest, preguntas.id_pregunta, COUNT(alternativas.id_alternativa) AS CantidadAlternativas
FROM preguntas INNER JOIN alternativas
ON preguntas.id_pregunta = alternativas.id_pregunta
INNER JOIN test
ON preguntas.id_test = test.id_test
GROUP BY test.nombretest, preguntas.id_pregunta
HAVING COUNT(alternativas.id_alternativa) <= 2
ORDER BY nombretest, preguntas.id_pregunta;

--finalmente se buscan las evaluaciones con preguntas que tengan todas las alternativas correctas o ninguna alternativa correcta
SELECT test.nombretest, preguntas.id_pregunta, COUNT(alternativas.id_alternativa) AS CantidadAlternativas, SUM(alternativas.correcta_incorrecta) AS cantidadAlternativasCorrectas
FROM preguntas INNER JOIN alternativas
ON preguntas.id_pregunta = alternativas.id_pregunta
INNER JOIN test
ON preguntas.id_test = test.id_test
GROUP BY test.nombretest, preguntas.id_pregunta
HAVING COUNT(alternativas.id_alternativa)  = SUM(alternativas.correcta_incorrecta) OR SUM(alternativas.correcta_incorrecta) = 0
ORDER BY test.nombretest, preguntas.id_pregunta;

--4)determinar la cantidad de alumnos por curso
-- notese que Hernan Hernandez participa en 2 cursos a la vez, tal como lo permite el modelo relacional.
SELECT cursos.id_curso, cursos.nombrecurso, COUNT(id_alumno) AS CantidadAlumnos
FROM cursos LEFT JOIN cursosalumnos
ON cursos.id_curso = cursosalumnos.id_curso
GROUP BY cursos.id_curso, cursos.nombrecurso
ORDER BY cursos.id_curso, cursos.nombrecurso;

--5)Obtener el puntaje no normalizado de cada evaluacion    

--primero se obtienen las buenas y luego las malas por separado, y luego las omitidas
CREATE GLOBAL TEMPORARY TABLE TEMPORAL3
ON COMMIT PRESERVE ROWS
AS SELECT alumnos.id_alumno, alumnos.nombre, alumnos.apellido, cursos.nombrecurso, test.nombretest, preguntas.id_pregunta, 'correctas' AS correcta_incorrecta_omitida, SUM(porcentajecorrecta) AS Correctas
FROM registrorespuestas INNER JOIN alternativas
ON registrorespuestas.id_alternativa = alternativas.id_alternativa
INNER JOIN alumnos
ON alumnos.id_alumno = registrorespuestas.id_alumno
INNER JOIN preguntas
ON preguntas.id_pregunta = registrorespuestas.id_pregunta AND alternativas.id_pregunta = registrorespuestas.id_pregunta
INNER JOIN cursos
ON cursos.id_curso = registrorespuestas.id_curso
INNER JOIN test
ON test.id_test = registrorespuestas.id_test AND preguntas.id_test = registrorespuestas.id_test
WHERE seleccion=correcta_incorrecta
GROUP BY alumnos.id_alumno, alumnos.nombre, alumnos.apellido, cursos.nombrecurso, test.nombretest, preguntas.id_pregunta
HAVING  SUM(porcentajecorrecta) = 1
--ORDER BY alumnos.id_alumno, alumnos.nombre, alumnos.apellido, test.nombretest, preguntas.id_pregunta
UNION ALL
SELECT alumnos.id_alumno, alumnos.nombre, alumnos.apellido, cursos.nombrecurso, test.nombretest, preguntas.id_pregunta, 'incorrectas' AS correcta_incorrecta_omitida, SUM(porcentajecorrecta) AS Correctas
FROM registrorespuestas INNER JOIN alternativas
ON registrorespuestas.id_alternativa = alternativas.id_alternativa
INNER JOIN alumnos
ON alumnos.id_alumno = registrorespuestas.id_alumno
INNER JOIN preguntas
ON preguntas.id_pregunta = registrorespuestas.id_pregunta AND alternativas.id_pregunta = registrorespuestas.id_pregunta
INNER JOIN cursos
ON cursos.id_curso = registrorespuestas.id_curso
INNER JOIN test
ON test.id_test = registrorespuestas.id_test AND preguntas.id_test = registrorespuestas.id_test
WHERE seleccion=correcta_incorrecta
GROUP BY alumnos.id_alumno, alumnos.nombre, alumnos.apellido, cursos.nombrecurso, test.nombretest, preguntas.id_pregunta
HAVING  SUM(porcentajecorrecta) < 1
--ORDER BY alumnos.id_alumno, alumnos.nombre, alumnos.apellido, test.nombretest, preguntas.id_pregunta;
UNION ALL
--al omitir debe omitir todas las alternativas o sino ya pasa a ser respuesta...
SELECT alumnos.id_alumno, alumnos.nombre, alumnos.apellido, cursos.nombrecurso, test.nombretest, preguntas.id_pregunta, 'omitidas' AS correcta_incorrecta_omitida, SUM(seleccion) AS Correctas
FROM registrorespuestas INNER JOIN alternativas
ON registrorespuestas.id_alternativa = alternativas.id_alternativa
INNER JOIN alumnos
ON alumnos.id_alumno = registrorespuestas.id_alumno
INNER JOIN preguntas
ON preguntas.id_pregunta = registrorespuestas.id_pregunta AND alternativas.id_pregunta = registrorespuestas.id_pregunta
INNER JOIN cursos
ON cursos.id_curso = registrorespuestas.id_curso
INNER JOIN test
ON test.id_test = registrorespuestas.id_test AND preguntas.id_test = registrorespuestas.id_test
WHERE seleccion=2
GROUP BY alumnos.id_alumno, alumnos.nombre, alumnos.apellido, cursos.nombrecurso, test.nombretest, preguntas.id_pregunta
HAVING  SUM(seleccion) = 8;

CREATE GLOBAL TEMPORARY TABLE BUENASMALAS2
ON COMMIT PRESERVE ROWS
AS SELECT id_alumno, nombre, apellido, nombrecurso, nombretest, correcta_incorrecta_omitida, COUNT(id_pregunta) AS cantidad 
FROM temporal3
GROUP BY id_alumno, nombre, apellido, nombrecurso, nombretest, correcta_incorrecta_omitida
ORDER BY id_alumno, nombre, apellido, nombrecurso, nombretest, correcta_incorrecta_omitida;

CREATE GLOBAL TEMPORARY TABLE asignacionpuntaje2
ON COMMIT PRESERVE ROWS
AS select id_alumno, nombre, apellido, nombrecurso, nombretest, cantidad/4 as puntaje
from buenasmalas2
where correcta_incorrecta_omitida = 'incorrectas'
UNION ALL
select id_alumno, nombre, apellido, nombrecurso, nombretest, cantidad*1 as puntaje
from buenasmalas2
where correcta_incorrecta_omitida = 'correctas';

--todos los puntaje asignados por evaluacion tienen un maximo de 10
CREATE GLOBAL TEMPORARY TABLE puntajes1
ON COMMIT PRESERVE ROWS
AS select id_alumno, nombre, apellido, nombrecurso, nombretest, sum(puntaje) as puntaje_no_normalizado, sum(puntaje)*7/10 as puntaje_normalizado
from asignacionpuntaje2
group by id_alumno, nombre, apellido, nombrecurso, nombretest;

-- puntajes normalizados y no normalizados
select *
from puntajes1;

--estudiantes que aprueban un evaluacion con 4 o mas
select *
from puntajes1
where puntaje_normalizado >4;

--nota promedio para una evaluacion de un curso
select nombrecurso, nombretest, avg(puntaje_normalizado)
from puntajes1
group by nombrecurso, nombretest;













