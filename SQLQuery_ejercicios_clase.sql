---- VER QUE HAY EN LA TABLA
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '001_sales';

----- Agrupar por producto y contar el numero de productos y  el precio medio

SELECT 
    [Id_Producto],
    COUNT([Id_Producto]) AS Numero_Productos,
    ROUND(AVG([PVP]), 2) AS Precio_Medio
FROM [DATAEX].[001_sales]
GROUP BY [Id_Producto]

--ALTER TABLE [DATAEX].[001_sales]
--ALTER COLUMN [Id_Producto] VARCHAR(255); -- Ajusta el tamaño según lo necesites


----- Agrupar por producto y contar distintivosny quitar los nulos de producto
SELECT 
    [Id_Producto],
    COUNT([Id_Producto]) AS Numero_Productos,
    COUNT(DISTINCT [Id_Producto]) AS Productos_Unicos, -- Cuenta productos distintos
    ROUND(AVG(CAST([PVP] AS FLOAT)), 2) AS Precio_Medio
FROM [DATAEX].[001_sales]
WHERE [Id_Producto] IS NOT NULL
GROUP BY [Id_Producto]






---- convertir la fecha de texto a numero
--ALTER TABLE [DATAEX].[001_sales]
--ALTER COLUMN [Sales_Date] VARCHAR(255); -- Ajusta el tamaño según lo necesites

SELECT 
 
    Sales_Date,
    CAST(CONVERT(DATE, Sales_Date, 103) AS DATE) AS Fecha_Convertida
FROM [DATAEX].[001_sales]


---- dame las ventas por años, por año y mes, y la tasa d evariacion

SELECT 
    YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Año,
    COUNT(*) AS Total_Ventas
FROM [DATAEX].[001_sales]
GROUP BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
ORDER BY Año DESC;

SELECT 
    YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Año,
    MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Mes,
    COUNT(*) AS Total_Ventas
FROM [DATAEX].[001_sales]
GROUP BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)), 
         MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
ORDER BY Año DESC, Mes DESC;



--- Convertir la fecha de fin de garantia y hacer la diferencia 

--ALTER TABLE [DATAEX].[001_sales]
--ALTER COLUMN [CODE] VARCHAR(255); -- Ajusta el tamaño según lo necesites

SELECT 
    Sales_Date,
    CAST(CONVERT(DATE, Sales_Date, 103) AS DATE) AS Fecha_Convertida,
    FIN_GARANTIA,
    CAST(CONVERT(DATE, FIN_GARANTIA, 103) AS DATE) AS Fecha_Fin_Garantia
FROM [DATAEX].[001_sales];


--- Obtener las ventas por Dia y en el caso que la diferencia entre la gantia y las ventas in inferiores a 10 marcar cin un flag de danger

SELECT 
    
    CAST(CONVERT(DATE, Sales_Date, 103) AS DATE) AS Fecha_Convertida,
    CAST(CONVERT(DATE, FIN_GARANTIA, 103) AS DATE) AS Fecha_Fin_Garantia,
    COUNT(DISTINCT [CODE]) AS Sales,
    case when COUNT(DISTINCT [CODE])<20 then 'Danger' else 'Normal' end as Garantia_menos_365
FROM [DATAEX].[001_sales]
GROUP by CAST(CONVERT(DATE, Sales_Date, 103) AS DATE), CAST(CONVERT(DATE, FIN_GARANTIA, 103) AS DATE)


--- el máximo de ventas de la base de datos

SELECT TOP 1
    CAST(CONVERT(DATE, Sales_Date, 103) AS DATE) AS Fecha_Convertida,
    COUNT(*) AS Total_Ventas,
    'Máximo Global' AS Tipo
FROM [DATAEX].[001_sales]
GROUP BY CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)
ORDER BY Total_Ventas DESC;


-- Máximo de ventas de 2023 

SELECT TOP 1 
--WITH TIES
    CAST(CONVERT(DATE, Sales_Date, 103) AS DATE) AS Fecha_Convertida,
    COUNT(*) AS Total_Ventas,
    'Máximo 2023' AS Tipo
FROM [DATAEX].[001_sales]
WHERE YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) = 2023
GROUP BY CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)
ORDER BY Total_Ventas DESC;

--- producto con mas financiaciaciones
SELECT TOP 1 WITH TIES
    Id_Producto,
    COUNT(*) AS Total_Financiaciones
FROM [DATAEX].[001_sales]
WHERE FORMA_PAGO_ID = 'FINANCIADO' -- Ajusta según el valor que indica financiación
GROUP BY Id_Producto
ORDER BY Total_Financiaciones DESC;



---- Máximo de ventas si el seguro de bateria es si

--ALTER TABLE [DATAEX].[001_sales]
--ALTER COLUMN [SEGURO_BATERIA_LARGO_PLAZO] VARCHAR(255);

SELECT TOP 1 WITH TIES
    Id_Producto,
    COUNT(*) AS Total_Ventas
FROM [DATAEX].[001_sales]
WHERE SEGURO_BATERIA_LARGO_PLAZO = 'SI' -- Filtra solo las ventas con batería a largo plazo
GROUP BY Id_Producto
ORDER BY Total_Ventas DESC;

---- Calcula la tasa de variacion por año 
SELECT 
    YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Año,
    COUNT(*) AS Total_Ventas,
    
    -- Ventas del año anterior usando LAG()
    LAG(COUNT(*)) OVER (
        ORDER BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
    ) AS Ventas_Año_Anterior,

    -- Cálculo de la tasa de variación en porcentaje
    CASE 
        WHEN LAG(COUNT(*)) OVER (
            ORDER BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
        ) IS NULL 
        THEN NULL
        ELSE 
            ROUND(
                100.0 * (COUNT(*) - LAG(COUNT(*)) OVER (
                                ORDER BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
                            )) 
                / NULLIF(LAG(COUNT(*)) OVER (
                                ORDER BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
                            ), 0), 2)
    END AS Tasa_Variacion_Porcentual

FROM [DATAEX].[001_sales]
GROUP BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
ORDER BY Año DESC;


--- calcula las ventas  pro año y mes y su tasa d evariacion
SELECT 
    YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Año,
    MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) AS Mes,
    COUNT(*) AS Total_Ventas,
    LAG(COUNT(*)) OVER (PARTITION BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) 
                        ORDER BY MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))) AS Ventas_Mes_Anterior,
    CASE 
        WHEN LAG(COUNT(*)) OVER (PARTITION BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) 
                                 ORDER BY MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))) IS NULL 
        THEN NULL
        ELSE 
            ROUND(
                100.0 * (COUNT(*) - LAG(COUNT(*)) OVER (PARTITION BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) 
                                                         ORDER BY MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))))
                / NULLIF(LAG(COUNT(*)) OVER (PARTITION BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)) 
                                             ORDER BY MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))), 0), 2)
    END AS Tasa_Variacion_Porcentual
FROM [DATAEX].[001_sales]
GROUP BY YEAR(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE)), 
         MONTH(CAST(CONVERT(DATE, Sales_Date, 103) AS DATE))
ORDER BY Año DESC, Mes DESC;







