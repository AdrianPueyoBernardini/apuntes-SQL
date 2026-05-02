# Oracle Database — 100 Ejercicios de SELECT
## Base de datos: Academia Universitaria

> Utiliza el script `academia_setup.sql` para crear la base de datos antes de comenzar.

---

### Esquema de tablas
| Tabla | Columnas clave |
|-------|---------------|
| `PAIS` | id_pais, nombre, continente |
| `CIUDAD` | id_ciudad, nombre, id_pais, poblacion |
| `FACULTAD` | id_facultad, nombre, decano, año_fundacion, presupuesto, id_ciudad |
| `DEPARTAMENTO` | id_departamento, nombre, id_facultad, num_profesores |
| `PROFESOR` | id_profesor, nombre, apellido, email, categoria, salario, fecha_ingreso, id_departamento, id_jefe, id_ciudad_origen |
| `ALUMNO` | id_alumno, nombre, apellido, email, dni, fecha_nacimiento, id_ciudad_origen, año_ingreso, grado, creditos_superados, beca_activa |
| `ASIGNATURA` | id_asignatura, nombre, creditos, tipo, curso, semestre, id_departamento, id_profesor, max_alumnos |
| `MATRICULA` | id_matricula, id_alumno, id_asignatura, año_academico, fecha_matricula, estado |
| `EXAMEN` | id_examen, id_asignatura, tipo, fecha_examen, duracion_min, año_academico |
| `NOTA` | id_nota, id_matricula, id_examen, calificacion, fecha_publicacion, observaciones |
| `BECA` | id_beca, id_alumno, tipo_beca, importe_anual, año_academico, entidad, renovable |
| `AULA` | id_aula, nombre, capacidad, tipo, id_facultad, tiene_proyector |
| `HORARIO` | id_horario, id_asignatura, id_aula, dia_semana, hora_inicio, hora_fin, año_academico |

---

## 🟢 NIVEL 1 — SELECT básico (ejercicios 1–15)

**1.** Muestra todos los datos de la tabla `PAIS`.

**2.** Muestra el nombre y el continente de todos los países.

**3.** Muestra el nombre, apellido y email de todos los profesores.

**4.** Muestra el nombre, apellido, grado y año de ingreso de todos los alumnos.

**5.** Muestra todas las asignaturas con su número de créditos.

**6.** Muestra el nombre y la capacidad de todas las aulas.

**7.** Muestra los datos completos de todas las facultades.

**8.** Muestra el nombre, el tipo y la entidad de todas las becas.

**9.** Muestra el id, nombre y apellido de todos los alumnos. Renombra las columnas como `CODIGO`, `NOMBRE_ALU` y `APELLIDO_ALU`.

**10.** Muestra una lista con los distintos tipos de asignatura que existen (`DISTINCT`).

**11.** Muestra los distintos continentes que hay en la tabla `PAIS`.

**12.** Muestra los distintos grados que cursan los alumnos.

**13.** Muestra los distintos tipos de aula disponibles.

**14.** Muestra el nombre completo de cada profesor concatenando nombre y apellido en una sola columna llamada `NOMBRE_COMPLETO` (usa `||` y un espacio entre ambos).

**15.** Muestra el nombre completo de cada alumno y su email, con el encabezado `ALUMNO` y `CORREO`.

---

## 🟡 NIVEL 2 — WHERE y ORDER BY (ejercicios 16–30)

**16.** Muestra los profesores con categoría `'Catedrático'`.

**17.** Muestra los alumnos que ingresaron en el año 2022.

**18.** Muestra las asignaturas del primer semestre.

**19.** Muestra las facultades con un presupuesto mayor de 2.000.000 €.

**20.** Muestra los profesores con un salario entre 40.000 y 55.000 €.

**21.** Muestra los alumnos que tienen beca activa (`beca_activa = 'S'`).

**22.** Muestra los alumnos cuyo apellido empieza por la letra `'S'`.

**23.** Muestra las asignaturas cuyo nombre contiene la palabra `'Derecho'`.

**24.** Muestra los profesores que no tienen jefe asignado (`id_jefe IS NULL`).

**25.** Muestra las matrículas con estado `'Anulada'`.

**26.** Muestra los países del continente `'América'` ordenados alfabéticamente por nombre.

**27.** Muestra los alumnos con más de 200 créditos superados, ordenados de mayor a menor créditos.

**28.** Muestra las asignaturas de tipo `'Obligatoria'` del curso 1, ordenadas por semestre y luego por nombre.

**29.** Muestra los profesores con salario superior a 60.000 € ordenados por salario descendente.

**30.** Muestra los exámenes cuya duración es menor de 100 minutos o cuya duración es `NULL`, ordenados por fecha de examen.

---

## 🟠 NIVEL 3 — Funciones de agregación y GROUP BY (ejercicios 31–45)

**31.** Cuenta el número total de alumnos registrados.

**32.** Calcula el salario medio, máximo y mínimo de todos los profesores.

**33.** Muestra cuántas asignaturas hay por tipo (`Obligatoria`, `Optativa`, etc.).

**34.** Muestra el número de alumnos agrupados por año de ingreso.

**35.** Calcula la suma total de créditos superados por todos los alumnos.

**36.** Muestra el número de profesores por categoría, ordenado de mayor a menor.

**37.** Calcula el presupuesto total de todas las facultades.

**38.** Muestra el número de matrículas por estado (`Activa`, `Anulada`, `Convalidada`).

**39.** Calcula la media de créditos de las asignaturas agrupadas por curso.

**40.** Muestra los departamentos que tienen más de 10 profesores (usa la columna `num_profesores`).

**41.** Muestra cuántas becas hay por tipo de beca, incluyendo el importe total de cada tipo.

**42.** Calcula la nota media, máxima y mínima de cada examen (tabla `NOTA`), mostrando el `id_examen`.

**43.** Muestra los alumnos que tienen más de 2 matrículas activas en el curso `'2023-2024'`.

**44.** Muestra los países que tienen más de 3 ciudades registradas.

**45.** Muestra las asignaturas con más de 70 alumnos matriculados en el curso `'2023-2024'` (número de matrículas activas).

---

## 🔵 NIVEL 4 — JOIN entre dos tablas (ejercicios 46–60)

**46.** Muestra el nombre de cada ciudad junto con el nombre del país al que pertenece.

**47.** Muestra el nombre de cada departamento junto con el nombre de la facultad a la que pertenece.

**48.** Muestra el nombre y apellido de cada profesor junto con el nombre del departamento en el que trabaja.

**49.** Muestra el nombre y apellido de cada alumno junto con el nombre de su ciudad de origen.

**50.** Muestra el nombre de cada asignatura junto con el nombre del departamento que la imparte.

**51.** Muestra las matrículas activas del curso `'2023-2024'` con el nombre y apellido del alumno.

**52.** Muestra el nombre de cada asignatura y el nombre completo del profesor responsable de ella.

**53.** Muestra el nombre del aula y el nombre de la facultad a la que pertenece cada aula.

**54.** Muestra los datos de cada beca junto con el nombre y apellido del alumno beneficiario.

**55.** Muestra el nombre de la asignatura, el día de la semana y el aula de cada horario registrado.

**56.** Muestra cada nota junto con la calificación y el tipo de examen al que corresponde.

**57.** Muestra los alumnos que tienen beca activa (`beca_activa = 'S'`) junto con el nombre de su ciudad de origen. Usa `INNER JOIN`.

**58.** Muestra el nombre de cada asignatura y su semestre junto con el nombre del aula y día de la semana de su horario (solo asignaturas con horario asignado).

**59.** Muestra el nombre y apellido de cada profesor junto con el nombre de su ciudad de origen.

**60.** Muestra los alumnos matriculados en la asignatura `'Bases de Datos'` (curso `2023-2024`), con su nombre y apellido.

---

## 🟣 NIVEL 5 — OUTER JOIN y SELF JOIN (ejercicios 61–72)

**61.** Muestra todos los profesores con el nombre de su departamento. Incluye también los profesores que no tengan departamento asignado.

**62.** Muestra todos los alumnos con el nombre de su ciudad de origen. Incluye los alumnos que no tengan ciudad asignada.

**63.** Muestra todas las facultades con el nombre de la ciudad donde se ubican. Incluye las facultades sin ciudad asignada.

**64.** Muestra todas las categorías de profesores (`Catedrático`, `Titular`, etc.) y cuántos profesores tiene cada una, incluyendo categorías con 0 profesores si las hubiera. *(Pista: usa un `CROSS JOIN` o `RIGHT JOIN` con una lista de valores.)*

**65.** Muestra todos los departamentos y cuántas asignaturas tiene cada uno. Incluye los departamentos sin asignaturas.

**66.** Muestra todas las asignaturas y el nombre del aula asignada en el horario. Incluye asignaturas sin horario.

**67.** Muestra todos los alumnos y cuántas matrículas activas tienen en `'2023-2024'`. Incluye los alumnos sin ninguna matrícula (resultado 0).

**68.** Muestra cada profesor junto con el nombre de su jefe directo. Incluye también los profesores sin jefe (directores). *(SELF JOIN)*

**69.** Muestra cada profesor, su jefe directo y el jefe del jefe (tres niveles jerárquicos). *(SELF JOIN triple)*

**70.** Muestra todas las asignaturas y el importe total de becas percibido por los alumnos matriculados en ellas en `'2023-2024'`. Incluye asignaturas sin alumnos becados (importe = 0 o NULL).

**71.** Muestra todos los países con el número de ciudades que tienen registradas. Incluye los países sin ninguna ciudad.

**72.** Muestra todas las facultades y el número de departamentos de cada una. Incluye las facultades sin departamentos.

---

## 🔴 NIVEL 6 — Subconsultas (ejercicios 73–85)

**73.** Muestra los profesores cuyo salario es superior al salario medio de todos los profesores.

**74.** Muestra los alumnos que tienen más créditos superados que la media de todos los alumnos.

**75.** Muestra las asignaturas cuyos créditos son superiores a la media de créditos de todas las asignaturas.

**76.** Muestra el nombre y apellido de los profesores del departamento con más profesores (según la columna `num_profesores`).

**77.** Muestra los alumnos que **nunca** se han matriculado en ninguna asignatura. *(Subconsulta con NOT EXISTS o NOT IN)*

**78.** Muestra los alumnos matriculados en **todas** las asignaturas del primer curso del grado de `'Ingeniería Informática'` del año `'2023-2024'`. *(Subconsulta de división relacional)*

**79.** Muestra las asignaturas en las que **ningún** alumno ha obtenido una nota superior a 9.0.

**80.** Muestra el nombre de la facultad con el mayor presupuesto.

**81.** Muestra los profesores que imparten más de una asignatura (son responsables de más de una).

**82.** Muestra los alumnos cuya nota media (en todos sus exámenes con nota registrada) es superior a 7.5.

**83.** Muestra las ciudades que tienen más alumnos que la media de alumnos por ciudad.

**84.** Muestra los departamentos cuya suma de salarios de profesores supera los 200.000 € anuales.

**85.** Muestra los alumnos que están becados pero que **no** tienen ninguna matrícula activa en `'2023-2024'`.

---

## ⚫ NIVEL 7 — Consultas avanzadas y combinadas (ejercicios 86–100)

**86.** Muestra para cada facultad: nombre de la facultad, número de departamentos, número total de profesores (suma de `num_profesores`) y presupuesto medio por departamento. Ordena por presupuesto descendente.

**87.** Genera un ranking de alumnos por créditos superados dentro de cada grado. Muestra el grado, nombre, apellido y créditos, ordenado por grado y créditos descendentes.

**88.** Muestra los 5 profesores con mayor salario, indicando su nombre completo, categoría, departamento y salario. Usa `ROWNUM` o `FETCH FIRST`.

**89.** Para cada asignatura del departamento 1 (`Ingeniería del Software`), muestra el nombre de la asignatura, el número de alumnos matriculados en `'2023-2024'` y la nota media obtenida en los exámenes finales de ese año. Incluye asignaturas sin notas.

**90.** Muestra los alumnos internacionales (de países distintos a España) con sus becas. Muestra nombre, apellido, país de origen, tipo de beca e importe. Incluye alumnos internacionales sin beca.

**91.** Para cada examen del curso `'2023-2024'`, muestra el nombre de la asignatura, el tipo de examen, la fecha, el número de alumnos presentados, la nota media y el porcentaje de aprobados (nota >= 5). Redondea los valores a 2 decimales.

**92.** Muestra un informe de carga lectiva por día de la semana: día, número de asignaturas impartidas, número total de alumnos matriculados en esas asignaturas y capacidad total de las aulas utilizadas.

**93.** Calcula para cada alumno del grado `'Ingeniería Informática'` su nota media global (de todas las notas registradas) y clasifícalo con una etiqueta: `'Sobresaliente'` (>= 9), `'Notable'` (>= 7), `'Aprobado'` (>= 5) o `'Suspenso'` (< 5). Usa `CASE WHEN`.

**94.** Detecta posibles conflictos de aula: muestra los casos en que dos asignaturas distintas comparten aula, día de la semana y rango horario solapado en el mismo año académico.

**95.** Muestra la evolución del número de matrículas por año académico y por facultad (a través del departamento de la asignatura). Muestra el año, la facultad y el número de matrículas.

**96.** Para cada profesor, muestra su nombre completo, su categoría, el nombre de su jefe y calcula cuánto gana de más o de menos respecto a la media salarial de su categoría. Expresa la diferencia como un porcentaje redondeado a 1 decimal.

**97.** Genera un listado de las asignaturas más demandadas: muestra el nombre de la asignatura, la facultad a la que pertenece, el número total de matrículas históricas y el porcentaje que representa sobre el total de matrículas de esa facultad.

**98.** Muestra un informe completo de becas por país: país, número de alumnos becados, importe total de becas, importe medio por becado y el alumno con la beca más alta (nombre y apellido). Si un país no tiene alumnos becados no debe aparecer.

**99.** Encuentra los alumnos que han mejorado su nota entre el parcial y el final de la misma asignatura en el mismo año académico: muestra nombre, apellido, asignatura, nota del parcial, nota del final y la diferencia.

**100.** Diseña una consulta que genere el expediente académico completo de los 10 alumnos con mayor nota media. Para cada uno muestra: nombre completo, grado, año de ingreso, créditos superados, nota media global, número de asignaturas superadas (nota >= 5), si tiene beca activa y el nombre de la facultad principal donde está matriculado (la que tiene más asignaturas suyas). Ordena por nota media descendente.
