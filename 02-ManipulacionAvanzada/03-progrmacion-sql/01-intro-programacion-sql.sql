/*============================== Variables en transacto-SQL=================*/

DECLARE @edad INT; --Declarar variable
SET @edad=21; --Ponerle valor

PRINT @edad; --Imprimir
SELECT @edad AS [EDAD]; --Muestre la variable

DECLARE @nombre VARCHAR(30) = 'San Gallardo';
SELECT @nombre AS [Nombre];
SET @nombre = 'San Adonai';
SELECT @nombre AS [Nombre];

/*==================Ejercicio=================*/
/*
-Declarar una variable @Precio
-Asisganar el valor 150
-Calcular IVA (16)
-Mostrar el total 
*/

DECLARE @Precio MONEY = 150;
DECLARE @Iva DECIMAL(10,2); 
DECLARE @Total MONEY;

SET @Iva = @Precio * 0.16;
SET @Total = @Precio + @Iva;
SELECT 
    @Precio AS [PRECIO], 
    CONCAT ('$', @Iva) AS [IVA(16%)],
    CONCAT('$', @Total) AS [TOTAL];

/*=====================================IF/ELSE==================================*/

DECLARE @edad INT;
SET @edad = 18;

IF @edad >=18
    PRINT 'Eres mayor de edad';
ELSE 
    PRINT 'Eres menor de edad';

/*APROBADO > 7, REPROBADO <7*/

DECLARE @PROM DECIMAL(10,2); --10 ENTEROS, 2 DECIMALES
SET @PROM = 7;

IF @PROM >= 0.0 AND @PROM <=10.0
BEGIN
    IF @PROM >= 7.0
        BEGIN   
            PRINT ('Aprobado')
        END
        ELSE
        BEGIN
            PRINT ('Reprobado')
        END
END
ELSE
BEGIN
    SELECT CONCAT(@PROM, 'Esta fuera de rango') AS [RESOUESTA];
END

/*################## WHILE##############*/

DECLARE @limite INT = 5;
DECLARE @i INT = 1;

WHILE (@i<=@limite)
BEGIN
    PRINT CONCAT('Numero ', @i)
    SET @i = @i + 1
END


