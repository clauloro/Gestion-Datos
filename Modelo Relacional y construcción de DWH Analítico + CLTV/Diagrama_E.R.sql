-- Diagrama Entidad-Relación en SQL (3FN)

-- Tabla Clientes
CREATE TABLE Clientes (
    Cliente_ID INT PRIMARY KEY,
    Nombre VARCHAR(255),
    Email VARCHAR(255) UNIQUE,
    Telefono VARCHAR(20),
    Fecha_Registro DATE
);

-- Tabla Vehiculos
CREATE TABLE Vehiculos (
    Vehiculo_ID INT PRIMARY KEY,
    Modelo VARCHAR(255),
    Anio INT,
    Precio DECIMAL(10,2),
    Tipo VARCHAR(50)
);

-- Tabla Ventas
CREATE TABLE Ventas (
    Venta_ID INT PRIMARY KEY,
    Cliente_ID INT,
    Vehiculo_ID INT,
    Fecha_Venta DATE,
    Monto_Total DECIMAL(10,2),
    FOREIGN KEY (Cliente_ID) REFERENCES Clientes(Cliente_ID),
    FOREIGN KEY (Vehiculo_ID) REFERENCES Vehiculos(Vehiculo_ID)
);

-- Tabla Postventa
CREATE TABLE Postventa (
    Postventa_ID INT PRIMARY KEY,
    Cliente_ID INT,
    Vehiculo_ID INT,
    Tipo_Servicio VARCHAR(255),
    Costo DECIMAL(10,2),
    Fecha DATE,
    FOREIGN KEY (Cliente_ID) REFERENCES Clientes(Cliente_ID),
    FOREIGN KEY (Vehiculo_ID) REFERENCES Vehiculos(Vehiculo_ID)
);

-- Tabla Financiamiento
CREATE TABLE Financiamiento (
    Financiamiento_ID INT PRIMARY KEY,
    Cliente_ID INT,
    Tipo VARCHAR(50),
    Monto DECIMAL(10,2),
    Intereses DECIMAL(5,2),
    Fecha_Inicio DATE,
    FOREIGN KEY (Cliente_ID) REFERENCES Clientes(Cliente_ID)
);

-- Tabla Suscripciones
CREATE TABLE Suscripciones (
    Suscripcion_ID INT PRIMARY KEY,
    Cliente_ID INT,
    Tipo VARCHAR(50),
    Costo_Mensual DECIMAL(10,2),
    Fecha_Alta DATE,
    FOREIGN KEY (Cliente_ID) REFERENCES Clientes(Cliente_ID)
);

-- Relación entre tablas en formato visual
-- Clientes (1) <---> (N) Ventas
-- Vehículos (1) <---> (N) Ventas
-- Clientes (1) <---> (N) Postventa
-- Vehículos (1) <---> (N) Postventa
-- Clientes (1) <---> (N) Financiamiento
-- Clientes (1) <---> (N) Suscripciones