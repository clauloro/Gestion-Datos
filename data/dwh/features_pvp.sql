-- Esta consulta calcula estadísticas agregadas relacionadas con las ventas de vehículos o productos,
-- agrupadas por el precio de venta al público (PVP). Las métricas calculadas incluyen la edad promedio del
-- vehículo, los kilómetros promedio por revisión, el número promedio de revisiones (considerando 0 en lugar
-- de NULL cuando no se tiene información) y el porcentaje promedio de churn (deserción) de los clientes.

SELECT
    fact.PVP,  -- Precio de venta al público (PVP)
    AVG(fact.Car_Age) AS avg_car_age,  -- Edad promedio de los vehículos vendidos
    AVG(fact.Km_medio_por_revision) AS avg_km_revision,  -- Kilómetros promedio por revisión
    AVG(ISNULL(fact.Revisiones, 0)) AS avg_revisiones,  -- Promedio de revisiones realizadas (0 en lugar de NULL)
    AVG(CAST(fact.Churn AS FLOAT)) AS churn_percentage  -- Promedio de churn (deserción) de los clientes

FROM fact_sales fact  -- Tabla de ventas que contiene los datos transaccionales

GROUP BY fact.PVP;  -- Agrupa los resultados por el precio de venta al público (PVP)
