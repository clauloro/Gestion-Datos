SELECT 
    -- 🔹 Datos del cliente
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

    -- 🔹 Variables de ventas
    f.CODE,
    f.TIENDA_ID,
    f.Id_Producto,
    f.DATE_ULTIMA_REVISION,
    f.Sales_Date,
    f.PVP,
    f.MANTENIMIENTO_GRATUITO,
    f.SEGURO_BATERIA_LARGO_PLAZO,
    f.FIN_GARANTIA,
    f.COSTE_VENTA_NO_IMPUESTOS,
    f.IMPUESTOS,
    f.EN_GARANTIA,
    f.EXTENSION_GARANTIA,
    f.Margen_Eur,
    f.Margen_Eur_bruto,
    f.Coste_Total_Venta,
    f.Tasa_Quejas_Venta,
    f.Origen,
    f.Car_Age,

    -- 🔹 Sumatorio de leads
    COALESCE(TRY_CONVERT(INT, f.Lead_compra), 0) + 
    COALESCE(TRY_CONVERT(INT, f.Fue_Lead), 0) AS Total_Leads,

    -- 🔹 CHURN basado en tiempo desde la última revisión
    CASE 
        WHEN TRY_CONVERT(INT, f.DIAS_DESDE_ULTIMA_REVISION) > 400 THEN 1 
        ELSE 0 
    END AS Churn_Revision,

    -- 🔹 CHURN basado en ausencia de entradas al taller
    CASE 
        WHEN f.DIAS_EN_TALLER IS NULL OR f.DIAS_EN_TALLER = 0 THEN 1 
        ELSE 0 
    END AS Churn_Taller,

    -- 🔹 CHURN por fin de garantía
    CASE 
        WHEN f.FIN_GARANTIA IS NOT NULL AND f.FIN_GARANTIA < GETDATE() THEN 1
        ELSE 0
    END AS Churn_FinGarantia,

    -- 🔹 CHURN por baja interacción (0 revisiones + pocos km)
    CASE 
        WHEN (COALESCE(f.Revisiones, 0) = 0 AND COALESCE(f.km_ultima_revision, 0) < 5000) THEN 1
        ELSE 0
    END AS Churn_BajaInteraccion,

    -- 🔹 CHURN basado en falta de VAS (servicios adicionales)
    CASE 
        WHEN 
            (ISNULL(f.MANTENIMIENTO_GRATUITO, '0') = '0' OR f.MANTENIMIENTO_GRATUITO IS NULL) AND
            (ISNULL(f.SEGURO_BATERIA_LARGO_PLAZO, '0') = '0' OR f.SEGURO_BATERIA_LARGO_PLAZO IS NULL) AND
            (ISNULL(f.EXTENSION_GARANTIA, '') = '') 
        THEN 1
        ELSE 0
    END AS Churn_VAS

FROM [dbo].[Dim_client] AS c
LEFT JOIN [dbo].[fact_sales] AS f 
    ON c.Customer_ID = f.Customer_ID;
