# Triggers en SQL Server

## 1.¿Qué es un trigger?

un trigger (disparador) en un bloque de código SQL que se ejecuta automaticamente cuando ocurre un evento en una tabla 

🍭 Eventos principales:
    - INSERT
    - UPDATE
    - DELETE

NOTA: No se ejecutan manualmente, se activan solos 

## 2. ¿Para que sirven?
    - Validaciones 
    -Auditoria (guardar historial)
    -Reglas de negocio 
    -Automatización

## 3. Tipos de Triggers en SQL Server

    -AFTER TRIGGER 
    se ejecuta despues del evento 

    -INSTEAD OF TRIGGER 
    Reemplaza la operación original 

```sql
    CREATE OR ALTER TRIGGER nombre_trigger
    ON nombre_tabla
    AFTER INSERT
    AS
    BEGIN
    END;
```

## Tablas especiales 
| Table | Contenido | 
| :--- | :---: | 
| Inserted | Nuevos Datos | 
| Deleted | Datos Antiguos |
 