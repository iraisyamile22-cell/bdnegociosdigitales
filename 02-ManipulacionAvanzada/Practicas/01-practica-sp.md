# Documentación de la Práctica: Sistema de Ventas con Stored Procedures

Esta práctica consiste en la creación de una base de datos relacional para gestionar ventas, utilizando datos base del catálogo de `NORTHWND` y automatizando el proceso de compra y actualización de inventario mediante un Procedimiento Almacenado (*Stored Procedure*) con manejo de transacciones.

A continuación, se explica paso a paso el código implementado en la solución.

---

## 1. Preparación del Entorno (Creación de la Base de Datos)

El primer paso es crear el espacio de trabajo aislando nuestra práctica de otras bases de datos.

```sql
CREATE DATABASE bdpractica; 
GO

USE bdpractica; 
GO

USE NORTHWND; 
GO
```
CREATE DATABASE: Genera la base de datos nueva llamada bdpractica.

USE: Le indica a SQL Server en qué base de datos nos vamos a posicionar para ejecutar los comandos siguientes. En este caso, nos posicionamos en NORTHWND para desde ahí enviar la información a nuestra base de datos mediante rutas completas (Cross-Database Queries).

## 2 Creacion de Tablas y llenado de tablas
```sql
    CREATE TABLE bdpractica.dbo.CatProducto (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    nombre_Producto NVARCHAR(40),
    existencia INT,
    precio MONEY
);
```
bdpractica.dbo.CatProducto: Se usa el nombre de tres partes para crear la tabla remotamente desde el entorno de Northwind.

IDENTITY(1,1): Hace que el ID del producto se genere automáticamente empezando desde el 1 y avanzando de 1 en 1.

Para llenar esta tabla, se extrajeron los datos de NORTHWND:
```sql
INSERT INTO bdpractica.dbo.CatProducto 
SELECT ProductName, UnitsInStock, UnitPrice
FROM NORTHWND.dbo.Products;
```

```sql
CREATE TABLE bdpractica.dbo.CatCliente (
    id_cliente NCHAR(5) PRIMARY KEY,
    nombre_cliente NVARCHAR(40) NOT NULL,
    pais NVARCHAR(15),
    ciudad NVARCHAR(15)
);
```
Se utiliza NCHAR(5) como llave primaria para que coincida exactamente con el tipo de dato que maneja Northwind para sus clientes. Posteriormente, se llenó la tabla con un INSERT INTO ... SELECT similar al de productos.
```sql
INSERT INTO bdpractica.dbo.CatCliente
SELECT 
    CustomerID, CompanyName, Country, City
    FROM NORTHWND.dbo.Customers;
GO
```

```sql
CREATE TABLE bdpractica.dbo.tblVENTA (
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL,
    ID_cliente NCHAR(5),
    FOREIGN KEY (ID_cliente) REFERENCES bdpractica.dbo.CatCliente(id_cliente)
);
```
Esta tabla guarda el "encabezado" del ticket. Registra automáticamente el número de venta y lo enlaza con un cliente válido.

```sql
CREATE TABLE bdpractica.dbo.tblDetalleVenta (
    ID_venta INT,
    ID_producto INT,
    precio_venta MONEY NOT NULL,
    cantidad_vendida INT NOT NULL,
    PRIMARY KEY (ID_venta, ID_producto),
    FOREIGN KEY (ID_venta) REFERENCES bdpractica.dbo.tblVENTA(id_venta),
    FOREIGN KEY (ID_producto) REFERENCES bdpractica.dbo.CatProducto(id_producto)
);
```
PRIMARY KEY (ID_venta, ID_producto): Es una Llave Primaria Compuesta. Garantiza que no se registre el mismo producto dos veces en el mismo ticket de venta.

## Stored Procedure
1. La Cabecera y los Parámetros
```sql
CREATE OR ALTER PROC usp_agregar_venta
    @Id_cliente  NCHAR(5),
    @Id_producto INT,
    @cantidad_vendida int 
AS
BEGIN
```
CREATE OR ALTER PROC: Le indica a SQL que cree el procedimiento llamado usp_agregar_venta. Si ya existe uno con ese nombre, la instrucción ALTER simplemente lo actualiza o lo sobreescribe sin marcar error.

Variables con @ (Parámetros): Son los datos de entrada que el procedimiento necesita para funcionar. Piensa en ellos como los campos vacíos de un formulario que el usuario debe llenar para poder registrar una venta: ¿A quién le vendo?, ¿Qué le vendo? y ¿Cuántos le vendo?

AS BEGIN: Marca el inicio oficial de las instrucciones lógicas del programa.

2. Las Validaciones
A. Validar el Cliente
```sql
    IF NOT EXISTS (
        SELECT 1 FROM bdpractica.dbo.CatCliente WHERE id_cliente = @Id_cliente
    )
    BEGIN 
        PRINT 'Error: El cliente no existe.';
        RETURN;
    END
```
IF NOT EXISTS: Busca en tu tabla CatCliente el ID que el usuario escribió. Si no lo encuentra, entra al bloque de error.

PRINT: Muestra el mensaje de texto en la pantalla.

RETURN: Es un freno de emergencia. Si el cliente no existe, el programa se detiene de golpe en esta línea y ya no lee nada del código que está más abajo. 

B. Validar el Inventario
```sql
    DECLARE @existencia_actual INT;
    SELECT @existencia_actual = existencia FROM bdpractica.dbo.CatProducto  
    WHERE id_producto = @Id_producto;

    IF @existencia_actual < @cantidad_vendida
        BEGIN
            PRINT 'Error: Cantidad insuficiente';
            RETURN;
        END
```
DECLARE: Crea una variable temporal llamada @existencia_actual para guardar un número.

SELECT ... = existencia: Va al catálogo de productos, revisa cuántos artículos quedan en stock del producto que se quiere comprar y guarda ese número en la cajita temporal.

IF @existencia_actual < @cantidad_vendida: Compara la cajita con lo que el cliente pidió. Si lo que hay guardado es menor a lo que se pide, se detiene el proceso con RETURN.

3. La Zona Segura y la Transacción
```sql
    BEGIN TRY
        BEGIN TRANSACTION;
```

BEGIN TRY: Activa el "modo a prueba de fallos" de SQL Server. Le dice al sistema: "Intenta ejecutar todo lo que sigue. Si cualquier cosa explota o da error, no colapses, simplemente salta al bloque CATCH".

BEGIN TRANSACTION: Es vital en sistemas de ventas. Significa "Agrupa todos los movimientos siguientes (insertar venta, insertar detalle, actualizar inventario) en un solo paquete". Los cambios se mantienen "en el aire" y no se guardan en el disco duro hasta que se dé la orden final.

4. El Registro de la Venta 

Si pasamos todas las validaciones de arriba, el código empieza a escribir en las tablas.
A. Crear el Ticket 
```sql
        INSERT INTO bdpractica.dbo.tblVENTA (fecha, ID_cliente)
        VALUES (GETDATE(), @Id_cliente);

        DECLARE @Id_venta_nueva INT = SCOPE_IDENTITY();

```
INSERT...: Guarda quién compró y cuándo.

GETDATE(): Es una función automática de SQL que obtiene la fecha y hora exactas del servidor en el momento de la compra.

SCOPE_IDENTITY(): Como el ID de la venta se genera solo (IDENTITY(1,1)), no sabemos qué número le tocó. Esta función "atrapa" ese último número creado y lo guarda en @Id_venta_nueva para que no se nos pierda.

B. Generar el Detalle del Ticket
```sql
        DECLARE @precio_producto MONEY
        SELECT @precio_producto = precio FROM bdpractica.dbo.CatProducto 
        WHERE id_producto = @Id_producto;

        INSERT INTO bdpractica.dbo.tblDetalleVenta (ID_venta, ID_producto, precio_venta, cantidad_vendida)
        VALUES (@Id_venta_nueva, @Id_producto, @precio_producto, @cantidad_vendida);
```

Primero, vamos al catálogo a leer el precio actual del producto y lo guardamos en @precio_producto.

Luego, guardamos el detalle uniendo todo: El ID del ticket que acabamos de atrapar arriba (@Id_venta_nueva), el ID del producto, su precio y cuántos se llevó.

C. Descontar del Inventario

```sql
        UPDATE bdpractica.dbo.CatProducto 
        SET existencia = existencia - @cantidad_vendida
        WHERE  id_producto = @Id_producto;   
```

UPDATE: Va al catálogo de productos y dice: "Tu nueva existencia será igual a la que tenías antes, menos la cantidad que acabo de vender".

5. Cierre y Manejo de Errores (El Plan B)
```sql
        COMMIT TRANSACTION
            PRINT 'Venta registrada exitosamente';
    END TRY
```
COMMIT TRANSACTION: Esta es la orden final. Si el código llegó intacto hasta esta línea, le dice a SQL: "Todo salió perfecto, confirma y guarda permanentemente todos los cambios en la base de datos".

```sql
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'La transacción no lograda';
        PRINT ERROR_MESSAGE(); 
        THROW;
    END CATCH
END
```
BEGIN CATCH: Si hubo un apagón, un fallo de conexión o un dato mal escrito en la zona del TRY, el sistema brinca directamente aquí.

@@TRANCOUNT > 0: Verifica si se quedó alguna transacción abierta o a medias.

ROLLBACK TRANSACTION: El botón de "Deshacer". Cancela cualquier inserción que se haya intentado hacer en ese intento fallido, regresando la base de datos a como estaba antes para no dejar datos corruptos.

ERROR_MESSAGE() y THROW: Muestran y lanzan el detalle técnico exacto de por qué falló el proceso para que el programador pueda arreglarlo.

## 3 Prueba
```sql
EXEC usp_agregar_venta 
    @Id_cliente = 'ALFKI', 
    @Id_producto = 1, 
    @cantidad_vendida = 5;
```
Registra la venta, el detalle y descuenta 5 unidades del inventario del producto 1.
```sql
EXEC usp_agregar_venta @Id_cliente = 'NOEXI', @Id_producto = 1, @cantidad_vendida = 5;
```
Comportamiento esperado: El código se detiene, no afecta la base de datos y lanza el error programado de cliente.
```sql
EXEC usp_agregar_venta @Id_cliente = 'ALFKI', @Id_producto = 1, @cantidad_vendida = 10000;
```
Comportamiento esperado: El código identifica que la cantidad supera las existencias, se detiene y notifica la falta de stock.