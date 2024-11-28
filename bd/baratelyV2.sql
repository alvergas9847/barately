--=================================[ I N I C I O ]==========================================--------
-- Crear la base de datos
CREATE DATABASE barately;

-- Usar la base de datos
USE barately;

-- Tabla para almacenar la información del personal
CREATE TABLE IF NOT EXISTS personal (
    per_codigo INT AUTO_INCREMENT PRIMARY KEY,  -- Código único del personal
    per_nombres VARCHAR(100) NOT NULL,          -- Nombres del personal
    per_apellidos VARCHAR(100) NOT NULL,        -- Apellidos del personal
    per_dpi CHAR(13)   NULL,  -- DPI de 13 dígitos
    per_nit VARCHAR(12)   NULL,        -- NIT de hasta 12 caracteres alfanuméricos
    per_tel1 CHAR(8) NULL,    -- Teléfono principal (8 dígitos)
    per_tel2 CHAR(8) NULL,   -- Teléfono secundario (8 dígitos)
    per_mail VARCHAR(50)NULL,                       -- Correo electrónico
    per_imagen LONGBLOB NULL,                     -- Imagen del personal (almacenada en formato binario)
    per_direccion VARCHAR(255) NULL,                 -- Dirección del personal
    per_fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha de registro
    per_situacion INT NOT NULL DEFAULT 1        -- Estado del registro (1 = Activo, 0 = Inactivo)
);

SHOW VARIABLES LIKE 'max_allowed_packet';

 
CREATE INDEX idx_personal_nombre ON personal(per_nombres, per_apellidos);

-- roles para usuarios
CREATE TABLE IF NOT EXISTS roles (
    rol_id INT AUTO_INCREMENT PRIMARY KEY,      -- ID único del rol
    rol_nombre VARCHAR(50) NOT NULL UNIQUE,     -- Nombre del rol
    rol_descripcion VARCHAR(255)                -- Descripción opcional del rol
);

-- tabla de usuarios
CREATE TABLE IF NOT EXISTS usuario (
    usu_codigo INT AUTO_INCREMENT PRIMARY KEY,         -- Código único del usuario
    per_codigo INT NOT NULL,                           -- Código del personal (FK) asociado al usuario
    usu_nombre VARCHAR(50) NOT NULL UNIQUE,            -- Nombre de usuario (debe ser único)
    usu_contrasena VARCHAR(255) NOT NULL,              -- Contraseña (almacenada de manera segura)
    rol_id INT NOT NULL,                               -- ID del rol (FK)
    usu_situacion INT NOT NULL DEFAULT 1,              -- Estado del registro (1 = Activo, 0 = Inactivo)
    FOREIGN KEY (per_codigo) REFERENCES personal(per_codigo) ON DELETE CASCADE, -- Relación con personal
    FOREIGN KEY (rol_id) REFERENCES roles(rol_id) ON DELETE CASCADE -- Relación con roles
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
CREATE TABLE pago_tipo (
    pago_tipo_id INT AUTO_INCREMENT PRIMARY KEY,      -- ID único del tipo de pago
    pago_tipo_nombre VARCHAR(50) NOT NULL,            -- Nombre del tipo de pago (Comisión, Diario, Quincenal, Mensual)
    pago_tipo_descripcion VARCHAR(255)                -- Descripción opcional del tipo de pago
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
    FOREIGN KEY (pago_tipo_id) REFERENCES pago_tipo(pago_tipo_id)  -- Relación con la tabla pago_tipo
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
CREATE TABLE tipo_servicio (
    tipo_servicio_id INT AUTO_INCREMENT PRIMARY KEY,  -- Código único del tipo de servicio
    tipo_servicio_nombre VARCHAR(100) NOT NULL        -- Nombre del tipo de servicio (agua, luz, internet, etc.)
);

-- Tabla para almacenar los pagos de servicios básicos
CREATE TABLE pago_servicio (
    servicio_codigo INT AUTO_INCREMENT PRIMARY KEY,   -- Código único del pago
    per_codigo INT,                                   -- Código del cliente (FK)
    tipo_servicio_id INT,                             -- ID del tipo de servicio (FK)
    monto DECIMAL(10, 2) NOT NULL,                    -- Monto del pago
    fecha_pago DATETIME NOT NULL,                     -- Fecha del pago
    pago_situacion INT NOT NULL DEFAULT 1,            -- Estado del registro (1 = Activo, 0 = Inactivo)
    pago_total DECIMAL(10, 2) NOT NULL,               -- Monto total del servicio (pago total)
    FOREIGN KEY (per_codigo) REFERENCES personal(per_codigo),  -- Relación con la tabla cliente
    FOREIGN KEY (tipo_servicio_id) REFERENCES tipo_servicio(tipo_servicio_id)  -- Relación con la tabla tipo_servicio
);


CREATE INDEX idx_pago_fecha_servicio ON pago_servicio(fecha_pago);

-- Tabla para almacenar los pagos de renta
CREATE TABLE tipo_servicio_prestado (
    tipo_servicio_id INT AUTO_INCREMENT PRIMARY KEY,  -- Código único del tipo de servicio
    tipo_servicio_nombre VARCHAR(100) NOT NULL        -- Nombre del tipo de servicio (bodega, alquiler, etc.)
);


CREATE TABLE cobro_servicio (
    cobro_codigo INT AUTO_INCREMENT PRIMARY KEY,        -- Código único del cobro
    per_codigo INT,                                     -- Código del cliente (FK)
    tipo_servicio_id INT,                               -- ID del tipo de servicio (FK) (por ejemplo, bodega, alquiler)
    monto DECIMAL(10, 2) NOT NULL,                      -- Monto del cobro
    fecha_cobro DATETIME NOT NULL,                      -- Fecha del cobro
    fecha_inicio DATETIME,                              -- Fecha de inicio del servicio (si aplica)
    fecha_fin DATETIME,                                 -- Fecha de fin del servicio (si aplica)
    cobro_situacion INT NOT NULL DEFAULT 1,             -- Estado del registro (1 = Activo, 0 = Inactivo)
    FOREIGN KEY (per_codigo) REFERENCES personal(per_codigo),   -- Relación con la tabla cliente
    FOREIGN KEY (tipo_servicio_id) REFERENCES tipo_servicio_prestado(tipo_servicio_id)  -- Relación con la tabla tipo_servicio_prestado
);



--=================================[ F I N ]==========================================--------
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

-- 

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


-- Llamada a procedimientos almacenados
CALL agregar_producto('Camiseta de Algodón', 'Camiseta básica para hombre', 50.00, 100.00, 'Nuevo', 1, 2, 1, 3, 1, 50);


-- para obtener el total de ventas de un producto (por ejemplo, producto con prod_codigo = 1):
CALL obtener_total_ventas_producto(1);

========================================
========================================
========================================
========================================
========================================
========================================
========================================
========================================
========================================











========================================
========================================


















--=================================[ INICIO TRIGGER Y AUDITORIA ]==========================================--------
--Trigger para Actualizar Inventario Después de una Venta
--Este trigger se activará cada vez que se inserte un registro en la tabla detalle_venta, actualizando automáticamente la cantidad de productos en el inventario.

DELIMITER //

CREATE TRIGGER actualizar_inventario 
AFTER INSERT ON detalle_venta
FOR EACH ROW
BEGIN
    DECLARE cantidad_actual INT;

    -- Obtener la cantidad actual del inventario para el producto
    SELECT inv_cantidad INTO cantidad_actual 
    FROM inventario 
    WHERE prod_codigo = NEW.prod_codigo;

    -- Verificar si hay suficiente inventario
    IF cantidad_actual < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inventario insuficiente para el producto.';
    ELSE
        -- Actualizar la cantidad en el inventario
        UPDATE inventario
        SET inv_cantidad = inv_cantidad - NEW.cantidad
        WHERE prod_codigo = NEW.prod_codigo;
    END IF;
END;
//

DELIMITER ;


--Trigger para Auditoría de Ventas
--Este trigger se activará después de que se inserte una venta, registrando la acción en una tabla de auditoría.
CREATE TABLE auditoria_venta (
    aud_codigo INT AUTO_INCREMENT PRIMARY KEY,
    venta_codigo INT,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(100),  -- Nombre del usuario que realizó la venta
    accion ENUM('INSERT', 'UPDATE', 'DELETE'),
    detalle TEXT,
    FOREIGN KEY (venta_codigo) REFERENCES venta(venta_codigo)
);


DELIMITER //

CREATE TRIGGER auditoria_venta_insert 
AFTER INSERT ON venta
FOR EACH ROW
BEGIN
    DECLARE usuario_actual VARCHAR(100);
    
    -- Aquí deberías obtener el nombre del usuario actual. Esto puede variar según tu implementación.
    SET usuario_actual = 'Nombre del Usuario'; -- Reemplaza con la forma de obtener el usuario actual

    -- Insertar en la tabla de auditoría
    INSERT INTO auditoria_venta (venta_codigo, usuario, accion, detalle)
    VALUES (NEW.venta_codigo, usuario_actual, 'INSERT', 'Se ha realizado una nueva venta.');
END;
//

DELIMITER ;

 

--Procedimientos Almacenados
--2.1 Procedimiento Almacenado para Registrar una Venta
--Este procedimiento almacenado permitirá registrar una venta, actualizar el inventario y registrar la auditoría en un solo paso.
DELIMITER //

CREATE PROCEDURE registrar_venta(
    IN p_cli_codigo INT,
    IN p_per_codigo INT,
    IN p_total DECIMAL(10, 2),
    IN p_detalles JSON  -- Detalles de los productos vendidos en formato JSON
)
BEGIN
    DECLARE nueva_venta_codigo INT;
    DECLARE cantidad_actual INT;
    DECLARE prod_codigo INT;
    DECLARE cantidad INT;
    DECLARE precio DECIMAL(10, 2);
    DECLARE i INT DEFAULT 0;

    -- Insertar la venta
    INSERT INTO venta (cli_codigo, per_codigo, fecha_venta, total_venta)
    VALUES (p_cli_codigo, p_per_codigo, NOW(), p_total);
    
    SET nueva_venta_codigo = LAST_INSERT_ID();

    -- Recorrer los detalles de la venta
    WHILE i < JSON_LENGTH(p_detalles) DO
        -- Extraer los detalles del producto
        SET prod_codigo = JSON_UNQUOTE(JSON_EXTRACT(p_detalles, CONCAT('$[', i, '].prod_codigo')));
        SET cantidad = JSON_UNQUOTE(JSON_EXTRACT(p_detalles, CONCAT('$[', i, '].cantidad')));
        SET precio = JSON_UNQUOTE(JSON_EXTRACT(p_detalles, CONCAT('$[', i, '].precio')));

        -- Verificar la cantidad en inventario
        SELECT inv_cantidad INTO cantidad_actual 
        FROM inventario 
        WHERE prod_codigo = prod_codigo;

        IF cantidad_actual IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = CONCAT('El producto con código ', prod_codigo, ' no existe en el inventario.');
        ELSEIF cantidad_actual < cantidad THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = CONCAT('Inventario insuficiente para el producto con código ', prod_codigo, '. Disponible: ', cantidad_actual, ', Solicitado: ', cantidad);
        END IF;

        -- Insertar en detalle de venta
        INSERT INTO detalle_venta (venta_codigo, prod_codigo, cantidad, precio)
        VALUES (nueva_venta_codigo, prod_codigo, cantidad, precio);

        -- Actualizar el inventario
        UPDATE inventario
        SET inv_cantidad = inv_cantidad - cantidad
        WHERE prod_codigo = prod_codigo;

        -- Incrementar el índice
        SET i = i + 1;
    END WHILE;

    -- Registrar auditoría
    INSERT INTO auditoria_venta (venta_codigo, usuario, accion, detalle)
    VALUES (nueva_venta_codigo, CURRENT_USER(), 'INSERT', CONCAT('Venta realizada por cliente: ', p_cli_codigo));
END //

DELIMITER ;


-----------------------------------------------------------------------

DELIMITER //

CREATE PROCEDURE registrar_venta(
    IN p_cli_codigo INT,
    IN p_per_codigo INT,
    IN p_total DECIMAL(10, 2),
    IN p_prod_codigo INT,
    IN p_cantidad INT,
    IN p_precio DECIMAL(10, 2)
)
BEGIN
    DECLARE nueva_venta_codigo INT;
    DECLARE cantidad_actual INT;

    -- Insertar la venta
    INSERT INTO venta (cli_codigo, per_codigo, fecha_venta, total_venta)
    VALUES (p_cli_codigo, p_per_codigo, NOW(), p_total);
    
    SET nueva_venta_codigo = LAST_INSERT_ID();

    -- Verificar la cantidad en inventario
    SELECT inv_cantidad INTO cantidad_actual 
    FROM inventario 
    WHERE prod_codigo = p_prod_codigo;

    IF cantidad_actual IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = CONCAT('El producto con código ', CAST(p_prod_codigo AS CHAR), ' no existe en el inventario.');
    ELSEIF cantidad_actual < p_cantidad THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = CONCAT('Inventario insuficiente para el producto con código ', CAST(p_prod_codigo AS CHAR), 
                                  '. Disponible: ', CAST(cantidad_actual AS CHAR), ', Solicitado: ', CAST(p_cantidad AS CHAR));
    END IF;

    -- Insertar en detalle de venta
    INSERT INTO detalle_venta (venta_codigo, prod_codigo, cantidad, precio)
    VALUES (nueva_venta_codigo, p_prod_codigo, p_cantidad, p_precio);

    -- Actualizar el inventario
    UPDATE inventario
    SET inv_cantidad = inv_cantidad - p_cantidad
    WHERE prod_codigo = p_prod_codigo;

    -- Registrar auditoría
    INSERT INTO auditoria_venta (venta_codigo, usuario, accion, detalle)
    VALUES (nueva_venta_codigo, CURRENT_USER(), 'INSERT', CONCAT('Venta realizada por cliente: ', CAST(p_cli_codigo AS CHAR)));
END //

DELIMITER ;

---------------------------------------------------------------











-- Trigger para actualizar el inventario después de una venta

DELIMITER //

CREATE TRIGGER after_detalle_venta_insert
AFTER INSERT ON detalle_venta
FOR EACH ROW
BEGIN
    UPDATE inventario
    SET inv_cantidad = inv_cantidad - NEW.cantidad
    WHERE prod_codigo = NEW.prod_codigo;
END;

//

DELIMITER ;


-- Procedimiento para registrar una venta
DELIMITER //

CREATE PROCEDURE registrar_venta(
    IN p_cli_codigo INT,
    IN p_per_codigo INT,
    IN p_total_venta DECIMAL(10, 2),
    IN p_detalle JSON  -- Detalles de los productos vendidos en formato JSON
)
BEGIN
    DECLARE v_venta_codigo INT;

    -- Insertar la venta
    INSERT INTO venta (cli_codigo, per_codigo, fecha_venta, total_venta)
    VALUES (p_cli_codigo, p_per_codigo, NOW(), p_total_venta);

    SET v_venta_codigo = LAST_INSERT_ID();

    -- Insertar detalles de la venta
    DECLARE v_prod_codigo INT;
    DECLARE v_cantidad INT;
    DECLARE v_precio DECIMAL(10, 2);

    -- Loop a través de los detalles
    WHILE JSON_LENGTH(p_detalle) > 0 DO
        SET v_prod_codigo = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, '$[0].prod_codigo'));
        SET v_cantidad = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, '$[0].cantidad'));
        SET v_precio = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, '$[0].precio'));

        INSERT INTO detalle_venta (venta_codigo, prod_codigo, cantidad, precio)
        VALUES (v_venta_codigo, v_prod_codigo, v_cantidad, v_precio);

        SET p_detalle = JSON_REMOVE(p_detalle, '$[0]');
    END WHILE;
END;

//

DELIMITER ;

--Tabla de auditoría para ventas
CREATE TABLE auditoria_venta (
    aud_codigo INT AUTO_INCREMENT PRIMARY KEY,
    venta_codigo INT,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(100),  -- Puede ser el nombre del usuario que realizó el cambio
    accion ENUM('INSERT', 'UPDATE', 'DELETE'),
    detalle TEXT,
    FOREIGN KEY (venta_codigo) REFERENCES venta(venta_codigo)
);

-- Trigger para registrar cambios en la tabla de ventas
DELIMITER //

CREATE TRIGGER after_venta_insert
AFTER INSERT ON venta
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_venta (venta_codigo, fecha_cambio, accion, usuario)
    VALUES (NEW.venta_codigo, NOW(), 'INSERT', USER());
END;

//

DELIMITER ;


--=================================[ FIN TRIGGER Y AUDITORI ]==========================================--------

---------
--4. Optimización de Consultas
--Asegúrate de revisar y optimizar tus consultas utilizando EXPLAIN para identificar posibles cuellos de botella. Aquí hay un ejemplo de cómo puedes optimizar una consulta:
EXPLAIN SELECT * FROM venta WHERE cli_codigo = 1;

--5. Seguridad
--Implementa roles y permisos para asegurar tu base de datos. Por ejemplo, puedes crear un rol de solo lectura para ciertos usuarios.
CREATE ROLE 'readonly';
GRANT SELECT ON barately.* TO 'readonly';

--Backup y Recuperación
--Asegúrate de tener un plan de respaldo regular. Puedes usar mysqldump para realizar respaldos:

mysqldump -u username -p barately > barately_backup.sql

--Monitoreo y Mantenimiento Regular
--Utiliza herramientas de monitoreo para verificar el rendimiento de tu base de datos. También es recomendable realizar un mantenimiento regular, como optimizar tablas y actualizar estadísticas.
OPTIMIZE TABLE producto;
ANALYZE TABLE venta;