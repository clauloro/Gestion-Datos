-- VALIDACIÓN DEL NÚMERO DE CLIENTES EN LA TABLA  
-- SELECT COUNT(*) AS Num_Clients FROM [DATAEX].[003_clientes];  

/*  
   CONSULTA PARA VERIFICAR LOS TIPOS DE DATOS DE LAS TABLAS INVOLUCRADAS  
   SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE  
   FROM INFORMATION_SCHEMA.COLUMNS  
   WHERE TABLE_NAME IN ('003_clientes', '005_cp', '019_mosaic')  
   AND TABLE_SCHEMA = 'DATAEX';  
*/  


-- CONSULTA PARA UNIR INFORMACIÓN DE CLIENTES, UBICACIÓN Y SEGMENTACIÓN  
SELECT  
    cliente.Customer_ID,  -- Identificador único del cliente (PK de 003_clientes).  
    cliente.Edad,  
    CONVERT(DATE, cliente.Fecha_nacimiento, 103) AS Fecha_nacimiento,  -- Conversión de la fecha al formato DD/MM/YYYY.  
    cliente.GENERO,  
    cliente.STATUS_SOCIAL,  
    cliente.RENTA_MEDIA_ESTIMADA,  
    cliente.ENCUESTA_ZONA_CLIENTE_VENTA,  
    cliente.ENCUESTA_CLIENTE_ZONA_TALLER,  
    RIGHT('00000' + REPLACE(cliente.CODIGO_POSTAL, 'CP', ''), 5) AS CODIGO_POSTAL,  -- Normalización del código postal (eliminación de prefijo "CP").  

    -- Datos de ubicación del cliente  
    cp.poblacion,  
    cp.provincia,  
    CAST(cp.lat AS FLOAT) AS lat,  -- Conversión de latitud a tipo FLOAT para cálculos geoespaciales.  
    CAST(cp.lon AS FLOAT) AS lon,  -- Conversión de longitud a tipo FLOAT.  

    -- Datos de segmentación Mosaic  
    mosaic.A,  
    mosaic.B,  
    mosaic.C,  
    mosaic.D,  
    mosaic.E,  
    mosaic.F,  
    mosaic.G,  
    mosaic.H,  
    mosaic.I,  
    mosaic.J,  
    mosaic.K,  
    mosaic.U,  
    mosaic.Max_Mosaic_G,  
    mosaic.Max_Mosaic2,  
    mosaic.Renta_Media,  
    mosaic.F2,  
    mosaic.Mosaic_number,  
    mosaic.PROV  

FROM [DATAEX].[003_clientes] cliente  

-- Unión con la tabla de códigos postales usando el campo CP  
LEFT JOIN [DATAEX].[005_cp] cp ON cliente.CODIGO_POSTAL = cp.CP  

-- Unión con la tabla de segmentación Mosaic  
-- Se usa TRY_CAST para convertir codigopostalid a INT y enlazarlo con CP_value (clave en Mosaic).  
LEFT JOIN [DATAEX].[019_mosaic] mosaic ON TRY_CAST(cp.codigopostalid AS INT) = mosaic.CP_value;  


