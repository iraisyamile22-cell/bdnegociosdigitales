/*
SUBCONSUKTA ESCALAR (UN VALOR)
*/

SELECT 
	O.OrderID,
	(OD.Quantity * OD.UnitPrice) AS [TOTAL],
	(SELECT AVG(OD.Quantity * OD.UnitPrice) FROM [Order Details] AS OD) AS [AVGTOTAL]
FROM Orders AS O
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID;

/*
MOSTRAR EL NOMBRE DEL PRODUCTO Y EL PRECIO PROMEDIO
DE TODOS LOS PRODUCTOS
*/
SELECT 
	p.ProductName,
	(
		SELECT AVG(UnitPrice) FROM Products
	) AS [PRECIO PROMEDIO]
FROM Products AS p;

/*
MOSTRAR CADA EMPLEADO Y LA CANTIDAD TOTAL DE PEDIDOS QUE TIENE 
*/

SELECT e.EmployeeID,FirstName,lastName, count(o.OrderID)
FROM Employees AS e
INNER JOIN Orders as o
ON e.EmployeeID=o.EmployeeID
GROUP BY e.EmployeeID, FirstName,lastName;


/*
MOSTRAR CADA CLIENTE Y FECHA DE SU ULTIMO PEDIDO 
*/


--Datos de ejemplo 
CREATE DATABASE bdsubconsultas; 
GO

USE bdsubconsultas;
GO

CREATE TABLE clientes(
	id_cliente INT NOT NULL identity(1,1) primary key,
	nombre NVARCHAR(50) NOT NULL,
	ciudad NCHAR(20) NOT NULL
);


CREATE TABLE pedidos(
	id_pedido INT NOT NULL identity(1,1) primary key,
	id_cliente INT NOT NULL,
	total MONEY NOT NULL,
	fecha DATE NOT NULL,
	CONSTRAINT fk_pedidos_clientes 
	FOREIGN KEY (id_cliente)
	REFERENCES clientes(id_cliente)
);

--CONSULTA ESCALAR 
INSERT INTO clientes (nombre, ciudad) VALUES
('Ana', 'CDMX'),
('Luis', 'Guadalajara'),
('Marta', 'CDMX'),
('Pedro', 'Monterrey'),
('Sofia', 'Puebla'),
('Carlos', 'CDMX'), 
('Artemio', 'Pachuca'), 
('Roberto', 'Veracruz');

INSERT INTO pedidos (id_cliente, total, fecha) VALUES
(1, 1000.00, '2024-01-10'),
(1, 500.00,  '2024-02-10'),
(2, 300.00,  '2024-01-05'),
(3, 1500.00, '2024-03-01'),
(3, 700.00,  '2024-03-15'),
(1, 1200.00, '2024-04-01'),
(2, 800.00,  '2024-02-20'),
(3, 400.00,  '2024-04-10');

-- SELECCIONAR LOS PEDIDOS EN DONDE EL TOTAL 
-- SEA IGUAL AL TOTAL MAXIMO DE ELLOS 

SELECT MAX(total)
FROM pedidos;

SELECT *
FROM pedidos
WHERE total = (SELECT MAX(total)
FROM pedidos);

SELECT P.id_pedido, C.nombre, P.fecha, P.total
FROM pedidos AS P
INNER JOIN clientes AS C
ON P.id_cliente = C.id_cliente
ORDER BY p.total DESC;

SELECT P.id_pedido, C.nombre, P.fecha, P.total
FROM pedidos AS P
INNER JOIN clientes AS C
ON P.id_cliente = C.id_cliente
WHERE P.total = (
	SELECT MAX(total)
	FROM pedidos
);


--SELECCIONAR LOS PEDIDOS MAYORES AL PROMEDIO

SELECT AVG(total)
FROM pedidos;

SELECT *
FROM pedidos
WHERE total > (
	SELECT AVG(total)
	FROM pedidos
);

--SELECCIONAR TODO LOS PEDIDOS DEL CLIENTE QUE TENGA EL MENOR ID

SELECT MIN(id_cliente)
FROM pedidos;

SELECT *
FROM pedidos
WHERE id_cliente = (
	SELECT MIN(id_cliente)
	FROM pedidos
);

SELECT id_cliente, COUNT(*) AS [Numero de Pedidos]
FROM pedidos
WHERE id_cliente = (
	SELECT MIN(id_cliente)
	FROM pedidos
)
GROUP BY id_cliente;

--MOSTRAR LOS DATOS DEL PEDIDO DEL ULTIMA ORDEN 

SELECT MAX(fecha)
FROM pedidos;

SELECT P.id_pedido, C.nombre, P.fecha, P.total
FROM pedidos AS P
INNER JOIN clientes AS C
ON P.id_cliente = C.id_cliente
WHERE fecha = (
	SELECT MAX(fecha)
	FROM pedidos
);

--MOSTRAR TODO LOS PEDIDOS CON UN TOTAL 
--QUE SEA EL MAS BAJO 

SELECT MIN(total)
FROM pedidos;

SELECT P.id_pedido, C.nombre, P.total
FROM pedidos AS P
INNER JOIN clientes AS C
ON P.id_pedido = C.id_cliente
WHERE total = (
	SELECT MIN(total)
	FROM pedidos
);

--SELECCIONAR LOS PEDIDOS CON EL NOMBRE DEL CLIENTE 
--CUYO TOTAL (FREIGHT) SEA MAYOR AL PROMEDIO GENERAL 
--DE FREIGHT

/*SELECT * FROM Orders;

SELECT AVG(Freight)
FROM Orders;

SELECT O.OrderID, C.CompanyName, O.Freight
FROM Orders AS O
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
WHERE O.Freight > (
	SELECT AVG(Freight)
	FROM Orders
)
ORDER BY O.Freight DESC;

SELECT O.OrderID, C.CompanyName, O.Freight
FROM Orders AS O
INNER JOIN Customers AS C
ON o.CustomerID = C.CustomerID
WHERE O.FREIGHT > 78.2442;

USE NORTHWND;

-- SUBQUERIES CON IN, ANY, ALL (LLEVAN UNA SOLA COLUMNA)
-- LA CLAUSILA IN

--CLIENTES QUE HAN HECHO PEDIDOS
SELECT id_clientes
FROM pedidos;

SELECT *
FROM clientes
WHERE id_cliente IN (
	SELECT id_cliente
	FROM pedidos
);

SELECT DISTINCT c.id_cliente, c.nombre, c.ciudad
FROM clientes AS C
INNER JOIN pedidos AS P
ON C.id_cliente = p.id_cliente;*/


 --CLIENTES QUE HAN HECHO PEDIDOS MAYORES A 800
 
 --subconsulta

 SELECT id_cliente
 FROM pedidos
 WHERE total > 800;

 --Principal

 SELECT *
 FROM pedidos
 WHERE id_cliente IN (
	 SELECT id_cliente
	FROM pedidos
	 WHERE total > 800
 );

 --MOSTRAR TODOS LOS CLIENTES DE LA CIUDAD DE MEXICO QUE HAN HECHO PEDIDOS

 SELECT id_cliente
 FROM pedidos;
 
 SELECT *
 FROM clientes
 WHERE ciudad = 'CDMX'
 AND id_cliente IN (
	 SELECT id_cliente
     FROM pedidos
 );

--SELECCIONAR CLIENTES QUE NO HAN HECHO PEDIDOS 

SELECT *
FROM pedidos AS P
INNER JOIN clientes AS C
ON P.id_cliente = C.id_cliente;

--BUENA 
SELECT C.id_cliente, C.nombre, C.ciudad
FROM pedidos AS P
RIGHT JOIN clientes AS C
ON P.id_cliente = C.id_cliente
WHERE P.id_cliente IS NULL;

--SELECCIONAR LOS PEDIDOS DE CLIENTES DE MONTEREY 
SELECT id_cliente
FROM clientes
WHERE ciudad = 'Monterrey'
;
SELECT * 
FROM pedidos
WHERE id_cliente IN (
	SELECT id_cliente
	FROM clientes
	WHERE ciudad = 'Monterrey'
);
 
 SELECT *
 FROM clientes
 WHERE ciudad = 'Monterrey'
 AND id_cliente IN (
	 SELECT id_cliente
     FROM pedidos
 );

 --OPERADOR ANY
 
-- SELECCIONAR PEDIDOS MAYORES QUE ALG�N PEDIDO DE LUIS (id_cliente=2)

SELECT total
FROM pedidos
WHERE id_cliente = 2;

-- consulta principal 

SELECT *
FROM pedidos
WHERE total > ANY (
	SELECT total
	FROM pedidos
	WHERE id_cliente = 2
);

-- SELECCIONAR LOS PEDIDPS MAYORES (DEL TOTAL) DE ALGUN PEDIDO DE ANA

SELECT total
FROM pedidos
WHERE id_cliente = 1;

-- consulta principal 
SELECT *
FROM pedidos
WHERE total > ANY (
	SELECT total
	FROM pedidos
	WHERE id_cliente = 1
);

-- SELECCIONAR LOS PEDIDOS MAYORES QUE ALGUN PEDIDO SUPERIOR (total) A 500
--------------------------------------------
SELECT total
FROM pedidos
WHERE total > 500;

SELECT *
FROM pedidos
WHERE total > ANY (
	SELECT total
	FROM pedidos
	WHERE total > 500
); 
--------------------------------------------
SELECT total
FROM pedidos
WHERE total > 500;

-- consulta principal 
SELECT *
FROM pedidos
WHERE total > ANY (
	SELECT id_cliente
	FROM pedidos
	WHERE total > 500
);

SELECT *
FROM pedidos
WHERE id_cliente > ANY (
	SELECT id_cliente
	FROM pedidos
	WHERE total > 500
);

--ALL

-- SELECCIONAFR LOS PEDIDOS DONDE EL TOTAL SEA MAYOR A TODOS LOS TOTALES DE LOS PEDIDOS DE LUIS

SELECT total
FROM pedidos
WHERE id_cliente=2;

SELECT total
FROM pedidos;

SELECT *
FROM pedidos
WHERE total > ALL (
	SELECT total
	FROM pedidos
	WHERE id_cliente=2
);

-- SELECCIONAR TODOS LOS CLIENTES EN DONDE SU ID SEA MENOR QUE TODOS LOS CLIENTES DE LA CDMX

SELECT id_cliente
FROM clientes
WHERE ciudad = 'CDMX';

SELECT *
FROM clientes
WHERE id_cliente < ALL (
	SELECT id_cliente
	FROM clientes
	WHERE ciudad = 'CDMX'
);

-- Seleccionar los clientes cuyo total de comprar sea mayor a 1000
-- Subconsulta correlacionada

SELECT SUM(total)
FROM pedidos AS p
;

SELECT *
FROM clientes AS c
WHERE (
	SELECT SUM(total)
	FROM pedidos AS p
	WHERE p.id_cliente = c.id_cliente
) > 1000;

SELECT SUM(total)
	FROM pedidos AS p
	WHERE p.id_cliente = 2

-- SELECCIONAR TODOS LOS CLIENTES QUE HAN HECHO MAS DE UN PEDIDO 

SELECT COUNT(*)
FROM pedidos AS p
WHERE id_cliente = 2;

SELECT id_cliente, nombre, ciudad
FROM clientes AS c
WHERE (
	SELECT COUNT(*)
	FROM pedidos AS p
	WHERE p.id_cliente = c.id_cliente
) > 1;

SELECT SUM(total)
	FROM pedidos AS p
	WHERE p.id_cliente = 2


-- SELECCIONAR TODOS LOS PEDIDOS EN DONDE SU TOTAL 
-- DEBE SER MAYOR AL PROMEDIO DE LOS TOTALES HECHOS POR LOS CLIENTES

SELECT AVG(total)
FROM pedidos AS pe;

SELECT *
FROM pedidos AS p
WHERE total > (
	SELECT AVG(total)
	FROM pedidos AS pe
	WHERE pe.id_cliente = p.id_cliente
);


-- SELECCIONAR TODOS LOS CLIENTES CUYO PEDIDO MAX SEA MAYOR A 1200

SELECT MAX(total)
	FROM pedidos AS p

SELECT id_cliente, nombre, ciudad
FROM clientes AS c
WHERE (
	SELECT MAX(total)
	FROM pedidos AS p
	WHERE p.id_cliente = c.id_cliente
) > 1200;


SELECT *
FROM clientes;

SELECT *
FROM pedidos;





