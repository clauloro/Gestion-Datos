-- Esta consulta construye la dimensión temporal, desglosando las fechas en varios elementos temporales
-- como día, mes, trimestre y año, además de identificar días especiales como fines de semana, festivos y laborales.

SELECT  
    -- Conversión de fechas al formato DD/MM/YYYY.  
    CONVERT(DATE, Date, 103) AS Fecha,  -- Fecha original.  
    CONVERT(DATE, InicioMes, 103) AS InicioMes,  -- Inicio del mes correspondiente.  
    CONVERT(DATE, FinMes, 103) AS FinMes,  -- Fin del mes correspondiente.  

    -- Descomposición de la fecha en elementos individuales.
    Dia,  -- Día del mes (1-31).  
    Diadelasemana,  -- Día de la semana en formato numérico (1 = Lunes, 7 = Domingo).  
    Diadelesemana_desc,  -- Descripción del día de la semana (Lunes, Martes, etc.).  
    Mes,  -- Número del mes (1-12).  
    Mes_desc,  -- Descripción del mes (Enero, Febrero, etc.).  
    Anno AS Año,  -- Año de la fecha.  
    Annomes AS Añomes,  -- Combinación de año y mes (YYYYMM).  
    Week,  -- Número de semana del año.  

    -- Cálculo de indicadores temporales adicionales.
    DATEPART(QUARTER, CONVERT(DATE, Date, 103)) AS Trimestre,  -- Número de trimestre (1-4).  
    (DATEPART(DAY, CONVERT(DATE, Date, 103)) - 1) / 7 + 1 AS SemanaDelMes,  -- Semana dentro del mes (1-5).  
    DATEPART(DAYOFYEAR, CONVERT(DATE, Date, 103)) AS DiaDelAño,  -- Número de día dentro del año (1-365).  
    DATEDIFF(  
        DAY,  
        DATEFROMPARTS(YEAR(CONVERT(DATE, Date, 103)), ((DATEPART(QUARTER, CONVERT(DATE, Date, 103)) - 1) * 3 + 1), 1),  
        CONVERT(DATE, Date, 103)  
    ) + 1 AS DiaDelTrimestre,  -- Día dentro del trimestre (1-90).  

    -- Identificación de días especiales.
    Findesemana,  -- Indica si el día es sábado o domingo.  
    Festivo,  -- Marca si el día es feriado.  
    Laboral  -- Determina si el día es hábil (lunes a viernes, no festivo).  

FROM [DATAEX].[002_date];  -- Selección de la tabla de fechas.
