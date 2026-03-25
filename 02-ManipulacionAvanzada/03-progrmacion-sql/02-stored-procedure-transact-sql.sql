/*============ Stored Prodedures==========*/
 
CREATE DATABASE bdstored;
GO
USE bdstored;
GO

 -- Ejemplo Simple

 CREATE PROCEDURE usp_mensaje_Saludar
 -- no tendra parametro
 AS
 BEGIN
    PRINT 'Hola mundo Transact SQL desde SQL SERVER'
 END;
 GO

 -- Ejecutar 
 Execute usp_mensaje_Saludar;
GO

 CREATE PROC usp_mensaje_Saludar2
 -- no tendra parametro
 AS
 BEGIN
    PRINT 'Hola mundo Ing en TI'
 END;
 GO

 EXEC usp_mensaje_Saludar2;
GO

CREATE OR ALTER PROC usp_mensaje_Saludar3
 -- no tendra parametro
 AS
 BEGIN
    PRINT 'Hola Mundo ENTORNOS VIRTUALES Y NEGOCIOS DIGITALES'
 END;
 GO

--ELIMITAR UN SP
DROP PROCEDURE  usp_mensaje_Saludar3;
GO

 EXEC usp_mensaje_Saludar3;
 GO

 -- Crear un  SP que muestre la fecha actual del sitema 

 CREATE OR ALTER PROC usp_Servidor_FechaActual

 AS
 BEGIN 
    SELECT CAST(GETDATE () AS DATE) [FECHA DEL SISTEMA]
 END;
 GO

 -- EJECUTAR

 EXEC  usp_Servidor_FechaActual;
 GO

 -- Crear un SP que muestre el nombre de la base de datos (BD_name())

 CREATE OR ALTER PROC usp_Dbname_get
AS
BEGIN

    SELECT 
    HOST_NAME() AS [MACHINE],
    SUSER_NAME() AS [SQLUSER],
    SYSTEM_USER AS [SYSTEM_USER],
    DB_NAME() AS [DATABASE NAME],
    APP_NAME() AS [APPLICATION];
END;
GO

--Ejecutar

EXEC usp_Dbname_get;
GO

/*============STORED PROCEDURES CON PARAMETROS=============*/

CREATE OR ALTER PROC usp_Persona_Saludar
    @nombre VARCHAR(50) -- Parametro de entrada
AS
BEGIN
    PRINT 'Hola ' + @nombre
END;
GO

EXECUTE usp_Persona_Saludar 'Israel';
EXECUTE usp_Persona_Saludar 'Artemio';
EXECUTE usp_Persona_Saludar 'Irais';
EXECUTE usp_Persona_Saludar @nombre = 'Israel';

DECLARE @name VARCHAR(50);
SET @name = 'Yael';

EXEC usp_Persona_Saludar @name
GO

--TODO: Ejemplo de consultas, vamos a crear una tabla de clientes basada en tabla de customers de Northwind*/

SELECT CustomerID, CompanyName
INTO customers 
FROM  NORTHWND.dbo.Customers;
GO

CREATE OR ALTER PROCEDURE spu_customer_buscar
@id NCHAR(10)
AS
 BEGIN
    IF LEN(@id)<= 0 OR LEN(@id)>=5
    BEGIN
        PRINT 'EL ID DEBE ESTAR EN EL RANFO DE 1 A 5 DE TAMAÑO'
        RETURN;
    END

    IF NOT EXISTS (SELECT * FROM customers WHERE CustomerID = @id)
    BEGIN
     SELECT CustomerID AS [NUMERO], CompanyName AS [CLIENTE]
    FROM customers
    WHERE CustomerID = @id
    END
    ELSE
        PRINT 'EL CLIENTE NO EXISTE EN LA BD'
    END
 GO

SELECT * 
FROM NORTHWND.dbo.Categories

WHERE NOT EXISTS(
   SELECT 1
   FROM customers
   WHERE CustomerID = 'AntonI');
   GO

CREATE OR ALTER PROC spu_Customer_buscar
@id NCHAR(10)
AS 
BEGIN
SET @id = TRIM(@id)
IF EXISTS (SELECT 1 FROM Customers WHERE CustomerID = 'ANTON')
    BEGIN   
    SELECT CustomerID AS [Numero], CompanyName AS [Cliente]
    FROM Customers
    WHERE CustomerID= @id;
    END
    ELSE
        PRINT 'El cliente no existe en la BD'
END;
GO

--ejecutar 
EXEC spu_Customer_buscar 'YUT TT'
GO

-- Ejercicios crear un SP que resiva un numero que verifique que no sea negativo,
-- si es negativo imprimir valor no valido, y si no multiplicarlo por 5 y mostrarlo 
-- para mostrarlo usar un select 

CREATE OR ALTER PROC usp_numero_multiplicar
@number INT 
AS 
BEGIN 
    IF @number <= 0
    BEGIN
        PRINT 'el numero no puede ser negativo'
        RETURN;
END

    SELECT (@number * 5) AS [OPERACION]
    END
GO

EXEC usp_numero_multiplicar -34
EXEC usp_numero_multiplicar 0
EXEC usp_numero_multiplicar 5
GO

--Ejercicio 2 crera un SP que resiva un nombre y lo imprima en mayuscula 
--
CREATE OR ALTER PROC 
@name VARCHAR(15)
AS
BEGIN 
SELECT UPPER(@name) AS [NAME]
END

EXEC usp_nombre_mayuscula 'Monico'
GO

/*==============================PARAMETRO DE SALIDA===================================0====*/

CREATE OR ALTER PROC spu_numero_sumar
    @a INT,
    @b INT,
    @resultado INT OUTPUT 
    AS
    BEGIN
        SET @resultado = @a + @b
    END;
GO

DECLARE @res INT
EXEC spu_numero_sumar 5,7,@res OUTPUT;
SELECT @res AS [RESULTADO]
GO


CREATE OR ALTER PROC spu_numero_sumar2
    @a INT,
    @b INT,
    @resultado INT OUTPUT 
    AS
    BEGIN
        SELECT  @resultado = @a + @b
    END;
GO

DECLARE @res INT
EXEC spu_numero_sumar2 5,7,@res OUTPUT;
SELECT @res AS [RESULTADO]
GO

--CREAR UN SP QUE DEVUELVA EL AREA DE UN CIRCULO 
CREATE OR ALTER PROC usp_aria_circulo
@radio DECIMAL (10,2),
@area DECIMAL (10,2) OUTPUT
AS
BEGIN 
    --SET @area= PI() * @radio * @radio
    SET @area= PI() *   POWER(@radio,2);
END;
GO

DECLARE @r DECIMAL(10,2)
EXECUTE usp_aria_circulo 2.4, @r OUTPUT;
SELECT @r AS [AREA DE CIRCULO]
GO
--CREAR UN SP QUE RECIBA IN IDCLIENTE Y QUE DEVUELVA EL NOMBRE

CREATE OR ALTER PROC spu_cliente_obtener 
    @id NCHAR(10),
    @name NVARCHAR(40)OUTPUT
AS
BEGIN
    IF LEN(@id) = 5
    BEGIN
        IF EXISTS (SELECT 1 FROM customers WHERE CustomerID = @id)
        BEGIN
            SELECT @name = CompanyName 
            FROM customers
            WHERE CustomerID = @id;
            RETURN
        END
        PRINT 'EL CUSTOMER NO EXISTE'
        RETURN;
    END

    PRINT 'EL ID DEBE SER TAMAÑO 5';
END;
GO

DECLARE @name NVARCHAR(40)
EXEC spu_cliente_obtener 'arout', @name OUTPUT
SELECT @name AS [NOMBRE DEL CLIENTE];
GO

/*========================================CASE======================================*/

CREATE OR ALTER PROC spu_Evaluar_calificacion
@calif INT 
AS
BEGIN 
    SELECT
        CASE
            WHEN @calif >=90 THEN 'EXELENT'
            WHEN @calif >=70 THEN 'APROBADO'
            WHEN @calif >=60 THEN 'REGULAR'
            ELSE 'NO ACREDITO'
        END AS [RESULTADO]
END;


EXEC spu_Evaluar_calificacion 100;
EXEC spu_Evaluar_calificacion 75;
EXEC spu_Evaluar_calificacion 55;
EXEC spu_Evaluar_calificacion 65;
GO

-- Case dentro de un select caso real 
USE NORTHWND;
GO

CREATE TABLE bdstored.dbo.Productos
(
    nombre VARCHAR(50),
    precio MONEY

);

-- Inserta los datos basados en la consuta (Select)
INSERT INTO bdstored.dbo.Productos
SELECT 
    ProductName, UnitPrice
    FROM NORTHWND.dbo.Products;
GO

SELECT * FROM bdstored.bdo.Productos;    
GO
-- ejercicio con case
SELECT 
    nombre, 
    precio,
    CASE
        WHEN precio >= 200 THEN 'CARO'
        WHEN precio >= 100 THEN 'MEDIO'
        ELSE 'BARATO'
        END AS [CATEGORIA]
FROM bdstored.dbo.Productos;       
GO

USE NORTHWND;
-- SELECCIONAR LOS CLIENTES, CON SU NOMBRE, PAIS, CIUDAD Y REGION (LOS VALORES NULOS VISUALIZALOS CON LA LEYENDA SIN REGION), ADEMAS QUIERO QUE TODO EL RESULTADO ESTE EN MAYUSCULAS
CREATE OR ALTER view vw_buena 
AS
SELECT 
    UPPER(CompanyName) AS [CompanyName],
    UPPER(c.Country) AS [Country],
    UPPER(c.City) AS [City],
    UPPER (ISNULL(c.Region, 'Sin Region')) AS [RegionLimpia],
    LTRIM(UPPER(CONCAT(e.FirstName,''))) AS [FULLNAME],
    ROUND(SUM(od.Quantity * od.UnitPrice),2) AS [Total],
  CASE
    WHEN SUM(od.Quantity * od.UnitPrice) >= 30000 AND 
    SUM(od.Quantity * od.UnitPrice) <= 60000 THEN 'GOLD'
    when 
    SUM(od.Quantity * od.UnitPrice) >= 10000 AND 
    SUM(od.Quantity * od.UnitPrice) <= 30000 THEN 'SILVER'
    ELSE 'BRONCE'
    END AS [MEDALLON]
FROM NORTHWND.dbo.Customers AS c
INNER JOIN
NORTHWND.dbo.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
AND UPPER (ISNULL(c.Region, 'Sin Region')) = UPPER('Sin Region')
GROUP BY c.CompanyName,c.Country,c.City, c.Region, CONCAT(e.FirstName,'');
GO

CREATE OR ALTER PROC spu_informe_clientes_EMPLEADOS
@nombre VARCHAR(50),
@region VARCHAR(50) 
AS
BEGIN
    SELECT *
        FROM vw_buena
        WHERE FULLNAME = @nombre
        AND RegionLimpia = @region
END;

EXEC  spu_informe_clientes_EMPLEADOS 'Andrew', 'Sin region'
GO


/*SELECT 
    UPPER(CompanyName) AS [CompanyName],
    UPPER(c.Country) AS [Country],
    UPPER(c.City) AS [City],
    UPPER (ISNULL(c.Region, 'Sin Region')) AS [RegionLimpia],
    LTRIM(UPPER(CONCAT(e.FirstName,''))) AS [FULLNAME],
    ROUND(SUM(od.Quantity * od.UnitPrice),2) AS [Total],
  CASE
    WHEN SUM(od.Quantity * od.UnitPrice) >= 30000 AND 
    SUM(od.Quantity * od.UnitPrice) <= 60000 THEN 'GOLD'
    when 
    SUM(od.Quantity * od.UnitPrice) >= 10000 AND 
    SUM(od.Quantity * od.UnitPrice) <= 30000 THEN 'SILVER'
    ELSE 'BRONCE'
    END AS [MEDALLON]
FROM NORTHWND.dbo.Customers AS c
INNER JOIN
NORTHWND.dbo.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
WHERE UPPER(CONCAT(e.FirstName,'')) =  UPPER('ANDREW')
AND UPPER (ISNULL(c.Region, 'Sin Region')) = UPPER('Sin Region')
GROUP BY c.CompanyName,c.Country,c.City, c.Region, CONCAT(e.FirstName,'')
ORDER BY  FULLNAME ASC,[Total] DESC;*/



/*==============================================MANEJO DE ERRORES CON TRY ... CATCH=================================================*/

--- Sin TRY - CATCH 
SELECT 10/10;

-- CON TRY - CATCH

BEGIN TRY
    SELECT 10/10;
END TRY
BEGIN CATCH 
    PRINT 'OCURRE UN ERROR';
END CATCH;

--EJEMPLO DE USO DE FUNCIONES PARA OBTENER INFORMACION DEL ERROR 
BEGIN TRY
    SELECT 10/0;
END TRY 
BEGIN CATCH
    PRINT 'Mensaje: ' +  ERROR_MESSAGE();
    PRINT 'Número del Error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Líne de Error: ' + CAST(ERROR_LINE() AS VARCHAR);
    PRINT 'Estado del Error: ' + CAST(ERROR_STATE() AS VARCHAR)
END CATCH;
GO

CREATE TABLE clientes(
    id INT PRIMARY KEY,
    nombre VARCHAR(35)
);
GO
INSERT INTO clientes
VALUES (1, 'PANFILO');
GO

BEGIN TRY
    INSERT INTO clientes
    VALUES (1, 'EUSTOLIO');
END TRY
BEGIN CATCH
    PRINT 'ERROR AL INSERTAR: ' + ERROR_MESSAGE();
    PRINT 'ERROR EN LA LINEA: ' + CAST(ERROR_LINE() AS VARCHAR)
END CATCH 

BEGIN TRANSACTION;

INSERT INTO clientes
VALUES (2, 'AMERICO ANGEL');

SELECT *FROM clientes;

COMMIT ;
ROLLBACK;
GO

--Ejemplo de uso de transacciones junto con el try catch 
USE bdstored;
GO

BEGIN TRY 
    BEGIN  TRANSACTION;

    INSERT INTO clientes
    VALUES(3,'VALDERAMA');
    INSERT INTO clientes
    VALUES (3, 'ROLES ALINA');

    COMMIT;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 1
        BEGIN
            ROLLBACK;
        END
            PRINT  'SE HIZO ROLLBACK POR ERROR';
            PRINT 'ERROR: ' + ERROR_MESSAGE();
    END CATCH;
GO
-- CREAR UN STORE PROCEDURE QUE INSERTE UN CLIENTE, CON LAS VALIDACIONES NECESARIAS 

CREATE OR ALTER PROCEDURE usp_insertar_cliente
    @id INT,
    @nombre VARCHAR(35)
AS 
BEGIN    
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO clientes
        VALUES (@id, @nombre);

        COMMIT;
        PRINT 'CLIENTE INSERTADO';
    END TRY 
    BEGIN CATCH
        IF @@TRANCOUNT > 1
            BEGIN
            ROLLBACK;
            END
            PRINT 'EROR: ' + ERROR_MESSAGE();
    END CATCH
END;




UPDATE clientes
SET nombre = 'Americo azul'
WHERE id = 2;

IF @@ROWCOUNT < 1
BEGIN
    PRINT @@ROWCOUNT
    PRINT 'no xiste el cliente'
END
ELSE
    PRINT ' cliente actualizado';
GO

CREATE TABLE teams
(
    id INT NOT NULL IDENTITY PRIMARY KEY,
    nombre NVARCHAR(15)

);

SELECT * FROM teams

INSERT INTO teams (NOMBRE)
VALUES ('CRUZ AZUL');

--FORMA DE OBTENER UN IDENTYTI INSERTADO FORMA 1

DECLARE @id_insertado INT
SET @id_insertado = @@IDENTITY
PRINT 'ID INSERTADO: ' + CAST(@id_insertado AS VARCHAR);
SELECT @id_insertado = @@IDENTITY
PRINT 'ID INSERTADO FORMA 2: ' + CAST(@id_insertado AS VARCHAR);



--FORMA DE OBTENER UN IDENTYTI INSERTADO FORMA 2

INSERT INTO teams (NOMBRE)
VALUES ('AGUILAS');

DECLARE @id_insertado2 INT
SET @id_insertado2 = SCOPE_IDENTITY();
PRINT 'ID INSERTADO: ' + CAST(@id_insertado2 AS VARCHAR);
SELECT @id_insertado2 = SCOPE_IDENTITY();
PRINT 'ID INSERTADO FORMA 2: ' + CAST(@id_insertado2 AS VARCHAR);