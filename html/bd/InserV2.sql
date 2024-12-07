
 
-- Insertar registros en la tabla `roles`
INSERT INTO roles (rol_nombre, rol_descripcion)
VALUES
  ('Administrador', 'Tiene acceso total al sistema'),
  ('Cajero', 'Realiza ventas y maneja la caja'),
  ('Cliente', 'Comprador de productos'),
  ('Vendedor', 'Asiste a los clientes en la sala de ventas'),
  ('Encargado de almacén', 'Gestiona el inventario y realiza los pedidos'),
  ('Contador', 'Lleva el control de las finanzas de la tienda');


-- personal
INSERT INTO personal (per_nombres, per_apellidos, per_dpi, per_nit, per_tel1, per_tel2, per_mail, per_direccion, per_rol_id)
VALUES
  ('Juan', 'Pérez', 25489632109, '48965210-2', 23456789, 45678901, 'juan.perez@ejemplo.com', '5a. Avenida 12-32, Zona 1', 2),
  ('María', 'López', 54321987601, '78945612-3', 34567890, 56789012, 'maria.lopez@ejemplo.com', '7a. Calle 5-10, Zona 4', 3),
  ('Carlos', 'García', 98765432102, '12345678-9', 45678901, 67890123, 'carlos.garcia@ejemplo.com', '10a. Avenida 20-50, Zona 5', 4),
  ('Ana', 'Martínez', 12345678903, '32165498-7', 56789012, 78901234, 'ana.martinez@ejemplo.com', '15a. Calle 15-75, Zona 6', 1),
  ('Pedro', 'Rodríguez', 87654321094, '98765432-1', 67890123, 89012345, 'pedro.rodriguez@ejemplo.com', '20a. Avenida 10-25, Zona 7', 5);

-- Insertar registros en la tabla `usuario`
-- Usuario 1: Administrador
INSERT INTO usuario (usu_nombre, usu_pass, rol_id, usu_situacion) 
VALUES ('admin', 'admin123', 1, 1);

-- Usuario 2: Usuario
INSERT INTO usuario (usu_nombre, usu_pass, rol_id, usu_situacion) 
VALUES ('usuario1', 'usuario123', 2, 1);

-- Usuario 3: Contador
INSERT INTO usuario (usu_nombre, usu_pass, rol_id, usu_situacion) 
VALUES ('contador1', 'cont123', 3, 1);

-- Usuario 4: Proveedor
INSERT INTO usuario (usu_nombre, usu_pass, rol_id, usu_situacion) 
VALUES ('proveedor1', 'proveedor123', 4, 1);

-- Usuario 5: Soporte
INSERT INTO usuario (usu_nombre, usu_pass, rol_id, usu_situacion) 
VALUES ('soporte1', 'soporte123', 5, 1);


-- Tabla `usuario`:
-- Esta tabla almacena la información de los usuarios que pueden iniciar sesión en el sistema.
-- Los usuarios están asociados a un personal (`per_codigo`) y un rol (`rol_id`).
-- La contraseña (`usu_contrasena`) debe ser almacenada de manera segura (en este caso, usando SHA2 para hashing).
-- El estado del usuario (`usu_situacion`) indica si el usuario está activo (1) o inactivo (0).

-- Registros de ejemplo para la tabla `usuario`:
-- 1. Usuario 'admin': Administrador con acceso completo al sistema.
-- 2. Usuario 'usuario1': Usuario estándar con acceso a funcionalidades limitadas.
-- 3. Usuario 'cliente1': Cliente que interactúa con el sistema como comprador.
-- 4. Usuario 'vendedor1': Vendedor que realiza ventas y gestiona clientes.
-- 5. Usuario 'contador1': Contador que maneja la gestión financiera.


-- Insertar registros en la tabla `categoria`
INSERT INTO categoria (cat_nombre, cat_descripcion, cat_situacion) VALUES
('Ropa', 'Categoría que incluye todas las prendas de vestir para damas, caballeros, niños, etc.', 1),
('Calzado', 'Categoría para almacenar todos los tipos de calzado, desde deportivos hasta formales.', 1),
('Accesorios', 'Categoría de productos como bolsos, joyería, sombreros y otros complementos.', 1),
('Deportes', 'Categoría destinada a ropa y calzado deportivo, equipos y accesorios de entrenamiento.', 1),
('Niños', 'Categoría dedicada a la ropa, calzado y accesorios para niños y bebés.', 1);

-- Tabla `categoria`:
-- Esta tabla almacena las categorías principales de productos como Ropa, Calzado, Accesorios, etc.
-- Las categorías permiten organizar los productos para facilitar su gestión y búsqueda.
-- El campo `cat_situacion` indica si la categoría está activa (1) o inactiva (0).

-- Registros en `categoria`:
-- 1. 'Ropa': Incluye prendas de vestir como camisas, pantalones, etc.
-- 2. 'Calzado': Incluye todo tipo de calzado, desde zapatos formales hasta deportivos.
-- 3. 'Accesorios': Para productos como bolsos, joyería, sombreros, entre otros complementos.
-- 4. 'Deportes': Ropa y calzado deportivo, así como accesorios para actividades deportivas.
-- 5. 'Niños': Ropa, calzado y accesorios diseñados para niños y bebés.

-- Insertar registros en la tabla `subcategoria`
INSERT INTO subcategoria (subcat_nombre, cat_codigo, subcat_situacion) VALUES
('Camisas', 1, 1),  -- Subcategoría de Ropa
('Pantalones', 1, 1),  -- Subcategoría de Ropa
('Zapatos', 2, 1),  -- Subcategoría de Calzado
('Bolsos', 3, 1),  -- Subcategoría de Accesorios
('Camisetas Deportivas', 4, 1);  -- Subcategoría de Deportes

-- Tabla `subcategoria`:
-- La tabla `subcategoria` almacena las subcategorías que pertenecen a cada categoría principal, 
-- permitiendo una organización más específica de los productos.
-- Cada subcategoría está vinculada a una categoría principal a través de la clave foránea `cat_codigo`.

-- Registros en `subcategoria`:
-- 1. 'Camisas' bajo la categoría 'Ropa'.
-- 2. 'Pantalones' bajo la categoría 'Ropa'.
-- 3. 'Zapatos' bajo la categoría 'Calzado'.
-- 4. 'Bolsos' bajo la categoría 'Accesorios'.
-- 5. 'Camisetas Deportivas' bajo la categoría 'Deportes'.

-- Insertar registros en la tabla `color`
INSERT INTO color (color_nombre, color_hex, color_situacion) VALUES
('Rojo', '#FF0000', 1),
('Azul', '#0000FF', 1),
('Verde', '#008000', 1),
('Negro', '#000000', 1),
('Blanco', '#FFFFFF', 1);



-- Insertar registros en la tabla `categoria_talla`
INSERT INTO categoria_talla (talla_nombre, talla_descripcion, talla_situacion) VALUES
('0-3 meses', 'Talla de ropa para bebé de 0 a 3 meses', 1),  -- Bebé
('3-6 meses', 'Talla de ropa para bebé de 3 a 6 meses', 1),  -- Bebé
('6-12 meses', 'Talla de ropa para bebé de 6 a 12 meses', 1),  -- Bebé
('12-18 meses', 'Talla de ropa para bebé de 12 a 18 meses', 1),  -- Bebé
('18-24 meses', 'Talla de ropa para bebé de 18 a 24 meses', 1),  -- Bebé
('2 años', 'Talla de ropa para niños de 2 años', 1),  -- Niños
('4 años', 'Talla de ropa para niños de 4 años', 1),  -- Niños
('6 años', 'Talla de ropa para niños de 6 años', 1),  -- Niños
('8 años', 'Talla de ropa para niños de 8 años', 1),  -- Niños
('10 años', 'Talla de ropa para niños de 10 años', 1),  -- Niños
('S', 'Talla pequeña (S) para mujeres y hombres', 1),  -- Dama / Caballero
('M', 'Talla mediana (M) para mujeres y hombres', 1),  -- Dama / Caballero
('L', 'Talla grande (L) para mujeres y hombres', 1),  -- Dama / Caballero
('XL', 'Talla extra grande (XL) para mujeres y hombres', 1),  -- Dama / Caballero
('2XL', 'Talla doble extra grande (2XL) para mujeres y hombres', 1),  -- Dama / Caballero
('3XL', 'Talla triple extra grande (3XL) para mujeres y hombres', 1),  -- Dama / Caballero
('4XL', 'Talla cuatro veces extra grande (4XL) para mujeres y hombres', 1),  -- Dama / Caballero
('5XL', 'Talla cinco veces extra grande (5XL) para mujeres y hombres', 1),  -- Dama / Caballero
('6XL', 'Talla seis veces extra grande (6XL) para mujeres y hombres', 1);  -- Dama / Caballero


-- Insertar productos en la tabla `producto` con las subcategorías correctas
INSERT INTO producto (prod_nombre, prod_descripcion, prod_precio_costo, prod_precio_venta, prod_estado, prod_imagen, cat_codigo, subcat_codigo, talla_codigo, color_codigo, per_codigo, prod_codigo_barra, prod_situacion) VALUES
('Camiseta de Algodón', 'Camiseta de algodón de hombre, talla M', 50.00, 100.00, 'Nuevo', NULL, 1, 1, 9, 1, 1, '123456789012', 1),  -- Camisas, talla M, color (Rojo)
('Jeans de Mezclilla', 'Pantalones de mezclilla de mujer, talla 28', 70.00, 140.00, 'Nuevo', NULL, 1, 2, 10, 2, 2, '234567890123', 1),  -- Pantalones, talla 28, color (Azul)
('Zapatos Deportivos', 'Zapatos deportivos de hombre talla 42', 120.00, 250.00, 'Nuevo', NULL, 2, 3, 13, 3, 3, '345678901234', 1),  -- Zapatos, talla 42, color (Blanco)
('Bolso de Cuero', 'Bolso de cuero para dama, color marrón', 100.00, 200.00, 'En promoción', NULL, 3, 4, 12, 4, 4, '456789012345', 1),  -- Bolsos, color (Marrón)
('Camiseta Deportiva', 'Camiseta deportiva para hombres, talla L', 80.00, 160.00, 'Stock', NULL, 4, 5, 15, 5, 5, '567890123456', 1);  -- Camisetas Deportivas, talla L, color (Azul)

-- Insertar registros en la tabla `inventario` para los productos
INSERT INTO inventario (prod_codigo, inv_cantidad, inv_situacion) VALUES
(1, 200, 1),  -- Camiseta de Algodón
(2, 200, 1),  -- Jeans de Mezclilla
(3, 200, 1),  -- Zapatos Deportivos
(4, 200, 1),  -- Bolso de Cuero
(5, 200, 1);  -- Camiseta Deportiva

-- Insertar registros de movimientos de inventario

-- Movimiento 1: Entrada de productos (productos recién comprados)
INSERT INTO movimiento_inventario (prod_codigo, mov_tipo, mov_cantidad, mov_observaciones) VALUES
(1, 'Entrada', 200, 'Productos ingresados al inventario desde el proveedor.');  -- Camiseta de Algodón (Entrada de 200 unidades)

-- Movimiento 2: Entrada de productos en bodega (productos almacenados en bodega)
INSERT INTO movimiento_inventario (prod_codigo, mov_tipo, mov_cantidad, mov_observaciones) VALUES
(2, 'Entrada', 200, 'Productos ingresados y almacenados en bodega para stock.');  -- Jeans de Mezclilla (Entrada de 200 unidades)

-- Movimiento 3: Salida de productos para exhibición (productos trasladados a la tienda para exhibición)
INSERT INTO movimiento_inventario (prod_codigo, mov_tipo, mov_cantidad, mov_observaciones) VALUES
(3, 'Salida', 50, 'Productos trasladados a la tienda para exhibición.');  -- Zapatos Deportivos (Salida de 50 unidades)

-- Movimiento 4: Venta de productos (productos vendidos)
INSERT INTO movimiento_inventario (prod_codigo, mov_tipo, mov_cantidad, mov_observaciones) VALUES
(4, 'Salida', 10, 'Productos vendidos a clientes.');  -- Bolso de Cuero (Venta de 10 unidades)

-- Movimiento 5: Devolución de productos por parte de cliente (productos devueltos por el cliente)
INSERT INTO movimiento_inventario (prod_codigo, mov_tipo, mov_cantidad, mov_observaciones) VALUES
(5, 'Entrada', 5, 'Productos devueltos por el cliente, regresados al inventario.');  -- Camiseta Deportiva (Devolución de 5 unidades)


-- Insertar registros en la tabla `metodo_pago` para los métodos de pago disponibles

-- Registro 1: Pago en efectivo
INSERT INTO metodo_pago (metodo_pago_nombre, metodo_pago_situacion) VALUES
('Efectivo', 1);  -- Método de pago en efectivo, activo

-- Registro 2: Pago con tarjeta de crédito
INSERT INTO metodo_pago (metodo_pago_nombre, metodo_pago_situacion) VALUES
('Tarjeta de Crédito', 1);  -- Método de pago con tarjeta de crédito, activo

-- Registro 3: Pago con tarjeta de débito
INSERT INTO metodo_pago (metodo_pago_nombre, metodo_pago_situacion) VALUES
('Tarjeta de Débito', 1);  -- Método de pago con tarjeta de débito, activo

-- Registro 4: Pago por transferencia bancaria
INSERT INTO metodo_pago (metodo_pago_nombre, metodo_pago_situacion) VALUES
('Transferencia Bancaria', 1);  -- Método de pago por transferencia bancaria, activo

-- Registro 5: Pago con criptomonedas
INSERT INTO metodo_pago (metodo_pago_nombre, metodo_pago_situacion) VALUES
('Criptomonedas', 1);  -- Método de pago con criptomonedas, activo



-- Insertar una venta en la tabla `venta`
INSERT INTO venta (cli_codigo, per_codigo, fecha_venta, total_venta, venta_pagada, venta_situacion) VALUES
(1, 1, NOW(), 200.00, 1, 1);  -- Cliente con código 1, vendedor con código 1, total de venta 200.00, venta pagada, venta activa


-- Insertar tipos de pago para proveedores y clientes por mayoreo
INSERT INTO pago_tipo (pago_tipo_nombre, pago_tipo_descripcion) VALUES
('Comisión', 'Pago basado en una comisión por ventas realizadas a clientes. Utilizado para vendedores o representantes de ventas.'),  -- Pago por comisión
('Diario', 'Pago realizado diariamente. Usado generalmente para trabajadores que reciben pago por su jornada diaria de trabajo.'),  -- Pago diario
('Quincenal', 'Pago realizado cada quincena, es común en muchos trabajos que siguen el ciclo de 15 días.'),  -- Pago quincenal
('Mensual', 'Pago realizado una vez al mes, común para empleados de planta o trabajos a largo plazo.'),  -- Pago mensual
('Mayoreo', 'Pago realizado a clientes por compras al por mayor. Generalmente con descuentos especiales por volumen de compra.')  -- Pago por mayoreo
;


-- Insertar comisión para la venta 1
INSERT INTO comision_venta (per_codigo, venta_codigo, comision_monto, fecha_pago, comision_situacion) VALUES
(1, 1, 10.00, '2024-11-17 10:00:00', 1);  -- Vendedor 1, Venta 1 (Camiseta de Algodón, comisión 10%)



-- Insertar registros en la tabla `pago_persona`
INSERT INTO pago_persona (per_codigo, pago_tipo_id, monto, fecha_pago, descripcion, pago_situacion) VALUES
(1, 1, 500.00, '2024-11-17 09:00:00', 'Pago por comisión de ventas (Comisión por Venta)', 1),  -- Vendedor 1, Pago de comisión por venta
(2, 2, 1200.00, '2024-11-17 09:15:00', 'Pago mensual por salario fijo', 1),                    -- Vendedor 2, Pago de salario mensual
(3, 3, 600.00, '2024-11-17 09:30:00', 'Pago quincenal por trabajo realizado', 1),               -- Vendedor 3, Pago quincenal
(4, 1, 400.00, '2024-11-17 09:45:00', 'Pago por comisión de ventas (Comisión por Venta)', 1),  -- Vendedor 4, Pago de comisión por venta
(5, 4, 1500.00, '2024-11-17 10:00:00', 'Pago por comisión de ventas, más bono por objetivos', 1);  -- Vendedor 5, Pago por comisión y bono

-- Insertar registros en la tabla `pago_detalle`
INSERT INTO pago_detalle (pago_codigo, periodo_inicio, periodo_fin, monto_base, comision, total_pago) VALUES
(1, '2024-11-01', '2024-11-30', 500.00, 50.00, 550.00),  -- Detalle de pago para Vendedor 1: Salario base + comisión
(2, '2024-11-01', '2024-11-30', 1200.00, 0.00, 1200.00), -- Detalle de pago para Vendedor 2: Solo salario mensual
(3, '2024-11-01', '2024-11-15', 600.00, 60.00, 660.00),  -- Detalle de pago para Vendedor 3: Salario base + comisión quincenal
(4, '2024-11-01', '2024-11-30', 400.00, 40.00, 440.00),  -- Detalle de pago para Vendedor 4: Salario base + comisión
(5, '2024-11-01', '2024-11-30', 1500.00, 150.00, 1650.00); -- Detalle de pago para Vendedor 5: Salario base + comisión + bono


-- Insertar registros en la tabla `orden_compra`
INSERT INTO orden_compra (cli_codigo, per_codigo, orden_fecha, orden_total, orden_tipo, orden_pagada, orden_situacion) 
VALUES
(1, 1, '2024-11-01 10:00:00', 5000.00, 'Mayorista', 1, 1),  -- Orden Mayorista, Cliente 1, gestionada por Vendedor 1, pagada
(2, 2, '2024-11-05 12:30:00', 1500.00, 'Consignación', 0, 1), -- Orden por Consignación, Cliente 2, gestionada por Vendedor 2, pendiente de pago
(3, 3, '2024-11-10 14:00:00', 3000.00, 'Lote', 1, 1),      -- Orden por Lote, Cliente 3, gestionada por Vendedor 3, pagada
(4, 4, '2024-11-15 16:30:00', 2500.00, 'Mayorista', 0, 1),  -- Orden Mayorista, Cliente 4, gestionada por Vendedor 4, pendiente de pago
(5, 5, '2024-11-20 18:00:00', 4000.00, 'Consignación', 1, 1); -- Orden por Consignación, Cliente 5, gestionada por Vendedor 5, pagada



-- Insertar detalles de las órdenes de compra
INSERT INTO detalle_orden (orden_codigo, prod_codigo, detalle_cantidad, detalle_precio, detalle_situacion) VALUES
(1, 1, 100, 50.00, 1),  -- Orden 1 (Mayorista): 100 unidades de Camiseta de Algodón a 50.00 cada una
(1, 2, 50, 30.00, 1),   -- Orden 1 (Mayorista): 50 unidades de Jeans de Mezclilla a 30.00 cada una
(2, 3, 200, 75.00, 1),  -- Orden 2 (Consignación): 200 unidades de Zapatos Deportivos a 75.00 cada una
(3, 4, 150, 60.00, 1),  -- Orden 3 (Lote): 150 unidades de Bolso de Cuero a 60.00 cada una
(4, 5, 120, 40.00, 1);  -- Orden 4 (Mayorista): 120 unidades de Camiseta Deportiva a 40.00 cada una


-- Insertar pagos de órdenes de compra
INSERT INTO pago_orden_compra (orden_codigo, metodo_pago_id, monto, fecha_pago, descripcion, pago_completado, pago_situacion) VALUES
(1, 1, 5000.00, '2024-11-02 10:00:00', 'Pago completo por transferencia bancaria', 1, 1),  -- Orden 1, Transferencia bancaria, Pago completado
(2, 2, 1500.00, '2024-11-06 12:30:00', 'Pago con tarjeta de crédito', 1, 1),  -- Orden 2, Tarjeta de crédito, Pago completado
(3, 3, 3000.00, '2024-11-11 14:00:00', 'Pago en efectivo', 1, 1),  -- Orden 3, Efectivo, Pago completado
(4, 4, 2500.00, '2024-11-16 16:30:00', 'Pago realizado vía PayPal', 1, 1),  -- Orden 4, PayPal, Pago completado
(5, 5, 4000.00, '2024-11-21 18:00:00', 'Pago con cheque', 0, 1);  -- Orden 5, Cheque, Pago pendiente

INSERT INTO pago_venta (venta_codigo, metodo_pago_id, monto, fecha_pago, descripcion, pago_completado, pago_situacion) VALUES
(1, 1, 5000.00, '2024-11-17 14:00:00', 'Pago completo de la venta 1 (Camiseta de Algodón, Jeans de Mezclilla, Zapatos, Bolso de Cuero, Camiseta Deportiva)', 1, 1);


 INSERT INTO detalle_venta (venta_codigo, prod_codigo, cantidad, precio, detalle_situacion) VALUES
(1, 1, 100, 100.00, 1),  -- Venta 1: 100 unidades de Camiseta de Algodón a 100.00 cada una
(1, 2, 50, 140.00, 1),   -- Venta 1: 50 unidades de Jeans de Mezclilla a 140.00 cada una
(1, 3, 200, 250.00, 1),  -- Venta 1: 200 unidades de Zapatos Deportivos a 250.00 cada una
(1, 4, 150, 200.00, 1),  -- Venta 1: 150 unidades de Bolso de Cuero a 200.00 cada una
(1, 5, 120, 160.00, 1);  -- Venta 1: 120 unidades de Camiseta Deportiva a 160.00 cada una


INSERT INTO tipo_servicio (tipo_servicio_nombre) VALUES
('Agua'),      -- Servicio básico de agua
('Luz'),       -- Servicio básico de electricidad
('Internet'),  -- Servicio de internet
('Gas'),       -- Servicio de gas
('Teléfono');  -- Servicio telefónico

INSERT INTO pago_servicio (per_codigo, tipo_servicio_id, monto, fecha_pago, pago_situacion, pago_total) VALUES
(1, 1, 50.00, '2024-11-01 09:00:00', 1, 50.00),  -- Cliente 1 paga por el servicio de agua
(2, 2, 75.00, '2024-11-05 10:00:00', 1, 75.00),  -- Cliente 2 paga por el servicio de luz
(3, 3, 100.00, '2024-11-10 11:30:00', 1, 100.00), -- Cliente 3 paga por el servicio de internet
(4, 4, 120.00, '2024-11-12 14:00:00', 1, 120.00), -- Cliente 4 paga por el servicio de gas
(5, 5, 80.00, '2024-11-15 16:00:00', 1, 80.00);   -- Cliente 5 paga por el servicio telefónico

INSERT INTO tipo_servicio_prestado (tipo_servicio_nombre) VALUES
('Bodega'),        -- Tipo de servicio de alquiler de bodega
('Alquiler de oficina'), -- Tipo de servicio de alquiler de oficina
('Alquiler de departamento'), -- Tipo de servicio de alquiler de departamento
('Alquiler de vivienda'), -- Tipo de servicio de alquiler de vivienda
('Alquiler de local comercial'); -- Tipo de servicio de alquiler de local comercial

INSERT INTO cobro_servicio (per_codigo, tipo_servicio_id, monto, fecha_cobro, fecha_inicio, fecha_fin, cobro_situacion) VALUES
(1, 1, 500.00, '2024-11-01 10:00:00', '2024-11-01', '2024-11-30', 1),  -- Cobro por alquiler de bodega para el cliente 1
(2, 2, 1200.00, '2024-11-02 12:00:00', '2024-11-01', '2024-11-30', 1),  -- Cobro por alquiler de oficina para el cliente 2
(3, 3, 2500.00, '2024-11-05 14:00:00', '2024-11-01', '2024-11-30', 1),  -- Cobro por alquiler de departamento para el cliente 3
(4, 4, 1500.00, '2024-11-10 16:00:00', '2024-11-01', '2024-11-30', 1),  -- Cobro por alquiler de vivienda para el cliente 4
(5, 5, 2000.00, '2024-11-12 18:00:00', '2024-11-01', '2024-11-30', 1);  -- Cobro por alquiler de local comercial para el cliente 5


-----****


barately/
├── Dockerfile
├── README.md
├── docker-compose.yaml
└── html/
    ├── assets/
    ├── bd/
    ├── controladores/
    ├── index.php
    ├── modelos/
    └── vistas/

Dockerfile: Archivo utilizado para construir tu imagen de Docker con PHP y Apache.
README.md: Información o documentación del proyecto.
docker-compose.yaml: Archivo para definir y ejecutar servicios de Docker.
html/: Directorio que contiene los archivos y subcarpetas principales de tu aplicación web.
assets/: Para archivos estáticos como CSS, JS, imágenes, etc.
bd/: Probablemente para scripts SQL o archivos relacionados con la base de datos.
controladores/: Para los controladores en el patrón MVC.
index.php: Archivo de entrada para tu aplicación web.
modelos/: Para las clases del modelo en MVC (gestión de datos).
vistas/: Para las vistas de la interfaz de usuario en MVC.
