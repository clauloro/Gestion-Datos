-- VERIFICACIÓN DEL NÚMERO TOTAL DE PRODUCTOS  
/* SELECT COUNT(*) AS Num_Product FROM [DATAEX].[006_producto];  

CONSULTA PARA REVISAR LOS TIPOS DE DATOS DE LAS TABLAS INVOLUCRADAS 
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE  FROM INFORMATION_SCHEMA.COLUMNS  
WHERE TABLE_NAME IN ('006_producto', '007_costes', '014_categoría_producto', '015_fuel')  
AND TABLE_SCHEMA = 'DATAEX';  
*/
-- CONSTRUCCIÓN DE LA DIMENSIÓN DE PRODUCTOS  
SELECT  
    producto.Id_Producto,          -- Identificador único del producto.  
    producto.Code_,                -- Código alternativo del producto.  
    producto.Kw,                   -- Potencia en kilovatios.  
    producto.TIPO_CARROCERIA,      -- Tipo de carrocería del vehículo.  
    producto.TRANSMISION_ID,       -- Tipo de transmisión.  

    -- Información sobre la categoría del producto.  
    categoria_producto.Equipamiento,  

    -- Tipo de combustible utilizado.  
    fuel.FUEL,  

    -- Costos asociados al producto.  
    costes.Margen,  
    costes.Costetransporte,  
    costes.Margendistribuidor,  
    costes.GastosMarketing,  
    costes.Mantenimiento_medio,  
    costes.Comisión_Marca  

FROM [DATAEX].[006_producto] producto  
LEFT JOIN [DATAEX].[007_costes] costes ON producto.Modelo = costes.Modelo  -- Relación con los costos del producto (*:1).  
LEFT JOIN [DATAEX].[014_categoría_producto] categoria_producto ON producto.CATEGORIA_ID = categoria_producto.CATEGORIA_ID  -- Relación con la categoría del producto (*:1).  
LEFT JOIN [DATAEX].[015_fuel] fuel ON producto.Fuel_ID = fuel.Fuel_ID;  -- Relación con el tipo de combustible (*:1).  
