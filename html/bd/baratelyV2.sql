--=================================[ I N I C I O ]==========================================--------
-- Crear la base de datos
CREATE DATABASE barately;

-- Usar la base de datos
USE barately;

-- roles para usuarios
CREATE TABLE IF NOT EXISTS roles (
    rol_id INT AUTO_INCREMENT PRIMARY KEY,      -- ID único del rol
    rol_nombre VARCHAR(50) NOT NULL UNIQUE,     -- Nombre del rol
    rol_descripcion VARCHAR(255),                -- Descripción opcional del rol
    rol_situacion INT NOT NULL DEFAULT 1
);

-- Tabla para almacenar la información del personal
CREATE TABLE IF NOT EXISTS personal (
    per_codigo INT AUTO_INCREMENT PRIMARY KEY,  -- Código único del personal
    per_nombres VARCHAR(100) NOT NULL,          -- Nombres del personal
    per_apellidos VARCHAR(100) NOT NULL,        -- Apellidos del personal
    per_dpi BIGINT  NOT NULL DEFAULT 777,  -- DPI de 13 dígitos
    per_nit VARCHAR(12)   NULL,        -- NIT de hasta 12 caracteres alfanuméricos
    per_tel1 BIGINT  NOT NULL DEFAULT 777,    -- Teléfono principal (8 dígitos)
    per_tel2 BIGINT  NOT NULL DEFAULT 777,   -- Teléfono secundario (8 dígitos)
    per_mail VARCHAR(50)NULL,                       -- Correo electrónico
    per_imagen LONGBLOB NULL,                     -- Imagen del personal (almacenada en formato binario)
    per_direccion VARCHAR(255) NULL,                 -- Dirección del personal
    per_fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha de registro
    per_rol_id INT NOT NULL DEFAULT 3,
    per_situacion INT NOT NULL DEFAULT 1,        -- Estado del registro (1 = Activo, 0 = Inactivo)
    FOREIGN KEY (per_rol_id) REFERENCES roles(rol_id)
);
 

SHOW VARIABLES LIKE 'max_allowed_packet';

 
CREATE INDEX idx_personal_nombre ON personal(per_nombres, per_apellidos);

 

-- tabla de usuarios
CREATE TABLE IF NOT EXISTS usuario (
    usu_codigo INT AUTO_INCREMENT PRIMARY KEY,         -- Código único del usuario
    usu_nombre VARCHAR(50) NOT NULL UNIQUE,            -- Nombre de usuario (debe ser único)
    usu_pass VARCHAR(255) NOT NULL,                     -- Contraseña (si el login es normal)
    rol_id INT NOT NULL,                               -- ID del rol (FK)
    usu_situacion INT NOT NULL DEFAULT 1,              -- Estado del registro (1 = Activo, 0 = Inactivo)
    proveedor VARCHAR(50) NULL,                         -- El nombre del proveedor de autenticación (Google, Facebook, etc.)
    proveedor_id VARCHAR(255) NULL,                     -- El ID único del usuario proporcionado por el proveedor (debe ser único)
    FOREIGN KEY (rol_id) REFERENCES roles(rol_id) ON DELETE CASCADE, -- Relación con roles
    UNIQUE (proveedor, proveedor_id),                    -- Un índice único para evitar múltiples registros con el mismo proveedor e ID
    UNIQUE (usu_nombre)                                -- Un índice único para el nombre de usuario tradicional
);


-- Tabla para almacenar las categorías de productos
CREATE TABLE IF NOT EXISTS categoria (
    cat_codigo INT AUTO_INCREMENT PRIMARY KEY,    -- Código único de la categoría
    cat_nombre VARCHAR(100) NOT NULL,            -- Nombre de la categoría
    cat_descripcion VARCHAR(255),                -- Descripción adicional de la categoría
    cat_situacion INT NOT NULL DEFAULT 1          -- Estado del registro (1 = Activa, 0 = Inactiva)
);

-- Tabla para almacenar las subcategorías de productos
CREATE TABLE IF NOT EXISTS subcategoria (
    subcat_codigo INT AUTO_INCREMENT PRIMARY KEY,  -- Código único de la subcategoría
    subcat_nombre VARCHAR(100) NOT NULL,          -- Nombre de la subcategoría
    cat_codigo INT NOT NULL,                      -- Código de la categoría (FK)
    subcat_situacion INT NOT NULL DEFAULT 1,      -- Estado del registro (1 = Activa, 0 = Inactiva)
    FOREIGN KEY (cat_codigo) REFERENCES categoria(cat_codigo) ON DELETE CASCADE -- Relación con categoría
);


-- Tabla para almacenar la información de los colores de los productos
CREATE TABLE IF NOT EXISTS color (
    color_codigo INT AUTO_INCREMENT PRIMARY KEY,    -- Código único del color
    color_nombre VARCHAR(50) NOT NULL,             -- Nombre del color
    color_hex VARCHAR(7),                          -- Código HEX del color (ej. #FFFFFF)
    color_situacion INT NOT NULL DEFAULT 1          -- Estado del registro (1 = Activo, 0 = Inactivo)
);


-- Tabla para almacenar la información de las tallas
CREATE TABLE IF NOT EXISTS categoria_talla (
    talla_codigo INT AUTO_INCREMENT PRIMARY KEY,  -- Código único de la categoría de talla
    talla_nombre VARCHAR(50) NOT NULL UNIQUE,     -- Nombre de la categoría (ej. Bebé, Adulto, etc.)
    talla_descripcion VARCHAR(255),              -- Descripción adicional
    talla_situacion INT NOT NULL DEFAULT 1        -- Estado del registro (1 = Activa, 0 = Inactiva)
);


CREATE TABLE producto (
    prod_codigo INT AUTO_INCREMENT PRIMARY KEY,          -- Código único del producto
    prod_nombre VARCHAR(100) NOT NULL,                  -- Nombre del producto
    prod_descripcion TEXT,                               -- Descripción del producto
    prod_precio_costo DECIMAL(10, 2) NOT NULL,          -- Precio de costo del producto
    prod_precio_venta DECIMAL(10, 2) NOT NULL,          -- Precio de venta del producto
    prod_estado ENUM('Nuevo', 'Stock', 'En promoción', 'Devolucion', 'Mal Estado' ) NOT NULL, -- Estado del producto
    prod_imagen LONGBLOB,                                -- Imagen del producto almacenada como binario
    cat_codigo INT NOT NULL,                            -- Código de la categoría del producto (FK)
    subcat_codigo INT,                                  -- Código de la subcategoría del producto (FK)
    talla_codigo INT,                                   -- Código de la talla (FK)
    color_codigo INT,                                   -- Código del color (FK)
    per_codigo INT,                                     -- Código del proveedor (FK)
    prod_codigo_barra VARCHAR(100) NULL,  -- Añadir columna para almacenar el código de barras
    prod_situacion INT NOT NULL DEFAULT 1,              -- Estado del registro (1 = Disponible, 0 = No disponible)
    FOREIGN KEY (cat_codigo) REFERENCES categoria(cat_codigo) ON DELETE CASCADE, -- Relación con categoría
    FOREIGN KEY (subcat_codigo) REFERENCES subcategoria(subcat_codigo) ON DELETE SET NULL, -- Relación con subcategoría
    FOREIGN KEY (talla_codigo) REFERENCES categoria_talla(talla_codigo) ON DELETE SET NULL, -- Relación con talla
    FOREIGN KEY (color_codigo) REFERENCES color(color_codigo) ON DELETE SET NULL, -- Relación con color
    FOREIGN KEY (per_codigo) REFERENCES personal(per_codigo) ON DELETE SET NULL -- Relación con proveedor
);

CREATE INDEX idx_prod_codigo_barra ON producto(prod_codigo_barra);

 
-- Tabla para almacenar la cantidad de productos disponibles en inventario
CREATE TABLE inventario (
    inv_codigo INT AUTO_INCREMENT PRIMARY KEY,            -- Código único del inventario
    prod_codigo INT NOT NULL,                             -- Código del producto (FK)
    inv_cantidad INT NOT NULL DEFAULT 0,                  -- Cantidad disponible del producto
    inv_fecha_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Fecha de última actualización
    inv_situacion INT NOT NULL DEFAULT 1,                 -- Estado del registro (1 = Activo, 0 = Inactivo)
    FOREIGN KEY (prod_codigo) REFERENCES producto(prod_codigo) ON DELETE CASCADE  -- Relación con la tabla producto
);

-- Tabla para almacenar los movimientos de inventario (entradas, salidas, ajustes)
CREATE TABLE movimiento_inventario (
    mov_codigo INT AUTO_INCREMENT PRIMARY KEY,             -- Código único del movimiento
    prod_codigo INT NOT NULL,                              -- Código del producto (FK)
    mov_tipo ENUM('Entrada', 'Salida', 'Ajuste') NOT NULL, -- Tipo de movimiento
    mov_cantidad INT NOT NULL,                             -- Cantidad modificada (positiva o negativa)
    mov_fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Fecha y hora del movimiento
    mov_observaciones TEXT,                                -- Observaciones sobre el movimiento
    FOREIGN KEY (prod_codigo) REFERENCES producto(prod_codigo) ON DELETE CASCADE  -- Relación con la tabla producto
);


-- Tabla para almacenar los métodos de pago disponibles
CREATE TABLE metodo_pago (
    metodo_pago_id INT AUTO_INCREMENT PRIMARY KEY,    -- ID único del método de pago
    metodo_pago_nombre VARCHAR(50) NOT NULL UNIQUE,    -- Nombre del método de pago (Efectivo, Tarjeta, Transferencia, etc.)
    metodo_pago_situacion INT NOT NULL DEFAULT 1       -- Estado del registro (1 = Activo, 0 = Inactivo)
);


-- Tabla para almacenar la información de las ventas
CREATE TABLE venta (
    venta_codigo INT AUTO_INCREMENT PRIMARY KEY,    -- Código único de la venta
    cli_codigo INT,                                 -- Código del cliente (FK)
    per_codigo INT,                                 -- Código del personal que realizó la venta (FK)
    fecha_venta DATETIME NOT NULL,                  -- Fecha de la venta
    total_venta DECIMAL(10, 2) NOT NULL,            -- Total de la venta
    venta_pagada INT NOT NULL DEFAULT 0,            -- Indica si la venta ha sido pagada completamente (0 = Pendiente, 1 = Pagada)
    venta_situacion INT NOT NULL DEFAULT 1,         -- Estado del registro (1 = Activa, 0 = Inactiva)
    FOREIGN KEY (cli_codigo) REFERENCES personal(per_codigo),  -- Relación con la tabla cliente
    FOREIGN KEY (per_codigo) REFERENCES personal(per_codigo)   -- Relación con la tabla personal
);
 
 
-- Esta tabla puede ayudarte a clasificar los distintos tipos de pago (por comisión, por día, por quincena o por mes).
CREATE TABLE pago (
    pago_codigo INT AUTO_INCREMENT PRIMARY KEY,      -- ID único del tipo de pago
    pago_nombre VARCHAR(50) NOT NULL,            -- Nombre del tipo de pago (Comisión, Diario, Quincenal, Mensual)
    pago_descripcion VARCHAR(255),                -- Descripción opcional del tipo de pago
    pago_situacion SMALLINT NOT NULL DEFAULT 1    -- Situacion, activo a inactivo
);


-- Si los pagos están basados en comisiones por ventas, puedes tener una tabla para registrar las comisiones generadas por cada venta.
CREATE TABLE comision_venta (
    comision_codigo INT AUTO_INCREMENT PRIMARY KEY,    -- Código único de la comisión
    per_codigo INT,                                    -- Código del personal (FK)
    venta_codigo INT,                                  -- Código de la venta
    comision_monto DECIMAL(10, 2) NOT NULL,            -- Monto de la comisión
    fecha_pago DATETIME NOT NULL,                      -- Fecha de pago de la comisión
    comision_situacion INT NOT NULL DEFAULT 1,         -- Estado de la comisión (1 = Activa, 0 = Inactiva)
    FOREIGN KEY (per_codigo) REFERENCES personal(per_codigo) ON DELETE CASCADE,   -- Relación con el personal
    FOREIGN KEY (venta_codigo) REFERENCES venta(venta_codigo) ON DELETE CASCADE  -- Relación con las ventas (si existe una tabla de ventas)
);

-- La tabla que mencionaste puede ser mejorada para permitir el registro de distintos tipos de pagos, haciendo referencia a la tabla pago_tipo para indicar cómo se hace el pago.
CREATE TABLE pago_persona (
    pago_codigo INT AUTO_INCREMENT PRIMARY KEY,      -- Código único del pago
    per_codigo INT,                                  -- Código del personal que recibe el pago (FK)
    pago_tipo_id INT,                                -- ID del tipo de pago (FK)
    monto DECIMAL(10, 2) NOT NULL,                   -- Monto del pago
    fecha_pago DATETIME NOT NULL,                    -- Fecha del pago
    descripcion TEXT,                                -- Descripción del pago
    pago_situacion INT NOT NULL DEFAULT 1,           -- Estado del registro (1 = Activa, 0 = Inactiva)
    FOREIGN KEY (per_codigo) REFERENCES personal(per_codigo),  -- Relación con la tabla personal
    FOREIGN KEY (pago_tipo_id) REFERENCES pago(pago_codigo)  -- Relación con la tabla pago_tipo
);

-- Si necesitas llevar un control más detallado de los pagos, podrías tener una tabla de pago_detalle que almacene información adicional sobre cada pago realizado, como los periodos de pago o las comisiones asociadas.
CREATE TABLE pago_detalle (
    detalle_codigo INT AUTO_INCREMENT PRIMARY KEY,  -- Código único del detalle de pago
    pago_codigo INT,                                -- Código del pago (FK)
    periodo_inicio DATE,                            -- Fecha de inicio del periodo de pago
    periodo_fin DATE,                               -- Fecha de fin del periodo de pago
    monto_base DECIMAL(10, 2),                      -- Monto base del pago (por ejemplo, salario mensual)
    comision DECIMAL(10, 2),                        -- Monto de la comisión (si aplica)
    total_pago DECIMAL(10, 2),                      -- Total del pago (base + comisiones)
    FOREIGN KEY (pago_codigo) REFERENCES pago_persona(pago_codigo)  -- Relación con el pago
);



-- Tabla para almacenar las órdenes de compra
CREATE TABLE orden_compra (
    orden_codigo INT AUTO_INCREMENT PRIMARY KEY,    -- Código único de la orden
    cli_codigo INT,                                 -- Código del cliente (FK)
    per_codigo INT,                                 -- Código del personal que gestiona la orden (FK)
    orden_fecha DATETIME NOT NULL,                  -- Fecha de la orden
    orden_total DECIMAL(10, 2) NOT NULL,            -- Total de la orden
    orden_tipo ENUM('Mayorista', 'Consignación', 'Lote') NOT NULL, -- Tipo de compra
    orden_pagada INT NOT NULL DEFAULT 0,            -- Estado de pago de la orden (0 = Pendiente, 1 = Pagada)
    orden_situacion INT NOT NULL DEFAULT 1,         -- Estado del registro (1 = Activa, 0 = Inactiva)
    FOREIGN KEY (cli_codigo) REFERENCES personal(per_codigo),  -- Relación con la tabla cliente
    FOREIGN KEY (per_codigo) REFERENCES personal(per_codigo)   -- Relación con la tabla personal
);

CREATE INDEX idx_orden_fecha ON orden_compra(orden_fecha);


-- Tabla para almacenar los detalles de las órdenes de compra
CREATE TABLE detalle_orden (
    detalle_codigo INT AUTO_INCREMENT PRIMARY KEY,   -- Código único del detalle
    orden_codigo INT,                                -- Código de la orden (FK)
    prod_codigo INT,                                 -- Código del producto (FK)
    detalle_cantidad INT NOT NULL,                   -- Cantidad del producto en la orden
    detalle_precio DECIMAL(10, 2) NOT NULL,         -- Precio del producto en la orden
    detalle_situacion INT NOT NULL DEFAULT 1,        -- Estado del registro (1 = Activa, 0 = Inactiva)
    FOREIGN KEY (orden_codigo) REFERENCES orden_compra(orden_codigo),  -- Relación con la tabla orden_compra
    FOREIGN KEY (prod_codigo) REFERENCES producto(prod_codigo)          -- Relación con la tabla producto
);

CREATE TABLE pago_orden_compra (
    pago_codigo INT AUTO_INCREMENT PRIMARY KEY,      -- Código único del pago
    orden_codigo INT,                                -- Código de la orden de compra (FK)
    metodo_pago_id INT,                              -- Método de pago utilizado (FK)
    monto DECIMAL(10, 2) NOT NULL,                   -- Monto del pago
    fecha_pago DATETIME NOT NULL,                    -- Fecha en la que se realizó el pago
    descripcion TEXT,                                -- Descripción del pago
    pago_completado INT NOT NULL DEFAULT 0,          -- Indica si el pago está finalizado (0 = Pendiente, 1 = Completado)
    pago_situacion INT NOT NULL DEFAULT 1,           -- Estado del registro (1 = Activo, 0 = Inactivo)
    FOREIGN KEY (orden_codigo) REFERENCES orden_compra(orden_codigo), -- Relación con la orden de compra
    FOREIGN KEY (metodo_pago_id) REFERENCES metodo_pago(metodo_pago_id)  -- Relación con el método de pago
);


CREATE TABLE pago_venta (
    pago_codigo INT AUTO_INCREMENT PRIMARY KEY,      -- Código único del pago
    venta_codigo INT,                                -- Código de la venta (FK)
    metodo_pago_id INT,                              -- Método de pago utilizado (FK)
    monto DECIMAL(10, 2) NOT NULL,                   -- Monto del pago
    fecha_pago DATETIME NOT NULL,                    -- Fecha del pago
    descripcion TEXT,                                -- Descripción del pago
    pago_completado INT NOT NULL DEFAULT 0,          -- Indica si el pago está finalizado (0 = Pendiente, 1 = Completado)
    pago_situacion INT NOT NULL DEFAULT 1,           -- Estado del registro (1 = Activo, 0 = Inactivo)
    FOREIGN KEY (venta_codigo) REFERENCES venta(venta_codigo), -- Relación con la tabla venta
    FOREIGN KEY (metodo_pago_id) REFERENCES metodo_pago(metodo_pago_id)  -- Relación con la tabla método de pago
);

-- Tabla para almacenar los detalles de las ventas (productos vendidos)
CREATE TABLE detalle_venta (
    detalle_codigo INT AUTO_INCREMENT PRIMARY KEY,   -- Código único del detalle
    venta_codigo INT,                                -- Código de la venta (FK)
    prod_codigo INT,                                 -- Código del producto (FK)
    cantidad INT NOT NULL,                           -- Cantidad del producto vendido
    precio DECIMAL(10, 2) NOT NULL,                  -- Precio del producto en la venta
    detalle_situacion INT NOT NULL DEFAULT 1,        -- Estado del registro (1 = Activa, 0 = Inactiva)
    FOREIGN KEY (venta_codigo) REFERENCES venta(venta_codigo),  -- Relación con la tabla venta
    FOREIGN KEY (prod_codigo) REFERENCES producto(prod_codigo)  -- Relación con la tabla producto
);


CREATE INDEX idx_pago_fecha_venta ON pago_venta(fecha_pago);


-- Tabla para tipos de servicios básicos
CREATE TABLE servicio (
    ser_codigo INT AUTO_INCREMENT PRIMARY KEY, -- Código único del tipo de servicio
    ser_nombre VARCHAR(100) NOT NULL,         -- Nombre del servicio
    ser_descri VARCHAR(250) NOT NULL,         -- Descripción del servicio
    ser_tipo SMALLINT NOT NULL DEFAULT 1,     -- 01: Servicios básicos, 02: Rentas
    ser_sit SMALLINT NOT NULL DEFAULT 1       -- Situación: 1=Activo, 0=Inactivo
);

-- Tabla para almacenar los pagos y cobros de servicios básicos y rentas
CREATE TABLE pago_servicio (
    pagser_codigo INT AUTO_INCREMENT PRIMARY KEY,   -- Código único del pago
    pagser_per_codigo INT,                           -- Código del cliente (FK)
    pagser_ser_codigo INT,                           -- ID del tipo de servicio (FK)
    pagser_monto DECIMAL(10, 2) NOT NULL,              -- Monto del pago
    pagser_fecha_ini DATETIME NOT NULL,                     -- Fecha del pago
    pagser_fecha_fin DATETIME NOT NULL,                     -- Fecha del pago
    pagser_total DECIMAL(10, 2) NOT NULL,               -- Monto total del servicio (pago total)
    pagser_descripcion VARCHAR(250) NOT NULL,         -- Descripción del del pago
    pagser_pag_tipo_id INT NULL,                        -- Codigo del tipo de pago (por día, semana, quincena, mes)
    pagser_meto_pago_id INT NULL,                       -- Codigo del tipo de pago (efectivo, tarjeta)
    pagser_situacion INT NOT NULL DEFAULT 1,            -- Estado del registro (1 = cobos, 2 = Pagos, 0 = Inactivo)
    FOREIGN KEY (pagser_per_codigo) REFERENCES personal(per_codigo),  -- Relación con la tabla cliente
    FOREIGN KEY (pagser_ser_codigo) REFERENCES servicio(ser_codigo)  -- Relación con la tabla tipo_servicio
);

 
 
 CREATE INDEX idx_pago_fecha_servicio ON pago_servicio(pagser_fecha);


--=================================[ F I N ]==========================================--------

-- tabla de auditoria de persoanl
CREATE TABLE IF NOT EXISTS auditoria_personal (
    aud_codigo INT AUTO_INCREMENT PRIMARY KEY,
    per_codigo INT,
    usuario_modifico INT,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    campo_modificado VARCHAR(255),
    valor_anterior TEXT,
    valor_nuevo TEXT,
    FOREIGN KEY (per_codigo) REFERENCES personal(per_codigo),
    FOREIGN KEY (usuario_modifico) REFERENCES usuario(usu_codigo)
);

-- Trigger para actualizar el inventario cuando se realiza una venta
DELIMITER $$

CREATE TRIGGER actualizar_inventario_venta
AFTER INSERT ON detalle_venta
FOR EACH ROW
BEGIN
    DECLARE nueva_cantidad INT;

    -- Obtener la cantidad actual del producto en el inventario
    SELECT inv_cantidad INTO nueva_cantidad
    FROM inventario
    WHERE prod_codigo = NEW.prod_codigo;

    -- Actualizar el inventario, restando la cantidad vendida
    UPDATE inventario
    SET inv_cantidad = nueva_cantidad - NEW.cantidad
    WHERE prod_codigo = NEW.prod_codigo;

END $$

DELIMITER ;

-- Trigger para prevenir ventas cuando el inventario es insuficiente
DELIMITER $$

CREATE TRIGGER verificar_inventario_venta
BEFORE INSERT ON detalle_venta
FOR EACH ROW
BEGIN
    DECLARE cantidad_disponible INT;

    -- Verificar la cantidad disponible en inventario
    SELECT inv_cantidad INTO cantidad_disponible
    FROM inventario
    WHERE prod_codigo = NEW.prod_codigo;

    -- Si no hay suficiente inventario, generar un error
    IF cantidad_disponible < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente inventario para completar la venta';
    END IF;
END $$

DELIMITER ;



-- Procedimiento para agregar un nuevo producto

 

DELIMITER $$

CREATE PROCEDURE agregar_productos(
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_precio_costo DECIMAL(10, 2),
    IN p_precio_venta DECIMAL(10, 2),
    IN p_estado ENUM('Nuevo', 'Stock', 'En promoción', 'Devolucion', 'Mal Estado'),
    IN p_categoria INT,
    IN p_subcategoria INT,   -- Ahora subcategoria no tiene valor por defecto
    IN p_talla INT,          -- Ahora talla no tiene valor por defecto
    IN p_color INT,          -- Ahora color no tiene valor por defecto
    IN p_proveedor INT,      -- Ahora proveedor no tiene valor por defecto
    IN p_codigo_barra VARCHAR(100),  -- Código de barra opcional
    IN p_cantidad_inicial INT
)
BEGIN
    -- Declarar la variable para almacenar el ID del producto insertado
    DECLARE prod_id INT;

    -- Si los parámetros opcionales son NULL, asignamos un valor por defecto
    SET p_subcategoria = IFNULL(p_subcategoria, NULL);
    SET p_talla = IFNULL(p_talla, NULL);
    SET p_color = IFNULL(p_color, NULL);
    SET p_proveedor = IFNULL(p_proveedor, NULL);
    SET p_codigo_barra = IFNULL(p_codigo_barra, NULL);

    -- Insertar el nuevo producto en la tabla producto
    INSERT INTO producto (prod_nombre, prod_descripcion, prod_precio_costo, prod_precio_venta, 
                          prod_estado, cat_codigo, subcat_codigo, talla_codigo, color_codigo, 
                          per_codigo, prod_codigo_barra, prod_situacion)
    VALUES (p_nombre, p_descripcion, p_precio_costo, p_precio_venta, p_estado, p_categoria, 
            p_subcategoria, p_talla, p_color, p_proveedor, p_codigo_barra, 1);  -- prod_situacion se establece en 1 por defecto

    -- Obtener el ID del producto recién insertado
    SET prod_id = LAST_INSERT_ID();

    -- Insertar en la tabla de inventario con la cantidad inicial proporcionada
    INSERT INTO inventario (prod_codigo, inv_cantidad)
    VALUES (prod_id, p_cantidad_inicial);
    
END $$

DELIMITER ;


-- Procedimiento para obtener el total de ventas de un producto
DELIMITER $$

CREATE PROCEDURE obtener_total_ventas_producto(IN p_prod_codigo INT)
BEGIN
    SELECT 
        SUM(dv.cantidad) AS total_cantidad_vendida,
        SUM(dv.cantidad * dv.precio) AS total_monto_vendido
    FROM detalle_venta dv
    WHERE dv.prod_codigo = p_prod_codigo;
END $$

DELIMITER ;

-- Procedimiento almacenados para movimientos de pagos
DELIMITER $$

CREATE PROCEDURE RegistrarPago(
    IN p_per_codigo INT,
    IN p_ser_codigo INT,
    IN p_monto DECIMAL(10, 2),
    IN p_total DECIMAL(10, 2),
    IN p_pag_tipo_id INT,
    IN p_meto_pago_id INT
)
BEGIN
    -- Validar que el cliente y el servicio existan
    IF (SELECT COUNT(*) FROM personal WHERE per_codigo = p_per_codigo) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cliente no encontrado.';
    END IF;

    IF (SELECT COUNT(*) FROM servicio WHERE ser_codigo = p_ser_codigo) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Servicio no encontrado.';
    END IF;

    -- Insertar el registro del pago
    INSERT INTO pago_servicio (pagser_per_codigo, pagser_ser_codigo, pagser_monto, pagser_total, pagser_fecha, pagser_pag_tipo_id, pagser_meto_pago_id)
    VALUES (p_per_codigo, p_ser_codigo, p_monto, p_total, NOW(), p_pag_tipo_id, p_meto_pago_id);
END$$

DELIMITER ;

-- Procedimiento almacenado para registrar un Cobro
DELIMITER $$

CREATE PROCEDURE RegistrarCobro(
    IN c_per_codigo INT,
    IN c_ser_codigo INT,
    IN c_monto DECIMAL(10, 2),
    IN c_total DECIMAL(10, 2),
    IN c_pag_tipo_id INT,
    IN c_meto_pago_id INT
)
BEGIN
    -- Validar que el cliente y el servicio existan
    IF (SELECT COUNT(*) FROM personal WHERE per_codigo = c_per_codigo) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cliente no encontrado.';
    END IF;

    IF (SELECT COUNT(*) FROM servicio WHERE ser_codigo = c_ser_codigo) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Servicio no encontrado.';
    END IF;

    -- Insertar el registro del cobro
    INSERT INTO cobro_servicio (cobser_per_codigo, cobser_ser_codigo, cobser_monto, cobser_total, cobser_fecha, cobser_pag_tipo_id, cobser_meto_pago_id)
    VALUES (c_per_codigo, c_ser_codigo, c_monto, c_total, NOW(), c_pag_tipo_id, c_meto_pago_id);
END$$

DELIMITER ;

-- Triggers para mantener resumen consolidado
CREATE TABLE resumen_movimientos (
    res_codigo INT AUTO_INCREMENT PRIMARY KEY,
    res_tipo ENUM('Pago', 'Cobro') NOT NULL,
    res_fecha DATETIME NOT NULL,
    res_cliente_id INT NOT NULL,
    res_servicio_id INT NOT NULL,
    res_monto DECIMAL(10, 2) NOT NULL,
    res_total DECIMAL(10, 2) NOT NULL,
    res_situacion INT NOT NULL DEFAULT 1
);

-- Triggers para mantener insertar actualizado
DELIMITER $$

CREATE TRIGGER after_pago_insert
AFTER INSERT ON pago_servicio
FOR EACH ROW
BEGIN
    INSERT INTO resumen_movimientos (res_tipo, res_fecha, res_cliente_id, res_servicio_id, res_monto, res_total, res_situacion)
    VALUES ('Pago', NEW.pagser_fecha, NEW.pagser_per_codigo, NEW.pagser_ser_codigo, NEW.pagser_monto, NEW.pagser_total, NEW.pagser_situacion);
END$$

DELIMITER ;
-- Triggers para mantener insertar actualizado de cobros
DELIMITER $$

CREATE TRIGGER after_cobro_insert
AFTER INSERT ON cobro_servicio
FOR EACH ROW
BEGIN
    INSERT INTO resumen_movimientos (res_tipo, res_fecha, res_cliente_id, res_servicio_id, res_monto, res_total, res_situacion)
    VALUES ('Cobro', NEW.cobser_fecha, NEW.cobser_per_codigo, NEW.cobser_ser_codigo, NEW.cobser_monto, NEW.cobser_total, NEW.cobser_situacion);
END$$

DELIMITER ;

-- procedimiento para obtenre resumen por cliente o servicio
DELIMITER $$

CREATE PROCEDURE ObtenerResumen(
    IN p_cliente_id INT,
    IN p_servicio_id INT
)
BEGIN
    SELECT 
        res_tipo AS Tipo,
        SUM(res_monto) AS TotalMonto,
        SUM(res_total) AS TotalServicio,
        COUNT(*) AS Movimientos
    FROM resumen_movimientos
    WHERE 
        (p_cliente_id IS NULL OR res_cliente_id = p_cliente_id) AND
        (p_servicio_id IS NULL OR res_servicio_id = p_servicio_id)
    GROUP BY res_tipo;
END$$

DELIMITER ;
