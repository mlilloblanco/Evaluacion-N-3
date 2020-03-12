--numero de evaluaciones por curso
SELECT cursos.nombrecurso, count(cursostest.id_test) as evaluaciones
FROM cursos INNER JOIN cursostest
ON cursos.id_curso = cursostest.id_curso
group by cursos.nombrecurso;

--cursos sin evaluacion
SELECT cursos.nombrecurso, count(cursostest.id_test) as evaluaciones
FROM cursos LEFT JOIN cursostest
ON cursos.id_curso = cursostest.id_curso
WHERE cursostest.id_curso IS NULL
group by cursos.nombrecurso;

--determinar las evaluacion con deficiencias
SELECT *
FROM test INNER JOIN preguntas
ON test.id_test = preguntas.id_test