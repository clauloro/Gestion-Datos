# **Identificación de Fuentes de Datos**

## **Definición de los Sistemas Involucrados**

Para el desarrollo del Data Warehouse (DW), es fundamental identificar las fuentes de datos relevantes. Estas provienen de distintos sistemas que la empresa utiliza para gestionar operaciones y procesos clave.

Los principales sistemas involucrados son:

- **ERP (Enterprise Resource Planning):** Sistema central de gestión que almacena información sobre productos, ventas, clientes, inventarios y logística.
- **CRM (Customer Relationship Management):** Plataforma utilizada para la gestión de clientes, incluyendo datos de contacto, historial de compras, reclamaciones y preferencias.
- **Logística:** Base de datos donde se registran movimientos de productos, tiempos de entrega, seguimiento de pedidos y almacenamiento.
- **Postventa:** Información sobre garantías, devoluciones, mantenimiento y soporte técnico.

# **Tablas Relevantes en Cada Sistema**

| **Tabla**            | **Descripción Modificada**                                                            | **Sistema Fuente**            |
|----------------------|--------------------------------------------------------------------------------------|------------------------------|
| `001_sales`         | Registra información de ventas, costos, impuestos y garantías asociadas a los productos vendidos. | ERP                          |
| `002_date`          | Contiene datos de fechas, incluyendo días de la semana, festivos y períodos comerciales. | ERP (o sistema de gestión de tiempos) |
| `003_clientes`      | Almacena información demográfica y de comportamiento de los clientes registrados.      | CRM                          |
| `004_rev`          | Guarda detalles sobre inspecciones, revisiones y mantenimiento de productos.          | Postventa                    |
| `005_cp`           | Incluye información de códigos postales, regiones y ubicación geográfica de clientes. | Logística                    |
| `006_producto`     | Base de datos con especificaciones de productos, categorías, modelos y características. | ERP                          |
| `007_costes`       | Contabiliza costos logísticos, márgenes de ganancia y gastos publicitarios.            | ERP                          |
| `008_cac`         | Contiene registros sobre reclamaciones, fallas en productos y tiempos de servicio.     | Postventa                    |
| `009_motivo_venta` | Lista los principales factores que influyen en la decisión de compra de los clientes.  | ERP                          |
| `010_forma_pago`   | Almacena los diferentes métodos de pago utilizados en las transacciones comerciales.   | ERP                          |
| `011_tienda`       | Contiene datos de tiendas físicas, su distribución y zonas de operación.               | ERP                          |
| `012_provincia`    | Guarda descripciones de provincias y sus respectivos códigos identificadores.          | ERP                          |
| `013_zona`        | Proporciona información sobre zonas de mercado y su segmentación geográfica.           | ERP                          |
| `014_categoría_producto` | Agrupa productos según sus categorías, equipamiento y características especiales.  | ERP                          |
| `015_fuel`         | Identifica los diferentes tipos de combustible disponibles en el sistema.              | ERP                          |
| `016_origen_venta` | Clasifica el origen de las ventas según su canal o estrategia de comercialización.     | ERP                          |
| `017_logist`       | Contiene información detallada sobre logística, fechas de producción y distribución.   | Logística                    |
| `018_edad`        | Registra la antigüedad de los productos vendidos y su tiempo de circulación en el mercado. | Postventa                 |
| `019_Mosaic`       | Contiene análisis de clientes según características demográficas y hábitos de consumo. | CRM                          |
