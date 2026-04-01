## Reporte de Práctica: Sistema de Ventas (N Productos) con Stored Procedures

## Paso 1: Creación del Tipo de Dato de Tabla (El "Carrito")

Para poder enviar múltiples productos al procedimiento almacenado en un solo parámetro, primero tuve que definir un "molde" o tipo de dato de tabla en SQL Server. Este tipo de dato almacena temporalmente los identificadores de los productos y la cantidad que el cliente desea llevar.

```sql
USE bdpractica;
GO

-- Creamos el Type (El molde del carrito)
CREATE TYPE dbo.TipoListaProductos AS TABLE 
(
    id_producto INT,
    cantidad INT
);
GO
```
A diferencia de las tablas normales, los TYPE no se pueden modificar con la instrucción ALTER. Si la estructura de este "carrito" necesita cambiar en el futuro, se debe hacer un DROP TYPE y volver a crearlo.

## Paso 2: Creación del Procedimiento Almacenado
El núcleo de la práctica es el procedimiento usp_agregar_venta_n_productos. Este recibe únicamente el ID del cliente y la tabla con los productos (usando la cláusula obligatoria READONLY).

El código se divide en dos fases principales:

Validaciones Masivas: Para asegurar la integridad de los datos, el motor de base de datos verifica que el cliente exista, que ningún producto solicitado esté fuera de catálogo y que haya inventario suficiente para cubrir toda la demanda.

Transacción Segura (TRY/CATCH): Si todas las validaciones pasan, se abre una transacción. Se genera un único ticket (tblVENTA), se extrae su ID con SCOPE_IDENTITY(), y se realizan inserciones y actualizaciones masivas cruzando la información de nuestro "carrito" temporal con las tablas físicas mediante INNER JOIN.

```sql
CREATE OR ALTER PROC usp_agregar_venta_n_productos
    -- Parámetros del SP
    @Id_cliente NCHAR(5),
    @TablaProductos dbo.TipoListaProductos READONLY -- Aquí viajan "n" productos con sus cantidades
AS
BEGIN
```

#### 1. Definición y Parámetros de Entrada
El procedimiento recibe la información a través de dos parámetros:
* **`@Id_cliente NCHAR(5)`:** Recibe el identificador único del cliente que realiza la compra.
* **`@TablaProductos dbo.TipoListaProductos READONLY`:** Es un parámetro de tipo tabla (*Table-Valued Parameter*). Actúa como el "carrito de compras", recibiendo una lista dinámica de productos y sus cantidades. La cláusula `READONLY` es obligatoria en SQL Server para este tipo de estructuras, asegurando que la tabla temporal no sea modificada dentro del procedimiento.

```sql
    -- ==========================================
    -- FASE 1: VALIDACIONES 
    -- ==========================================
    
    -- 1. Verificar si el cliente existe
    IF NOT EXISTS (SELECT 1 FROM bdpractica.dbo.CatCliente WHERE id_cliente = @Id_cliente)
    BEGIN 
        PRINT 'Error: El cliente no existe.';
        RETURN;
    END

    -- 2. Verificar si ALGÚN producto de la tabla Type NO existe en el catálogo
    IF EXISTS(
        SELECT 1 FROM @TablaProductos TP 
        LEFT JOIN bdpractica.dbo.CatProducto P ON TP.id_producto = P.id_producto
        WHERE P.id_producto IS NULL
    )
    BEGIN 
        PRINT 'Error: Uno o más productos enviados no existen en el catálogo.';
        RETURN;
    END

    -- 3. Verificar si falta stock para ALGÚN producto de la tabla Type
    IF EXISTS(
        SELECT 1 FROM @TablaProductos TP
        INNER JOIN bdpractica.dbo.CatProducto P ON TP.id_producto = P.id_producto
        WHERE P.existencia < TP.cantidad
    )
    BEGIN
        PRINT 'Error: Cantidad insuficiente en el inventario para uno de los productos.';
        RETURN;
    END
```
#### 2. Fase 1: Validaciones de Reglas de Negocio
Antes de realizar cualquier modificación en la base de datos, el código implementa tres filtros de seguridad (`IF EXISTS` / `IF NOT EXISTS`) para prevenir errores de inconsistencia:

* **Validación de Cliente:** Consulta la tabla `CatCliente` para asegurar que el comprador registrado es válido.
* **Validación de Catálogo (Productos):** Utiliza un `LEFT JOIN` entre el "carrito" y el catálogo de productos. Si el cruce detecta un valor nulo (`IS NULL`), significa que el usuario intentó enviar un producto que no existe en el sistema, abortando la operación.
* **Validación de Existencias (Stock):** Mediante un `INNER JOIN`, compara la cantidad solicitada en el carrito contra la columna `existencia` del catálogo. Si la demanda supera el inventario de al menos un producto, la transacción se cancela mediante `RETURN` para evitar un stock negativo.

```sql
    -- ==========================================
    -- FASE 2: LA TRANSACCIÓN (TRY / CATCH)
    -- ==========================================
    BEGIN TRY
        BEGIN TRANSACTION;

        -- A. Insertar el Encabezado de la Venta (Solo 1 fila para todo el ticket)
        INSERT INTO bdpractica.dbo.tblVENTA (fecha, ID_cliente)
        VALUES (GETDATE(), @Id_cliente);
            
        -- Guardar el ID de la venta generada
        DECLARE @Id_venta_nueva INT = SCOPE_IDENTITY();

        -- B. Insertar "N" Detalles (Insert masivo)
        -- Cruzamos la Tabla Type con el Catálogo para obtener el precio actual de cada producto
        INSERT INTO bdpractica.dbo.tblDetalleVenta (ID_venta, ID_producto, precio_venta, cantidad_vendida)
        SELECT 
            @Id_venta_nueva, 
            TP.id_producto, 
            P.precio, 
            TP.cantidad
        FROM @TablaProductos TP
        INNER JOIN bdpractica.dbo.CatProducto P ON TP.id_producto = P.id_producto;

        -- C. Actualizar existencias de "N" productos (Update masivo)
        UPDATE P
        SET P.existencia = P.existencia - TP.cantidad
        FROM bdpractica.dbo.CatProducto P
        INNER JOIN @TablaProductos TP ON P.id_producto = TP.id_producto;   

        -- Confirmar todo si no hubo errores
        COMMIT TRANSACTION;
        PRINT 'Venta múltiple registrada exitosamente';
                
    END TRY
```
#### 3. Fase 2: Ejecución de la Transacción (Bloque TRY)
Si los datos de entrada son válidos, se entra a una zona segura delimitada por `BEGIN TRY` y `BEGIN TRANSACTION`. Esto empaqueta las siguientes tres operaciones como una sola unidad de trabajo lógico:

* **A. Creación del Encabezado (Ticket):** Se inserta un único registro en `tblVENTA` con la función `GETDATE()` para registrar el momento exacto de la transacción.
* **Captura de Identidad:** Se utiliza la función escalar `SCOPE_IDENTITY()` para capturar dinámicamente el `ID_venta` que la base de datos acaba de generar de forma automática.
* **B. Inserción Masiva de Detalles:** En lugar de usar un ciclo que consuma muchos recursos, se emplea la técnica basada en conjuntos (*Set-based processing*). A través de un `INSERT INTO ... SELECT`, se cruza el carrito con el catálogo para heredar los precios actuales e insertar todos los productos en la tabla `tblDetalleVenta` vinculándolos al ID del ticket capturado anteriormente.
* **C. Actualización de Inventario:** Se ejecuta un `UPDATE` masivo utilizando un `JOIN` con la tabla temporal del carrito para restar las cantidades vendidas directamente del catálogo `CatProducto`.
* **Confirmación (`COMMIT`):** Si todas las instrucciones se ejecutan correctamente, se confirman y guardan los cambios de forma permanente en el disco.

```sql
    BEGIN CATCH
        -- Si algo falla, el Rollback deshace todo para no dejar registros huérfanos
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'La transacción no lograda';
        PRINT ERROR_MESSAGE(); 
        THROW;
    END CATCH
END;
GO
```
#### 4. Fase 3: Manejo de Errores (Bloque CATCH)
Si ocurre cualquier excepción a nivel de base de datos (como caídas de red, bloqueos de tablas o errores de conversión de datos), el control del flujo salta inmediatamente al bloque `CATCH`:

* **`ROLLBACK TRANSACTION`:** Si se detecta que hay una transacción abierta (`@@TRANCOUNT > 0`), se deshacen todas las inserciones y actualizaciones realizadas en el bloque `TRY`. Esto es vital para evitar que se guarde un ticket de venta sin detalles, o que se descuente el stock sin haber generado la venta.
* **`THROW`:** Finalmente, se relanza el error original hacia la aplicación o el usuario final, permitiendo que el sistema capture el mensaje exacto de la falla (`ERROR_MESSAGE()`) para fines de depuración y soporte.

## Paso 3: Prueba

Para probar la lógica construida, preparamos un script de ejecución. En lugar de hacer un EXEC simple, primero declaramos una variable de nuestro tipo TipoListaProductos, la llenamos con datos de prueba (simulando que el cliente agregó tres artículos distintos a su compra) y finalmente enviamos todo al procedimiento.

```sql
-- 1. Declaramos la variable de tipo Tabla Type
DECLARE @MiCarrito dbo.TipoListaProductos;

-- 2. Insertamos "n" productos (El id del producto y su respectiva cantidad)
INSERT INTO @MiCarrito (id_producto, cantidad)
VALUES 
    (1, 5),   -- Lleva 5 del producto 1
    (4, 2),   -- Lleva 2 del producto 4
    (7, 10);  -- Lleva 10 del producto 7

-- 3. Ejecutamos el Stored Procedure mandando el cliente y la tabla
EXEC usp_agregar_venta_n_productos 
    @Id_cliente = 'ALFKI', 
    @TablaProductos = @MiCarrito;
GO
```

## 4: Comprobación

```sql
-- 4. Comprobamos que se haya hecho 1 sola venta con 3 detalles
SELECT * FROM bdpractica.dbo.tblVENTA; 
SELECT * FROM bdpractica.dbo.tblDetalleVenta;
```
Al revisar tblVENTA, debe aparecer un único registro nuevo con la fecha actual. Al revisar tblDetalleVenta, deben aparecer tres filas nuevas, todas asociadas al mismo ID_venta, demostrando que el Table-Valued Parameter funcionó a la perfección para agrupar los artículos en un solo ticket.

## Tabla Type 
¿Para que sirve?
Su uso principal es actuar como un parametro en procedimiento almacenados o funciones.
Esto es extremadamente útil cuando necesitas enviar una lista completa de registro desde una aplicación hacia la base de datos en una sola llamada.

# Como se crea 

Para crear un *Table Type* (Tipo de Tabla Definido por el Usuario) en SQL Server, se utiliza la instrucción `CREATE TYPE` seguida de `AS TABLE`.

Aquí tienes un ejemplo práctico siguiendo la estructura del sistema de ventas. Sería muy útil si quisieras procesar múltiples productos en un solo ticket:

```sql
CREATE TYPE dbo.TipoDetalleVenta AS TABLE (
    ID_producto INT NOT NULL,
    cantidad_vendida INT NOT NULL,
    precio_venta MONEY NOT NULL
);
GO
```

**Explicación de la sintaxis:**
- **`CREATE TYPE dbo.TipoDetalleVenta`**: Define el nombre de tu nuevo tipo de dato personalizado.
- **`AS TABLE`**: Le indica a SQL Server que este tipo de dato funcionará y tendrá la estructura de una tabla.
- En su interior, defines las columnas y tipos de datos exactamente igual que al crear una tabla estándar.

**Nota importante:** Una vez creado, si deseas utilizar este *Table Type* como parámetro de entrada en un *Stored Procedure*, debes declararlo obligatoriamente con la cláusula `READONLY` (ej. `@detalles dbo.TipoDetalleVenta READONLY`), ya que SQL Server no permite modificar su contenido dentro del procedimiento.

# Como se usa

1. Definir el Tipo
Aquí creas la estructura que tendrá tu tabla

```sql
CREATE TYPE FacturaDetalleType AS TABLE (
    ProductoID INT,
    Cantidad INT,
    Precio Unitario DECIMAL(10, 2)
);
```

2. Usarlo en un Procedimiento Almacenado
Para recibir los datos, declaras el parámetro usando el tipo que creaste. Es obligatorio usar la palabra clave READONLY.

```sql
CREATE PROCEDURE sp_InsertarVenta
    @Detalles FacturaDetalleType READONLY
AS
BEGIN
    INSERT INTO VentasReales (ProdID, Cant, Precio)
    SELECT ProductoID, Cantidad, PrecioUnitario FROM @Detalles;
END;
```

3. Declarar y Llenar la Variable
En un script o desde tu código, la usas como cualquier otra variable.

```sql
DECLARE @MiLista AS FacturaDetalleType;

INSERT INTO @MiLista VALUES (101, 2, 15.50), (102, 1, 40.00);

EXEC sp_InsertarVenta @MiLista;
```

