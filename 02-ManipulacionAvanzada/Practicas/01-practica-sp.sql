CREATE DATABASE bdpractica; --Creamos la base de datos
GO

USE bdpractica; --Usamos la bd que creamos 
GO

USE NORTHWND; --Usamos nothwnd para mandar a llamar los datos de nuestras tablas 
GO

--creacion de tablas
CREATE TABLE bdpractica.dbo.CatProducto 
/*Creamos las tablas en NORTHWND pero  
con su respectiva ruta, le estamos diciendo a SQL: 
"Sé que estoy trabajando en Northwind ahorita, pero quiero que vayas y 
me crees esta tabla allá en la base de datos bdstord". Te permite cruzar 
información entre dos bases de datos diferentes en la misma consulta.
 bdpractica(es la base de datos a donde quieres que vaya).
 dbo(Dueño de la base de datos).CatProducto(Nombre fila de la tabla)*/
(
    id_producto INT IDENTITY(1,1) PRIMARY KEY,   --PK, INT IDENTITY
    nombre_Producto NVARCHAR(40),   --NVARCHAR(40)
    existencia INT, --INT
    precio MONEY    --MONEY
);
GO

--INSERTAR DATOS 
-- Para insertar el dato desde de cambiar a tu base de datos original
--USE bdpractica; --Usamos la bd que creamos 

INSERT INTO bdpractica.dbo.CatProducto 
SELECT 
    ProductName, UnitsInStock, UnitPrice
    FROM NORTHWND.dbo.Products;
GO


CREATE TABLE bdpractica.dbo.CatCliente
(
    id_cliente NCHAR(5) PRIMARY KEY,    --PK, NCHAR(5)
    nombre_cliente NVARCHAR(40) NOT NULL,   --NVARCHAR(40)
    pais NVARCHAR(15),  --NVARCHAR(15)
    ciudad NVARCHAR(15) --NVARCHAR(15)
);
GO

INSERT INTO bdpractica.dbo.CatCliente
SELECT 
    CustomerID, CompanyName, Country, City
    FROM NORTHWND.dbo.Customers;
GO


CREATE TABLE bdpractica.dbo.tblVENTA
(
    id_venta INT IDENTITY(1,1) PRIMARY KEY,     --PK, INT IDENTITY
    fecha DATE NOT NULL,    --DATE
    ID_cliente NCHAR(5),    --FK
    FOREIGN KEY (ID_cliente) REFERENCES bdpractica.dbo.CatCliente(id_cliente)
    --Creamos la conexioón con CatCliente
);
GO

CREATE TABLE bdpractica.dbo.tblDetalleVenta
(
    --La llave primaria es compuesta: una combinación de ambos IDs
    ID_venta INT,   --PK Y FK
    ID_producto INT,    --PK Y FK
    precio_venta MONEY NOT NULL,    --MONEY
    cantidad_vendida INT NOT NULL,  --INT
    PRIMARY KEY (ID_venta, ID_producto),    --Definir la llave primeria compuesta 
    FOREIGN KEY (ID_venta) REFERENCES bdpractica.dbo.tblVENTA(id_venta),
    FOREIGN KEY (ID_producto) REFERENCES bdpractica.dbo.CatProducto(id_producto)
);
GO

CREATE OR ALTER PROC usp_agregar_venta
    @Id_cliente  NCHAR(5),
    @Id_producto INT,
    @cantidad_vendida int 
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM bdpractica.dbo.CatCliente WHERE id_cliente = @Id_cliente
    )
    BEGIN 
        PRINT 'Error: El cliente no existe.';
        RETURN;
    END


    IF NOT EXISTS(
        SELECT 1 FROM bdpractica.dbo.CatProducto WHERE id_producto = @Id_producto 
    )
    BEGIN 
        PRINT 'Error: El producto no existe.';
        RETURN;
    END
    DECLARE @existencia_actual INT;
    SELECT @existencia_actual = existencia FROM bdpractica.dbo.CatProducto  
    WHERE id_producto = @Id_producto;

    IF @existencia_actual < @cantidad_vendida
        BEGIN
            PRINT 'Error: Cantidad insuficiente';
            RETURN;
        END
    
    BEGIN TRY
    
        BEGIN TRANSACTION;

        INSERT INTO bdpractica.dbo.tblVENTA
        (fecha, ID_cliente)
            VALUES (GETDATE(), @Id_cliente);

            DECLARE @Id_venta_nueva INT = SCOPE_IDENTITY();
            DECLARE @precio_producto MONEY
            SELECT @precio_producto = precio FROM bdpractica.dbo.CatProducto 
            WHERE id_producto = @Id_producto;

            INSERT INTO bdpractica.dbo.tblDetalleVenta
            (ID_venta, ID_producto, precio_venta, cantidad_vendida)
            VALUES (@Id_venta_nueva, @Id_producto, @precio_producto,
            @cantidad_vendida);

            UPDATE bdpractica.dbo.CatProducto 
            SET existencia = existencia - @cantidad_vendida
            WHERE  id_producto = @Id_producto;   

            COMMIT TRANSACTION
                PRINT 'Venta registrada exitosamente';
                
                END TRY
                BEGIN CATCH
                    IF @@TRANCOUNT > 0
                        ROLLBACK TRANSACTION;

                        PRINT 'La transacción no lograda';

                        PRINT ERROR_MESSAGE(); 
                        THROW;
                        END CATCH
END
GO

EXEC usp_agregar_venta 'ANDY', 2, 1253;

EXEC usp_agregar_venta 
    @Id_cliente = 'ALFKI', 
    @Id_producto = 1, 
    @cantidad_vendida = 5;
GO
SELECT * FROM bdpractica.dbo.tblVENTA;
SELECT * FROM bdpractica.dbo.tblDetalleVenta;
SELECT * FROM bdpractica.dbo.CatProducto WHERE id_producto = 1;

EXEC usp_agregar_venta 
    @Id_cliente = 'NOEXI', -- Este cliente no existe
    @Id_producto = 1, 
    @cantidad_vendida = 5;

EXEC usp_agregar_venta 
    @Id_cliente = 'ALFKI', 
    @Id_producto = 1, 
    @cantidad_vendida = 10000; -- Seguramente no tienes 10,000 en stock