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
    COALESCE(TRY_CONVERT(INT, f.Fue_Lead), 0) AS Total_Leads

FROM [dbo].[Dim_client] AS c
LEFT JOIN [dbo].[fact_sales] AS f 
    ON c.Customer_ID = f.Customer_ID;
