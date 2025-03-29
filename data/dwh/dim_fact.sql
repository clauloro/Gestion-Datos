-- Esta consulta genera la tabla de hechos de ventas, incorporando información de distintas fuentes como 
-- revisiones, quejas, logística, formas de pago y otros detalles relevantes para cada venta.

SELECT  
    sales.CODE,                          -- Identificador único de la venta.  
    sales.Code_,                         -- Referencia del producto vendido.  
    sales.COSTE_VENTA_NO_IMPUESTOS,      -- Coste de la venta antes de impuestos.  
    sales.Customer_ID,                   -- Identificador del cliente asociado a la venta.  
    sales.EN_GARANTIA,                   -- Indica si el producto vendido tiene garantía.  
    sales.EXTENSION_GARANTIA,            -- Indica si se adquirió una extensión de garantía.  
    CONVERT(DATE, sales.FIN_GARANTIA, 103) AS Fin_Garantia, -- Fecha de finalización de la garantía en formato DD/MM/YYYY.  
    sales.Id_Producto,                   -- Identificador del producto vendido.  
    sales.IMPUESTOS,                     -- Impuestos aplicados a la venta.  
    sales.MANTENIMIENTO_GRATUITO,        -- Si el mantenimiento está incluido o no.  
    sales.PVP,                           -- Precio de venta al público.  
    CONVERT(DATE, sales.Sales_Date, 103) AS Sales_Date, -- Fecha de la transacción de venta.  
    sales.SEGURO_BATERIA_LARGO_PLAZO,    -- Si se incluyó un seguro para la batería del producto.  
    sales.TIENDA_ID,                     -- Identificador de la tienda donde se realizó la venta.  

    -- Información de las revisiones del producto vendido.
    CONVERT(DATE, revisions.DATE_UTIMA_REV, 103) AS DATE_ULTIMA_REVISION,  
    CAST(REPLACE(revisions.DIAS_DESDE_ULTIMA_REVISION, '.', '') AS INT) AS DIAS_DESDE_ULTIMA_REVISION,  
    revisions.Km_medio_por_revision,  
    revisions.km_ultima_revision,  
    revisions.Revisiones,  

    -- Información sobre quejas y tiempos de permanencia en taller.
    cac.DIAS_DESDE_LA_ULTIMA_ENTRADA_TALLER,  
    cac.DIAS_EN_TALLER,  
    cac.QUEJA,  

    -- Motivo de la venta, capturado de la tabla de motivos de compra.
    motivo_venta.MOTIVO_VENTA,  

    -- Forma de pago utilizada en la venta.
    forma_pago.FORMA_PAGO,  
    forma_pago.FORMA_PAGO_GRUPO,  

    -- Datos de logística relacionados con el producto vendido.
    logist.Fue_Lead,  
    logist.Lead_compra,  
    CONVERT(DATE, logist.Logistic_date, 103) AS Logistic_date,  
    CONVERT(DATE, logist.Prod_date, 103) AS Prod_date,  
    logist.t_logist_days,  
    logist.t_prod_date,  
    logist.t_stock_dates,  

    -- Información sobre el canal de venta, que indica el origen de la compra.
    origen_venta.Origen,  

    -- Edad del vehículo en el momento de la venta.
    edad_coche.Car_Age,  

    -- Cálculos financieros asociados a la venta.  
    -- Margen bruto antes de otros costes asociados.  
    ROUND(sales.PVP * (costes.Margen) * 0.01 * (1 - sales.IMPUESTOS / 100), 2) AS Margen_Eur_bruto,  

    -- Margen neto, teniendo en cuenta costes adicionales y gastos asociados.  
    ROUND(sales.PVP * (costes.Margen) * 0.01 * (1 - sales.IMPUESTOS / 100)  
        - sales.COSTE_VENTA_NO_IMPUESTOS  
        - (costes.Margendistribuidor * 0.01 + costes.GastosMarketing * 0.01 - costes.Comisión_Marca * 0.01) * sales.PVP * (1 - sales.IMPUESTOS / 100)  
        - costes.Costetransporte, 2) AS Margen_Eur,  

    -- Cálculo del coste total de la venta, sumando todos los costes asociados.  
    sales.COSTE_VENTA_NO_IMPUESTOS + (costes.Margendistribuidor * 0.01 + costes.GastosMarketing * 0.01 - costes.Comisión_Marca * 0.01) * sales.PVP * (1 - sales.IMPUESTOS / 100)  
    + costes.Costetransporte AS Coste_Total_Venta,  

    -- Identificación de ventas que han generado quejas.  
    CASE WHEN cac.QUEJA IS NOT NULL THEN 1 ELSE 0 END AS Tasa_Quejas_Venta,  

    -- Cálculo de la tasa de Churn, que indica si la venta ha sido cancelada (basado en la revisión).
    CASE
        -- Caso 1: Revisión reciente o sin revisión (0-400 días) - No churn.
        WHEN
            revisions.DIAS_DESDE_ULTIMA_REVISION IS NOT NULL AND
            revisions.DIAS_DESDE_ULTIMA_REVISION <> '' AND
            TRY_CAST(REPLACE(revisions.DIAS_DESDE_ULTIMA_REVISION, '.', '') AS INT) BETWEEN 0 AND 400
        THEN 0
        -- Caso 2: Revisión muy antigua (>400 días) - Churn.
        WHEN
            revisions.DIAS_DESDE_ULTIMA_REVISION IS NOT NULL AND
            revisions.DIAS_DESDE_ULTIMA_REVISION <> '' AND
            TRY_CAST(REPLACE(revisions.DIAS_DESDE_ULTIMA_REVISION, '.', '') AS INT) > 400
        THEN 1
        -- Caso 3: Otros valores inesperados - Churn por precaución.
        ELSE 1
    END AS Churn

FROM [DATAEX].[001_sales] sales  

-- Relación con la tabla de revisiones del producto (*1:1*).
LEFT JOIN [DATAEX].[004_rev] revisions ON sales.CODE = revisions.CODE  

-- Relación con la tabla de quejas y tiempos en taller (*1:0..1*).
LEFT JOIN [DATAEX].[008_cac] cac ON sales.CODE = cac.CODE  

-- Relación con la tabla de motivos de la venta (*1:1*).
LEFT JOIN [DATAEX].[009_motivo_venta] motivo_venta ON sales.MOTIVO_VENTA_ID = motivo_venta.MOTIVO_VENTA_ID  

-- Relación con la tabla de formas de pago (*1:1*).
LEFT JOIN [DATAEX].[010_forma_pago] forma_pago ON sales.FORMA_PAGO_ID = forma_pago.FORMA_PAGO_ID  

-- Relación con la tabla que contiene la edad del coche en la venta (*1:0..1*).
LEFT JOIN [DATAEX].[018_edad] edad_coche ON sales.CODE = edad_coche.CODE  

-- Relación con la tabla de logística (*1:1*), seguida de la tabla de origen de la venta (*1:1*).
LEFT JOIN [DATAEX].[017_logist] logist ON sales.CODE = logist.CODE  
LEFT JOIN [DATAEX].[016_origen_venta] origen_venta ON logist.Origen_Compra_ID = origen_venta.Origen_Compra_ID  

-- Relación con la tabla de productos vendidos (*1:1*).
LEFT JOIN [DATAEX].[006_producto] producto ON sales.Id_Producto = producto.Id_Producto  

-- Relación con la tabla de costes (*1:1*), para cálculo de márgenes y rentabilidad.
LEFT JOIN [DATAEX].[007_costes] costes ON producto.Modelo = costes.Modelo;
