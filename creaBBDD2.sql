-- BORRAR TABLAS SI EXISTEN
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Registro_tiempo CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Asignaciones CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Empleados CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Proyectos CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- CREAR TABLAS
CREATE TABLE Empleados (
    id_empleado NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    apellido VARCHAR2(50),
    email VARCHAR2(100),
    fecha_contratacion DATE,
    salario NUMBER
);

CREATE TABLE Proyectos (
    id_proyecto NUMBER PRIMARY KEY,
    nombre_proyecto VARCHAR2(100),
    descripcion VARCHAR2(200),
    fecha_inicio DATE,
    fecha_fin_prevista DATE,
    presupuesto NUMBER
);

CREATE TABLE Asignaciones (
    id_asignacion NUMBER PRIMARY KEY,
    id_empleado NUMBER,
    id_proyecto NUMBER,
    fecha_asignacion DATE,
    fecha_fin_asignacion DATE,
    rol VARCHAR2(50),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_proyecto) REFERENCES Proyectos(id_proyecto)
);

CREATE TABLE Registro_tiempo (
    id_registro NUMBER PRIMARY KEY,
    id_asignacion NUMBER UNIQUE,
    fecha_registro DATE,
    horas_trabajadas NUMBER,
    descripcion_tarea VARCHAR2(200),
    FOREIGN KEY (id_asignacion) REFERENCES Asignaciones(id_asignacion)
);

-- INSERT EMPLEADOS
INSERT INTO Empleados VALUES (1,'Juan','Pérez','juan.perez@example.com',TO_DATE('2023-01-15','YYYY-MM-DD'),50000);
INSERT INTO Empleados VALUES (2,'María','Gómez','maria.gomez@example.com',TO_DATE('2022-11-01','YYYY-MM-DD'),52000);
INSERT INTO Empleados VALUES (3,'Carlos','Rodríguez','carlos.rodriguez@example.com',TO_DATE('2023-05-20','YYYY-MM-DD'),48000);

-- INSERT PROYECTOS
INSERT INTO Proyectos VALUES (101,'Proyecto A','Desarrollo web',TO_DATE('2024-02-01','YYYY-MM-DD'),TO_DATE('2024-08-31','YYYY-MM-DD'),120000);
INSERT INTO Proyectos VALUES (102,'Proyecto B','App móvil',TO_DATE('2024-03-15','YYYY-MM-DD'),TO_DATE('2024-09-30','YYYY-MM-DD'),150000);
INSERT INTO Proyectos VALUES (103,'Proyecto C','Análisis datos',TO_DATE('2024-04-01','YYYY-MM-DD'),TO_DATE('2024-10-15','YYYY-MM-DD'),110000);

-- INSERT ASIGNACIONES
INSERT INTO Asignaciones VALUES (201,1,101,TO_DATE('2024-02-01','YYYY-MM-DD'),TO_DATE('2024-08-31','YYYY-MM-DD'),'Desarrollador');
INSERT INTO Asignaciones VALUES (202,2,102,TO_DATE('2024-03-15','YYYY-MM-DD'),TO_DATE('2024-09-30','YYYY-MM-DD'),'Diseñador');
INSERT INTO Asignaciones VALUES (203,3,103,TO_DATE('2024-04-01','YYYY-MM-DD'),TO_DATE('2024-10-15','YYYY-MM-DD'),'Analista');

-- INSERT REGISTRO TIEMPO
INSERT INTO Registro_tiempo VALUES (301,201,TO_DATE('2024-02-05','YYYY-MM-DD'),8,'Desarrollo interfaz');
INSERT INTO Registro_tiempo VALUES (302,202,TO_DATE('2024-03-20','YYYY-MM-DD'),7.5,'Diseño navegación');
INSERT INTO Registro_tiempo VALUES (303,203,TO_DATE('2024-04-03','YYYY-MM-DD'),9,'Recopilación datos');

COMMIT;

-- PRUEBA
SELECT * FROM Empleados;