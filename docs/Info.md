# **Identificación de Fuentes de Datos**

## **Definición de los Sistemas Involucrados**

Para el desarrollo de un Data Warehouse (DW), es esencial identificar correctamente las fuentes de datos relevantes. Estas provienen de diversos sistemas que la empresa utiliza para gestionar sus operaciones y procesos clave, y permiten obtener una visión integral de la organización.

Los sistemas involucrados son los siguientes:

- **ERP (Enterprise Resource Planning):** Sistema integral de gestión empresarial que abarca módulos clave como ventas, compras, inventarios, contabilidad y recursos humanos. El ERP es la fuente principal de datos transaccionales y operativos.
- **CRM (Customer Relationship Management):** Plataforma utilizada para gestionar la relación con los clientes, almacenando información sobre su historial de compras, interacciones, preferencias y comportamiento.
- **Logística:** Sistema que gestiona la cadena de suministro, incluyendo movimientos de productos, tiempos de entrega, almacenes y seguimiento de pedidos.
- **Postventa:** Gestión de todas las actividades relacionadas con el servicio postventa, como garantías, devoluciones, reparaciones, mantenimiento, y soporte técnico.
- **Marketing:** Sistema que recopila y analiza datos sobre campañas publicitarias, comportamiento del consumidor, segmentación de mercados y efectividad de las estrategias de marketing.

## **Tablas Relevantes en Cada Sistema**

| **Tabla**             | **Descripción Mejorada**                                                                 | **Sistema Fuente**            |
|-----------------------|------------------------------------------------------------------------------------------|------------------------------|
| `001_sales`           | Información detallada de las ventas, incluyendo productos vendidos, cantidades, precios, impuestos aplicados, descuentos, y garantías asociadas. | ERP                          |
| `002_date`            | Tabla con información sobre fechas relevantes como días de la semana, festivos nacionales, períodos comerciales y de ofertas especiales. | ERP / Sistema de gestión de tiempos |
| `003_clientes`        | Almacena información demográfica (edad, género, ubicación) y comportamiento de los clientes (historial de compras, preferencias y feedback). | CRM                          |
| `004_rev`             | Registra datos sobre inspecciones, revisiones y mantenimiento de productos, incluyendo fechas y tipos de servicios realizados. | Postventa                    |
| `005_cp`              | Contiene los códigos postales y regiones geográficas, así como el análisis de la ubicación de los clientes y su relación con la demanda. | Logística                    |
| `006_producto`        | Especificaciones de productos, incluidas categorías, marcas, modelos, características técnicas, precios y proveedores. | ERP                          |
| `007_costes`          | Registra los costos operativos, costos logísticos, márgenes de ganancia y otros gastos relacionados con las ventas y operaciones. | ERP                          |
| `008_cac`             | Datos relacionados con las reclamaciones, fallas de productos, tiempos de respuesta y soluciones proporcionadas a los clientes. | Postventa                    |
| `009_motivo_venta`    | Análisis de los factores que influyen en la decisión de compra de los clientes, como promociones, precios, características del producto, etc. | ERP                          |
| `010_forma_pago`      | Almacena los diferentes métodos de pago utilizados en las transacciones comerciales, incluyendo tarjetas, pagos electrónicos, transferencias bancarias, etc. | ERP                          |
| `011_tienda`          | Información sobre las tiendas físicas, incluyendo ubicación, tamaño, personal, ventas por tienda y zonas de operación. | ERP                          |
| `012_provincia`       | Datos de provincias con su descripción, códigos y demarcaciones geográficas.              | ERP                          |
| `013_zona`            | Segmentación de zonas de mercado, incluyendo análisis de demanda y tendencias regionales. | ERP                          |
| `014_categoría_producto` | Agrupación de productos en categorías específicas, con detalles sobre tipo de equipamiento y características. | ERP                          |
| `015_fuel`            | Información sobre los distintos tipos de combustible disponibles, así como su precio, distribución y consumo en el sistema. | ERP                          |
| `016_origen_venta`    | Registro del origen de las ventas, categorizado por canal de venta (online, físico, telefónico, etc.) o estrategia de comercialización. | ERP                          |
| `017_logist`          | Información detallada de los procesos logísticos, incluyendo fechas de producción, rutas de distribución, tiempos de entrega y almacenamiento. | Logística                    |
| `018_edad`            | Registra la antigüedad de los productos, su tiempo de circulación en el mercado y su estado actual. | Postventa                    |
| `019_Mosaic`          | Segmentación avanzada de clientes utilizando el análisis de características demográficas y hábitos de consumo, permitiendo la personalización de ofertas. | CRM                          |
| `020_marketing_campaign` | Detalles sobre campañas de marketing, incluyendo canales utilizados, segmentación del público objetivo, presupuesto y resultados de las campañas. | Marketing                    |

