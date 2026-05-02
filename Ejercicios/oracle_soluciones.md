# Oracle Database — Soluciones de los 100 Ejercicios
## Base de datos: Academia Universitaria

---

## 🟢 NIVEL 1 — SELECT básico

---

### Ejercicio 1
*Muestra todos los datos de la tabla `PAIS`.*
```sql
SELECT * FROM PAIS;
```

---

### Ejercicio 2
*Muestra el nombre y el continente de todos los países.*
```sql
SELECT nombre, continente
FROM PAIS;
```

---

### Ejercicio 3
*Muestra el nombre, apellido y email de todos los profesores.*
```sql
SELECT nombre, apellido, email
FROM PROFESOR;
```

---

### Ejercicio 4
*Muestra el nombre, apellido, grado y año de ingreso de todos los alumnos.*
```sql
SELECT nombre, apellido, grado, año_ingreso
FROM ALUMNO;
```

---

### Ejercicio 5
*Muestra todas las asignaturas con su número de créditos.*
```sql
SELECT nombre, creditos
FROM ASIGNATURA;
```

---

### Ejercicio 6
*Muestra el nombre y la capacidad de todas las aulas.*
```sql
SELECT nombre, capacidad
FROM AULA;
```

---

### Ejercicio 7
*Muestra los datos completos de todas las facultades.*
```sql
SELECT * FROM FACULTAD;
```

---

### Ejercicio 8
*Muestra el nombre, el tipo y la entidad de todas las becas.*
```sql
SELECT tipo_beca, entidad, importe_anual
FROM BECA;
```

---

### Ejercicio 9
*Muestra el id, nombre y apellido de todos los alumnos con alias.*
```sql
SELECT id_alumno   AS CODIGO,
       nombre      AS NOMBRE_ALU,
       apellido    AS APELLIDO_ALU
FROM ALUMNO;
```

---

### Ejercicio 10
*Tipos distintos de asignatura.*
```sql
SELECT DISTINCT tipo
FROM ASIGNATURA;
```

---

### Ejercicio 11
*Distintos continentes.*
```sql
SELECT DISTINCT continente
FROM PAIS;
```

---

### Ejercicio 12
*Distintos grados que cursan los alumnos.*
```sql
SELECT DISTINCT grado
FROM ALUMNO;
```

---

### Ejercicio 13
*Distintos tipos de aula.*
```sql
SELECT DISTINCT tipo
FROM AULA;
```

---

### Ejercicio 14
*Nombre completo del profesor concatenado.*
```sql
SELECT nombre || ' ' || apellido AS NOMBRE_COMPLETO
FROM PROFESOR;
```

---

### Ejercicio 15
*Nombre completo del alumno y email con alias.*
```sql
SELECT nombre || ' ' || apellido AS ALUMNO,
       email                      AS CORREO
FROM ALUMNO;
```

---

## 🟡 NIVEL 2 — WHERE y ORDER BY

---

### Ejercicio 16
*Profesores con categoría Catedrático.*
```sql
SELECT nombre, apellido, email
FROM PROFESOR
WHERE categoria = 'Catedrático';
```

---

### Ejercicio 17
*Alumnos que ingresaron en 2022.*
```sql
SELECT nombre, apellido, grado, año_ingreso
FROM ALUMNO
WHERE año_ingreso = 2022;
```

---

### Ejercicio 18
*Asignaturas del primer semestre.*
```sql
SELECT nombre, creditos, tipo, curso
FROM ASIGNATURA
WHERE semestre = 1;
```

---

### Ejercicio 19
*Facultades con presupuesto mayor de 2.000.000 €.*
```sql
SELECT nombre, decano, presupuesto
FROM FACULTAD
WHERE presupuesto > 2000000;
```

---

### Ejercicio 20
*Profesores con salario entre 40.000 y 55.000 €.*
```sql
SELECT nombre, apellido, categoria, salario
FROM PROFESOR
WHERE salario BETWEEN 40000 AND 55000;
```

---

### Ejercicio 21
*Alumnos con beca activa.*
```sql
SELECT nombre, apellido, grado, creditos_superados
FROM ALUMNO
WHERE beca_activa = 'S';
```

---

### Ejercicio 22
*Alumnos con apellido que empieza por 'S'.*
```sql
SELECT nombre, apellido, email
FROM ALUMNO
WHERE apellido LIKE 'S%';
```

---

### Ejercicio 23
*Asignaturas cuyo nombre contiene 'Derecho'.*
```sql
SELECT nombre, creditos, tipo, curso
FROM ASIGNATURA
WHERE nombre LIKE '%Derecho%';
```

---

### Ejercicio 24
*Profesores sin jefe asignado.*
```sql
SELECT nombre, apellido, categoria, salario
FROM PROFESOR
WHERE id_jefe IS NULL;
```

---

### Ejercicio 25
*Matrículas con estado Anulada.*
```sql
SELECT id_matricula, id_alumno, id_asignatura, año_academico
FROM MATRICULA
WHERE estado = 'Anulada';
```

---

### Ejercicio 26
*Países de América ordenados alfabéticamente.*
```sql
SELECT nombre, continente
FROM PAIS
WHERE continente = 'América'
ORDER BY nombre ASC;
```

---

### Ejercicio 27
*Alumnos con más de 200 créditos, ordenados descendente.*
```sql
SELECT nombre, apellido, grado, creditos_superados
FROM ALUMNO
WHERE creditos_superados > 200
ORDER BY creditos_superados DESC;
```

---

### Ejercicio 28
*Asignaturas obligatorias de 1.er curso ordenadas.*
```sql
SELECT nombre, creditos, semestre
FROM ASIGNATURA
WHERE tipo = 'Obligatoria' AND curso = 1
ORDER BY semestre ASC, nombre ASC;
```

---

### Ejercicio 29
*Profesores con salario > 60.000 €.*
```sql
SELECT nombre, apellido, categoria, salario
FROM PROFESOR
WHERE salario > 60000
ORDER BY salario DESC;
```

---

### Ejercicio 30
*Exámenes con duración < 100 min o duración NULL.*
```sql
SELECT id_examen, id_asignatura, tipo, fecha_examen, duracion_min
FROM EXAMEN
WHERE duracion_min < 100 OR duracion_min IS NULL
ORDER BY fecha_examen ASC;
```

---

## 🟠 NIVEL 3 — Funciones de agregación y GROUP BY

---

### Ejercicio 31
*Total de alumnos.*
```sql
SELECT COUNT(*) AS total_alumnos
FROM ALUMNO;
```

---

### Ejercicio 32
*Salario medio, máximo y mínimo de los profesores.*
```sql
SELECT ROUND(AVG(salario), 2) AS salario_medio,
       MAX(salario)            AS salario_maximo,
       MIN(salario)            AS salario_minimo
FROM PROFESOR;
```

---

### Ejercicio 33
*Número de asignaturas por tipo.*
```sql
SELECT tipo,
       COUNT(*) AS num_asignaturas
FROM ASIGNATURA
GROUP BY tipo
ORDER BY num_asignaturas DESC;
```

---

### Ejercicio 34
*Alumnos por año de ingreso.*
```sql
SELECT año_ingreso,
       COUNT(*) AS num_alumnos
FROM ALUMNO
GROUP BY año_ingreso
ORDER BY año_ingreso ASC;
```

---

### Ejercicio 35
*Suma total de créditos superados.*
```sql
SELECT SUM(creditos_superados) AS total_creditos_superados
FROM ALUMNO;
```

---

### Ejercicio 36
*Número de profesores por categoría.*
```sql
SELECT categoria,
       COUNT(*) AS num_profesores
FROM PROFESOR
GROUP BY categoria
ORDER BY num_profesores DESC;
```

---

### Ejercicio 37
*Presupuesto total de todas las facultades.*
```sql
SELECT SUM(presupuesto) AS presupuesto_total
FROM FACULTAD;
```

---

### Ejercicio 38
*Matrículas por estado.*
```sql
SELECT estado,
       COUNT(*) AS num_matriculas
FROM MATRICULA
GROUP BY estado;
```

---

### Ejercicio 39
*Media de créditos de asignaturas por curso.*
```sql
SELECT curso,
       ROUND(AVG(creditos), 2) AS media_creditos
FROM ASIGNATURA
GROUP BY curso
ORDER BY curso;
```

---

### Ejercicio 40
*Departamentos con más de 10 profesores.*
```sql
SELECT nombre, num_profesores
FROM DEPARTAMENTO
WHERE num_profesores > 10
ORDER BY num_profesores DESC;
```

---

### Ejercicio 41
*Becas por tipo: cantidad e importe total.*
```sql
SELECT tipo_beca,
       COUNT(*)            AS num_becas,
       SUM(importe_anual)  AS importe_total
FROM BECA
GROUP BY tipo_beca
ORDER BY importe_total DESC;
```

---

### Ejercicio 42
*Nota media, máxima y mínima por examen.*
```sql
SELECT id_examen,
       ROUND(AVG(calificacion), 2) AS nota_media,
       MAX(calificacion)            AS nota_maxima,
       MIN(calificacion)            AS nota_minima,
       COUNT(*)                     AS num_notas
FROM NOTA
GROUP BY id_examen
ORDER BY id_examen;
```

---

### Ejercicio 43
*Alumnos con más de 2 matrículas activas en 2023-2024.*
```sql
SELECT id_alumno,
       COUNT(*) AS num_matriculas
FROM MATRICULA
WHERE año_academico = '2023-2024'
  AND estado = 'Activa'
GROUP BY id_alumno
HAVING COUNT(*) > 2
ORDER BY num_matriculas DESC;
```

---

### Ejercicio 44
*Países con más de 3 ciudades registradas.*
```sql
SELECT id_pais,
       COUNT(*) AS num_ciudades
FROM CIUDAD
GROUP BY id_pais
HAVING COUNT(*) > 3;
```

---

### Ejercicio 45
*Asignaturas con más de 70 alumnos matriculados en 2023-2024.*
```sql
SELECT id_asignatura,
       COUNT(*) AS num_matriculados
FROM MATRICULA
WHERE año_academico = '2023-2024'
  AND estado = 'Activa'
GROUP BY id_asignatura
HAVING COUNT(*) > 70;
```
> *Nota: con los datos de ejemplo posiblemente no devuelva filas; ajusta el umbral a > 1 para ver resultados.*

---

## 🔵 NIVEL 4 — JOIN entre dos tablas

---

### Ejercicio 46
*Ciudad con nombre del país.*
```sql
SELECT c.nombre   AS ciudad,
       p.nombre   AS pais,
       p.continente
FROM CIUDAD c
INNER JOIN PAIS p ON c.id_pais = p.id_pais
ORDER BY p.nombre, c.nombre;
```

---

### Ejercicio 47
*Departamento con nombre de su facultad.*
```sql
SELECT d.nombre  AS departamento,
       f.nombre  AS facultad
FROM DEPARTAMENTO d
INNER JOIN FACULTAD f ON d.id_facultad = f.id_facultad
ORDER BY f.nombre, d.nombre;
```

---

### Ejercicio 48
*Profesor con nombre de su departamento.*
```sql
SELECT p.nombre || ' ' || p.apellido AS profesor,
       p.categoria,
       d.nombre                       AS departamento
FROM PROFESOR p
INNER JOIN DEPARTAMENTO d ON p.id_departamento = d.id_departamento
ORDER BY d.nombre, p.apellido;
```

---

### Ejercicio 49
*Alumno con ciudad de origen.*
```sql
SELECT a.nombre || ' ' || a.apellido AS alumno,
       a.grado,
       c.nombre                       AS ciudad_origen
FROM ALUMNO a
INNER JOIN CIUDAD c ON a.id_ciudad_origen = c.id_ciudad
ORDER BY a.apellido;
```

---

### Ejercicio 50
*Asignatura con nombre del departamento.*
```sql
SELECT asi.nombre  AS asignatura,
       asi.creditos,
       d.nombre    AS departamento
FROM ASIGNATURA asi
INNER JOIN DEPARTAMENTO d ON asi.id_departamento = d.id_departamento
ORDER BY d.nombre, asi.nombre;
```

---

### Ejercicio 51
*Matrículas activas 2023-2024 con nombre del alumno.*
```sql
SELECT m.id_matricula,
       a.nombre || ' ' || a.apellido AS alumno,
       m.id_asignatura,
       m.año_academico,
       m.estado
FROM MATRICULA m
INNER JOIN ALUMNO a ON m.id_alumno = a.id_alumno
WHERE m.año_academico = '2023-2024'
  AND m.estado = 'Activa'
ORDER BY a.apellido;
```

---

### Ejercicio 52
*Asignatura con nombre completo del profesor responsable.*
```sql
SELECT asi.nombre                         AS asignatura,
       p.nombre || ' ' || p.apellido      AS profesor_responsable,
       p.categoria
FROM ASIGNATURA asi
INNER JOIN PROFESOR p ON asi.id_profesor = p.id_profesor
ORDER BY asi.nombre;
```

---

### Ejercicio 53
*Aula con nombre de la facultad.*
```sql
SELECT au.nombre    AS aula,
       au.tipo,
       au.capacidad,
       f.nombre     AS facultad
FROM AULA au
INNER JOIN FACULTAD f ON au.id_facultad = f.id_facultad
ORDER BY f.nombre, au.nombre;
```

---

### Ejercicio 54
*Beca con nombre del alumno beneficiario.*
```sql
SELECT b.tipo_beca,
       b.importe_anual,
       b.entidad,
       a.nombre || ' ' || a.apellido AS alumno
FROM BECA b
INNER JOIN ALUMNO a ON b.id_alumno = a.id_alumno
ORDER BY b.tipo_beca, a.apellido;
```

---

### Ejercicio 55
*Asignatura, día y aula de cada horario.*
```sql
SELECT asi.nombre    AS asignatura,
       h.dia_semana,
       h.hora_inicio,
       h.hora_fin,
       au.nombre     AS aula
FROM HORARIO h
INNER JOIN ASIGNATURA asi ON h.id_asignatura = asi.id_asignatura
INNER JOIN AULA       au  ON h.id_aula       = au.id_aula
ORDER BY h.dia_semana, h.hora_inicio;
```

---

### Ejercicio 56
*Nota con tipo de examen.*
```sql
SELECT n.id_nota,
       n.calificacion,
       e.tipo           AS tipo_examen,
       e.fecha_examen,
       e.año_academico
FROM NOTA n
INNER JOIN EXAMEN e ON n.id_examen = e.id_examen
ORDER BY e.fecha_examen;
```

---

### Ejercicio 57
*Alumnos con beca activa y ciudad de origen (INNER JOIN).*
```sql
SELECT a.nombre || ' ' || a.apellido AS alumno,
       a.beca_activa,
       c.nombre                       AS ciudad_origen
FROM ALUMNO a
INNER JOIN CIUDAD c ON a.id_ciudad_origen = c.id_ciudad
WHERE a.beca_activa = 'S'
ORDER BY a.apellido;
```

---

### Ejercicio 58
*Asignatura, semestre, aula y día (solo con horario).*
```sql
SELECT asi.nombre    AS asignatura,
       asi.semestre,
       au.nombre     AS aula,
       h.dia_semana,
       h.hora_inicio
FROM ASIGNATURA asi
INNER JOIN HORARIO h ON asi.id_asignatura = h.id_asignatura
INNER JOIN AULA    au ON h.id_aula        = au.id_aula
ORDER BY asi.semestre, asi.nombre;
```

---

### Ejercicio 59
*Profesor con ciudad de origen.*
```sql
SELECT p.nombre || ' ' || p.apellido AS profesor,
       p.categoria,
       c.nombre                       AS ciudad_origen,
       pa.nombre                      AS pais_origen
FROM PROFESOR p
INNER JOIN CIUDAD c ON p.id_ciudad_origen = c.id_ciudad
INNER JOIN PAIS   pa ON c.id_pais         = pa.id_pais
ORDER BY p.apellido;
```

---

### Ejercicio 60
*Alumnos matriculados en 'Bases de Datos' en 2023-2024.*
```sql
SELECT a.nombre || ' ' || a.apellido AS alumno,
       a.grado,
       asi.nombre                     AS asignatura,
       m.año_academico
FROM MATRICULA m
INNER JOIN ALUMNO     a   ON m.id_alumno     = a.id_alumno
INNER JOIN ASIGNATURA asi ON m.id_asignatura = asi.id_asignatura
WHERE asi.nombre     = 'Bases de Datos'
  AND m.año_academico = '2023-2024'
  AND m.estado        = 'Activa'
ORDER BY a.apellido;
```

---

## 🟣 NIVEL 5 — OUTER JOIN y SELF JOIN

---

### Ejercicio 61
*Todos los profesores con departamento (LEFT JOIN).*
```sql
SELECT p.nombre || ' ' || p.apellido      AS profesor,
       p.categoria,
       NVL(d.nombre, '-- Sin departamento --') AS departamento
FROM PROFESOR p
LEFT JOIN DEPARTAMENTO d ON p.id_departamento = d.id_departamento
ORDER BY d.nombre NULLS LAST, p.apellido;
```

---

### Ejercicio 62
*Todos los alumnos con ciudad de origen.*
```sql
SELECT a.nombre || ' ' || a.apellido AS alumno,
       a.grado,
       NVL(c.nombre, '(desconocida)') AS ciudad_origen
FROM ALUMNO a
LEFT JOIN CIUDAD c ON a.id_ciudad_origen = c.id_ciudad
ORDER BY a.apellido;
```

---

### Ejercicio 63
*Todas las facultades con ciudad (incluye sin ciudad).*
```sql
SELECT f.nombre                         AS facultad,
       NVL(c.nombre, '-- Sin ciudad --') AS ciudad,
       f.presupuesto
FROM FACULTAD f
LEFT JOIN CIUDAD c ON f.id_ciudad = c.id_ciudad
ORDER BY f.nombre;
```

---

### Ejercicio 64
*Departamentos con número de asignaturas (incluye sin asignaturas).*
```sql
SELECT d.nombre             AS departamento,
       COUNT(a.id_asignatura) AS num_asignaturas
FROM DEPARTAMENTO d
LEFT JOIN ASIGNATURA a ON d.id_departamento = a.id_departamento
GROUP BY d.id_departamento, d.nombre
ORDER BY num_asignaturas DESC;
```

---

### Ejercicio 65
*Todos los departamentos con número de asignaturas.*
```sql
-- Igual que ejercicio 64; aquí se enfatiza el LEFT JOIN
SELECT d.nombre,
       d.id_facultad,
       COUNT(a.id_asignatura) AS num_asignaturas
FROM DEPARTAMENTO d
LEFT JOIN ASIGNATURA a ON d.id_departamento = a.id_departamento
GROUP BY d.id_departamento, d.nombre, d.id_facultad
ORDER BY d.nombre;
```

---

### Ejercicio 66
*Todas las asignaturas con aula del horario (incluye sin horario).*
```sql
SELECT asi.nombre           AS asignatura,
       h.dia_semana,
       h.hora_inicio,
       au.nombre             AS aula
FROM ASIGNATURA asi
LEFT JOIN HORARIO h  ON asi.id_asignatura = h.id_asignatura
                     AND h.año_academico  = '2023-2024'
LEFT JOIN AULA    au ON h.id_aula         = au.id_aula
ORDER BY asi.nombre;
```

---

### Ejercicio 67
*Todos los alumnos con número de matrículas activas 2023-2024.*
```sql
SELECT a.nombre || ' ' || a.apellido AS alumno,
       a.grado,
       COUNT(m.id_matricula)          AS num_matriculas
FROM ALUMNO a
LEFT JOIN MATRICULA m ON a.id_alumno     = m.id_alumno
                      AND m.año_academico = '2023-2024'
                      AND m.estado        = 'Activa'
GROUP BY a.id_alumno, a.nombre, a.apellido, a.grado
ORDER BY num_matriculas DESC, a.apellido;
```

---

### Ejercicio 68
*Cada profesor con su jefe directo (SELF JOIN).*
```sql
SELECT e.nombre || ' ' || e.apellido      AS profesor,
       e.categoria,
       NVL(j.nombre || ' ' || j.apellido,
           '(Director/a)')                AS jefe_directo
FROM PROFESOR e
LEFT JOIN PROFESOR j ON e.id_jefe = j.id_profesor
ORDER BY j.apellido NULLS FIRST, e.apellido;
```

---

### Ejercicio 69
*Tres niveles jerárquicos: profesor → jefe → director.*
```sql
SELECT e.nombre || ' ' || e.apellido AS profesor,
       j.nombre || ' ' || j.apellido AS jefe,
       d.nombre || ' ' || d.apellido AS director
FROM PROFESOR e
INNER JOIN PROFESOR j ON e.id_jefe = j.id_profesor
LEFT  JOIN PROFESOR d ON j.id_jefe = d.id_profesor
ORDER BY d.apellido NULLS FIRST, j.apellido, e.apellido;
```

---

### Ejercicio 70
*Asignaturas con importe total de becas de sus matriculados.*
```sql
SELECT asi.nombre              AS asignatura,
       NVL(SUM(b.importe_anual), 0) AS total_becas
FROM ASIGNATURA asi
LEFT JOIN MATRICULA m ON asi.id_asignatura = m.id_asignatura
                      AND m.año_academico  = '2023-2024'
                      AND m.estado         = 'Activa'
LEFT JOIN BECA      b ON m.id_alumno       = b.id_alumno
                      AND b.año_academico  = '2023-2024'
GROUP BY asi.id_asignatura, asi.nombre
ORDER BY total_becas DESC;
```

---

### Ejercicio 71
*Todos los países con número de ciudades.*
```sql
SELECT p.nombre              AS pais,
       p.continente,
       COUNT(c.id_ciudad)    AS num_ciudades
FROM PAIS p
LEFT JOIN CIUDAD c ON p.id_pais = c.id_pais
GROUP BY p.id_pais, p.nombre, p.continente
ORDER BY num_ciudades DESC;
```

---

### Ejercicio 72
*Todas las facultades con número de departamentos.*
```sql
SELECT f.nombre                  AS facultad,
       COUNT(d.id_departamento)  AS num_departamentos
FROM FACULTAD f
LEFT JOIN DEPARTAMENTO d ON f.id_facultad = d.id_facultad
GROUP BY f.id_facultad, f.nombre
ORDER BY num_departamentos DESC;
```

---

## 🔴 NIVEL 6 — Subconsultas

---

### Ejercicio 73
*Profesores con salario superior a la media.*
```sql
SELECT nombre, apellido, categoria, salario
FROM PROFESOR
WHERE salario > (SELECT AVG(salario) FROM PROFESOR)
ORDER BY salario DESC;
```

---

### Ejercicio 74
*Alumnos con más créditos que la media.*
```sql
SELECT nombre, apellido, grado, creditos_superados
FROM ALUMNO
WHERE creditos_superados > (SELECT AVG(creditos_superados) FROM ALUMNO)
ORDER BY creditos_superados DESC;
```

---

### Ejercicio 75
*Asignaturas con más créditos que la media.*
```sql
SELECT nombre, creditos, tipo, curso
FROM ASIGNATURA
WHERE creditos > (SELECT AVG(creditos) FROM ASIGNATURA)
ORDER BY creditos DESC;
```

---

### Ejercicio 76
*Profesores del departamento con más profesores.*
```sql
SELECT nombre, apellido, categoria, salario
FROM PROFESOR
WHERE id_departamento = (
    SELECT id_departamento
    FROM DEPARTAMENTO
    WHERE num_profesores = (SELECT MAX(num_profesores) FROM DEPARTAMENTO)
    AND ROWNUM = 1
)
ORDER BY apellido;
```

---

### Ejercicio 77
*Alumnos que nunca se han matriculado.*
```sql
SELECT nombre, apellido, grado, año_ingreso
FROM ALUMNO
WHERE NOT EXISTS (
    SELECT 1
    FROM MATRICULA m
    WHERE m.id_alumno = ALUMNO.id_alumno
)
ORDER BY apellido;
```

---

### Ejercicio 78
*Alumnos matriculados en TODAS las asignaturas de 1.er curso de Informática 2023-2024.*
```sql
-- División relacional: el alumno no puede "faltar" en ninguna asignatura del conjunto
SELECT a.nombre, a.apellido, a.grado
FROM ALUMNO a
WHERE a.grado = 'Ingeniería Informática'
  AND NOT EXISTS (
      -- Asignaturas de 1.er curso del departamento 1 (Ing. del Software, dpto que imparte las de primer curso)
      SELECT asi.id_asignatura
      FROM ASIGNATURA asi
      WHERE asi.curso = 1
        AND asi.id_departamento = 1
      MINUS
      -- Asignaturas en las que SÍ está matriculado este alumno
      SELECT m.id_asignatura
      FROM MATRICULA m
      WHERE m.id_alumno     = a.id_alumno
        AND m.año_academico = '2023-2024'
        AND m.estado        = 'Activa'
  )
ORDER BY a.apellido;
```

---

### Ejercicio 79
*Asignaturas en las que ningún alumno ha superado el 9.0.*
```sql
SELECT DISTINCT asi.nombre, asi.creditos
FROM ASIGNATURA asi
WHERE asi.id_asignatura NOT IN (
    SELECT e.id_asignatura
    FROM NOTA n
    INNER JOIN EXAMEN e ON n.id_examen = e.id_examen
    WHERE n.calificacion > 9.0
)
ORDER BY asi.nombre;
```

---

### Ejercicio 80
*Nombre de la facultad con mayor presupuesto.*
```sql
SELECT nombre, presupuesto
FROM FACULTAD
WHERE presupuesto = (SELECT MAX(presupuesto) FROM FACULTAD);
```

---

### Ejercicio 81
*Profesores responsables de más de una asignatura.*
```sql
SELECT p.nombre || ' ' || p.apellido AS profesor,
       COUNT(a.id_asignatura)         AS num_asignaturas
FROM PROFESOR p
INNER JOIN ASIGNATURA a ON p.id_profesor = a.id_profesor
GROUP BY p.id_profesor, p.nombre, p.apellido
HAVING COUNT(a.id_asignatura) > 1
ORDER BY num_asignaturas DESC;
```

---

### Ejercicio 82
*Alumnos con nota media global superior a 7.5.*
```sql
SELECT a.nombre || ' ' || a.apellido AS alumno,
       ROUND(AVG(n.calificacion), 2)  AS nota_media
FROM ALUMNO a
INNER JOIN MATRICULA m ON a.id_alumno  = m.id_alumno
INNER JOIN NOTA      n ON m.id_matricula = n.id_matricula
GROUP BY a.id_alumno, a.nombre, a.apellido
HAVING AVG(n.calificacion) > 7.5
ORDER BY nota_media DESC;
```

---

### Ejercicio 83
*Ciudades con más alumnos que la media de alumnos por ciudad.*
```sql
SELECT c.nombre      AS ciudad,
       COUNT(a.id_alumno) AS num_alumnos
FROM CIUDAD c
INNER JOIN ALUMNO a ON c.id_ciudad = a.id_ciudad_origen
GROUP BY c.id_ciudad, c.nombre
HAVING COUNT(a.id_alumno) > (
    SELECT AVG(cnt)
    FROM (
        SELECT COUNT(id_alumno) AS cnt
        FROM ALUMNO
        WHERE id_ciudad_origen IS NOT NULL
        GROUP BY id_ciudad_origen
    )
)
ORDER BY num_alumnos DESC;
```

---

### Ejercicio 84
*Departamentos cuya masa salarial supera 200.000 €.*
```sql
SELECT d.nombre           AS departamento,
       SUM(p.salario)      AS masa_salarial
FROM DEPARTAMENTO d
INNER JOIN PROFESOR p ON d.id_departamento = p.id_departamento
GROUP BY d.id_departamento, d.nombre
HAVING SUM(p.salario) > 200000
ORDER BY masa_salarial DESC;
```

---

### Ejercicio 85
*Alumnos becados sin ninguna matrícula activa en 2023-2024.*
```sql
SELECT a.nombre || ' ' || a.apellido AS alumno,
       a.grado,
       b.tipo_beca,
       b.importe_anual
FROM ALUMNO a
INNER JOIN BECA b ON a.id_alumno = b.id_alumno
                  AND b.año_academico = '2023-2024'
WHERE NOT EXISTS (
    SELECT 1
    FROM MATRICULA m
    WHERE m.id_alumno     = a.id_alumno
      AND m.año_academico = '2023-2024'
      AND m.estado        = 'Activa'
)
ORDER BY a.apellido;
```

---

## ⚫ NIVEL 7 — Consultas avanzadas y combinadas

---

### Ejercicio 86
*Informe por facultad: departamentos, profesores, presupuesto medio por departamento.*
```sql
SELECT f.nombre                          AS facultad,
       COUNT(DISTINCT d.id_departamento) AS num_departamentos,
       SUM(d.num_profesores)              AS total_profesores,
       ROUND(f.presupuesto /
         NULLIF(COUNT(DISTINCT d.id_departamento), 0), 2) AS presupuesto_por_dpto
FROM FACULTAD f
LEFT JOIN DEPARTAMENTO d ON f.id_facultad = d.id_facultad
GROUP BY f.id_facultad, f.nombre, f.presupuesto
ORDER BY f.presupuesto DESC;
```

---

### Ejercicio 87
*Ranking de alumnos por créditos dentro de cada grado.*
```sql
SELECT grado,
       nombre || ' ' || apellido AS alumno,
       creditos_superados,
       RANK() OVER (PARTITION BY grado ORDER BY creditos_superados DESC) AS posicion
FROM ALUMNO
ORDER BY grado, posicion;
```

---

### Ejercicio 88
*Top 5 profesores por salario.*
```sql
SELECT nombre || ' ' || apellido AS profesor,
       categoria,
       salario
FROM (
    SELECT p.nombre, p.apellido, p.categoria, p.salario,
           d.nombre AS departamento,
           RANK() OVER (ORDER BY p.salario DESC) AS rnk
    FROM PROFESOR p
    LEFT JOIN DEPARTAMENTO d ON p.id_departamento = d.id_departamento
)
WHERE rnk <= 5
ORDER BY salario DESC;
```

---

### Ejercicio 89
*Asignaturas del dpto 1 con matriculados y nota media en examen final.*
```sql
SELECT asi.nombre                            AS asignatura,
       COUNT(DISTINCT m.id_alumno)           AS alumnos_matriculados,
       ROUND(AVG(n.calificacion), 2)         AS nota_media_final
FROM ASIGNATURA asi
LEFT JOIN MATRICULA m ON asi.id_asignatura = m.id_asignatura
                      AND m.año_academico  = '2023-2024'
                      AND m.estado         = 'Activa'
LEFT JOIN EXAMEN    e ON asi.id_asignatura = e.id_asignatura
                      AND e.tipo           = 'Final'
                      AND e.año_academico  = '2023-2024'
LEFT JOIN NOTA      n ON m.id_matricula    = n.id_matricula
                      AND n.id_examen      = e.id_examen
WHERE asi.id_departamento = 1
GROUP BY asi.id_asignatura, asi.nombre
ORDER BY asi.nombre;
```

---

### Ejercicio 90
*Alumnos internacionales con sus becas (incluye sin beca).*
```sql
SELECT a.nombre || ' ' || a.apellido AS alumno,
       pa.nombre                      AS pais_origen,
       b.tipo_beca,
       b.importe_anual,
       b.entidad
FROM ALUMNO a
INNER JOIN CIUDAD c  ON a.id_ciudad_origen = c.id_ciudad
INNER JOIN PAIS   pa ON c.id_pais          = pa.id_pais
LEFT  JOIN BECA   b  ON a.id_alumno        = b.id_alumno
                     AND b.año_academico   = '2023-2024'
WHERE pa.nombre <> 'España'
ORDER BY pa.nombre, a.apellido;
```

---

### Ejercicio 91
*Estadísticas de cada examen 2023-2024.*
```sql
SELECT asi.nombre                                              AS asignatura,
       e.tipo                                                  AS tipo_examen,
       TO_CHAR(e.fecha_examen, 'DD/MM/YYYY')                   AS fecha,
       COUNT(n.id_nota)                                        AS presentados,
       ROUND(AVG(n.calificacion), 2)                           AS nota_media,
       ROUND(COUNT(CASE WHEN n.calificacion >= 5 THEN 1 END)
             * 100.0 / NULLIF(COUNT(n.id_nota), 0), 2)        AS pct_aprobados
FROM EXAMEN e
INNER JOIN ASIGNATURA asi ON e.id_asignatura = asi.id_asignatura
LEFT  JOIN NOTA       n   ON e.id_examen     = n.id_examen
WHERE e.año_academico = '2023-2024'
GROUP BY e.id_examen, asi.nombre, e.tipo, e.fecha_examen
ORDER BY e.fecha_examen;
```

---

### Ejercicio 92
*Carga lectiva por día de la semana.*
```sql
SELECT h.dia_semana,
       COUNT(DISTINCT h.id_asignatura)  AS asignaturas,
       SUM(mat_cnt.num_matriculados)    AS total_matriculados,
       SUM(au.capacidad)                AS capacidad_total
FROM HORARIO h
INNER JOIN AULA au ON h.id_aula = au.id_aula
LEFT JOIN (
    SELECT id_asignatura,
           COUNT(*) AS num_matriculados
    FROM MATRICULA
    WHERE año_academico = '2023-2024' AND estado = 'Activa'
    GROUP BY id_asignatura
) mat_cnt ON h.id_asignatura = mat_cnt.id_asignatura
WHERE h.año_academico = '2023-2024'
GROUP BY h.dia_semana
ORDER BY DECODE(h.dia_semana,
    'Lunes',1,'Martes',2,'Miércoles',3,'Jueves',4,'Viernes',5);
```

---

### Ejercicio 93
*Nota media y etiqueta de calificación para alumnos de Informática.*
```sql
SELECT a.nombre || ' ' || a.apellido    AS alumno,
       ROUND(AVG(n.calificacion), 2)     AS nota_media,
       CASE
           WHEN AVG(n.calificacion) >= 9 THEN 'Sobresaliente'
           WHEN AVG(n.calificacion) >= 7 THEN 'Notable'
           WHEN AVG(n.calificacion) >= 5 THEN 'Aprobado'
           ELSE                               'Suspenso'
       END AS clasificacion
FROM ALUMNO a
INNER JOIN MATRICULA m ON a.id_alumno    = m.id_alumno
INNER JOIN NOTA      n ON m.id_matricula = n.id_matricula
WHERE a.grado = 'Ingeniería Informática'
GROUP BY a.id_alumno, a.nombre, a.apellido
ORDER BY nota_media DESC;
```

---

### Ejercicio 94
*Conflictos de aula: dos asignaturas en la misma aula, mismo día y horario solapado.*
```sql
SELECT h1.id_aula,
       au.nombre           AS aula,
       h1.dia_semana,
       h1.id_asignatura    AS asig_1,
       a1.nombre           AS nombre_asig_1,
       h1.hora_inicio      AS inicio_1,
       h1.hora_fin         AS fin_1,
       h2.id_asignatura    AS asig_2,
       a2.nombre           AS nombre_asig_2,
       h2.hora_inicio      AS inicio_2,
       h2.hora_fin         AS fin_2
FROM HORARIO h1
INNER JOIN HORARIO    h2 ON h1.id_aula       = h2.id_aula
                         AND h1.dia_semana   = h2.dia_semana
                         AND h1.año_academico = h2.año_academico
                         AND h1.id_asignatura < h2.id_asignatura  -- evitar duplicados
                         AND h1.hora_inicio   < h2.hora_fin       -- solapamiento
                         AND h1.hora_fin      > h2.hora_inicio
INNER JOIN AULA       au ON h1.id_aula        = au.id_aula
INNER JOIN ASIGNATURA a1 ON h1.id_asignatura  = a1.id_asignatura
INNER JOIN ASIGNATURA a2 ON h2.id_asignatura  = a2.id_asignatura
ORDER BY h1.dia_semana, h1.hora_inicio;
```

---

### Ejercicio 95
*Evolución de matrículas por año académico y facultad.*
```sql
SELECT m.año_academico,
       f.nombre             AS facultad,
       COUNT(m.id_matricula) AS num_matriculas
FROM MATRICULA m
INNER JOIN ASIGNATURA   asi ON m.id_asignatura  = asi.id_asignatura
INNER JOIN DEPARTAMENTO d   ON asi.id_departamento = d.id_departamento
INNER JOIN FACULTAD     f   ON d.id_facultad    = f.id_facultad
GROUP BY m.año_academico, f.id_facultad, f.nombre
ORDER BY m.año_academico, f.nombre;
```

---

### Ejercicio 96
*Diferencia salarial de cada profesor respecto a la media de su categoría.*
```sql
SELECT p.nombre || ' ' || p.apellido         AS profesor,
       p.categoria,
       j.nombre || ' ' || j.apellido         AS jefe,
       p.salario,
       ROUND(media_cat.salario_medio, 2)      AS media_categoria,
       ROUND((p.salario - media_cat.salario_medio)
             / media_cat.salario_medio * 100, 1) AS diferencia_pct
FROM PROFESOR p
LEFT JOIN PROFESOR j ON p.id_jefe = j.id_profesor
INNER JOIN (
    SELECT categoria, AVG(salario) AS salario_medio
    FROM PROFESOR
    GROUP BY categoria
) media_cat ON p.categoria = media_cat.categoria
ORDER BY p.categoria, diferencia_pct DESC;
```

---

### Ejercicio 97
*Asignaturas más demandadas: matrículas históricas y % sobre la facultad.*
```sql
SELECT asi.nombre                  AS asignatura,
       f.nombre                    AS facultad,
       COUNT(m.id_matricula)        AS total_matriculas,
       ROUND(COUNT(m.id_matricula) * 100.0
             / SUM(COUNT(m.id_matricula)) OVER
                 (PARTITION BY f.id_facultad), 2) AS pct_facultad
FROM ASIGNATURA   asi
INNER JOIN MATRICULA    m ON asi.id_asignatura  = m.id_asignatura
INNER JOIN DEPARTAMENTO d ON asi.id_departamento = d.id_departamento
INNER JOIN FACULTAD     f ON d.id_facultad       = f.id_facultad
GROUP BY asi.id_asignatura, asi.nombre, f.id_facultad, f.nombre
ORDER BY f.nombre, pct_facultad DESC;
```

---

### Ejercicio 98
*Informe de becas por país.*
```sql
SELECT pa.nombre                        AS pais,
       COUNT(DISTINCT b.id_alumno)       AS alumnos_becados,
       SUM(b.importe_anual)              AS importe_total,
       ROUND(AVG(b.importe_anual), 2)    AS importe_medio,
       MAX(a.nombre || ' ' || a.apellido)
           KEEP (DENSE_RANK FIRST ORDER BY b.importe_anual DESC)
                                        AS alumno_beca_mayor
FROM BECA b
INNER JOIN ALUMNO a  ON b.id_alumno        = a.id_alumno
INNER JOIN CIUDAD c  ON a.id_ciudad_origen = c.id_ciudad
INNER JOIN PAIS   pa ON c.id_pais          = pa.id_pais
GROUP BY pa.id_pais, pa.nombre
ORDER BY importe_total DESC;
```

---

### Ejercicio 99
*Alumnos que mejoraron del parcial al final en la misma asignatura.*
```sql
SELECT a.nombre || ' ' || a.apellido AS alumno,
       asi.nombre                     AS asignatura,
       n_par.calificacion             AS nota_parcial,
       n_fin.calificacion             AS nota_final,
       ROUND(n_fin.calificacion
             - n_par.calificacion, 2) AS mejora
FROM ALUMNO a
INNER JOIN MATRICULA  m     ON a.id_alumno      = m.id_alumno
INNER JOIN ASIGNATURA asi   ON m.id_asignatura  = asi.id_asignatura
-- Examen parcial
INNER JOIN EXAMEN     e_par ON asi.id_asignatura = e_par.id_asignatura
                            AND e_par.tipo        = 'Parcial'
INNER JOIN NOTA       n_par ON m.id_matricula    = n_par.id_matricula
                            AND n_par.id_examen  = e_par.id_examen
-- Examen final del mismo año
INNER JOIN EXAMEN     e_fin ON asi.id_asignatura  = e_fin.id_asignatura
                            AND e_fin.tipo         = 'Final'
                            AND e_fin.año_academico = e_par.año_academico
INNER JOIN NOTA       n_fin ON m.id_matricula     = n_fin.id_matricula
                            AND n_fin.id_examen   = e_fin.id_examen
WHERE n_fin.calificacion > n_par.calificacion
ORDER BY mejora DESC;
```

---

### Ejercicio 100
*Expediente académico completo de los 10 alumnos con mayor nota media.*
```sql
WITH notas_alumno AS (
    SELECT m.id_alumno,
           ROUND(AVG(n.calificacion), 2)                        AS nota_media,
           COUNT(CASE WHEN n.calificacion >= 5 THEN 1 END)      AS asig_superadas
    FROM MATRICULA m
    INNER JOIN NOTA n ON m.id_matricula = n.id_matricula
    GROUP BY m.id_alumno
),
facultad_principal AS (
    SELECT m.id_alumno,
           f.nombre AS facultad_principal,
           RANK() OVER (PARTITION BY m.id_alumno
                        ORDER BY COUNT(*) DESC) AS rnk
    FROM MATRICULA   m
    INNER JOIN ASIGNATURA   asi ON m.id_asignatura   = asi.id_asignatura
    INNER JOIN DEPARTAMENTO d   ON asi.id_departamento = d.id_departamento
    INNER JOIN FACULTAD     f   ON d.id_facultad       = f.id_facultad
    GROUP BY m.id_alumno, f.id_facultad, f.nombre
)
SELECT a.nombre || ' ' || a.apellido  AS alumno,
       a.grado,
       a.año_ingreso,
       a.creditos_superados,
       na.nota_media,
       na.asig_superadas,
       a.beca_activa,
       fp.facultad_principal
FROM ALUMNO a
INNER JOIN notas_alumno     na ON a.id_alumno = na.id_alumno
INNER JOIN facultad_principal fp ON a.id_alumno = fp.id_alumno
                                 AND fp.rnk     = 1
ORDER BY na.nota_media DESC
FETCH FIRST 10 ROWS ONLY;
```

---

> **Nota:** Las consultas de nivel 7 utilizan funciones analíticas (`RANK`, `SUM ... OVER`, `KEEP DENSE_RANK`) y CTEs (`WITH`), disponibles a partir de Oracle 9i. Para versiones antiguas puede ser necesario adaptar la sintaxis.
