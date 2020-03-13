-- Generado por Oracle SQL Developer Data Modeler 19.4.0.350.1424
--   en:        2020-03-12 20:26:22 CLST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



CREATE TABLE alternativas (
    id_alternativa       INTEGER NOT NULL,
    descripcion          NVARCHAR2(100),
    correcta_incorrecta  CHAR(1),
    porcentajecorrecta   NUMBER(3, 2),
    id_pregunta          INTEGER
);

ALTER TABLE alternativas ADD CONSTRAINT alternativas_pk PRIMARY KEY ( id_alternativa );

CREATE TABLE alumnos (
    id_alumno  INTEGER NOT NULL,
    nombre     NVARCHAR2(30),
    apellido   NVARCHAR2(30)
);

ALTER TABLE alumnos ADD CONSTRAINT alumnos_pk PRIMARY KEY ( id_alumno );

CREATE TABLE cursos (
    id_curso     INTEGER NOT NULL,
    nombrecurso  NVARCHAR2(40),
    horainicio   NVARCHAR2(5),
    horafin      NVARCHAR2(5)
);

ALTER TABLE cursos ADD CONSTRAINT cursos_pk PRIMARY KEY ( id_curso );

CREATE TABLE cursosalumnos (
    id_curso   INTEGER NOT NULL,
    id_alumno  INTEGER NOT NULL
);

ALTER TABLE cursosalumnos ADD CONSTRAINT cursosalumnos_pk PRIMARY KEY ( id_curso,
                                                                        id_alumno );

CREATE TABLE cursostest (
    id_curso  INTEGER NOT NULL,
    id_test   INTEGER NOT NULL
);

ALTER TABLE cursostest ADD CONSTRAINT cursostest_pk PRIMARY KEY ( id_curso,
                                                                  id_test );

CREATE TABLE preguntas (
    id_pregunta      INTEGER NOT NULL,
    enunciado        NVARCHAR2(100),
    puntajeasociado  NUMBER(3, 2),
    id_test          INTEGER NOT NULL
);

ALTER TABLE preguntas ADD CONSTRAINT preguntas_pk PRIMARY KEY ( id_pregunta );

CREATE TABLE registrorespuestas (
    id_alumno       INTEGER NOT NULL,
    id_curso        INTEGER NOT NULL,
    id_test         INTEGER NOT NULL,
    id_pregunta     INTEGER NOT NULL,
    id_alternativa  INTEGER NOT NULL,
    seleccion       CHAR(1) NOT NULL
);

ALTER TABLE registrorespuestas
    ADD CONSTRAINT registrorespuestas_pk PRIMARY KEY ( id_alumno,
                                                       id_test,
                                                       id_pregunta,
                                                       id_alternativa,
                                                       seleccion,
                                                       id_curso );

CREATE TABLE test (
    id_test        INTEGER NOT NULL,
    nombretest     NVARCHAR2(50),
    descripcion    NVARCHAR2(100),
    programa       NVARCHAR2(50),
    unidad         NVARCHAR2(50),
    autor          NVARCHAR2(50),
    fechacreacion  DATE
);

ALTER TABLE test ADD CONSTRAINT test_pk PRIMARY KEY ( id_test );

ALTER TABLE alternativas
    ADD CONSTRAINT alternativas_preguntas_fk FOREIGN KEY ( id_pregunta )
        REFERENCES preguntas ( id_pregunta );

ALTER TABLE cursosalumnos
    ADD CONSTRAINT cursosalumnos_alumnos_fk FOREIGN KEY ( id_alumno )
        REFERENCES alumnos ( id_alumno );

ALTER TABLE cursosalumnos
    ADD CONSTRAINT cursosalumnos_cursos_fk FOREIGN KEY ( id_curso )
        REFERENCES cursos ( id_curso );

ALTER TABLE cursostest
    ADD CONSTRAINT cursostest_cursos_fk FOREIGN KEY ( id_curso )
        REFERENCES cursos ( id_curso );

ALTER TABLE cursostest
    ADD CONSTRAINT cursostest_test_fk FOREIGN KEY ( id_test )
        REFERENCES test ( id_test );

ALTER TABLE preguntas
    ADD CONSTRAINT preguntas_test_fk FOREIGN KEY ( id_test )
        REFERENCES test ( id_test );

ALTER TABLE registrorespuestas
    ADD CONSTRAINT registrores_alternativas_fk FOREIGN KEY ( id_alternativa )
        REFERENCES alternativas ( id_alternativa );

ALTER TABLE registrorespuestas
    ADD CONSTRAINT registrores_alumnos_fk FOREIGN KEY ( id_alumno )
        REFERENCES alumnos ( id_alumno );

ALTER TABLE registrorespuestas
    ADD CONSTRAINT registrores_cursos_fk FOREIGN KEY ( id_curso )
        REFERENCES cursos ( id_curso );

ALTER TABLE registrorespuestas
    ADD CONSTRAINT registrores_preguntas_fk FOREIGN KEY ( id_pregunta )
        REFERENCES preguntas ( id_pregunta );

ALTER TABLE registrorespuestas
    ADD CONSTRAINT registrores_test_fk FOREIGN KEY ( id_test )
        REFERENCES test ( id_test );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             8
-- CREATE INDEX                             0
-- ALTER TABLE                             19
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
