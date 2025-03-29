-- Esta consulta se utiliza para calcular el **Customer Lifetime Value (CLTV)** de los clientes, un indicador clave en la gestión de relaciones con los clientes.
-- El CLTV estima el valor total que un cliente generará durante su relación con la empresa, considerando factores como la retención, el comportamiento de compra y el descuento.
-- Además, se calculan métricas adicionales que permiten entender mejor el comportamiento del cliente, como el churn estimado, la cantidad de compras realizadas, y el margen generado en cada transacción.

-- Se utiliza un modelo de churn (deserción) para estimar la probabilidad de que un cliente permanezca activo durante un determinado periodo de tiempo.
-- El CLTV se calcula para distintos horizontes temporales (1, 2, 3, 4 y 5 años), lo que permite evaluar el valor proyectado del cliente a lo largo del tiempo.

-- Primero, si existe una tabla `cltv` previa, se elimina para permitir la creación de una nueva tabla.
IF OBJECT_ID('cltv') IS NOT NULL
    DROP TABLE cltv;

-- Declaración de Variables
DECLARE
    @discount_rate FLOAT = 0.07,  -- Tasa de descuento utilizada para calcular el CLTV
    @b_intercepto FLOAT,          -- Coeficiente para el intercepto del modelo
    @b_pvp FLOAT,                 -- Coeficiente para el precio de venta promedio (PVP)
    @b_edad FLOAT,                -- Coeficiente para la edad promedio del coche
    @b_km FLOAT,                  -- Coeficiente para el kilometraje promedio en la última revisión
    @b_revisiones FLOAT;         -- Coeficiente para el número promedio de revisiones

-- Cargar coeficientes del modelo de churn desde la tabla `churn_coef`
SELECT
    @b_intercepto = MAX(CASE WHEN Variable = 'Intercepto' THEN Coeficiente END),
    @b_pvp        = MAX(CASE WHEN Variable = 'PVP' THEN Coeficiente END),
    @b_edad       = MAX(CASE WHEN Variable = 'avg_car_age' THEN Coeficiente END),
    @b_km         = MAX(CASE WHEN Variable = 'avg_km_revision' THEN Coeficiente END),
    @b_revisiones = MAX(CASE WHEN Variable = 'avg_revisiones' THEN Coeficiente END)
FROM churn_coef;

-- CTE para calcular la retención estimada utilizando los coeficientes del modelo de churn
WITH retencion_cte AS (
    SELECT
        c.Customer_ID,
        LEAST(1, GREATEST(0,
            1 - (
                @b_intercepto +
                AVG(f.PVP) * @b_pvp +
                MAX(f.Car_Age) * @b_edad +
                AVG(f.km_ultima_revision) * @b_km +
                AVG(f.Revisiones) * @b_revisiones
            )
        )) AS retencion_estimado
    FROM dim_client c
    LEFT JOIN fact_sales f ON c.Customer_ID = f.Customer_ID
    GROUP BY c.Customer_ID
)

-- Consulta principal para crear la tabla `cltv` con la información de clientes y su valor a lo largo del tiempo
SELECT
    c.Customer_ID,  
    c.Edad,
    c.Fecha_nacimiento,
    c.GENERO,
    c.CODIGO_POSTAL,
    c.poblacion,
    c.provincia,
    c.STATUS_SOCIAL,
    c.RENTA_MEDIA_ESTIMADA,
    c.ENCUESTA_ZONA_CLIENTE_VENTA,
    c.ENCUESTA_CLIENTE_ZONA_TALLER,
    c.A, c.B, c.C, c.D, c.E, c.F, c.G, c.H, c.I, c.J, c.K, c.U,
    c.Max_Mosaic_G,
    c.Max_Mosaic2,
    c.Renta_Media,
    c.F2,
    c.Mosaic_number,

    -- Total de leads (oportunidades de venta)
    SUM(COALESCE(TRY_CAST(f.Lead_compra AS INT), 0) + 
        COALESCE(TRY_CAST(f.Fue_Lead AS INT), 0)) AS Total_Leads,

    -- Cálculo del churn estimado (probabilidad de que un cliente se pierda)
    LEAST(1, GREATEST(0, 1 - r.retencion_estimado)) AS churn_estimado,
    r.retencion_estimado,

    -- Cálculo del CLTV para 1 a 5 años
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1)
    ) AS CLTV_1_anio,

    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + @discount_rate, 2)
    ) AS CLTV_2_anios,

    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + @discount_rate, 2) +
        POWER(r.retencion_estimado, 3) / POWER(1 + @discount_rate, 3)
    ) AS CLTV_3_anios,

    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + @discount_rate, 2) +
        POWER(r.retencion_estimado, 3) / POWER(1 + @discount_rate, 3) +
        POWER(r.retencion_estimado, 4) / POWER(1 + @discount_rate, 4)
    ) AS CLTV_4_anios,

    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + @discount_rate, 2) +
        POWER(r.retencion_estimado, 3) / POWER(1 + @discount_rate, 3) +
        POWER(r.retencion_estimado, 4) / POWER(1 + @discount_rate, 4) +
        POWER(r.retencion_estimado, 5) / POWER(1 + @discount_rate, 5)
    ) AS CLTV_5_anios,

    -- Nuevas métricas adicionales
    COUNT(DISTINCT f.Sales_Date) AS total_compras,
    AVG(DATEDIFF(DAY, f.Prod_date, f.Sales_Date)) AS dias_produccion_venta,
    MAX(f.Margen_Eur) AS margen_max,
    MIN(f.Margen_Eur) AS margen_min,
    DATEDIFF(DAY, MIN(f.Sales_Date), MAX(f.Sales_Date)) AS dias_entre_compras

INTO cltv  -- Crea la tabla final con los resultados
FROM dim_client c
LEFT JOIN fact_sales f ON c.Customer_ID = f.Customer_ID
LEFT JOIN retencion_cte r ON c.Customer_ID = r.Customer_ID
GROUP BY
    c.Customer_ID,  
    c.Edad,
    c.Fecha_nacimiento,
    c.GENERO,
    c.CODIGO_POSTAL,
    c.poblacion,
    c.provincia,
    c.STATUS_SOCIAL,
    c.RENTA_MEDIA_ESTIMADA,
    c.ENCUESTA_ZONA_CLIENTE_VENTA,
    c.ENCUESTA_CLIENTE_ZONA_TALLER,
    c.A, c.B, c.C, c.D, c.E, c.F, c.G, c.H, c.I, c.J, c.K, c.U,
    c.Max_Mosaic_G,
    c.Max_Mosaic2,
    c.Renta_Media,
    c.F2,
    c.Mosaic_number,
    r.retencion_estimado;

-- Mostrar los resultados finales de la tabla CLTV
SELECT * FROM cltv;
