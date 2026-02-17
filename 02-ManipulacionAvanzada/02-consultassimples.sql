
--Consultas simples con SQL_MD
SELECT * 
FROM Categories;

SELECT * 
FROM Products;

SELECT * 
FROM Orders;

SELECT * 
FROM [Order Details];

--Proyección (seleccionar algunos campos)

SELECT * 
FROM Products;

SELECT ProductID,
	ProductName,
	UnitPrice,
	UnitsInStock
FROM Products;

--Alias de columnas

SELECT 
	ProductID AS [NUMERO DEL PRODUCTOS],
	ProductName 'NOMBRE DEL PRODUCTO',
	UnitPrice AS [PRECIO UNITARIO],
	UnitsInStock AS STOCK
FROM Products;

SELECT 
	CompanyName AS CLIENTES,
	City AS CIUDAD,
	Country AS PAÍS
FROM Customers;

--Campos Calculados 

--Seleccionar los productos y calcular el valor del inventario.

SELECT *, (UnitPrice * UnitsInStock) AS [Costo Inventario]
FROM Products;

SELECT 
	ProductID, 
	ProductName, 
	UnitPrice, 
	UnitsInStock, 
	(UnitPrice * UnitsInStock) AS [COSTO INVENTARIO]
FROM Products;

SELECT 
	*
FROM [Order Details];

SELECT 
	OrderId,
	ProductID,
	UnitPrice,
	Quantity,
	(UnitPrice * Quantity) AS SUBTOTAL
FROM [Order Details];

--Seleccionar la venta con el calculo del importe con descuento

USE NORTHWND;


SELECT 
    OrderId,
    ProductID,
    UnitPrice,
    Quantity,
    (UnitPrice * Quantity * 0.85) AS [IMPORTE CON DESCUENTO]
FROM [Order Details];

SELECT
	OrderID,
	UnitPrice,
	Quantity,
	Discount,
	(UnitPrice * Quantity) AS IMPORTE,
	(UnitPrice * Quantity) - ((UnitPrice * Quantity) * Discount)
	AS [Importe con Descunto 1],
	(UnitPrice * Quantity) * (1- Discount)
	AS [Importe con Descunto 2]
FROM [Order Details];

--Operadores Relacionales (<, >, <=, >=,  =, != ó <>)

/*
Seleccionar todos los productos con precio mayor a 30
Seleccionar los productos con stick menos o igual a 20
Sleccionar los pedidos posteriores a 1997
*/

SELECT 
	ProductID AS [Numero del producto], --[] Alias de columna
	ProductName AS [Nombre del Producto],
	UnitPrice AS [Precio Unitario],
	UnitsInStock AS [Stock]
FROM Products
WHERE UnitPrice>30
ORDER BY UnitPrice DESC;

SELECT 
	ProductID AS [Numero del producto], --[] Alias de columna
	ProductName AS [Nombre del Producto],
	UnitPrice AS [Precio Unitario],
	UnitsInStock AS [Stock]
FROM Products
WHERE UnitsInStock <=20;

--Sleccionar los pedidos posteriores a 1997
SELECT *
FROM Orders;

SELECT 
	OrderID, OrderDate, CustomerID, ShipCountry,
	YEAR(OrderDate) AS Año,
	MONTH(OrderDate) AS Mes,
	DAY(OrderDate) AS Día, 
	DATEPART(YEAR, OrderDate) AS Año2,
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate) AS [Día semana],
	DATENAME(WEEKDAY, OrderDate) AS [Día semana Nombre]
FROM Orders
WHERE YEAR(OrderDate) > 1997;

SET LANGUAGE SPANISH;
SELECT 
	OrderID, OrderDate, CustomerID, ShipCountry,
	YEAR(OrderDate) AS Año,
	MONTH(OrderDate) AS Mes,
	DAY(OrderDate) AS Día, 
	DATEPART(YEAR, OrderDate) AS Año2,
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate) AS [Día semana],
	DATENAME(WEEKDAY, OrderDate) AS [Día semana Nombre]
FROM Orders
WHERE DATEPART(YEAR, OrderDate) > 1997;

--OPERADORES LÓGICOS (NOT,AND, OR)
/*
	SELECCIONAR LOS PRODUCTOS QUE TENGAN UN PRECIO MAYOR A 20 Y MENOS DE 100 UNIDADES EN STOCK

	MOSTRAR LOS CLIENTES QUE SEAN DE ESTADOS UNIDOS O CANADA

	OBTENER LOS PEDIDOS QUE NO TENGAN REGION

*/

SELECT 
	ProductName AS [Producto],
	UnitPrice AS [Precio Unitario],
	UnitsInStock AS [Stock]
FROM Products
WHERE UnitPrice >20 AND UnitsInStock <100;


SELECT 
	CustomerID,
	CompanyName,
	City,
	Country
FROM Customers
WHERE Country = 'USA' OR Country = 'Canada';

SELECT 
	CustomerID,
	OrderDate,
	ShipRegion
FROM Orders
WHERE ShipRegion IS NULL;

SELECT 
	CustomerID,
	OrderDate,
	ShipRegion
FROM Orders
WHERE ShipRegion IS NOT NULL;

--OPERADOR IN 
 
 /*
 Mostrar los clientes de Alemania, Francia y UK
 OBTEBER LOS PRODUCTOS EN DONDE LA CATEGORIA SEA 1,3 O 5
 */

	SELECT *
	FROM Customers
	WHERE Country IN ('Germany', 'France', 'uk')
	ORDER BY country DESC;

	SELECT *
	FROM Customers
	WHERE Country = 'Germany' OR
	 Country = 'France' OR
	  Country = 'uk';


	SELECT *
	FROM Products
	WHERE CategoryID IN (1,3,5);

 --OPERADOR BETWEEN
  /*
MOSTRAR LOD PRODUCTOS CUYO PRECIOESTA ENTRE 20 Y 40
 */

 SELECT * FROM Products
 WHERE UnitPrice>= 20 AND UnitPrice <=40
 ORDER BY UnitPrice;

 --OPERADOR LIKE

 SELECT CustomerID, CompanyName, City, Region, Country
FROM Customers
WHERE CompanyName LIKE 'a%';

SELECT CustomerID, CompanyName, City, Region, Country
FROM Customers
WHERE CompanyName LIKE 'an%';

SELECT CustomerID, CompanyName, City, Region, Country
FROM Customers
WHERE City LIKE 'L_nd_n';

SELECT CustomerID, CompanyName, City, Region, Country
FROM Customers
WHERE CompanyName LIKE '%as';

--Seleccionar los clientes en donde la ciudad contenga la letra L

SELECT CustomerID, CompanyName, City, Region, Country
FROM Customers
WHERE City LIKE '%Mé%';


--Seleccionar en dinde todos los clientes que en su nombre comiencen con a o b

SELECT CustomerID, CompanyName, City, Region, Country
FROM Customers
WHERE NOT CompanyName LIKE 'a%' or CompanyName LIKE 'b%';

--SELECCIONAR TODOS LOS CLIENTES QUE COMIENCE CON B Y TERMINE CON S

SELECT CustomerID, CompanyName, City, Region, Country
FROM Customers
WHERE CompanyName LIKE 'b%s';

SELECT CustomerID, 
CompanyName, 
City, 
Region, 
Country
FROM Customers
WHERE CompanyName LIKE 'a__%';

--SELECCIONAR LOS CLIENTES (NOMBRE) QUE COMIENCEN CON B,S,O P

SELECT CustomerID, 
CompanyName, 
City, 
Region, 
Country
FROM Customers
WHERE CompanyName LIKE '[BSP]%';

--SELECCIONAR TODOS LOS COSTUER COMIENCENN CON A, B,C,D,E,F

SELECT CustomerID, 
CompanyName, 
City, 
Region, 
Country
FROM Customers
WHERE CompanyName LIKE '[^A-F]%'
ORDER BY 2 ASC;

--
SELECT CustomerID, 
CompanyName, 
City, 
Region, 
Country
FROM Customers
WHERE CompanyName LIKE '[^bsp]%';

--SELECCIONAR TODOS LOS CLIENTES DE ESTADOS UNIDOS O CANDA QUE INICIEN CON B

SELECT * FROM Customers;

SELECT CustomerID, 
CompanyName, 
City, 
Region, 
Country
FROM Customers
WHERE CompanyName LIKE 'b%' and 
(Country LIKE 'USA' OR Country LIKE 'CANADA');














