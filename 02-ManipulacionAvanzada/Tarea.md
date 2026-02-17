# 01-sql-ldd.sql

## 1. Crear Base de Datos
```sql 
CREATE DATABASE tienda;
GO

```


CREATE DATABASE: crea una nueva base de datos.

GO: ejecuta el bloque de instrucciones.

```sql 
USE tienda;
```
Selecciona la base de datos donde se trabajará.

Tabla: cliente
-- 
```sql 
CREATE TABLE cliente (
    id int not null,
    nombre nvarchar(30) not null,
    apaterno nvarchar(10) not null,
    amaterno nvarchar(10) null,
    sexo nchar(1) not null,
    edad int not null,
    direccion nvarchar(80) not null,
    rfc nvarchar(20) not null,
    limitecredito money not null default 500.0
);

```
int → números enteros.

nvarchar → texto.

not null → obligatorio.

null → opcional.

money → valores monetarios.

default 500.0 → si no se inserta valor, asigna 500.

Tabla: clientes (con restricciones)
--
```sql 
CREATE TABLE clientes(
   cliente_id INT NOT NULL PRIMARY KEY,
   nombre nvarchar(30) NOT NULL,
   apellido_paterno nvarchar(20) NOT NULL,
   apellido_materno nvarchar (20),
   edad INT NOT NULL,
   fecha_nacimiento DATE NOT NULL,
   limite_credito MONEY NOT NULL
);

```
PRIMARY KEY → clave primaria (única y no repetida).

DATE → tipo fecha.

INSERT (Insertar datos)
--
```sql 
INSERT INTO clientes
VALUES (1, 'GOKU', 'LINTERNA', 'SUPERMAN', 450, '1578-01-17', 100);

```
Inserta un registro completo respetando el orden de columnas.

Error ejemplo (clave duplicada)
--
```sql 
INSERT INTO clientes
VALUES (2, 'PANCRACIO', 'RIVERO', 'PATROCLO', 20, '2005-01-17', 10000);

```
Insert especificando columnas
--
```sql 
INSERT INTO clientes
(nombre, cliente_id, limite_credito, fecha_nacimiento, apellido_paterno, edad)
VALUES ('Arcadia', 3, 45800, '2000-01-22', 'Ramirez', 26);

```
Sirve para insertar datos en diferente orden.

SELECT (Consultas)
--
```sql 
SELECT * FROM clientes;

```
Muestra todos los registros.

```sql 
SELECT cliente_id, nombre, edad, limite_credito
FROM clientes;

```
Muestra solo columnas específicas.

```sql 
SELECT GETDATE();

```

Devuelve fecha y hora actual del sistema.

Tabla con IDENTITY
--
```sql 
CREATE TABLE clientes_2(
  cliente_id int not null identity(1,1),
  nombre nvarchar(50) not null,
  edad int not null,
  fecha_registro date default GETDATE(),
  limite_credito money not null,
  CONSTRAINT pk_clientes_2
  PRIMARY KEY (cliente_id)
);

```
IDENTITY(1,1) → autoincrementable.

default GETDATE() → asigna fecha automática.

CONSTRAINT → nombre personalizado de la restricción.

Tabla suppliers (con restricciones avanzadas)
--
```sql 
CREATE TABLE suppliers (
    supplier_id INT NOT NULL IDENTITY (1,1),
    [name] NVARCHAR(30) NOT NULL,
    date_rigistre DATE NOT NULL DEFAULT GETDATE(),
    tipo CHAR(1) NOT NULL,
    credit_limit MONEY NOT NULL,
    CONSTRAINT pk_suppliers PRIMARY KEY (supplier_id),
    CONSTRAINT unique_name UNIQUE ([name]),
    CONSTRAINT chk_credit_limit CHECK (credit_limit >0.0 AND credit_limit <= 50000),
    CONSTRAINT chk_tipo CHECK (tipo IN ('A', 'B', 'C'))
);

```

UNIQUE → no permite nombres repetidos.

CHECK → valida condiciones.

IN ('A','B','C') → solo acepta esos valores.

[name] → se usan corchetes porque es palabra reservada.

Crear Base de Datos dborders
--

``` sql
CREATE DATABASE dborders;
USE dborders;
```

Tabla customers
--
``` sql
CREATE TABLE customers (
    customer_id INT NOT NULL IDENTITY(1,1),
    first_name NVARCHAR (50) NOT NULL,
    last_name NVARCHAR (30),
    [address] NVARCHAR (80) NOT NULL,
    number INT,
    CONSTRAINT pk_customer PRIMARY KEY (customer_id)
);
``` 
Tabla products con FOREIGN KEY
--

```sql
CREATE TABLE products(
    product_id INT NOT NULL IDENTITY(1,1),
    [name] NVARCHAR (40) NOT NULL,
    quantity INT NOT NULL,
    unit_price MONEY NOT NULL,
    supplier_id INT,
    CONSTRAINT pk_products PRIMARY KEY (product_id),
    CONSTRAINT unique_name_products UNIQUE ([name]),
    CONSTRAINT chk_quantity CHECK (quantity BETWEEN 1 AND 100),
    CONSTRAINT chk_unit_price CHECK (unit_price > 0 AND unit_price <= 100000), 
    CONSTRAINT fk_products_suppliers
    FOREIGN KEY (supplier_id)
    REFERENCES suppliers (supplier_id)
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION
);
```

FOREIGN KEY
¿Qué hace?

Relaciona productos con proveedores.

ON DELETE NO ACTION

No permite borrar el proveedor si tiene productos asociados.

ON UPDATE NO ACTION

No permite modificar el ID si está relacionado.

ALTER TABLE
--
``` sql
ALTER TABLE products
DROP CONSTRAINT fk_products_suppliers;
``` 

Elimina la llave foránea.

```sql 
ALTER TABLE products
ALTER COLUMN supplier_id INT NULL;
```

Permite valores NULL en la columna.

DELETE
--
```sql 
DELETE FROM products WHERE supplier_id = 1;
DELETE FROM suppliers WHERE supplier_id = 1;
```
Primero se eliminan los hijos, luego el padre.

ON DELETE SET NULL
--

```sql 
FOREIGN KEY (supplier_id)
REFERENCES suppliers (supplier_id)
ON DELETE SET NULL
ON UPDATE SET NULL
```

¿Qué hace?

Si se elimina el proveedor → el **supplier_id** del producto se vuelve NULL.

Si se actualiza el ID del proveedor → también se vuelve NULL en productos.

# 02-consultassimples.sql

## Consultas Básicas en SQL – Base de Datos NORTHWND

Consultas Simples
--
```sql
SELECT * FROM Categories;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM [Order Details];
```
SELECT → Sirve para consultar información.

-*- → Significa “todas las columnas”.

FROM → Indica la tabla de donde se obtienen los datos.

Muestra todos los registros y todas las columnas de la tabla.

Proyección (Seleccionar Campos Específicos)
--
```sql
SELECT ProductID, ProductName, UnitPrice, UnitsInStock
FROM Products;
```
Permite seleccionar solo ciertas columnas en lugar de todas.

Alias de Columnas
--
```sql
SELECT 
	ProductID AS [NUMERO DEL PRODUCTOS],
	ProductName AS [NOMBRE DEL PRODUCTO],
	UnitPrice AS [PRECIO UNITARIO],
	UnitsInStock AS STOCK
FROM Products;
```
AS → Cambia el nombre de la columna en el resultado.

[ ] → Permite usar espacios en el nombre del alias.

Se usa para hacer los resultados más claros o personalizados.

Campos Calculados
--
### Calcular valor del inventario
```sql
SELECT 
	ProductID, 
	ProductName, 
	UnitPrice, 
	UnitsInStock, 
	(UnitPrice * UnitsInStock) AS [COSTO INVENTARIO]
FROM Products;
```
Permite hacer operaciones matemáticas dentro del SELECT.

### Calcular subtotal en pedidos

```sql
SELECT 
	OrderId,
	ProductID,
	UnitPrice,
	Quantity,
	(UnitPrice * Quantity) AS SUBTOTAL
FROM [Order Details];

```
Calcula el total por producto vendido.

### Calcular importe con descuento

```sql
SELECT
	OrderID,
	UnitPrice,
	Quantity,
	Discount,
	(UnitPrice * Quantity) AS IMPORTE,
	(UnitPrice * Quantity) * (1- Discount)
	AS [Importe con Descuento]
FROM [Order Details];

```
Operadores Relacionales
--

| Operador | Significado |
| :--- | :---: |
|> | Mayor que |
| < | Menor que|
|>=|Mayor o igual|
|<=|Menor o igual|
|=|Igual|
|<> o !=|Diferente|

### Ejemplo
```sql
    SELECT *
    FROM Products
    WHERE UnitPrice > 30;

```
**WHERE** sirve para filtrar datos.

ORDER BY
--
```sql
    ORDER BY UnitPrice DESC;

``` 
ORDER BY → Ordena los resultados.

DESC → Descendente.

ASC → Ascendente (por defecto).

Funciones de Fecha
--
```sql
    YEAR(OrderDate)
    MONTH(OrderDate)
    DAY(OrderDate)
    DATEPART(QUARTER, OrderDate)
    DATENAME(WEEKDAY, OrderDate)
```
Permiten extraer partes específicas de una fecha.

### Ejemplo
```sql
    WHERE YEAR(OrderDate) > 1997;
```
Muestra pedidos posteriores a 1997.

Operadores Lógicos
--
| Operador | Función |
| :--- | :---: |
| AND| Ambas condiciones deben cumplirse |
| OR| Se cumple al menos una|
|NOT|Niega la condición|

### Ejemplo
```sql
    WHERE UnitPrice > 20 AND UnitsInStock < 100;

```
Filtra productos que cumplen ambas condiciones.

IS NULL / IS NOT NULL
--
```sql
   WHERE ShipRegion IS NULL; 
```
Sirve para buscar valores vacíos (nulos).

Operador IN
--
```sql
    WHERE Country IN ('Germany', 'France', 'UK');
```
Es una forma más corta de usar varios **OR**.

Equivale a:
```sql
    WHERE Country = 'Germany'
    OR Country = 'France'
    OR Country = 'UK';  
```
Operador BETWEEN
--
```sql
    WHERE UnitPrice BETWEEN 20 AND 40;
```
Selecciona valores dentro de un rango.

Equivale a:
```sql
    WHERE UnitPrice >= 20 AND UnitPrice <= 40;
```
Operador LIKE
--
Se usa para buscar patrones de texto.

| Simbolo| Significado |
| :--- | :---: |
| % | Cualquier cantidad de caracteres |
| _| Un solo carácter|
|[ABC]|Cualquiera de esos caracteres|
|[^ABC`]|Excepto esos caracteres|

### Ejemplos

#### Empieza con A
```sql
    WHERE CompanyName LIKE 'A%';    
```
#### Termina con "as"
```sql
    WHERE CompanyName LIKE '%as';  
```
#### Contiene texto
```sql
    WHERE City LIKE '%Mé%'; 
```
#### Empieza con B, S o P
```sql
    WHERE CompanyName LIKE '[BSP]%';
```
#### No empieza con A-F
```sql
    WHERE CompanyName LIKE '[^A-F]%';
```
Uso de Paréntesis en Condiciones
--
```sql
    WHERE CompanyName LIKE 'b%' 
    AND (Country = 'USA' OR Country = 'CANADA');
```
Los paréntesis agrupan condiciones y controlan la prioridad lógica.

SET LANGUAGE
--
```sql
    SET LANGUAGE SPANISH;

```

Cambia el idioma del servidor para mostrar nombres de días y meses en español.

# 03-Funciones_aagregados.sql

## Funciones de Agregado y Consultas en SQL – Base de Datos NORTHWND

 Las funciones de agregado en SQL permiten realizar cálculos sobre un conjunto de registros y **devuelven un solo resultado**.

 ### Funciones principales:

1. `SUM()` → Suma valores numéricos.
2. `MAX()` → Devuelve el valor máximo.
3. `MIN()` → Devuelve el valor mínimo.
4. `AVG()` → Calcula el promedio.
5. `COUNT(*)` → Cuenta todos los registros.
6. `COUNT(campo)` → Cuenta los registros donde el campo NO es NULL.

###  Base de datos utilizada
```sql
USE NORTHWND
```
Selecciona la base de datos NORTHWND para trabajar sobre ella.

## COUNT() – Contar registros

### Contar todas las órdenes
```sql
SELECT COUNT(*) AS [TOTAL DE ORDENES]
FROM Orders;
```
Cuenta todas las filas de la tabla **Orders**.

### Contar órdenes enviadas a Alemania
```sql
SELECT COUNT(*) AS [ORDENES QUE FUERON ENVIADAS A ALEMANIA]
FROM Orders
WHERE ShipCountry = 'GERMANY';
```
Filtra primero con WHERE y luego cuenta solo esas filas.

### Contar órdenes agrupadas por país
```sql
SELECT ShipCountry, COUNT(*) AS [TOTAL DE ORDENES]
FROM Orders
GROUP BY ShipCountry;
```
**GROUP BY** agrupa por país y cuenta cuántas órdenes hay por cada uno.

### COUNT con campo específico
```sql
SELECT COUNT(CustomerID)
FROM Customers;
```
Cuenta los CustomerID (como no son NULL, cuenta todos).
```sql
SELECT COUNT(Region)
FROM Customers;
```
Cuenta solo los registros donde Region NO sea NULL.

## DISTINCT – Eliminar duplicados
### Mostrar ciudades sin repetir

```sql
SELECT DISTINCT City
FROM Customers
ORDER BY City ASC;
``` 
**DISTINCT** elimina valores repetidos.

### Contar ciudades diferentes
```sql
SELECT COUNT(DISTINCT City) AS [CIUDADES CLIENTES]
FROM Customers;
``` 
Cuenta cuántas ciudades distintas existen.

## MAX() – Valor máximo
### Precio mas alto
```sql
SELECT MAX(UnitPrice) AS [PRECIO MAS ALTO]
FROM Products;
``` 
Devuelve el precio más caro.

### Fecha más reciente
```sql
SELECT MAX(OrderDate) AS [ULTIMA FECHA DE COMPRA]
FROM Orders;
```
Devuelve la fecha más actual.

### Año más reciente
```sql
SELECT DATEPART(YEAR, MAX(OrderDate)) AS [AÑO]
FROM Orders;
```
Extrae el año de la fecha más reciente.

## MIN() – Valor mínimo
### Precio mínimo
```sql
SELECT MIN(UnitPrice) AS [MINIMA CANTIDAD]
FROM [Order Details];
```
Devuelve el precio más bajo.

## Importe más bajo
```sql
SELECT MIN(UnitPrice * Quantity * (1-Discount)) AS [IMPORTE]
FROM [Order Details];
```

Calcula el importe total de cada producto vendido y obtiene el más bajo.

## SUM() – Sumar valores
### Suma total de precios de productos
```sql
SELECT SUM(UnitPrice) AS TOTAL
FROM Products;
```

Suma todos los precios (no es dinero real vendido).

### Total de dinero percibido por ventas

```sql
    SELECT SUM(UnitPrice * Quantity * (1-Discount)) AS [IMPORTE]
    FROM [Order Details];
```
Calcula el dinero real generado considerando cantidad y descuento.

### Total vendido de productos específicos
```sql
    SELECT SUM(UnitPrice * Quantity * (1-Discount)) AS [IMPORTE]
    FROM [Order Details]
    WHERE ProductID IN (4, 10, 20);
```
Filtra productos específicos y suma sus ventas.

## INNER JOIN – Unir tablas
### Número de órdenes por cliente específico
```sql
    SELECT C.CompanyName,
       COUNT(O.OrderID) AS [Numero de Ordenes]
    FROM Customers C
    INNER JOIN Orders O
    ON C.CustomerID = O.CustomerID
    WHERE C.CompanyName IN ('Around the Horn', 'Bólido Comidas Preparadas', 'Chop-suey Chinese')
    GROUP BY C.CompanyName;
```
Une Customers con Orders para contar órdenes por cliente.

## Filtrar por año
```sql
    SELECT COUNT(*) AS [Total Ordenes 96-97]
    FROM Orders
    WHERE YEAR(OrderDate) BETWEEN 1996 AND 1997;
```
Cuenta órdenes entre esos años.
## LIKE – Buscar por patrón
### Clientes que comienzan con A o B
```sql
    SELECT COUNT(*) AS [Clientes A o B]
    FROM Customers
    WHERE CompanyName LIKE 'A%' 
   OR CompanyName LIKE 'B%';
```
**%** significa “cualquier texto después o antes”.
## GROUP BY – Agrupar datos
### Número de órdenes por cliente
```sql
    SELECT CustomerID,
       COUNT(*) AS [NUMERO DE ORDENES]
    FROM Orders
    GROUP BY CustomerID
    ORDER BY 2 DESC;
```
Agrupa por cliente y ordena de mayor a menor.
### Total de productos por categoría
```sql
    SELECT CategoryID,
       COUNT(ProductID) AS [TOTAL DE PRODUCTOS]
    FROM Products
    GROUP BY CategoryID
    ORDER BY [TOTAL DE PRODUCTOS] DESC;

```
Cuenta productos por categoría.
## AVG() – Promedio
### Precio promedio por proveedor
```sql
    SELECT SupplierID,
       ROUND(AVG(UnitPrice), 2) AS [Precio Promedio]
    FROM Products
    GROUP BY SupplierID
    ORDER BY [Precio Promedio] DESC;
```
Calcula el promedio y lo redondea a 2 decimales.

## Ventas agrupadas por producto y pedido
```sql
    SELECT ProductID,
       OrderID,
       SUM(UnitPrice * Quantity) AS [TOTAL]
    FROM [Order Details]
    GROUP BY ProductID, OrderID
    ORDER BY ProductID, [TOTAL] DESC;
```
Agrupa por producto y pedido para saber cuánto se vendió en cada uno.
## Cantidad máxima vendida por producto en cada pedido
```sql
    SELECT ProductID,
       OrderID,
       MAX(Quantity) AS [Cantidad Maxima]
    FROM [Order Details]
    GROUP BY ProductID, OrderID
    ORDER BY [Cantidad Maxima] DESC;
```
Devuelve la mayor cantidad vendida por producto en cada orden.
