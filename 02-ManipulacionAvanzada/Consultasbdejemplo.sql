SELECT * FROM Clientes;
SELECT * FROM Representantes;
SELECT * FROM Oficinas;
SELECT * FROM Productos;
SELECT * FROM Pedidos;

-- CREAR UNA VISTA QUE VISUALICE EL TOTAL DE LOS IMPORTES AGRUPADOS POR PRODUCTOS 


SELECT PR.Descripcion AS [Nombre del producto],
	SUM(P.Importe) AS [total],
	SUM(P.Importe * 1.15) AS [Importe Descuento]
FROM Pedidos AS P
INNER JOIN Productos AS PR
ON P.Fab = PR.id_fab
AND P.Producto = PR.Id_producto
GROUP BY PR.Descripcion;

SELECT *
FROM VW_IMPORTE_PRODUCTO
WHERE [Nombre del producto] Like '%Brazo%'
AND [Importe Descuento] > 34000;

-- seleccionar los nombres de los empleados de los representantes y las oficinas donde trabajan
CREATE OR ALTER VIEW vw_oficinas_representantes
AS
SELECT r.Nombre, 
	r.Ventas AS [Ventasrepresentantes],
	o.oficina, 
	o.Ciudad, 
	o.Region, 
	o.Ventas AS [VentasOficinas]
FROM Representantes AS r
INNER JOIN Oficinas AS o
ON r.Oficina_Rep = o.Oficina;

SELECT *
FROM Representantes
WHERE Nombre = 'Daniel Ruidrobo';

SELECT Nombre, Ciudad
FROM vw_oficinas_representantes
ORDER BY nombre DESC;

-- SELECCIONAR LOS PEDIDOS CON FECHA EN IMPORTE, EL NOMBRE DEL REPRESENTANTE 
-- QUE LO REALIZO Y AL CLIENTE QUE LO SOLICITO 

SELECT p.Num_Pedido, 
	p.Fecha_Pedido, 
	p.Importe, 
	c.Empresa,
	r.nombre
FROM Pedidos AS p
INNER JOIN 
Clientes AS c
ON c.Num_Cli = p.Cliente
INNER JOIN Representantes AS r
ON r.Num_Empl = p.Rep;

-- SELECCIONAR LOS PEDIDOS CON FECHA EN IMPORTE, EL NOMBRE DEL REPRESENTANTE 
-- QUE ATENDIO AL CLIENTE Y AL CLIENTE QUE LO SOLICITO 

SELECT p.Num_Pedido, 
	p.Fecha_Pedido, 
	p.Importe, 
	c.Empresa,
	r.nombre
FROM Pedidos AS p
INNER JOIN 
Clientes AS c
ON c.Num_Cli = p.Cliente
INNER JOIN Representantes AS r
ON r.Num_Empl = c.Rep_Cli;





