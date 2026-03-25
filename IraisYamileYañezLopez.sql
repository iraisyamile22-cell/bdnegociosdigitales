--C1 LISTA LOS PEDIDOS ATENDIDOS POR REPRESENTANTES CUYO PUESTO SEA 'JEFE VENTAS'
SELECT pe.Num_Pedido,
	pe.Fecha_Pedido,
	rp.Nombre,
	rp.Puesto,
	PE.Importe
FROM Pedidos AS PE
INNER JOIN 
Representantes AS RP
ON PE.Num_Pedido = RP.Oficina_Rep
WHERE PE.Rep = 104 OR PE.Rep = 108
ORDER BY REP DESC;



-- C2 Lista pedidos entre 01/dic/1989 y 28/feb/1990 
--que cumpla (importe > 10000) o (Cantidad >=20)
SELECT 
	p.Num_Pedido, 
	p.Fecha_Pedido,
	c.Empresa,
	p.Cantidad,
	p.Importe,
	(pro.Precio * Pro.Stock) AS importe
FROM Pedidos AS p
INNER JOIN 
Clientes AS c
ON p.Num_Pedido = c.Num_Cli
WHERE Fecha_Pedido = ('01/dic/1989') AND Fecha_Pedido = ('28/feb/1990')
INNER JOIN Productos AS pro
ON pro.precio = pro. Stock
WHERE (p.Importe > 10000) OR (p.Cantidad >=20;

--C3 Para cada producto vendido,calcula total y total importe 

SELECT p.Fab,
p.producto,
pro.Descripcion,
(PRO.Precio * PRO.Stock) AS [Total IMPORTE]
FROM Productos as pro
INNER JOIN 
Pedidos AS p
ON p.Num_Pedido = pro.Id_producto
WHERE ;

--C4 
SELECT Num_Empl,
Nombre
FROM Representantes;

SELECT Num_Empl,
Nombre,
Num_Pedido,
(Precio * Stock) AS [total_importe]
FROM Pedidos
Having Pedidos
WHERE [Total_importe] >= 20000;

SELECT *
FROM Representantes

--C5

SELECT Id_fab
FROM Productos
WHERE Descripcion LIKE '%Serie'
ORDER BY Descripcion desc;

-- C6
SELECT *
FROM Pedidos


--C7
CREATE OR ALTER VIEW vw_PedidoFull_C
AS
SELECT 
	pe.Num_Pedido,
	pe.Fecha_Pedido,
	cl.Empresa,
	NombreRep,
	Ciudad,
	Region,
	Descripcion,
	pe.Cantidad, 
	pe.Importe
FROM Pedidos as pe
INNER JOIN Clientes AS cl
ON

--C8 
CREATE OR ALTER VIEW vw_ProductosMasVendidos_C
AS
SELECT ID_FAB,
ID


