-- En este archivo se construye la dimensión de productos, que incluye información relevante sobre los productos
-- (en este caso, vehículos), tales como su identificación, características técnicas (potencia, tipo de carrocería, transmisión),
-- categoría, tipo de combustible utilizado, y diversos costos asociados como márgenes, costos de transporte, distribución, marketing,
-- mantenimiento y comisiones de la marca. 
--
-- Se realiza una consulta que utiliza LEFT JOINs entre las tablas de productos, costos, categorías de productos y tipos de combustible
-- para extraer la información completa de cada producto y sus respectivos atributos.

SELECT  
    producto.Id_Producto,          -- Identificador único del producto.  
    producto.Code_,                -- Código alternativo del producto.  
    producto.Kw,                   -- Potencia en kilovatios del producto (vehículo).  
    producto.TIPO_CARROCERIA,      -- Tipo de carrocería del vehículo.  
    producto.TRANSMISION_ID,       -- Tipo de transmisión del vehículo.  

    -- Se obtiene la categoría del producto, como equipamiento asociado a la categoría.
    categoria_producto.Equipamiento,  

    -- Se selecciona el tipo de combustible utilizado en el producto (vehículo).
    fuel.FUEL,  

    -- Información sobre los costos asociados al producto, incluyendo márgenes y gastos logísticos.
    costes.Margen,  
    costes.Costetransporte,  
    costes.Margendistribuidor,  
    costes.GastosMarketing,  
    costes.Mantenimiento_medio,  
    costes.Comisión_Marca  

FROM [DATAEX].[006_producto] producto  

-- Se hace un LEFT JOIN con la tabla de costos para obtener la información de costos relacionados con cada producto.
LEFT JOIN [DATAEX].[007_costes] costes ON producto.Modelo = costes.Modelo  -- Relación entre productos y costos basados en el modelo.  

-- Se hace un LEFT JOIN con la tabla de categorías de productos para obtener los datos de equipamiento de la categoría del producto.
LEFT JOIN [DATAEX].[014_categoría_producto] categoria_producto ON producto.CATEGORIA_ID = categoria_producto.CATEGORIA_ID  -- Relación entre productos y su categoría.  

-- Se hace un LEFT JOIN con la tabla de tipos de combustible para obtener el tipo de combustible de cada producto.
LEFT JOIN [DATAEX].[015_fuel] fuel ON producto.Fuel_ID = fuel.Fuel_ID;  -- Relación entre productos y su tipo de combustible.  
