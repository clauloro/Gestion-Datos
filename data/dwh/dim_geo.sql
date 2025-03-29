-- Esta consulta recupera la información de las tiendas junto con la provincia y zona asociadas a cada una,
-- utilizando LEFT JOINs entre las tablas de tiendas, provincias y zonas para obtener los datos completos.

SELECT
    tienda.TIENDA_ID,        -- Identificador único de la tienda (de la tabla 011_tienda).
    tienda.TIENDA_DESC,      -- Descripción o nombre de la tienda.
    provincia.PROV_DESC,     -- Nombre de la provincia donde se encuentra la tienda (de la tabla 012_provincia).
    zona.ZONA                -- Nombre de la zona geográfica de la tienda (de la tabla 013_zona).

FROM DATAEX.[011_tienda] tienda  -- Alias "tienda" para la tabla de tiendas (011_tienda).
LEFT JOIN DATAEX.[012_provincia] provincia ON tienda.PROVINCIA_ID = provincia.PROVINCIA_ID  -- Relaciona tiendas con provincias (*:1).
LEFT JOIN DATAEX.[013_zona] zona ON tienda.ZONA_ID = zona.ZONA_ID  -- Relaciona tiendas con zonas geográficas (*:1).


