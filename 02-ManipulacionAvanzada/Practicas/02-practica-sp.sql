USE bdpractica;
GO

USE bdpractica;
GO

-- Creamos el Type (El molde del carrito)
CREATE TYPE dbo.TipoListaProductos AS TABLE 
(
    id_producto INT,
    cantidad INT
);
GO

CREATE OR ALTER PROC usp_agregar_venta_n_productos
    -- Parámetros del SP
    @Id_cliente NCHAR(5),
    @TablaProductos dbo.TipoListaProductos READONLY -- Aquí viajan "n" productos con sus cantidades
AS
BEGIN
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
        -- Cruzamos la Tabla Type con el Catálogo para obtener el precio de cada producto
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

        -- Confirmar todo
        COMMIT TRANSACTION;
        PRINT 'Venta múltiple registrada exitosamente';
                
    END TRY
    BEGIN CATCH
        -- Si algo falla, deshacemos todo para no cobrar a medias
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'La transacción no lograda';
        PRINT ERROR_MESSAGE(); 
        THROW;
    END CATCH
END;
GO

-- 1. Declaramos la variable de tipo Tabla Type
DECLARE @MiCarrito dbo.TipoListaProductos;

-- 2. Insertamos "n" productos (El id del producto y su cantidad)
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

-- 4. Comprobamos que se haya hecho 1 sola venta con 3 detalles
SELECT * FROM bdpractica.dbo.tblVENTA; 
SELECT * FROM bdpractica.dbo.tblDetalleVenta;