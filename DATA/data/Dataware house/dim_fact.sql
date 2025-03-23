-- VERIFICACIÓN DEL TOTAL DE REGISTROS EN LA TABLA DE VENTAS  
/* SELECT COUNT(*) AS Num_Rows FROM [DATAEX].[001_sales];  

REVISIÓN DE LOS TIPOS DE DATOS DE LAS TABLAS INVOLUCRADAS  
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE  FROM INFORMATION_SCHEMA.COLUMNS  
WHERE TABLE_NAME IN ('001_sales', '004_rev', '008_cac',  
                    '009_motivo_venta', '010_forma_pago', '017_logist',  
                    '016_origen_venta', '018_edad', '006_producto', '007_costes')  
AND TABLE_SCHEMA = 'DATAEX';  
*/
-- CREACIÓN DE LA TABLA DE HECHOS PARA VENTAS  
SELECT  
    sales.CODE,                          -- Identificador único de la venta.  
    sales.Code_,                         -- Referencia del producto vendido.  
    sales.COSTE_VENTA_NO_IMPUESTOS,      -- Coste de la venta antes de impuestos.  
    sales.Customer_ID,                   -- Cliente asociado a la venta.  
    sales.EN_GARANTIA,                   -- Indica si el producto vendido tiene garantía.  
    sales.EXTENSION_GARANTIA,            -- Indica si se adquirió una extensión de garantía.  
    CONVERT(DATE, sales.FIN_GARANTIA, 103) AS Fin_Garantia, -- Fecha de fin de garantía en formato DD/MM/YYYY.  
    sales.Id_Producto,                   -- Identificador del producto vendido.  
    sales.IMPUESTOS,                     -- Impuestos aplicados a la venta.  
    sales.MANTENIMIENTO_GRATUITO,        -- Si el mantenimiento está incluido o no.  
    sales.PVP,                           -- Precio de venta al público.  
    CONVERT(DATE, sales.Sales_Date, 103) AS Sales_Date, -- Fecha de la transacción.  
    sales.SEGURO_BATERIA_LARGO_PLAZO,    -- Si se incluyó un seguro para la batería.  
    sales.TIENDA_ID,                     -- Identificador de la tienda donde se realizó la venta.  

    -- Información sobre revisiones.  
    CONVERT(DATE, revisions.DATE_UTIMA_REV, 103) AS DATE_ULTIMA_REVISION,  
    CAST(REPLACE(revisions.DIAS_DESDE_ULTIMA_REVISION, '.', '') AS INT) AS DIAS_DESDE_ULTIMA_REVISION,  
    revisions.Km_medio_por_revision,  
    revisions.km_ultima_revision,  
    revisions.Revisiones,  

    -- Información sobre quejas y tiempos en taller.  
    cac.DIAS_DESDE_LA_ULTIMA_ENTRADA_TALLER,  
    cac.DIAS_EN_TALLER,  
    cac.QUEJA,  

    -- Motivo de la compra.  
    motivo_venta.MOTIVO_VENTA,  

    -- Método de pago utilizado.  
    forma_pago.FORMA_PAGO,  
    forma_pago.FORMA_PAGO_GRUPO,  

    -- Datos relacionados con logística.  
    logist.Fue_Lead,  
    logist.Lead_compra,  
    CONVERT(DATE, logist.Logistic_date, 103) AS Logistic_date,  
    CONVERT(DATE, logist.Prod_date, 103) AS Prod_date,  
    logist.t_logist_days,  
    logist.t_prod_date,  
    logist.t_stock_dates,  

    -- Información del canal de venta.  
    origen_venta.Origen,  

    -- Edad del vehículo en la venta.  
    edad_coche.Car_Age,  

    -- Análisis financiero del producto vendido.  
        -- Cálculo del margen bruto antes de otros costes asociados.  
    ROUND(sales.PVP * (costes.Margen) * 0.01 * (1 - sales.IMPUESTOS / 100), 2) AS Margen_Eur_bruto,  

        -- Cálculo del margen neto considerando costes adicionales.  
    ROUND(sales.PVP * (costes.Margen) * 0.01 * (1 - sales.IMPUESTOS / 100)  
        - sales.COSTE_VENTA_NO_IMPUESTOS  
        - (costes.Margendistribuidor * 0.01 + costes.GastosMarketing * 0.01 - costes.Comisión_Marca * 0.01) * sales.PVP * (1 - sales.IMPUESTOS / 100)  
        - costes.Costetransporte, 2) AS Margen_Eur,  

        -- Cálculo del coste total de la venta, incluyendo todos los gastos asociados.  
    sales.COSTE_VENTA_NO_IMPUESTOS + (costes.Margendistribuidor * 0.01 + costes.GastosMarketing * 0.01 - costes.Comisión_Marca * 0.01) * sales.PVP * (1 - sales.IMPUESTOS / 100)  
    + costes.Costetransporte AS Coste_Total_Venta,  

        -- Identificación de ventas que generaron quejas.  
    CASE WHEN cac.QUEJA IS NOT NULL THEN 1 ELSE 0 END AS Tasa_Quejas_Venta  

FROM [DATAEX].[001_sales] sales  

-- Enlace con la información de revisiones (*1:1*).  
LEFT JOIN [DATAEX].[004_rev] revisions ON sales.CODE = revisions.CODE  

-- Relación con datos de quejas y tiempos en taller (*1:0..1*).  
LEFT JOIN [DATAEX].[008_cac] cac ON sales.CODE = cac.CODE  

-- Asociación con la tabla de motivos de venta (*1:1*).  
LEFT JOIN [DATAEX].[009_motivo_venta] motivo_venta ON sales.MOTIVO_VENTA_ID = motivo_venta.MOTIVO_VENTA_ID  

-- Relación con las formas de pago (*1:1*).  
LEFT JOIN [DATAEX].[010_forma_pago] forma_pago ON sales.FORMA_PAGO_ID = forma_pago.FORMA_PAGO_ID  

-- Relación con la edad del vehículo en la venta (*1:0..1*).  
LEFT JOIN [DATAEX].[018_edad] edad_coche ON sales.CODE = edad_coche.CODE  

-- Asociación con logística (*1:1*), seguida de la relación con el origen de la venta (*1:1*).  
LEFT JOIN [DATAEX].[017_logist] logist ON sales.CODE = logist.CODE  
LEFT JOIN [DATAEX].[016_origen_venta] origen_venta ON logist.Origen_Compra_ID = origen_venta.Origen_Compra_ID  

-- Relación con la información de productos vendidos (*1:1*).  
LEFT JOIN [DATAEX].[006_producto] producto ON sales.Id_Producto = producto.Id_Producto  

-- Asociación con la tabla de costes para cálculo de márgenes y rentabilidad (*1:1*).  
LEFT JOIN [DATAEX].[007_costes] costes ON producto.Modelo = costes.Modelo;  
