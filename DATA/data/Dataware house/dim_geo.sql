-- COMPROBACIÓN DE DIMENSIÓN: SELECT COUNT(*) AS Num_Tiendas FROM DATAEX.[011_tienda];
/*  
TIPO DE DATOS:
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('011_tienda', '012_provincia', '013_zona') AND TABLE_SCHEMA = 'DATAEX';
*/

SELECT
    tienda.TIENDA_ID,        -- ID de la tienda (tabla 011_tienda).
    tienda.TIENDA_DESC,      -- Descripción de la tienda.
    provincia.PROV_DESC,     -- Nombre de la provincia.
    zona.ZONA               -- Nombre de la zona.

FROM DATAEX.[011_tienda] tienda  -- Alias "tienda" para la tabla 011_tienda.
LEFT JOIN DATAEX.[012_provincia] provincia ON tienda.PROVINCIA_ID = provincia.PROVINCIA_ID  -- Join con provincia (*:1).
LEFT JOIN DATAEX.[013_zona] zona ON tienda.ZONA_ID = zona.ZONA_ID  -- Join con zona (*:1).

