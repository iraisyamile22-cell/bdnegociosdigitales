/*
	FUNCIONES DE AGREGADO SON 

	1.SUM()
	2.MAX()
	3.MIN()
	4.AVG()
	5.COUNT(*)
	6.COUNT(CAMPO)

	NOTA. estas funciones solamentes regresan un oslo registro
*/
USE NORTHWND

--SELECCIONAR LOS PAISES DE DONDE SON LOS CLIENTES

SELECT DISTINCT 

--Agregacion count(*) cuenta el numero de registros que tiene una tabla

SELECT COUNT(*) AS [TOTAL DE ORDENES]
FROM Orders;

--SELECCIONAR EL TOTAL DE ORDENES QUE FUERON ENVIADAS A ALEMANIA 
SELECT * FROM Orders;

SELECT COUNT(*) AS [ORDENES QUE FUERON ENVIADAS A ALEMANIA ]
FROM Orders
WHERE ShipCountry = 'GERMANY';

SELECT shipcountry, COUNT(*) AS [TOTAL DE ORDENES]
FROM Orders
GROUP BY ShipCountry;

SELECT * 
FROM Customers;


SELECT COUNT (CustomerID)
FROM Customers;

SELECT COUNT (Region)
FROM Customers;

--Selecciona de cuantas ciudades son las ciudades de los clientes

SELECT city
FROM Customers
ORDER BY City ASC;

SELECT DISTINCT city
FROM Customers
ORDER BY City ASC;

SELECT COUNT (DISTINCT city) AS [CIUDADES CLIENTES]
FROM Customers;

--SELECCIONA EL PRECIO MAXINO DE LOS PRODUCTOS 

SELECT *
FROM Products
ORDER BY UnitPrice DESC;

SELECT MAX(UnitPrice) AS [PRECIO MAS ALTO]
FROM Products;

--SELECCIONAR LA FECHA DE COMPRA MAS ACTUAL 

SELECT *
FROM Orders;

SELECT MAX(OrderDate) AS [ULTIMA FECHA DE COMPRA]
FROM Orders;


--SELECCIONAR EL A�O DEL LA FECHA DE COMPRA MAS RECIENTE 

SELECT *
FROM Orders;

SELECT MAX(YEAR(OrderDate)) AS [ULTIMA FECHA DE COMPRA]
FROM Orders;

SELECT MAX(DATEPART(YEAR, OrderDate))
FROM Orders;

SELECT DATEPART(YEAR, MAX(OrderDate)) AS [A�O]
FROM Orders;

--CUAL ES LA MINIMA CANTIDAD DE LOS PEDIDOS 

SELECT *
FROM [Order Details];

SELECT MIN(UnitPrice) AS [MINIMA CANTIDAD DE LOS PEDIDOS ]
FROM [Order Details]; 

--cual es el importe mas bajo de las compras 

SELECT *
FROM [Order Details]; 

SELECT (UnitPrice * Quantity * (1-Discount)) AS [IMPORTE]
FROM [Order Details]
ORDER BY [IMPORTE] ASC; 

SELECT 
	MIN(UnitPrice * Quantity * (1-Discount)) AS [IMPORTE]
FROM [Order Details];

--total de los precios de los productos 

SELECT SUM(UnitPrice) AS TOTAL 
FROM [Products]

--Obtener el total de dinero percibido por las ventas 

SELECT 
	SUM(UnitPrice * Quantity * (1-Discount)) AS [IMPORTE]
FROM [Order Details];

--Seleccionar las ventas totales de los productos 
--4, 10 y 20

SELECT *
FROM [Order Details];

SELECT 
    SUM(UnitPrice * Quantity * (1-Discount)) AS [IMPORTE]
FROM [Order Details]
WHERE ProductID IN (4, 10, 20);

--SELECCIONAR EL NUMERO DE ORDENES HECHAS POR LOS SIGUIENTES CLIENTES 
--AROUND THE HORN, BOLIDO COMIDAS PREPARADAS, CHOP-SUEY CHINESE

SELECT * 
FROM Customers;

SELECT 
    C.CompanyName, 
    COUNT(O.OrderID) AS [Numero de Ordenes]
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE C.CompanyName IN ('Around the Horn', 'B�lido Comidas Preparadas', 'Chop-suey Chinese')
GROUP BY C.CompanyName;


--SELECCIONAR EL NUMERO DE ORDENES ENTRE 1996 A 1997

SELECT COUNT(*) AS [Total Ordenes 96-97]
FROM Orders
WHERE YEAR(OrderDate) BETWEEN 1996 AND 1997;

SELECT COUNT(*) AS [NUMERO DE ORDENES]
FROM Orders
WHERE DATEPART(YEAR, OrderDate) BETWEEN 1996 AND 1997;

--SELECCIONAR EK NUMERO DE CLIENTES QUE COMIENZAN CON A O QUE COMIENZAN CON B 

SELECT COUNT(*) AS [Clientes A o B]
FROM Customers
WHERE CompanyName LIKE 'A%' OR CompanyName LIKE 'B%';



--SELECCIONAR EL NUMERO DE ORDENES REALIZADAS POR EL CLIENTE CHOP-SUEY CHINESE EN 1996

SELECT COUNT(O.OrderID) AS [Ordenes Chop-suey 1996]
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE C.CompanyName = 'Chop-suey Chinese' 
  AND YEAR(O.OrderDate) = 1996;

SELECT COUNT(*) as [NUMERO DE ORDENES],
FROM Orders
WHERE CustomerID = 'chops'
and YEAR(OrderDate) = 1996;

--SELECCIONAR EK NUMERO DE CLIENTES QUE COMIENZAN CON B O QUE TERMINEN CON S 

SELECT COUNT(*) AS [Clientes A o B]
FROM Customers
WHERE CompanyName LIKE 'B%S';

/*
	GROUO BY Y HAVING
*/

SELECT 
	CustomerID, 
	COUNT(*) AS [NUMERO DE ORDENES]
FROM orders
GROUP BY CustomerID
ORDER BY 2 DESC;

SELECT 
	C.CompanyName,
	COUNT(*) AS [NUMERO DE ORDENES]
FROM orders AS O
INNER JOIN
Customers AS C
ON o.CustomerID = c.CustomerID
GROUP BY C.CompanyName
ORDER BY 2 DESC;

---------------------------------------------------------------------------------------------------------
--SELECCIONAR EL NUMERO DE PRODUCTOS (CONTEO) POR CATEGORIA, 
-- MOSTRAR CATEGORIAID, TOTAL DE LOS PRODUCTOS
--ORDENAS DE MAYOR A MENOR DEL TOTAL DE PRODUCTOS
 
SELECT *
FROM Products;

SELECT 
	CategoryID,
	COUNT (ProductID) AS [TOTAL DE PRODUCTOS]
FROM Products
GROUP BY CategoryID
ORDER BY [TOTAL DE PRODUCTOS] DESC;

--SELECCIONAR EL PRECIO PROMEDIO POR PROVEEDOR DE LOS PRODUCTOS
--REDONDEAR A DOS DECIMALES EL RESULTADO
--ORDENAS DE FORMA DESCENDENTE POR EL PRECIO PROMEDIO 

SELECT *
FROM Products;

SELECT 
    SupplierID, 
    ROUND(AVG(UnitPrice), 2) AS [Precio Promedio]
FROM Products
GROUP BY SupplierID
ORDER BY [Precio Promedio] DESC;

SELECT 
    SupplierID, 
   		(AVG(UnitPrice), 2) AS [Precio Promedio]
FROM Products
GROUP BY SupplierID
ORDER BY [Precio Promedio] DESC;

--SELECCIONAR EL NUMERO DE CLIENTES POR PAIS 
--ORDENARLOS POR PAIS ALFABETICAMENTE 

SELECT *
FROM Suppliers;

--OBTENER LA CANTIDAD TOTAL VENDIDA AGRUPADA
--POR PRODUCTO Y PEDIDO 

SELECT *
FROM [Order Details];

SELECT SUM(UnitPrice * Quantity) AS [TOTAL] --SUM suma toda la tabla
FROM [Order Details];

SELECT ProductID, OrderID,SUM(UnitPrice * Quantity) AS [TOTAL]--SUM suma toda la tabla	
FROM [Order Details]
GROUP BY ProductID, OrderID
ORDER BY ProductID, [Total] DESC;

SELECT * , (UnitPrice * Quantity) AS [TOTAL]
FROM [Order Details]
WHERE OrderID = 10847
AND ProductID = 1;

--SELECCIONAR LA CANTIDAD MAXIMA VENDIDA POR PRUDCTO EN CADA PEDIDO 

SELECT *
FROM [Order Details];

SELECT 
    ProductID, OrderID,
    MAX(Quantity) AS [Cantidad Maxima]
FROM [Order Details]
GROUP BY ProductID,OrderID
ORDER BY [Cantidad Maxima] DESC;

/*
	WHERE=
	FILTRA FILAS 
*/

--Seleccionar el numero de productos vendidos en mas de 20 pedidos distintos
--mostrar el id del producto
--el nombre del producto
--y el numero de ordenes

SELECT p.ProductID, 
       p.ProductName, 
       COUNT (DISTINCT o.OrderID) AS [Numero de PEDIDOS]
FROM Products as p
inner join  [Order Details] as od
ON p.ProductID = od.ProductID
inner join Orders as o
on o.OrderID = od.OrderID
GROUP BY p.ProductID, 
       p.ProductName
HAVING COUNT (DISTINCT o.OrderID)>20;

--PASO1 Seleccionar los productos no descontinuados, 
--2 calcular el precio promedio vendido,
--3 y mostrar solo aquellos que se hayan vendido en menosde 15 pedidos

--1 
SELECT*
FROM Products as p
WHERE p.Discontinued =0

--2
SELECT p.ProductName, ROUND (avg (od.UnitPrice),2) as [Precio promedio]
FROM Products as p
INNER JOIN [Order Details]AS od ON p.ProductID=od.ProductID
WHERE p.Discontinued =0
GROUP BY p.ProductName
HAVING COUNT (OrderID) < 15;


--Seleccionar el precio maximo de productos por
--categoria, pero solo si la suma de unidades es menor a 200
--y ademas que no esten descontinuados
SELECT c.CategoryID, c.CategoryName, p.ProductName,
       MAX (p.UnitPrice) as [Precio Maximo]
FROM Products as p
INNER JOIN Categories AS c
ON p.CategoryID=c.CategoryId
WHERE p.Discontinued =0
GROUP BY c.CategoryID,
c.CategoryName,
p.ProductName
HAVING SUM(p.UnitsInStock) < 200
ORDER BY CategoryName, p.ProductName DESC;
