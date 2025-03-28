IF OBJECT_ID('cltv') IS NOT NULL
    DROP TABLE cltv;

-- Declaración de Variables.
DECLARE
    -- Tasa de descuento para cálculos financieros.
    @discount_rate FLOAT = 0.07,

    -- Coeficientes del modelo de churn.
    @b_intercepto FLOAT,
    @b_pvp FLOAT,
    @b_edad FLOAT,
    @b_km FLOAT,
    @b_revisiones FLOAT;

-- Carga de Coeficientes del modelo.
SELECT
    @b_intercepto = MAX(CASE WHEN Variable = 'Intercepto' THEN Coeficiente END),
    @b_pvp        = MAX(CASE WHEN Variable = 'PVP' THEN Coeficiente END),
    @b_edad       = MAX(CASE WHEN Variable = 'avg_car_age' THEN Coeficiente END),
    @b_km         = MAX(CASE WHEN Variable = 'avg_km_revision' THEN Coeficiente END),
    @b_revisiones = MAX(CASE WHEN Variable = 'avg_revisiones' THEN Coeficiente END)
FROM churn_coef;

-- CTE para estimar la retención por cliente.
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

-- Consulta principal.
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
    

    -- Leads agregados
    SUM(COALESCE(TRY_CAST(f.Lead_compra AS INT), 0) + 
        COALESCE(TRY_CAST(f.Fue_Lead AS INT), 0)) AS Total_Leads,

    -- Churn estimado
    LEAST(1, GREATEST(0, 1 - r.retencion_estimado)) AS churn_estimado,
    r.retencion_estimado,

    -- CLTV (Customer Lifetime Value) para 1 a 5 años
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
    ) AS CLTV_5_anios

INTO cltv
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
SELECT * FROM cltv;

