-- REVISIÓN DEL TOTAL DE REGISTROS EN LA TABLA DE FECHAS  
/*SELECT COUNT(*) AS Total_Fechas FROM [DATAEX].[002_date];  

OBTENCIÓN DE LOS TIPOS DE DATOS DE LOS CAMPOS DE LA TABLA TEMPORAL
SELECT COLUMN_NAME, DATA_TYPE  
FROM INFORMATION_SCHEMA.COLUMNS  
WHERE TABLE_NAME = '002_date'  
AND TABLE_SCHEMA = 'DATAEX';  
 */  
-- CONSTRUCCIÓN DE LA DIMENSIÓN TEMPORAL  
SELECT  
    -- Conversión de fechas al formato DD/MM/YYYY.  
    CONVERT(DATE, Date, 103) AS Fecha,  
    CONVERT(DATE, InicioMes, 103) AS InicioMes,  
    CONVERT(DATE, FinMes, 103) AS FinMes,  

    -- Descomposición de la fecha en elementos individuales.  
    Dia,  
    Diadelasemana,  
    Diadelesemana_desc,  
    Mes,  
    Mes_desc,  
    Anno AS Año,  
    Annomes AS Añomes,  
    Week,  

    -- Cálculo de indicadores temporales adicionales.  
    DATEPART(QUARTER, CONVERT(DATE, Date, 103)) AS Trimestre,   -- Número de trimestre (1-4).  
    (DATEPART(DAY, CONVERT(DATE, Date, 103)) - 1) / 7 + 1 AS SemanaDelMes, -- Semana dentro del mes (1-5).  
    DATEPART(DAYOFYEAR, CONVERT(DATE, Date, 103)) AS DiaDelAño, -- Número de día dentro del año (1-365).  
    DATEDIFF(  
        DAY,  
        DATEFROMPARTS(YEAR(CONVERT(DATE, Date, 103)), ((DATEPART(QUARTER, CONVERT(DATE, Date, 103)) - 1) * 3 + 1), 1),  
        CONVERT(DATE, Date, 103)  
    ) + 1 AS DiaDelTrimestre, -- Día dentro del trimestre (1-90).  

    -- Identificación de días especiales.  
    Findesemana,  -- Indica si el día es sábado o domingo.  
    Festivo,      -- Marca si el día es feriado.  
    Laboral       -- Determina si el día es hábil.  

FROM [DATAEX].[002_date];  