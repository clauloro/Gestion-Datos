select count(*) FROM [DATAEX].[001_sales] --cuenta datos
select * FROM [DATAEX].[001_sales] --muestra tabla
-- VER QUE HAY EN LA TABLA
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '001_sales';


-- AGRUPAR POR PRODUCTO Y CONTAR EL NUMERO DE PRODUCTOS Y PRECIO MEDIO
SELECT 
    [Id_Producto],  
    COUNT ([Id_Producto]) AS [Numero de Productos], 
    ROUND(AVG([PVP]), 2) AS Precio_Medio
FROM [DATAEX].[001_sales]
GROUP BY [Id_Producto]

-- AGRUPAR POR PRODUCTO Y CONTAR DISTINTIVAMENTE Y QUITAR LOS NULOS DE PRODUCTO
SELECT 
    [Id_Producto],  
    COUNT ([Id_Producto]) AS Numero_Productos,
    COUNT(DISTINCT [Id_Producto]) AS Productos_Unicos, -- CUENTA PRODUCTOS DISTINTOS
    ROUND(AVG(CAST([PVP] AS FLOAT)), 2) AS Precio_Medio
FROM [DATAEX].[001_sales]
WHERE [Id_Producto] IS NOT NULL
GROUP BY [Id_Producto]

-- convertir la fecha de texto a numero
--  
SELECT 

    Sales_Date,
    CAST(CONVERT(DATE, Sales_Date, 103) AS DATE) AS Fecha_Convertida -- CAST(CONVERT(FORMA DE MOSTRARSE)...): convertir de texto a fecha. 103 FORMATO PARA CONVERTIRLO.
FROM [DATAEX].[001_sales]



