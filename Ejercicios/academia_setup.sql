-- ================================================================
--  ORACLE DATABASE — Academia Universitaria
--  Script de creación e inserción de datos
--  Tablas: PAIS, CIUDAD, FACULTAD, DEPARTAMENTO, PROFESOR,
--          ALUMNO, ASIGNATURA, MATRICULA, EXAMEN, NOTA,
--          BECA, AULA, HORARIO
-- ================================================================

-- ================================================================
-- LIMPIEZA PREVIA
-- ================================================================
BEGIN EXECUTE IMMEDIATE 'DROP TABLE HORARIO       CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NOTA          CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE EXAMEN        CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE MATRICULA     CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE BECA          CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AULA          CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE ASIGNATURA    CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PROFESOR      CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE ALUMNO        CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DEPARTAMENTO  CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FACULTAD      CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE CIUDAD        CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END; /
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PAIS          CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END; /

-- ================================================================
-- TABLA: PAIS
-- ================================================================
CREATE TABLE PAIS (
    id_pais   NUMBER(3)     PRIMARY KEY,
    nombre    VARCHAR2(80)  NOT NULL,
    continente VARCHAR2(50)
);

-- ================================================================
-- TABLA: CIUDAD
-- ================================================================
CREATE TABLE CIUDAD (
    id_ciudad  NUMBER(4)     PRIMARY KEY,
    nombre     VARCHAR2(80)  NOT NULL,
    id_pais    NUMBER(3)     NOT NULL,
    poblacion  NUMBER(10),
    CONSTRAINT fk_ciu_pais FOREIGN KEY (id_pais) REFERENCES PAIS(id_pais)
);

-- ================================================================
-- TABLA: FACULTAD
-- ================================================================
CREATE TABLE FACULTAD (
    id_facultad  NUMBER(3)     PRIMARY KEY,
    nombre       VARCHAR2(120) NOT NULL,
    decano       VARCHAR2(120),
    año_fundacion NUMBER(4),
    presupuesto  NUMBER(12,2),
    id_ciudad    NUMBER(4),
    CONSTRAINT fk_fac_ciu FOREIGN KEY (id_ciudad) REFERENCES CIUDAD(id_ciudad)
);

-- ================================================================
-- TABLA: DEPARTAMENTO
-- ================================================================
CREATE TABLE DEPARTAMENTO (
    id_departamento NUMBER(4)    PRIMARY KEY,
    nombre          VARCHAR2(120) NOT NULL,
    id_facultad     NUMBER(3)    NOT NULL,
    num_profesores  NUMBER(4)    DEFAULT 0,
    CONSTRAINT fk_dep_fac FOREIGN KEY (id_facultad) REFERENCES FACULTAD(id_facultad)
);

-- ================================================================
-- TABLA: PROFESOR
-- ================================================================
CREATE TABLE PROFESOR (
    id_profesor     NUMBER(5)     PRIMARY KEY,
    nombre          VARCHAR2(80)  NOT NULL,
    apellido        VARCHAR2(80)  NOT NULL,
    email           VARCHAR2(120) UNIQUE,
    telefono        VARCHAR2(20),
    categoria       VARCHAR2(50)  CHECK (categoria IN (
                        'Catedrático','Titular','Asociado','Ayudante','Visitante')),
    salario         NUMBER(10,2),
    fecha_ingreso   DATE,
    id_departamento NUMBER(4),
    id_jefe         NUMBER(5),    -- director del departamento (autorreferencia)
    id_ciudad_origen NUMBER(4),
    CONSTRAINT fk_pro_dep  FOREIGN KEY (id_departamento) REFERENCES DEPARTAMENTO(id_departamento),
    CONSTRAINT fk_pro_jefe FOREIGN KEY (id_jefe)         REFERENCES PROFESOR(id_profesor),
    CONSTRAINT fk_pro_ciu  FOREIGN KEY (id_ciudad_origen) REFERENCES CIUDAD(id_ciudad)
);

-- ================================================================
-- TABLA: ALUMNO
-- ================================================================
CREATE TABLE ALUMNO (
    id_alumno       NUMBER(6)     PRIMARY KEY,
    nombre          VARCHAR2(80)  NOT NULL,
    apellido        VARCHAR2(80)  NOT NULL,
    email           VARCHAR2(120) UNIQUE,
    dni             VARCHAR2(10)  UNIQUE,
    fecha_nacimiento DATE,
    id_ciudad_origen NUMBER(4),
    año_ingreso     NUMBER(4),
    grado           VARCHAR2(80),
    creditos_superados NUMBER(6)  DEFAULT 0,
    beca_activa     CHAR(1)       DEFAULT 'N' CHECK (beca_activa IN ('S','N')),
    CONSTRAINT fk_alu_ciu FOREIGN KEY (id_ciudad_origen) REFERENCES CIUDAD(id_ciudad)
);

-- ================================================================
-- TABLA: ASIGNATURA
-- ================================================================
CREATE TABLE ASIGNATURA (
    id_asignatura   NUMBER(5)     PRIMARY KEY,
    nombre          VARCHAR2(150) NOT NULL,
    creditos        NUMBER(4,1)   NOT NULL,
    tipo            VARCHAR2(30)  CHECK (tipo IN ('Obligatoria','Optativa','Libre elección','TFG','TFM')),
    curso           NUMBER(1)     CHECK (curso BETWEEN 1 AND 5),
    semestre        NUMBER(1)     CHECK (semestre IN (1,2)),
    id_departamento NUMBER(4)     NOT NULL,
    id_profesor     NUMBER(5),    -- profesor responsable
    max_alumnos     NUMBER(4)     DEFAULT 60,
    CONSTRAINT fk_asi_dep FOREIGN KEY (id_departamento) REFERENCES DEPARTAMENTO(id_departamento),
    CONSTRAINT fk_asi_pro FOREIGN KEY (id_profesor)     REFERENCES PROFESOR(id_profesor)
);

-- ================================================================
-- TABLA: MATRICULA
-- ================================================================
CREATE TABLE MATRICULA (
    id_matricula    NUMBER(8)     PRIMARY KEY,
    id_alumno       NUMBER(6)     NOT NULL,
    id_asignatura   NUMBER(5)     NOT NULL,
    año_academico   VARCHAR2(9)   NOT NULL,   -- ej: '2023-2024'
    fecha_matricula DATE          NOT NULL,
    estado          VARCHAR2(20)  DEFAULT 'Activa'
                                  CHECK (estado IN ('Activa','Anulada','Convalidada')),
    CONSTRAINT fk_mat_alu FOREIGN KEY (id_alumno)     REFERENCES ALUMNO(id_alumno),
    CONSTRAINT fk_mat_asi FOREIGN KEY (id_asignatura) REFERENCES ASIGNATURA(id_asignatura),
    CONSTRAINT uq_mat UNIQUE (id_alumno, id_asignatura, año_academico)
);

-- ================================================================
-- TABLA: EXAMEN
-- ================================================================
CREATE TABLE EXAMEN (
    id_examen       NUMBER(6)     PRIMARY KEY,
    id_asignatura   NUMBER(5)     NOT NULL,
    tipo            VARCHAR2(30)  CHECK (tipo IN ('Parcial','Final','Extraordinario','Evaluación continua')),
    fecha_examen    DATE          NOT NULL,
    duracion_min    NUMBER(4),
    año_academico   VARCHAR2(9)   NOT NULL,
    CONSTRAINT fk_exa_asi FOREIGN KEY (id_asignatura) REFERENCES ASIGNATURA(id_asignatura)
);

-- ================================================================
-- TABLA: NOTA
-- ================================================================
CREATE TABLE NOTA (
    id_nota         NUMBER(8)     PRIMARY KEY,
    id_matricula    NUMBER(8)     NOT NULL,
    id_examen       NUMBER(6)     NOT NULL,
    calificacion    NUMBER(4,2)   CHECK (calificacion BETWEEN 0 AND 10),
    fecha_publicacion DATE,
    observaciones   VARCHAR2(200),
    CONSTRAINT fk_not_mat FOREIGN KEY (id_matricula) REFERENCES MATRICULA(id_matricula),
    CONSTRAINT fk_not_exa FOREIGN KEY (id_examen)    REFERENCES EXAMEN(id_examen),
    CONSTRAINT uq_nota UNIQUE (id_matricula, id_examen)
);

-- ================================================================
-- TABLA: BECA
-- ================================================================
CREATE TABLE BECA (
    id_beca         NUMBER(6)     PRIMARY KEY,
    id_alumno       NUMBER(6)     NOT NULL,
    tipo_beca       VARCHAR2(60)  NOT NULL,
    importe_anual   NUMBER(10,2),
    año_academico   VARCHAR2(9)   NOT NULL,
    entidad         VARCHAR2(100),
    renovable       CHAR(1)       DEFAULT 'S' CHECK (renovable IN ('S','N')),
    CONSTRAINT fk_bec_alu FOREIGN KEY (id_alumno) REFERENCES ALUMNO(id_alumno)
);

-- ================================================================
-- TABLA: AULA
-- ================================================================
CREATE TABLE AULA (
    id_aula         NUMBER(4)     PRIMARY KEY,
    nombre          VARCHAR2(30)  NOT NULL,
    capacidad       NUMBER(4)     NOT NULL,
    tipo            VARCHAR2(30)  CHECK (tipo IN ('Teoría','Laboratorio','Seminario','Aula magna')),
    id_facultad     NUMBER(3),
    tiene_proyector CHAR(1)       DEFAULT 'S' CHECK (tiene_proyector IN ('S','N')),
    CONSTRAINT fk_aul_fac FOREIGN KEY (id_facultad) REFERENCES FACULTAD(id_facultad)
);

-- ================================================================
-- TABLA: HORARIO
-- ================================================================
CREATE TABLE HORARIO (
    id_horario      NUMBER(6)     PRIMARY KEY,
    id_asignatura   NUMBER(5)     NOT NULL,
    id_aula         NUMBER(4)     NOT NULL,
    dia_semana      VARCHAR2(10)  CHECK (dia_semana IN
                        ('Lunes','Martes','Miércoles','Jueves','Viernes')),
    hora_inicio     VARCHAR2(5),  -- formato HH:MI
    hora_fin        VARCHAR2(5),
    año_academico   VARCHAR2(9)   NOT NULL,
    CONSTRAINT fk_hor_asi FOREIGN KEY (id_asignatura) REFERENCES ASIGNATURA(id_asignatura),
    CONSTRAINT fk_hor_aul FOREIGN KEY (id_aula)       REFERENCES AULA(id_aula)
);

-- ================================================================
-- DATOS: PAIS
-- ================================================================
INSERT INTO PAIS VALUES (1,  'España',          'Europa');
INSERT INTO PAIS VALUES (2,  'Francia',         'Europa');
INSERT INTO PAIS VALUES (3,  'Alemania',        'Europa');
INSERT INTO PAIS VALUES (4,  'Italia',          'Europa');
INSERT INTO PAIS VALUES (5,  'Portugal',        'Europa');
INSERT INTO PAIS VALUES (6,  'México',          'América');
INSERT INTO PAIS VALUES (7,  'Colombia',        'América');
INSERT INTO PAIS VALUES (8,  'Argentina',       'América');
INSERT INTO PAIS VALUES (9,  'Brasil',          'América');
INSERT INTO PAIS VALUES (10, 'Perú',            'América');
INSERT INTO PAIS VALUES (11, 'China',           'Asia');
INSERT INTO PAIS VALUES (12, 'Japón',           'Asia');
INSERT INTO PAIS VALUES (13, 'Marruecos',       'África');
INSERT INTO PAIS VALUES (14, 'Nigeria',         'África');
INSERT INTO PAIS VALUES (15, 'Estados Unidos',  'América');

-- ================================================================
-- DATOS: CIUDAD
-- ================================================================
INSERT INTO CIUDAD VALUES (1,  'Madrid',        1,  3400000);
INSERT INTO CIUDAD VALUES (2,  'Barcelona',     1,  1600000);
INSERT INTO CIUDAD VALUES (3,  'Valencia',      1,   800000);
INSERT INTO CIUDAD VALUES (4,  'Sevilla',       1,   690000);
INSERT INTO CIUDAD VALUES (5,  'Bilbao',        1,   340000);
INSERT INTO CIUDAD VALUES (6,  'Zaragoza',      1,   670000);
INSERT INTO CIUDAD VALUES (7,  'Málaga',        1,   570000);
INSERT INTO CIUDAD VALUES (8,  'Murcia',        1,   450000);
INSERT INTO CIUDAD VALUES (9,  'Palma',         1,   410000);
INSERT INTO CIUDAD VALUES (10, 'Granada',       1,   230000);
INSERT INTO CIUDAD VALUES (11, 'París',         2,  2100000);
INSERT INTO CIUDAD VALUES (12, 'Berlín',        3,  3700000);
INSERT INTO CIUDAD VALUES (13, 'Roma',          4,  2800000);
INSERT INTO CIUDAD VALUES (14, 'Lisboa',        5,   550000);
INSERT INTO CIUDAD VALUES (15, 'Ciudad de México',6,9200000);
INSERT INTO CIUDAD VALUES (16, 'Bogotá',        7,  7400000);
INSERT INTO CIUDAD VALUES (17, 'Buenos Aires',  8,  3000000);
INSERT INTO CIUDAD VALUES (18, 'São Paulo',     9,  12300000);
INSERT INTO CIUDAD VALUES (19, 'Lima',         10,  9700000);
INSERT INTO CIUDAD VALUES (20, 'Pekín',        11, 21500000);
INSERT INTO CIUDAD VALUES (21, 'Tokio',        12, 13900000);
INSERT INTO CIUDAD VALUES (22, 'Casablanca',   13,  3700000);
INSERT INTO CIUDAD VALUES (23, 'Lagos',        14, 14800000);
INSERT INTO CIUDAD VALUES (24, 'Nueva York',   15,  8300000);
INSERT INTO CIUDAD VALUES (25, 'Los Ángeles',  15,  4000000);

-- ================================================================
-- DATOS: FACULTAD
-- ================================================================
INSERT INTO FACULTAD VALUES (1, 'Facultad de Informática e Ingeniería',    'Dr. Ramón Vidal',     1985, 3200000, 1);
INSERT INTO FACULTAD VALUES (2, 'Facultad de Ciencias Económicas',         'Dra. Pilar Montero',  1972, 2800000, 1);
INSERT INTO FACULTAD VALUES (3, 'Facultad de Ciencias de la Salud',        'Dr. Luis Carmona',    1960, 4100000, 2);
INSERT INTO FACULTAD VALUES (4, 'Facultad de Humanidades y Letras',        'Dra. Ana Delgado',    1955, 1900000, 3);
INSERT INTO FACULTAD VALUES (5, 'Facultad de Ciencias Exactas y Naturales','Dr. Marcos Fuentes',  1968, 2500000, 4);
INSERT INTO FACULTAD VALUES (6, 'Facultad de Derecho y Ciencias Políticas','Dra. Carmen Rivas',   1948, 2200000, 1);
INSERT INTO FACULTAD VALUES (7, 'Escuela de Arquitectura y Diseño',        'Dr. Óscar Prieto',    1991, 1800000, 2);
INSERT INTO FACULTAD VALUES (8, 'Facultad de Educación',                   'Dra. Rosa Campos',    1970, 1500000, 3);
-- Facultad sin departamentos todavía (para ejercicios de OUTER JOIN)
INSERT INTO FACULTAD VALUES (9, 'Facultad de Artes Escénicas',             NULL,                  2023,  400000, 10);

-- ================================================================
-- DATOS: DEPARTAMENTO
-- ================================================================
INSERT INTO DEPARTAMENTO VALUES (1,  'Ingeniería del Software',        1, 12);
INSERT INTO DEPARTAMENTO VALUES (2,  'Redes y Sistemas',               1, 8);
INSERT INTO DEPARTAMENTO VALUES (3,  'Inteligencia Artificial',        1, 10);
INSERT INTO DEPARTAMENTO VALUES (4,  'Economía Aplicada',              2, 9);
INSERT INTO DEPARTAMENTO VALUES (5,  'Finanzas y Contabilidad',        2, 7);
INSERT INTO DEPARTAMENTO VALUES (6,  'Medicina Interna',               3, 15);
INSERT INTO DEPARTAMENTO VALUES (7,  'Cirugía y Especialidades',       3, 11);
INSERT INTO DEPARTAMENTO VALUES (8,  'Filología Hispánica',            4, 6);
INSERT INTO DEPARTAMENTO VALUES (9,  'Historia y Arqueología',         4, 7);
INSERT INTO DEPARTAMENTO VALUES (10, 'Matemáticas',                    5, 13);
INSERT INTO DEPARTAMENTO VALUES (11, 'Física y Química',               5, 9);
INSERT INTO DEPARTAMENTO VALUES (12, 'Derecho Civil y Mercantil',      6, 8);
INSERT INTO DEPARTAMENTO VALUES (13, 'Derecho Penal y Procesal',       6, 7);
INSERT INTO DEPARTAMENTO VALUES (14, 'Diseño Arquitectónico',          7, 5);
INSERT INTO DEPARTAMENTO VALUES (15, 'Didáctica y Organización Escolar',8,6);

-- ================================================================
-- DATOS: PROFESOR  (50 profesores)
-- ================================================================
-- Catedráticos / directores (sin jefe)
INSERT INTO PROFESOR VALUES (1, 'Roberto','Sánchez','r.sanchez@univ.es','600111001','Catedrático',  72000,DATE '2000-09-01',1, NULL,1);
INSERT INTO PROFESOR VALUES (2, 'Isabel', 'Moreno', 'i.moreno@univ.es', '600111002','Catedrático',  70000,DATE '1998-09-01',2, NULL,2);
INSERT INTO PROFESOR VALUES (3, 'Carlos', 'Jiménez','c.jimenez@univ.es','600111003','Catedrático',  71000,DATE '1999-09-01',3, NULL,3);
INSERT INTO PROFESOR VALUES (4, 'María',  'Torres', 'm.torres@univ.es', '600111004','Catedrático',  68000,DATE '2001-09-01',4, NULL,4);
INSERT INTO PROFESOR VALUES (5, 'Andrés', 'García', 'a.garcia@univ.es', '600111005','Catedrático',  69000,DATE '1997-09-01',5, NULL,5);
INSERT INTO PROFESOR VALUES (6, 'Lucía',  'Ruiz',   'l.ruiz@univ.es',   '600111006','Catedrático',  73000,DATE '1995-09-01',6, NULL,6);
INSERT INTO PROFESOR VALUES (7, 'Francisco','López','f.lopez@univ.es',  '600111007','Catedrático',  67000,DATE '2002-09-01',7, NULL,7);
INSERT INTO PROFESOR VALUES (8, 'Elena',  'Navarro','e.navarro@univ.es','600111008','Catedrático',  65000,DATE '2003-09-01',8, NULL,8);
INSERT INTO PROFESOR VALUES (9, 'Miguel', 'Serrano','m.serrano@univ.es','600111009','Catedrático',  71000,DATE '1996-09-01',9, NULL,9);
INSERT INTO PROFESOR VALUES (10,'Pilar',  'Martínez','p.martinez@univ.es','600111010','Catedrático', 70000,DATE '1994-09-01',10,NULL,10);
-- Titulares
INSERT INTO PROFESOR VALUES (11,'Diego',  'Castro', 'd.castro@univ.es', '600111011','Titular',      52000,DATE '2005-09-01',1, 1,  1);
INSERT INTO PROFESOR VALUES (12,'Sofía',  'Vega',   's.vega@univ.es',   '600111012','Titular',      51000,DATE '2006-09-01',2, 2,  2);
INSERT INTO PROFESOR VALUES (13,'Álvaro', 'Ortega', 'a.ortega@univ.es', '600111013','Titular',      53000,DATE '2004-09-01',3, 3,  3);
INSERT INTO PROFESOR VALUES (14,'Raquel', 'Herrero','r.herrero@univ.es','600111014','Titular',      50000,DATE '2007-09-01',4, 4,  4);
INSERT INTO PROFESOR VALUES (15,'Juan',   'Blanco', 'j.blanco@univ.es', '600111015','Titular',      51000,DATE '2008-09-01',5, 5,  5);
INSERT INTO PROFESOR VALUES (16,'Ana',    'Romero', 'a.romero@univ.es', '600111016','Titular',      52000,DATE '2006-09-01',6, 6,  6);
INSERT INTO PROFESOR VALUES (17,'Javier', 'Molina', 'j.molina@univ.es', '600111017','Titular',      50000,DATE '2009-09-01',7, 7,  7);
INSERT INTO PROFESOR VALUES (18,'Carmen', 'Santos', 'c.santos@univ.es', '600111018','Titular',      49000,DATE '2010-09-01',8, 8,  8);
INSERT INTO PROFESOR VALUES (19,'David',  'Alonso', 'd.alonso@univ.es', '600111019','Titular',      53000,DATE '2005-09-01',9, 9,  9);
INSERT INTO PROFESOR VALUES (20,'Patricia','Méndez','p.mendez@univ.es', '600111020','Titular',      51000,DATE '2007-09-01',10,10, 10);
-- Asociados
INSERT INTO PROFESOR VALUES (21,'Tomás',  'Ríos',   't.rios@univ.es',   '600111021','Asociado',     32000,DATE '2012-09-01',1, 1,  1);
INSERT INTO PROFESOR VALUES (22,'Nuria',  'Pascual','n.pascual@univ.es','600111022','Asociado',     31000,DATE '2013-09-01',2, 2,  2);
INSERT INTO PROFESOR VALUES (23,'Pablo',  'Cabrera','p.cabrera@univ.es','600111023','Asociado',     33000,DATE '2011-09-01',3, 3,  3);
INSERT INTO PROFESOR VALUES (24,'Laura',  'Fuentes','l.fuentes@univ.es','600111024','Asociado',     31000,DATE '2014-09-01',4, 4,  4);
INSERT INTO PROFESOR VALUES (25,'Sergio', 'Peña',   's.pena@univ.es',   '600111025','Asociado',     32000,DATE '2015-09-01',5, 5,  5);
INSERT INTO PROFESOR VALUES (26,'Marta',  'Iglesias','m.iglesias@univ.es','600111026','Asociado',   31000,DATE '2013-09-01',6, 6,  6);
INSERT INTO PROFESOR VALUES (27,'Adrián', 'Vargas', 'a.vargas@univ.es', '600111027','Asociado',     30000,DATE '2016-09-01',7, 7,  7);
INSERT INTO PROFESOR VALUES (28,'Silvia', 'Núñez',  's.nunez@univ.es',  '600111028','Asociado',     31000,DATE '2014-09-01',8, 8,  8);
INSERT INTO PROFESOR VALUES (29,'Hugo',   'Gil',    'h.gil@univ.es',    '600111029','Asociado',     33000,DATE '2012-09-01',9, 9,  9);
INSERT INTO PROFESOR VALUES (30,'Beatriz','Cano',   'b.cano@univ.es',   '600111030','Asociado',     32000,DATE '2015-09-01',10,10, 10);
-- Ayudantes
INSERT INTO PROFESOR VALUES (31,'Marcos', 'Pardo',  'm.pardo@univ.es',  '600111031','Ayudante',     24000,DATE '2018-09-01',1, 11, 1);
INSERT INTO PROFESOR VALUES (32,'Eva',    'Crespo', 'e.crespo@univ.es', '600111032','Ayudante',     24000,DATE '2019-09-01',2, 12, 2);
INSERT INTO PROFESOR VALUES (33,'Gonzalo','Reyes',  'g.reyes@univ.es',  '600111033','Ayudante',     24000,DATE '2020-09-01',3, 13, 11);
INSERT INTO PROFESOR VALUES (34,'Irene',  'Flores', 'i.flores@univ.es', '600111034','Ayudante',     23000,DATE '2021-09-01',4, 14, 4);
INSERT INTO PROFESOR VALUES (35,'Nicolás','Ramos',  'n.ramos@univ.es',  '600111035','Ayudante',     24000,DATE '2018-09-01',5, 15, 15);
INSERT INTO PROFESOR VALUES (36,'Victoria','Cruz',  'v.cruz@univ.es',   '600111036','Ayudante',     23000,DATE '2020-09-01',6, 16, 16);
INSERT INTO PROFESOR VALUES (37,'Rubén',  'Díaz',   'r.diaz@univ.es',   '600111037','Ayudante',     24000,DATE '2019-09-01',7, 17, 7);
INSERT INTO PROFESOR VALUES (38,'Claudia','Mora',   'c.mora@univ.es',   '600111038','Ayudante',     23000,DATE '2022-09-01',8, 18, 22);
INSERT INTO PROFESOR VALUES (39,'Fernando','Soler', 'f.soler@univ.es',  '600111039','Ayudante',     24000,DATE '2021-09-01',9, 19, 9);
INSERT INTO PROFESOR VALUES (40,'Vanessa','Lara',   'v.lara@univ.es',   '600111040','Ayudante',     23000,DATE '2023-09-01',10,20, 10);
-- Visitantes
INSERT INTO PROFESOR VALUES (41,'Hans',   'Müller', 'h.muller@univ.es', '600111041','Visitante',    45000,DATE '2023-09-01',1, NULL,12);
INSERT INTO PROFESOR VALUES (42,'Sophie', 'Dupont', 's.dupont@univ.es', '600111042','Visitante',    44000,DATE '2023-09-01',3, NULL,11);
INSERT INTO PROFESOR VALUES (43,'Luca',   'Ferrari','l.ferrari@univ.es','600111043','Visitante',    46000,DATE '2022-09-01',10,NULL,13);
INSERT INTO PROFESOR VALUES (44,'Yuki',   'Tanaka', 'y.tanaka@univ.es', '600111044','Visitante',    45000,DATE '2023-09-01',11,NULL,21);
INSERT INTO PROFESOR VALUES (45,'Maria',  'Oliveira','m.oliveira@univ.es','600111045','Visitante',  43000,DATE '2022-09-01',12,NULL,14);
-- Departamentos 11-15
INSERT INTO PROFESOR VALUES (46,'Ramón',  'Vera',   'r.vera@univ.es',   '600111046','Titular',      51000,DATE '2006-09-01',11,NULL,6);
INSERT INTO PROFESOR VALUES (47,'Concha', 'Nieto',  'c.nieto@univ.es',  '600111047','Titular',      50000,DATE '2008-09-01',12,NULL,7);
INSERT INTO PROFESOR VALUES (48,'Bruno',  'Aguilar','b.aguilar@univ.es','600111048','Titular',      51000,DATE '2007-09-01',13,NULL,8);
INSERT INTO PROFESOR VALUES (49,'Noemí',  'Rubio',  'n.rubio@univ.es',  '600111049','Titular',      50000,DATE '2009-09-01',14,NULL,9);
INSERT INTO PROFESOR VALUES (50,'Arturo', 'Pedraza','a.pedraza@univ.es','600111050','Asociado',     31000,DATE '2015-09-01',15,NULL,10);

-- ================================================================
-- DATOS: ALUMNO  (80 alumnos)
-- ================================================================
INSERT INTO ALUMNO VALUES (1001,'Andrea',  'Soto',     'andrea.soto@alu.es',    '11111111A',DATE '2001-03-15',1, 2020,'Ingeniería Informática',  180,'S');
INSERT INTO ALUMNO VALUES (1002,'Borja',   'Leal',     'borja.leal@alu.es',     '22222222B',DATE '2000-07-22',2, 2019,'Ingeniería Informática',  240,'N');
INSERT INTO ALUMNO VALUES (1003,'Clara',   'Medina',   'clara.medina@alu.es',   '33333333C',DATE '2002-05-10',3, 2021,'Administración Empresas', 120,'S');
INSERT INTO ALUMNO VALUES (1004,'Daniel',  'Roig',     'daniel.roig@alu.es',    '44444444D',DATE '2001-11-30',4, 2020,'Administración Empresas', 180,'N');
INSERT INTO ALUMNO VALUES (1005,'Emma',    'Ibáñez',   'emma.ibanez@alu.es',    '55555555E',DATE '2003-01-08',5, 2022,'Medicina',                 60,'S');
INSERT INTO ALUMNO VALUES (1006,'Felipe',  'Mora',     'felipe.mora@alu.es',    '66666666F',DATE '2000-09-14',6, 2019,'Derecho',                 240,'N');
INSERT INTO ALUMNO VALUES (1007,'Gema',    'Palomar',  'gema.palomar@alu.es',   '77777777G',DATE '2002-04-20',7, 2021,'Historia',                 90,'S');
INSERT INTO ALUMNO VALUES (1008,'Héctor',  'Quijada',  'hector.quijada@alu.es', '88888888H',DATE '2001-12-05',8, 2020,'Matemáticas',             150,'N');
INSERT INTO ALUMNO VALUES (1009,'Inés',    'Zamora',   'ines.zamora@alu.es',    '99999999I',DATE '2003-06-25',9, 2022,'Física',                   60,'S');
INSERT INTO ALUMNO VALUES (1010,'Jaime',   'Balaguer', 'jaime.balaguer@alu.es', '10101010J',DATE '2000-02-17',10,2019,'Ingeniería Informática',  270,'N');
INSERT INTO ALUMNO VALUES (1011,'Karla',   'Segura',   'karla.segura@alu.es',   '11121314K',DATE '2002-08-30',1, 2021,'Arquitectura',            100,'S');
INSERT INTO ALUMNO VALUES (1012,'Lorenzo', 'Bravo',    'lorenzo.bravo@alu.es',  '12131415L',DATE '2001-10-11',2, 2020,'Medicina',                140,'N');
INSERT INTO ALUMNO VALUES (1013,'Marta',   'Exposito', 'marta.exp@alu.es',      '13141516M',DATE '2003-03-07',3, 2022,'Derecho',                  40,'S');
INSERT INTO ALUMNO VALUES (1014,'Nacho',   'Torrent',  'nacho.torrent@alu.es',  '14151617N',DATE '2000-05-19',4, 2019,'Administración Empresas', 260,'N');
INSERT INTO ALUMNO VALUES (1015,'Olga',    'Carreño',  'olga.carreno@alu.es',   '15161718O',DATE '2002-07-03',11,2021,'Historia',                 90,'N');
INSERT INTO ALUMNO VALUES (1016,'Pedro',   'Vergara',  'pedro.vergara@alu.es',  '16171819P',DATE '2001-09-23',12,2020,'Matemáticas',             150,'S');
INSERT INTO ALUMNO VALUES (1017,'Queralt', 'Foix',     'queralt.foix@alu.es',   '17181920Q',DATE '2003-11-14',13,2022,'Ingeniería Informática',   60,'N');
INSERT INTO ALUMNO VALUES (1018,'Rodrigo', 'Esteve',   'rodrigo.esteve@alu.es', '18192021R',DATE '2000-01-28',14,2019,'Derecho',                 270,'S');
INSERT INTO ALUMNO VALUES (1019,'Sara',    'Linares',  'sara.linares@alu.es',   '19202122S',DATE '2002-02-14',15,2021,'Medicina',                 80,'N');
INSERT INTO ALUMNO VALUES (1020,'Toni',    'Espinosa', 'toni.espinosa@alu.es',  '20212223T',DATE '2001-04-09',16,2020,'Arquitectura',            160,'S');
INSERT INTO ALUMNO VALUES (1021,'Úrsula',  'Blanc',    'ursula.blanc@alu.es',   '21222324U',DATE '2003-07-31',17,2022,'Física',                   60,'N');
INSERT INTO ALUMNO VALUES (1022,'Víctor',  'Pons',     'victor.pons@alu.es',    '22232425V',DATE '2000-10-22',18,2019,'Ingeniería Informática',  250,'S');
INSERT INTO ALUMNO VALUES (1023,'Wanda',   'Córdoba',  'wanda.cordoba@alu.es',  '23242526W',DATE '2002-12-18',19,2021,'Matemáticas',             100,'S');
INSERT INTO ALUMNO VALUES (1024,'Xavi',    'Miró',     'xavi.miro@alu.es',      '24252627X',DATE '2001-06-04',20,2020,'Medicina',                170,'N');
INSERT INTO ALUMNO VALUES (1025,'Yolanda', 'Serret',   'yolanda.serret@alu.es', '25262728Y',DATE '2003-09-16',21,2022,'Historia',                 40,'S');
INSERT INTO ALUMNO VALUES (1026,'Zaira',   'Huerta',   'zaira.huerta@alu.es',   '26272829Z',DATE '2000-11-29',22,2019,'Derecho',                 270,'N');
INSERT INTO ALUMNO VALUES (1027,'Aitor',   'Unzué',    'aitor.unzue@alu.es',    '27282930A',DATE '2002-01-07',23,2021,'Ingeniería Informática',  100,'S');
INSERT INTO ALUMNO VALUES (1028,'Begoña',  'Olabe',    'begona.olabe@alu.es',   '28293031B',DATE '2001-03-21',24,2020,'Administración Empresas', 150,'N');
INSERT INTO ALUMNO VALUES (1029,'César',   'Alcázar',  'cesar.alcazar@alu.es',  '29303132C',DATE '2003-05-12',25,2022,'Arquitectura',             50,'S');
INSERT INTO ALUMNO VALUES (1030,'Diana',   'Quiroga',  'diana.quiroga@alu.es',  '30313233D',DATE '2000-08-08',15,2019,'Matemáticas',             280,'N');
-- Alumnos internacionales
INSERT INTO ALUMNO VALUES (1031,'Pierre',  'Dubois',   'pierre.d@alu.es',       '31323334P',DATE '2001-02-14',11,2020,'Ingeniería Informática',  150,'S');
INSERT INTO ALUMNO VALUES (1032,'Giulia',  'Romano',   'giulia.r@alu.es',       '32333435G',DATE '2002-06-20',13,2021,'Arquitectura',             90,'N');
INSERT INTO ALUMNO VALUES (1033,'Kai',     'Schmidt',  'kai.schmidt@alu.es',    '33343536K',DATE '2001-09-09',12,2020,'Física',                  150,'S');
INSERT INTO ALUMNO VALUES (1034,'Yuna',    'Park',     'yuna.park@alu.es',      '34353637Y',DATE '2003-03-25',21,2022,'Matemáticas',              50,'N');
INSERT INTO ALUMNO VALUES (1035,'Ahmed',   'El-Amine', 'ahmed.el@alu.es',       '35363738A',DATE '2002-11-11',22,2021,'Derecho',                  80,'S');
INSERT INTO ALUMNO VALUES (1036,'Priya',   'Sharma',   'priya.sharma@alu.es',   '36373839P',DATE '2001-07-07',20,2020,'Medicina',                140,'N');
INSERT INTO ALUMNO VALUES (1037,'Lucas',   'Ferreira', 'lucas.ferr@alu.es',     '37383940L',DATE '2003-01-30',18,2022,'Ingeniería Informática',   60,'S');
INSERT INTO ALUMNO VALUES (1038,'Ximena',  'Vargas',   'ximena.v@alu.es',       '38394041X',DATE '2002-04-16',16,2021,'Administración Empresas',  90,'N');
INSERT INTO ALUMNO VALUES (1039,'Ryo',     'Watanabe', 'ryo.wata@alu.es',       '39404142R',DATE '2001-08-04',21,2020,'Física',                  180,'S');
INSERT INTO ALUMNO VALUES (1040,'Nina',    'Kovač',    'nina.kovac@alu.es',     '40414243N',DATE '2003-10-28',11,2022,'Historia',                  50,'S');
INSERT INTO ALUMNO VALUES (1041,'Mateo',   'Cruz',     'mateo.cruz@alu.es',     '41424344M',DATE '2000-12-12',16,2019,'Ingeniería Informática',  270,'N');
INSERT INTO ALUMNO VALUES (1042,'Lucia',   'Font',     'lucia.font@alu.es',     '42434445L',DATE '2002-03-03',2, 2021,'Medicina',                 80,'S');
INSERT INTO ALUMNO VALUES (1043,'Samuel',  'Coll',     'samuel.coll@alu.es',    '43444546S',DATE '2001-05-28',3, 2020,'Matemáticas',             170,'N');
INSERT INTO ALUMNO VALUES (1044,'Teresa',  'Aldana',   'teresa.aldana@alu.es',  '44454647T',DATE '2003-08-17',4, 2022,'Derecho',                  40,'S');
INSERT INTO ALUMNO VALUES (1045,'Unai',    'Zubiria',  'unai.zub@alu.es',       '45464748U',DATE '2000-10-06',5, 2019,'Ingeniería Informática',  260,'N');
INSERT INTO ALUMNO VALUES (1046,'Valentina','Cano',    'valentina.c@alu.es',    '46474849V',DATE '2002-02-21',6, 2021,'Arquitectura',             80,'S');
INSERT INTO ALUMNO VALUES (1047,'William', 'Jensen',   'william.j@alu.es',      '47484950W',DATE '2001-04-10',24,2020,'Economía',                150,'N');
INSERT INTO ALUMNO VALUES (1048,'Xuxa',    'Baldrich', 'xuxa.b@alu.es',         '48495051X',DATE '2003-06-25',2, 2022,'Ingeniería Informática',   60,'S');
INSERT INTO ALUMNO VALUES (1049,'Yanis',   'Hadjab',   'yanis.h@alu.es',        '49505152Y',DATE '2002-09-14',22,2021,'Derecho',                  80,'N');
INSERT INTO ALUMNO VALUES (1050,'Zoe',     'Harper',   'zoe.harper@alu.es',     '50515253Z',DATE '2001-11-03',24,2020,'Física',                  180,'S');
INSERT INTO ALUMNO VALUES (1051,'Agustín', 'Prieto',   'agustin.p@alu.es',      '51525354A',DATE '2002-01-19',7, 2021,'Arquitectura',             70,'N');
INSERT INTO ALUMNO VALUES (1052,'Blanca',  'Esteban',  'blanca.e@alu.es',       '52535455B',DATE '2001-03-08',8, 2020,'Medicina',                150,'S');
INSERT INTO ALUMNO VALUES (1053,'Cristian','Valls',    'cristian.v@alu.es',     '53545556C',DATE '2003-05-26',9, 2022,'Matemáticas',              50,'N');
INSERT INTO ALUMNO VALUES (1054,'Dolores', 'Amador',   'dolores.a@alu.es',      '54555657D',DATE '2000-07-15',10,2019,'Historia',                280,'S');
INSERT INTO ALUMNO VALUES (1055,'Ernesto', 'Mir',      'ernesto.m@alu.es',      '55565758E',DATE '2002-09-04',1, 2021,'Ingeniería Informática',  100,'N');
INSERT INTO ALUMNO VALUES (1056,'Fátima',  'Drissi',   'fatima.d@alu.es',       '56575859F',DATE '2001-11-22',22,2020,'Medicina',                180,'S');
INSERT INTO ALUMNO VALUES (1057,'Gerardo', 'Cobo',     'gerardo.c@alu.es',      '57585960G',DATE '2003-02-10',4, 2022,'Economía',                 50,'N');
INSERT INTO ALUMNO VALUES (1058,'Helena',  'Domingo',  'helena.d@alu.es',       '58596061H',DATE '2002-04-29',3, 2021,'Historia',                 80,'S');
INSERT INTO ALUMNO VALUES (1059,'Ignacio', 'Valls',    'ignacio.v@alu.es',      '59606162I',DATE '2001-06-18',2, 2020,'Derecho',                 160,'N');
INSERT INTO ALUMNO VALUES (1060,'Jimena',  'Ocaña',    'jimena.o@alu.es',       '60616263J',DATE '2003-08-07',5, 2022,'Física',                   50,'S');
INSERT INTO ALUMNO VALUES (1061,'Kevin',   'Osei',     'kevin.osei@alu.es',     '61626364K',DATE '2002-10-26',23,2021,'Economía',                 70,'N');
INSERT INTO ALUMNO VALUES (1062,'Laia',    'Puig',     'laia.puig@alu.es',      '62636465L',DATE '2001-12-15',2, 2020,'Ingeniería Informática',  190,'S');
INSERT INTO ALUMNO VALUES (1063,'Mauricio','Leiva',    'mauricio.l@alu.es',     '63646566M',DATE '2003-02-04',17,2022,'Arquitectura',             40,'N');
INSERT INTO ALUMNO VALUES (1064,'Noelia',  'Tena',     'noelia.t@alu.es',       '64656667N',DATE '2000-03-23',6, 2019,'Medicina',                290,'S');
INSERT INTO ALUMNO VALUES (1065,'Oriol',   'Roura',    'oriol.roura@alu.es',    '65666768O',DATE '2002-05-12',2, 2021,'Matemáticas',             110,'N');
INSERT INTO ALUMNO VALUES (1066,'Paula',   'Abad',     'paula.abad@alu.es',     '66676869P',DATE '2001-07-01',1, 2020,'Derecho',                 180,'S');
INSERT INTO ALUMNO VALUES (1067,'Quintín', 'Furio',    'quintin.f@alu.es',      '67686970Q',DATE '2003-08-19',4, 2022,'Ingeniería Informática',   60,'N');
INSERT INTO ALUMNO VALUES (1068,'Rocío',   'Giráldez', 'rocio.g@alu.es',        '68697071R',DATE '2002-10-08',3, 2021,'Medicina',                 90,'S');
INSERT INTO ALUMNO VALUES (1069,'Simón',   'Antón',    'simon.anton@alu.es',    '69707172S',DATE '2001-11-27',8, 2020,'Historia',                160,'N');
INSERT INTO ALUMNO VALUES (1070,'Tamara',  'Escudero', 'tamara.e@alu.es',       '70717273T',DATE '2003-01-15',9, 2022,'Arquitectura',              50,'S');
INSERT INTO ALUMNO VALUES (1071,'Ulises',  'Marco',    'ulises.m@alu.es',       '71727374U',DATE '2000-02-28',10,2019,'Ingeniería Informática',  280,'N');
INSERT INTO ALUMNO VALUES (1072,'Vera',    'Colom',    'vera.colom@alu.es',     '72737475V',DATE '2002-04-18',1, 2021,'Física',                   80,'S');
INSERT INTO ALUMNO VALUES (1073,'Xavier',  'Sala',     'xavier.sala@alu.es',    '73747576X',DATE '2001-06-07',2, 2020,'Economía',                160,'N');
INSERT INTO ALUMNO VALUES (1074,'Yasmin',  'Faridi',   'yasmin.f@alu.es',       '74757677Y',DATE '2003-07-26',22,2022,'Medicina',                 50,'S');
INSERT INTO ALUMNO VALUES (1075,'Zenón',   'Bel',      'zenon.bel@alu.es',      '75767778Z',DATE '2002-09-14',6, 2021,'Matemáticas',             100,'N');
INSERT INTO ALUMNO VALUES (1076,'Amparo',  'Trillo',   'amparo.t@alu.es',       '76777879A',DATE '2001-11-03',7, 2020,'Derecho',                 170,'S');
INSERT INTO ALUMNO VALUES (1077,'Bernardo','Otal',     'bernardo.o@alu.es',     '77787980B',DATE '2003-12-22',8, 2022,'Ingeniería Informática',   40,'N');
INSERT INTO ALUMNO VALUES (1078,'Celia',   'Molins',   'celia.m@alu.es',        '78798081C',DATE '2002-02-11',9, 2021,'Historia',                 70,'S');
INSERT INTO ALUMNO VALUES (1079,'Dario',   'Casado',   'dario.c@alu.es',        '79808182D',DATE '2001-04-01',10,2020,'Matemáticas',             170,'N');
INSERT INTO ALUMNO VALUES (1080,'Elena',   'Yuste',    'elena.yuste@alu.es',    '80818283E',DATE '2003-05-20',1, 2022,'Arquitectura',              50,'S');
-- Alumno sin ciudad origen (para ejercicios NULL)
INSERT INTO ALUMNO VALUES (1081,'Anónimo', 'Test',     'anonimo.test@alu.es',   '81828384F',DATE '2002-07-09',NULL,2022,'Ingeniería Informática',  30,'N');

-- ================================================================
-- DATOS: ASIGNATURA (40 asignaturas)
-- ================================================================
INSERT INTO ASIGNATURA VALUES (101,'Programación I',               6,'Obligatoria',1,1,1, 1, 80);
INSERT INTO ASIGNATURA VALUES (102,'Programación II',              6,'Obligatoria',1,2,1, 11,80);
INSERT INTO ASIGNATURA VALUES (103,'Estructuras de Datos',         6,'Obligatoria',2,1,1, 21,60);
INSERT INTO ASIGNATURA VALUES (104,'Bases de Datos',               6,'Obligatoria',2,2,1, 1, 70);
INSERT INTO ASIGNATURA VALUES (105,'Sistemas Operativos',          6,'Obligatoria',3,1,2, 2, 60);
INSERT INTO ASIGNATURA VALUES (106,'Redes de Computadores',        6,'Obligatoria',3,2,2, 12,60);
INSERT INTO ASIGNATURA VALUES (107,'Inteligencia Artificial',      6,'Obligatoria',4,1,3, 3, 50);
INSERT INTO ASIGNATURA VALUES (108,'Machine Learning',             4.5,'Optativa',  4,2,3, 13,40);
INSERT INTO ASIGNATURA VALUES (109,'Arquitectura de Computadores', 6,'Obligatoria',2,1,1, 11,60);
INSERT INTO ASIGNATURA VALUES (110,'Ingeniería del Software',      6,'Obligatoria',3,1,1, 1, 70);
INSERT INTO ASIGNATURA VALUES (111,'Microeconomía',                6,'Obligatoria',1,1,4, 4, 90);
INSERT INTO ASIGNATURA VALUES (112,'Macroeconomía',                6,'Obligatoria',1,2,4, 14,90);
INSERT INTO ASIGNATURA VALUES (113,'Contabilidad Financiera',      6,'Obligatoria',2,1,5, 5, 80);
INSERT INTO ASIGNATURA VALUES (114,'Finanzas Empresariales',       6,'Obligatoria',3,1,5, 15,70);
INSERT INTO ASIGNATURA VALUES (115,'Marketing Digital',            4.5,'Optativa',  3,2,4, 24,50);
INSERT INTO ASIGNATURA VALUES (116,'Anatomía Humana',              9,'Obligatoria',1,1,6, 6, 100);
INSERT INTO ASIGNATURA VALUES (117,'Fisiología',                   9,'Obligatoria',1,2,6, 16,100);
INSERT INTO ASIGNATURA VALUES (118,'Patología General',            6,'Obligatoria',3,1,6, 26,80);
INSERT INTO ASIGNATURA VALUES (119,'Cirugía General',              6,'Obligatoria',4,1,7, 7, 70);
INSERT INTO ASIGNATURA VALUES (120,'Farmacología',                 6,'Obligatoria',3,2,6, 16,80);
INSERT INTO ASIGNATURA VALUES (121,'Historia Medieval',            6,'Obligatoria',1,1,9, 9, 70);
INSERT INTO ASIGNATURA VALUES (122,'Historia Moderna',             6,'Obligatoria',2,1,9, 19,70);
INSERT INTO ASIGNATURA VALUES (123,'Literatura Española',          6,'Obligatoria',1,2,8, 8, 80);
INSERT INTO ASIGNATURA VALUES (124,'Lingüística General',          4.5,'Optativa',  2,2,8, 18,50);
INSERT INTO ASIGNATURA VALUES (125,'Cálculo I',                    6,'Obligatoria',1,1,10,10,120);
INSERT INTO ASIGNATURA VALUES (126,'Cálculo II',                   6,'Obligatoria',1,2,10,20,120);
INSERT INTO ASIGNATURA VALUES (127,'Álgebra Lineal',               6,'Obligatoria',1,1,10,30,100);
INSERT INTO ASIGNATURA VALUES (128,'Estadística',                  6,'Obligatoria',2,1,10,10,100);
INSERT INTO ASIGNATURA VALUES (129,'Física I',                     6,'Obligatoria',1,1,11,46,80);
INSERT INTO ASIGNATURA VALUES (130,'Física II',                    6,'Obligatoria',1,2,11,46,80);
INSERT INTO ASIGNATURA VALUES (131,'Derecho Civil',                6,'Obligatoria',1,1,12,47,90);
INSERT INTO ASIGNATURA VALUES (132,'Derecho Mercantil',            6,'Obligatoria',2,1,12,47,80);
INSERT INTO ASIGNATURA VALUES (133,'Derecho Penal',                6,'Obligatoria',2,2,13,48,80);
INSERT INTO ASIGNATURA VALUES (134,'Derecho Procesal',             6,'Obligatoria',3,1,13,48,70);
INSERT INTO ASIGNATURA VALUES (135,'Diseño Arquitectónico I',      6,'Obligatoria',1,1,14,49,40);
INSERT INTO ASIGNATURA VALUES (136,'Diseño Arquitectónico II',     6,'Obligatoria',2,1,14,49,40);
INSERT INTO ASIGNATURA VALUES (137,'Urbanismo',                    4.5,'Optativa',  3,1,14,49,35);
INSERT INTO ASIGNATURA VALUES (138,'Didáctica General',            6,'Obligatoria',1,1,15,50,60);
INSERT INTO ASIGNATURA VALUES (139,'Psicología Educativa',         6,'Obligatoria',2,1,15,50,60);
INSERT INTO ASIGNATURA VALUES (140,'TFG Informática',              12,'TFG',        4,2,1, 1, 30);

-- ================================================================
-- DATOS: MATRICULA (aprox. 300 matrículas)
-- ================================================================
-- Generar matrículas representativas
-- Año 2023-2024
INSERT INTO MATRICULA VALUES (1,  1001,101,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (2,  1001,102,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (3,  1001,103,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (4,  1001,104,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (5,  1002,104,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (6,  1002,105,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (7,  1002,106,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (8,  1002,110,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (9,  1003,111,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (10, 1003,112,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (11, 1003,113,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (12, 1004,113,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (13, 1004,114,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (14, 1004,115,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (15, 1005,116,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (16, 1005,117,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (17, 1006,131,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (18, 1006,132,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (19, 1007,121,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (20, 1007,123,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (21, 1008,125,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (22, 1008,126,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (23, 1008,127,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (24, 1009,129,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (25, 1009,130,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (26, 1010,107,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (27, 1010,108,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (28, 1010,140,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (29, 1011,135,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (30, 1011,136,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (31, 1012,116,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (32, 1012,118,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (33, 1013,131,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (34, 1013,133,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (35, 1014,114,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (36, 1014,115,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (37, 1015,121,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (38, 1015,122,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (39, 1016,125,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (40, 1016,128,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (41, 1017,101,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (42, 1017,102,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (43, 1018,132,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (44, 1018,134,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (45, 1019,116,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (46, 1019,117,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (47, 1020,135,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (48, 1020,136,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (49, 1021,129,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (50, 1021,130,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (51, 1022,103,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (52, 1022,104,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (53, 1022,107,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (54, 1023,125,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (55, 1023,127,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (56, 1024,118,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (57, 1024,119,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (58, 1025,121,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (59, 1025,122,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (60, 1026,131,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (61, 1026,133,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (62, 1027,101,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (63, 1027,102,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (64, 1028,111,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (65, 1028,112,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (66, 1029,135,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (67, 1030,126,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (68, 1030,128,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (69, 1031,101,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (70, 1031,103,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (71, 1032,135,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (72, 1032,136,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (73, 1033,129,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (74, 1033,130,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (75, 1034,125,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (76, 1034,127,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (77, 1035,131,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (78, 1036,116,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (79, 1036,117,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (80, 1037,101,'2023-2024',DATE '2023-09-10','Activa');
-- Año 2022-2023 (matrículas históricas)
INSERT INTO MATRICULA VALUES (81, 1002,101,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (82, 1002,102,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (83, 1002,103,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (84, 1010,101,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (85, 1010,102,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (86, 1010,104,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (87, 1022,101,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (88, 1022,102,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (89, 1041,101,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (90, 1041,102,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (91, 1041,103,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (92, 1041,104,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (93, 1045,101,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (94, 1045,102,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (95, 1071,101,'2022-2023',DATE '2022-09-12','Activa');
INSERT INTO MATRICULA VALUES (96, 1071,102,'2022-2023',DATE '2022-09-12','Activa');
-- Matrículas anuladas (para ejercicios de filtrado)
INSERT INTO MATRICULA VALUES (97, 1038,111,'2023-2024',DATE '2023-09-10','Anulada');
INSERT INTO MATRICULA VALUES (98, 1039,129,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (99, 1040,121,'2023-2024',DATE '2023-09-10','Activa');
INSERT INTO MATRICULA VALUES (100,1041,107,'2023-2024',DATE '2023-09-10','Activa');

-- ================================================================
-- DATOS: EXAMEN
-- ================================================================
INSERT INTO EXAMEN VALUES (201,101,'Parcial',        DATE '2024-11-15',90, '2023-2024');
INSERT INTO EXAMEN VALUES (202,101,'Final',          DATE '2025-01-20',120,'2023-2024');
INSERT INTO EXAMEN VALUES (203,102,'Parcial',        DATE '2024-11-16',90, '2023-2024');
INSERT INTO EXAMEN VALUES (204,102,'Final',          DATE '2025-01-21',120,'2023-2024');
INSERT INTO EXAMEN VALUES (205,103,'Final',          DATE '2025-01-22',120,'2023-2024');
INSERT INTO EXAMEN VALUES (206,104,'Parcial',        DATE '2024-11-18',90, '2023-2024');
INSERT INTO EXAMEN VALUES (207,104,'Final',          DATE '2025-01-23',120,'2023-2024');
INSERT INTO EXAMEN VALUES (208,105,'Final',          DATE '2025-01-24',120,'2023-2024');
INSERT INTO EXAMEN VALUES (209,107,'Final',          DATE '2025-01-27',120,'2023-2024');
INSERT INTO EXAMEN VALUES (210,108,'Evaluación continua',DATE '2024-12-15',60,'2023-2024');
INSERT INTO EXAMEN VALUES (211,111,'Final',          DATE '2025-01-28',120,'2023-2024');
INSERT INTO EXAMEN VALUES (212,113,'Parcial',        DATE '2024-11-20',90, '2023-2024');
INSERT INTO EXAMEN VALUES (213,116,'Final',          DATE '2025-06-15',180,'2023-2024');
INSERT INTO EXAMEN VALUES (214,125,'Parcial',        DATE '2024-11-22',90, '2023-2024');
INSERT INTO EXAMEN VALUES (215,125,'Final',          DATE '2025-01-30',120,'2023-2024');
INSERT INTO EXAMEN VALUES (216,129,'Final',          DATE '2025-01-31',120,'2023-2024');
INSERT INTO EXAMEN VALUES (217,131,'Final',          DATE '2025-02-03',120,'2023-2024');
INSERT INTO EXAMEN VALUES (218,135,'Evaluación continua',DATE '2024-12-20',90,'2023-2024');
INSERT INTO EXAMEN VALUES (219,140,'Final',          DATE '2025-06-20',NULL,'2023-2024');
-- Examen histórico
INSERT INTO EXAMEN VALUES (220,101,'Final',          DATE '2023-01-18',120,'2022-2023');
INSERT INTO EXAMEN VALUES (221,102,'Final',          DATE '2023-01-19',120,'2022-2023');
INSERT INTO EXAMEN VALUES (222,103,'Final',          DATE '2023-01-20',120,'2022-2023');

-- ================================================================
-- DATOS: NOTA  (notas de los exámenes)
-- ================================================================
-- Notas examen 201 (Parcial Prog I)
INSERT INTO NOTA VALUES (301,1, 201,7.5, DATE '2024-11-22',NULL);
INSERT INTO NOTA VALUES (302,41,201,6.0, DATE '2024-11-22',NULL);
INSERT INTO NOTA VALUES (303,62,201,8.5, DATE '2024-11-22',NULL);
INSERT INTO NOTA VALUES (304,69,201,5.0, DATE '2024-11-22',NULL);
INSERT INTO NOTA VALUES (305,80,201,7.0, DATE '2024-11-22',NULL);
-- Notas examen 202 (Final Prog I)
INSERT INTO NOTA VALUES (306,1, 202,8.0, DATE '2025-01-27',NULL);
INSERT INTO NOTA VALUES (307,41,202,6.5, DATE '2025-01-27',NULL);
INSERT INTO NOTA VALUES (308,62,202,9.0, DATE '2025-01-27',NULL);
INSERT INTO NOTA VALUES (309,69,202,4.5, DATE '2025-01-27','Suspenso convocatoria ordinaria');
INSERT INTO NOTA VALUES (310,80,202,7.5, DATE '2025-01-27',NULL);
-- Notas examen 205 (Final Estructuras de Datos)
INSERT INTO NOTA VALUES (311,3, 205,7.0, DATE '2025-01-29',NULL);
INSERT INTO NOTA VALUES (312,51,205,5.5, DATE '2025-01-29',NULL);
INSERT INTO NOTA VALUES (313,70,205,8.0, DATE '2025-01-29',NULL);
-- Notas examen 207 (Final BBDD)
INSERT INTO NOTA VALUES (314,4, 207,9.5, DATE '2025-01-30','Matrícula de honor candidato');
INSERT INTO NOTA VALUES (315,5, 207,8.0, DATE '2025-01-30',NULL);
INSERT INTO NOTA VALUES (316,52,207,7.5, DATE '2025-01-30',NULL);
INSERT INTO NOTA VALUES (317,53,207,6.0, DATE '2025-01-30',NULL);
-- Notas examen 209 (Final IA)
INSERT INTO NOTA VALUES (318,26,209,8.5, DATE '2025-02-03',NULL);
INSERT INTO NOTA VALUES (319,27,209,9.0, DATE '2025-02-03',NULL);
INSERT INTO NOTA VALUES (320,100,209,7.0, DATE '2025-02-03',NULL);
-- Notas examen 211 (Final Microeconomía)
INSERT INTO NOTA VALUES (321,9, 211,7.0, DATE '2025-02-04',NULL);
INSERT INTO NOTA VALUES (322,10,211,6.5, DATE '2025-02-04',NULL);
INSERT INTO NOTA VALUES (323,64,211,8.0, DATE '2025-02-04',NULL);
INSERT INTO NOTA VALUES (324,65,211,5.0, DATE '2025-02-04',NULL);
-- Notas examen 215 (Final Cálculo I)
INSERT INTO NOTA VALUES (325,21,215,9.5, DATE '2025-02-07','Sobresaliente');
INSERT INTO NOTA VALUES (326,22,215,8.0, DATE '2025-02-07',NULL);
INSERT INTO NOTA VALUES (327,39,215,7.5, DATE '2025-02-07',NULL);
INSERT INTO NOTA VALUES (328,54,215,4.0, DATE '2025-02-07','Suspenso');
INSERT INTO NOTA VALUES (329,55,215,6.5, DATE '2025-02-07',NULL);
INSERT INTO NOTA VALUES (330,75,215,5.5, DATE '2025-02-07',NULL);
-- Notas examen 217 (Final Derecho Civil)
INSERT INTO NOTA VALUES (331,17,217,7.0, DATE '2025-02-10',NULL);
INSERT INTO NOTA VALUES (332,33,217,8.5, DATE '2025-02-10',NULL);
INSERT INTO NOTA VALUES (333,60,217,6.0, DATE '2025-02-10',NULL);
INSERT INTO NOTA VALUES (334,77,217,9.0, DATE '2025-02-10',NULL);
-- Notas históricas examen 220 (Final Prog I 2022-23)
INSERT INTO NOTA VALUES (335,81,220,8.5, DATE '2023-01-25',NULL);
INSERT INTO NOTA VALUES (336,82,220,7.0, DATE '2023-01-25',NULL);
INSERT INTO NOTA VALUES (337,84,220,9.0, DATE '2023-01-25',NULL);
INSERT INTO NOTA VALUES (338,87,220,6.5, DATE '2023-01-25',NULL);
INSERT INTO NOTA VALUES (339,89,220,8.0, DATE '2023-01-25',NULL);
INSERT INTO NOTA VALUES (340,93,220,7.5, DATE '2023-01-25',NULL);
INSERT INTO NOTA VALUES (341,95,220,9.5, DATE '2023-01-25','Sobresaliente');

-- ================================================================
-- DATOS: BECA
-- ================================================================
INSERT INTO BECA VALUES (501,1001,'Beca MEC',        3600,'2023-2024','Ministerio de Educación','S');
INSERT INTO BECA VALUES (502,1003,'Beca MEC',        3600,'2023-2024','Ministerio de Educación','S');
INSERT INTO BECA VALUES (503,1005,'Beca Excelencia', 5000,'2023-2024','Comunidad Autónoma',      'S');
INSERT INTO BECA VALUES (504,1007,'Beca MEC',        3600,'2023-2024','Ministerio de Educación','S');
INSERT INTO BECA VALUES (505,1009,'Beca Movilidad',  2000,'2023-2024','Erasmus+',                'N');
INSERT INTO BECA VALUES (506,1011,'Beca MEC',        3600,'2023-2024','Ministerio de Educación','S');
INSERT INTO BECA VALUES (507,1016,'Beca Excelencia', 5000,'2023-2024','Comunidad Autónoma',      'S');
INSERT INTO BECA VALUES (508,1020,'Beca MEC',        3600,'2023-2024','Ministerio de Educación','S');
INSERT INTO BECA VALUES (509,1022,'Beca Empresa',    4000,'2023-2024','Indra S.A.',               'N');
INSERT INTO BECA VALUES (510,1023,'Beca MEC',        3600,'2023-2024','Ministerio de Educación','S');
INSERT INTO BECA VALUES (511,1025,'Beca Movilidad',  2000,'2023-2024','Erasmus+',                'N');
INSERT INTO BECA VALUES (512,1027,'Beca MEC',        3600,'2023-2024','Ministerio de Educación','S');
INSERT INTO BECA VALUES (513,1029,'Beca Excelencia', 5000,'2023-2024','Comunidad Autónoma',      'S');
INSERT INTO BECA VALUES (514,1031,'Beca Erasmus',    6000,'2023-2024','Erasmus+',                'S');
INSERT INTO BECA VALUES (515,1033,'Beca Erasmus',    6000,'2023-2024','Erasmus+',                'S');
INSERT INTO BECA VALUES (516,1035,'Beca Erasmus',    6000,'2023-2024','Erasmus+',                'S');
INSERT INTO BECA VALUES (517,1037,'Beca MEC',        3600,'2023-2024','Ministerio de Educación','S');
INSERT INTO BECA VALUES (518,1040,'Beca Erasmus',    6000,'2023-2024','Erasmus+',                'S');
INSERT INTO BECA VALUES (519,1050,'Beca Empresa',    4000,'2023-2024','Google LLC',              'N');
INSERT INTO BECA VALUES (520,1056,'Beca MEC',        3600,'2023-2024','Ministerio de Educación','S');
INSERT INTO BECA VALUES (521,1064,'Beca Excelencia', 5000,'2023-2024','Comunidad Autónoma',      'S');
INSERT INTO BECA VALUES (522,1066,'Beca MEC',        3600,'2023-2024','Ministerio de Educación','S');
INSERT INTO BECA VALUES (523,1071,'Beca Empresa',    4000,'2023-2024','Microsoft',               'N');
INSERT INTO BECA VALUES (524,1076,'Beca MEC',        3600,'2023-2024','Ministerio de Educación','S');
INSERT INTO BECA VALUES (525,1080,'Beca Excelencia', 5000,'2023-2024','Comunidad Autónoma',      'S');

-- ================================================================
-- DATOS: AULA
-- ================================================================
INSERT INTO AULA VALUES (301,'Aula A-01', 80, 'Teoría',      1,'S');
INSERT INTO AULA VALUES (302,'Aula A-02', 80, 'Teoría',      1,'S');
INSERT INTO AULA VALUES (303,'Lab B-01',  30, 'Laboratorio',  1,'S');
INSERT INTO AULA VALUES (304,'Lab B-02',  30, 'Laboratorio',  1,'S');
INSERT INTO AULA VALUES (305,'Sem C-01',  20, 'Seminario',    1,'N');
INSERT INTO AULA VALUES (306,'Aula D-01',100, 'Teoría',      2,'S');
INSERT INTO AULA VALUES (307,'Aula D-02', 90, 'Teoría',      2,'S');
INSERT INTO AULA VALUES (308,'Lab E-01',  25, 'Laboratorio',  3,'S');
INSERT INTO AULA VALUES (309,'Aula Magna',300,'Aula magna',   3,'S');
INSERT INTO AULA VALUES (310,'Aula F-01', 70, 'Teoría',      4,'S');
INSERT INTO AULA VALUES (311,'Aula G-01', 60, 'Teoría',      5,'N');
INSERT INTO AULA VALUES (312,'Lab H-01',  20, 'Laboratorio',  5,'S');
INSERT INTO AULA VALUES (313,'Aula I-01', 90, 'Teoría',      6,'S');
INSERT INTO AULA VALUES (314,'Sem J-01',  15, 'Seminario',    6,'N');
INSERT INTO AULA VALUES (315,'Aula K-01', 40, 'Teoría',      7,'S');

-- ================================================================
-- DATOS: HORARIO
-- ================================================================
INSERT INTO HORARIO VALUES (401,101,301,'Lunes',   '09:00','11:00','2023-2024');
INSERT INTO HORARIO VALUES (402,101,303,'Miércoles','09:00','11:00','2023-2024');
INSERT INTO HORARIO VALUES (403,102,301,'Martes',  '09:00','11:00','2023-2024');
INSERT INTO HORARIO VALUES (404,102,303,'Jueves',  '09:00','11:00','2023-2024');
INSERT INTO HORARIO VALUES (405,103,302,'Lunes',   '11:00','13:00','2023-2024');
INSERT INTO HORARIO VALUES (406,104,301,'Miércoles','11:00','13:00','2023-2024');
INSERT INTO HORARIO VALUES (407,104,303,'Viernes', '09:00','11:00','2023-2024');
INSERT INTO HORARIO VALUES (408,105,302,'Martes',  '11:00','13:00','2023-2024');
INSERT INTO HORARIO VALUES (409,107,304,'Jueves',  '11:00','13:00','2023-2024');
INSERT INTO HORARIO VALUES (410,111,306,'Lunes',   '09:00','11:00','2023-2024');
INSERT INTO HORARIO VALUES (411,112,306,'Martes',  '09:00','11:00','2023-2024');
INSERT INTO HORARIO VALUES (412,116,313,'Lunes',   '08:00','10:00','2023-2024');
INSERT INTO HORARIO VALUES (413,125,310,'Miércoles','16:00','18:00','2023-2024');
INSERT INTO HORARIO VALUES (414,126,310,'Jueves',  '16:00','18:00','2023-2024');
INSERT INTO HORARIO VALUES (415,131,307,'Lunes',   '12:00','14:00','2023-2024');
INSERT INTO HORARIO VALUES (416,135,315,'Martes',  '10:00','12:00','2023-2024');
INSERT INTO HORARIO VALUES (417,138,310,'Viernes', '10:00','12:00','2023-2024');

COMMIT;

-- ================================================================
-- VERIFICACIÓN RÁPIDA
-- ================================================================
SELECT 'PAIS'           tabla, COUNT(*) registros FROM PAIS          UNION ALL
SELECT 'CIUDAD',                COUNT(*) FROM CIUDAD         UNION ALL
SELECT 'FACULTAD',              COUNT(*) FROM FACULTAD       UNION ALL
SELECT 'DEPARTAMENTO',          COUNT(*) FROM DEPARTAMENTO   UNION ALL
SELECT 'PROFESOR',              COUNT(*) FROM PROFESOR       UNION ALL
SELECT 'ALUMNO',                COUNT(*) FROM ALUMNO         UNION ALL
SELECT 'ASIGNATURA',            COUNT(*) FROM ASIGNATURA     UNION ALL
SELECT 'MATRICULA',             COUNT(*) FROM MATRICULA      UNION ALL
SELECT 'EXAMEN',                COUNT(*) FROM EXAMEN         UNION ALL
SELECT 'NOTA',                  COUNT(*) FROM NOTA           UNION ALL
SELECT 'BECA',                  COUNT(*) FROM BECA           UNION ALL
SELECT 'AULA',                  COUNT(*) FROM AULA           UNION ALL
SELECT 'HORARIO',               COUNT(*) FROM HORARIO;
