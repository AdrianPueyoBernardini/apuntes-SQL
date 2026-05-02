--3. FUNCIONES NUMÉRICAS
--3.1.1 ABS: Convierte un valor negativo en absoluto(positivo)
SELECT ABS(-10) FROM EMPLEADO;

--3.1.2 CEIL: RENDONDEO EN POSITIVO
SELECT CEIL(2.2) FROM EMPLEADO;

--3.1.3 EXP:
SELECT EXP(2) FROM EMPLEADO;

--3.1.4 FLOOR: Rendondeo de un número
SELECT FLOOR(2.2) FROM EMPLEADO;

--3.1.5 MOD: Resto de una division
SELECT MOD(2, 2) FROM EMPLEADO;

--3.1.6 POWER: Exponente de una division
SELECT POWER(2, 2) FROM EMPLEADO;

--3.1.7 ROUND: REDONDEO ALOS DECIMALES SELECCIONADOS
SELECT ROUND(2.1872728, 2) FROM EMPLEADO;

--3.1.8 SQRT: RAIZ CUADRADA DE UN NÚMERO
SELECT SQRT(16) FROM EMPLEADO;

--3.1.9 TRUNC: Trunca un número a la cantidad de decimales especificada por el segundo argumento.
SELECT TRUNC(211.1872728, 2) FROM EMPLEADO;

--6.1 SUM(): Suma el valor total de un campo
SELECT SUM(presupuesto) FROM Proyectos;

--6.1 COUNT(): Cuenta el total de filas de un campo
SELECT COUNT(id_empleado) FROM Empleados;

--6.2 MIN/MAX: Maximo de un valor y minimo
SELECT MAX(presupuesto) FROM Proyectos;
SELECT MIN(presupuesto) FROM Proyectos;

--6.2 AVG: Media de un valor
SELECT AVG(presupuesto) FROM Proyectos;