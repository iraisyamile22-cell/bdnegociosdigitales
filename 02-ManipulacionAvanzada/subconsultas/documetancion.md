# ¿Qué es suna subconsulta?

Es un SELECT  dentro de otro SELECT. Puede devolcer 


1. Un solo valor (escalar)
1. Una lista de valores (Una columna, varias filas) 
1. Una tabla (varias columnas y/o varias filas)
1. Según lo que devuelva se elige el operador correcto (=, IN, EXISTS, etc).

Una subconsulta es una consulta anidada dentro de otra consulta que permite resolver problemas en varios niveles de información 

```
Depemdiendo de donde se coloque y que retorne, cambia su comportamiento 
```

5 grandes formas de usarlas:

1. subconsultas escalares
2. Subconsultas con IN, ANY, ALL
3. Subconsultas correlacionadas
4. Subconsultas en select
5. Subconsultas en from (Tablas derivadas).

## Escalares:

Devuelven un unico valor, por eso se pueden utilizar con operadores =,>,<.

Ejemplo
```sql
SELECT *
FROM pedidos
WHERE total = (SELECT MAX(total)
FROM pedidos);
```
## Subconsultas con IN, ANY, ALL.

Devuelve varios valores con una sola columna (IN)
```SQL
> SELECCIONAR CLIENTES QUE NO HAN HECHO PEDIDOS 

SELECT *
FROM pedidos AS P
INNER JOIN clientes AS C
ON P.id_cliente = C.id_cliente;

--BUENA 
SELECT C.id_cliente, C.nombre, C.ciudad
FROM pedidos AS P
RIGHT JOIN clientes AS C
ON P.id_cliente = C.id_cliente
WHERE P.id_cliente IS NULL;
```
## Clausula ANY
 
 - Compara un valor contra una lista 
 - La condición se cumple si se cumple con AL MENOS UNO 

```sql
valor > ANY (subconsulta)
```

> Es como decir: Mayor al menos uno de los valores 

- SELECCIONAR PEDIDOS MAYORES QUE ALGÚN PEDIDO DE LUIS (id_cliente=2)

## Clusula ALL

se cumple contra todos los valores  

```sql

VALOR > ALL (subconsulta)
```

Significa 

- Mayor que todos los valores

-- SELECCIONAFR LOS PEDIDOS DONDE EL TOTAL SEA MAYOR A TODOS LOS TOTALES DE LOS PEDIDOS DE LUIS

```SQL
SELECT total
FROM pedidos
WHERE id_cliente=2;

SELECT total
FROM pedidos;

SELECT *
FROM pedidos
WHERE total > ALL (
	SELECT total
	FROM pedidos
	WHERE id_cliente=2
);

-- SELECCIONAR TODOS LOS CLIENTES EN DONDE SU ID SEA MENOR QUE TODOS LOS CLIENTES DE LA CDMX

SELECT id_cliente
FROM clientes
WHERE ciudad = 'CDMX';

SELECT *
FROM clientes
WHERE id_cliente < ALL (
	SELECT id_cliente
	FROM clientes
	WHERE ciudad = 'CDMX'
);
```

## Subconsulta correlacionada

> Una subconsulta correlacionada depende de la fila actual de la consulta principal y se ejecuta una vez por cada fila